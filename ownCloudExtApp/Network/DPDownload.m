 //
//  DPDownload.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 10/12/14.
//
//

/**
 *    @author Gonzalo Gonzalez
 *
 *    Copyright (C) 2015 ownCloud, Inc.
 *
 *    This code is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU Affero General Public License, version 3,
 *    as published by the Free Software Foundation.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *    GNU Affero General Public License for more details.
 *
 *    You should have received a copy of the GNU Affero General Public
 License, version 3,
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import "DPDownload.h"
#import "FFCircularProgressView.h"
#import "OCCommunication.h"
#import "DocumentPickerViewController.h"
#import "Customization.h"
#import "Constants.h"
#import "ManageFilesDB.h"
#import "OCErrorMsg.h"
#import "UtilsDtos.h"
#import "UtilsUrls.h"
#import "FileNameUtils.h"

#define k_progressView_delay_just_download 1.0
#define k_progressView_delay_after_download 2.0

@interface DPDownload ()

@property (nonatomic, strong) NSOperation *operation;
@property (nonatomic, strong) FileDto *file;
@property (nonatomic, strong) UserDto *user;
@property (nonatomic, strong) NSString *currentLocalFolder;
@property (nonatomic, strong) NSString *temporalFileName;
@property (nonatomic, strong) NSString *deviceLocalPath;
@property (nonatomic, strong) FFCircularProgressView *progressView;
@property (nonatomic) BOOL isLIFO;
@property (nonatomic) BOOL isCancelTapped;
@property (nonatomic, strong) NSString *etagToUpdate;

@end

@implementation DPDownload

- (id) init{
    
    self = [super init];
    if (self) {
        _isLIFO = YES;
        _isCancelTapped = NO;
        _state = downloadNotStarted;
    }
    return self;
}

- (void) downloadFile:(FileDto *)file locatedInFolder:(NSString*)localFolder ofUser:(UserDto *)user withProgressView:(FFCircularProgressView *)progressView{
    
    self.file = file;
    self.progressView = progressView;
    self.currentLocalFolder = localFolder;
    self.user = user;
    
    [self updateThisEtagWithTheLast];
}

///-----------------------------------
/// @name Refresh
///-----------------------------------

/**
 * Method to set the last etag on this file on the DB
 */
- (void) updateThisEtagWithTheLast {
    
    OCCommunication *sharedCommunication = [DocumentPickerViewController sharedOCCommunication];
    
    //Set the right credentials
    if (k_is_sso_active) {
        [sharedCommunication setCredentialsWithCookie:self.user.password];
    } else if (k_is_oauth_active) {
        [sharedCommunication setCredentialsOauthWithToken:self.user.password];
    } else {
        [sharedCommunication setCredentialsWithUser:self.user.username andPassword:self.user.password];
    }

    
    //FileName full path
    NSString *serverPath = [NSString stringWithFormat:@"%@%@", self.user.url, k_url_webdav_server];
    NSString *path = [NSString stringWithFormat:@"%@%@%@",serverPath, [UtilsDtos getDbBFolderPathFromFullFolderPath:self.file.filePath andUser:self.user], self.file.fileName];
    
    path = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    [self.progressView startSpinProgressBackgroundLayer];
    
    self.state = downloadCheckingEtag;
    
    [sharedCommunication readFile:path onCommunication:sharedCommunication successRequest:^(NSHTTPURLResponse *response, NSArray *items, NSString *redirectedServer) {
        
        DLog(@"Operation response code: %ld", (long)response.statusCode);
        BOOL isSamlCredentialsError = NO;
        
        //Check the login error in shibboleth
        if (k_is_sso_active && redirectedServer) {
            //Check if there are fragmens of saml in url, in this case there are a credential error
            isSamlCredentialsError = [FileNameUtils isURLWithSamlFragment:redirectedServer];
            if (isSamlCredentialsError) {
                DLog(@"error login updating the etag");
                //Set not download or downloaded in database
                if (self.file.isNecessaryUpdate) {
                    [ManageFilesDB setFileIsDownloadState:self.file.idFile andState:downloaded];
                    
                } else {
                    [ManageFilesDB setFileIsDownloadState:self.file.idFile andState:notDownload];
                }
                
                [self.progressView stopSpinProgressBackgroundLayer];
                
                [self deleteFileFromLocalFolder];
                [self.delegate downloadFailed:NSLocalizedString(@"session_expired", nil) andFile:self.file];
            }
        }
        if(response.statusCode < kOCErrorServerUnauthorized && !isSamlCredentialsError) {
            
            //Change the filePath from the library to our format
            for (FileDto *currentFile in items) {
                //Remove part of the item file path
                NSString *partToRemove = [UtilsUrls getRemovedPartOfFilePathAnd:self.user];
                if([currentFile.filePath length] >= [partToRemove length]){
                    currentFile.filePath = [currentFile.filePath substringFromIndex:[partToRemove length]];
                }
            }
            
            DLog(@"The directory List have: %lu elements", (unsigned long)items.count);
            
            //Check if there are almost one item in the array
            if (items.count >= 1) {
                DLog(@"Directoy list: %@", items);
                FileDto *currentFileDto = [items objectAtIndex:0];
                DLog(@"currentFileDto: %@", currentFileDto.etag);
                
                self.etagToUpdate = currentFileDto.etag;
                
                if (!self.isCancelTapped) {
                    [self startDownload];
                }
             
            }else{
                
                [self.progressView stopSpinProgressBackgroundLayer];
                
                [self deleteFileFromLocalFolder];
                [self.delegate downloadFailed:nil andFile:self.file];
            }
            
        }
    } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
        
        [self.progressView stopSpinProgressBackgroundLayer];
        
        [self failureInDownloadProcessWithError:error andResponse:response];
        
        
    }];
}


- (void) startDownload {
    
    OCCommunication *sharedCommunication = [DocumentPickerViewController sharedOCCommunication];
    NSArray *splitedUrl = [self.user.url componentsSeparatedByString:@"/"];
    NSString *serverUrl = [NSString stringWithFormat:@"%@%@%@",[NSString stringWithFormat:@"%@/%@/%@",[splitedUrl objectAtIndex:0],[splitedUrl objectAtIndex:1],[splitedUrl objectAtIndex:2]], self.file.filePath, self.file.fileName];
    
    serverUrl = [serverUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __block NSString *localPath = nil;
    
    if (self.file.isNecessaryUpdate) {
        //Change the local name for a temporal one
        self.temporalFileName = [NSString stringWithFormat:@"%@-%@", [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]], [self.file.fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        localPath = [NSString stringWithFormat:@"%@%@", self.currentLocalFolder, self.temporalFileName];
    } else {
        localPath = [NSString stringWithFormat:@"%@%@", self.currentLocalFolder, [self.file.fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    self.deviceLocalPath = localPath;
    
    if (!self.file.isNecessaryUpdate && (self.file.isDownload != overwriting)) {
        //Change file status in Data Base to downloading
        [ManageFilesDB setFileIsDownloadState:self.file.idFile andState:downloading];
    } else if (self.file.isNecessaryUpdate) {
        //Change file status in Data Base to updating
        [ManageFilesDB setFileIsDownloadState:self.file.idFile andState:updating];
    }
    
    //Set the right credentials
    if (k_is_sso_active) {
        [sharedCommunication setCredentialsWithCookie:self.user.password];
    } else if (k_is_oauth_active) {
        [sharedCommunication setCredentialsOauthWithToken:self.user.password];
    } else {
        [sharedCommunication setCredentialsWithUser:self.user.username andPassword:self.user.password];
    }
    
   self.state = downloadWorking;
    
 
    
    self.operation = [sharedCommunication downloadFile:serverUrl toDestiny:localPath withLIFOSystem:self.isLIFO onCommunication:sharedCommunication progressDownload:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        [self.progressView stopSpinProgressBackgroundLayer];
        float percent = (float)totalBytesRead / totalBytesExpectedToRead;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView setProgress:percent];
        });
        
        
    } successRequest:^(NSHTTPURLResponse *response, NSString *redirectedServer) {
        [self.progressView stopSpinProgressBackgroundLayer];
        
        BOOL isSamlCredentialsError = NO;
        
        //Check the login error in shibboleth
        if (k_is_sso_active && redirectedServer) {
            //Check if there are fragmens of saml in url, in this case there are a credential error
            isSamlCredentialsError = [FileNameUtils isURLWithSamlFragment:redirectedServer];
            if (isSamlCredentialsError) {
                //Set not download or downloaded in database
                if (self.file.isNecessaryUpdate) {
                    [ManageFilesDB setFileIsDownloadState:self.file.idFile andState:downloaded];
                    
                } else {
                    [ManageFilesDB setFileIsDownloadState:self.file.idFile andState:notDownload];
                }
                [self deleteFileFromLocalFolder];
                self.state = downloadFailed;
                [self.delegate downloadFailed:NSLocalizedString(@"session_expired", nil) andFile:self.file];
            }
        }
        
        if (!isSamlCredentialsError) {
            if (self.file.isNecessaryUpdate) {
                if (![self updateFile:self.file withTemporalFile:self.deviceLocalPath]) {
                    NSLog(@"Problem updating the file");
                }else{
                    self.file.isNecessaryUpdate = NO;
                    [ManageFilesDB setFile:self.file.idFile isNecessaryUpdate:NO];
                }
            }
            
            [ManageFilesDB setFileIsDownloadState:self.file.idFile andState:downloaded];
            
            if (!self.file.isNecessaryUpdate) {
                //Set the store etag
                [ManageFilesDB updateEtagOfFileDtoByid:self.file.idFile andNewEtag:self.etagToUpdate];
            }
            
            self.state = downloadComplete;
            
            double delayInSeconds = k_progressView_delay_just_download;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.progressView setHidden:YES];
                [self.delegate downloadCompleted:self.file];
            });
            
            delayInSeconds = k_progressView_delay_after_download;
            popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.progressView setProgress:0.0];
            });
        }
        
    } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
        [self.progressView stopSpinProgressBackgroundLayer];
        self.state = downloadFailed;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressView setProgress:0.0];
        });
        
        [self failureInDownloadProcessWithError:error andResponse:response];
        
    } shouldExecuteAsBackgroundTaskWithExpirationHandler:^{
       [self.delegate downloadFailed:@"" andFile:self.file];
    }];

}

- (void) cancelDownload{
    
    self.isCancelTapped = YES;
    
    switch (self.state) {
        case downloadNotStarted:
            [self.progressView stopSpinProgressBackgroundLayer];
            [self.delegate downloadCancelled:self.file];
            break;
        
        case downloadCheckingEtag:
            [self.progressView stopSpinProgressBackgroundLayer];
            [self.delegate downloadCancelled:self.file];
            break;
            
        case downloadWorking:
            [self.operation cancel];
            break;
            
        case downloadComplete:
            break;
            
        case downloadFailed:
            break;
            
        default:
            break;
    }
    
   
}

- (void) failureInDownloadProcessWithError:(NSError*)error andResponse:(NSHTTPURLResponse*)response{
    
    self.file = [ManageFilesDB getFileDtoByIdFile:self.file.idFile];
    
    //Set not download or downloaded in database if the file is not on an overwritten process
    if (self.file.isDownload != overwriting) {
        if (self.file.isNecessaryUpdate) {
            [ManageFilesDB setFileIsDownloadState:self.file.idFile andState:downloaded];
        } else {
            [ManageFilesDB setFileIsDownloadState:self.file.idFile andState:notDownload];
        }
    }
    
    if (error.code == NSURLErrorCancelled) {
        [self.delegate downloadCancelled:self.file];
    }else if (error.code == NSURLErrorUserCancelledAuthentication && !response){
        [self.delegate downloadFailed:NSLocalizedString(@"error_connecting_with_server", nil) andFile:self.file];
    }else{
        switch (response.statusCode) {
            case kOCErrorServerUnauthorized:
                [self.delegate downloadFailed:NSLocalizedString(@"error_login_message", nil) andFile:self.file];
                
                break;
            case kOCErrorServerForbidden:
                [self.delegate downloadFailed:NSLocalizedString(@"not_establishing_connection", nil) andFile:self.file];
                break;
            case kOCErrorProxyAuth:
                [self.delegate downloadFailed:NSLocalizedString(@"not_establishing_connection", nil) andFile:self.file];
                break;
            case kOCErrorServerPathNotFound:
                [self.delegate downloadFailed:NSLocalizedString(@"download_file_exist", nil) andFile:self.file];
                break;
            default:
                [self.delegate downloadFailed:NSLocalizedString(@"not_possible_connect_to_server", nil) andFile:self.file];
                break;
        }
    }
    
    //Erase cache and cookies
    [self eraseURLCache];
}

#pragma mark File Manager

///-----------------------------------
/// @name Delete File From Local Folder
///-----------------------------------

/**
 * Method that delete a file from local folder.
 * It's called when the download fails or the user cancel an updating process
 */
- (void) deleteFileFromLocalFolder{
    //Delete file
    NSString *fileToDelete;
    if (self.file.isNecessaryUpdate) {
        fileToDelete = [NSString stringWithFormat:@"%@%@", self.currentLocalFolder, self.temporalFileName];
    } else {
        fileToDelete = [NSString stringWithFormat:@"%@%@", self.currentLocalFolder, self.file.fileName];
    }
    NSError *error;
    if([[NSFileManager defaultManager] removeItemAtPath:fileToDelete error:&error]) {
        DLog(@"All ok");
    } else {
        DLog(@"Error: %@",[error localizedDescription]);
    }
}

///-----------------------------------
/// @name Update a file with the temporal one
///-----------------------------------

/**
 * This method updates a file because there is a new version in the server
 *
 * @param file > (FileDto) the file to be updated
 * @param temporalFile > (NSString) the path of the temporal file
 */
- (BOOL) updateFile:(FileDto *)file withTemporalFile:(NSString *)temporalFile {
    
    BOOL updated = YES;
    
    //If the file has been updated
    DLog(@"Temporal local path: %@", temporalFile);
    DLog(@"Old local path: %@", file.localFolder);
    
    //Update the file
    self.file = [ManageFilesDB getFileDtoByFileName:file.fileName andFilePath:[UtilsDtos getFilePathOnDBFromFilePathOnFileDto:file.filePath andUser:self.user] andUser:self.user];
    
    //Delete the old file
    NSFileManager *fileManager=nil;
    fileManager =[NSFileManager defaultManager];
    NSError *error;
    
    //Delete the old file
    if ([fileManager removeItemAtPath:file.localFolder error:&error] != YES){
        DLog(@"Error: %@",[error localizedDescription]);
        updated = NO;
    }
   
    //Change the name of the new updated file
    if(![fileManager moveItemAtPath:temporalFile toPath:file.localFolder error:&error]){
        DLog(@"Error: %@",[error localizedDescription]);
        updated = NO;
    }
    else{
        DLog(@"Replace old file by updated file");
        updated = YES;
    }
    
    return updated;
}

- (void)eraseURLCache
{
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
}

@end
