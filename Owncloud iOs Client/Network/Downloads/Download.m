//
//  Download.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 09/01/13.
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


#import "Download.h"
#import "UserDto.h"
#import "AppDelegate.h"
#import "UtilsDtos.h"
#import "UtilsUrls.h"
#import "Customization.h"
#import "ManageFilesDB.h"
#import "constants.h"
#import "FileNameUtils.h"
#import "OCCommunication.h"
#import "OCErrorMsg.h"
#import "ManageFavorites.h"
#import "FilesViewController.h"
#import "UploadUtils.h"

#define k_task_identifier_invalid -1

NSString * fileWasDownloadNotification = @"fileWasDownloadNotification";


@implementation Download


- (id) init{
    
    self = [super init];
    if (self) {
        _isCancel = NO;
        _isComplete = NO;
        _isFirstTime = YES;
        _isLIFO = YES;
    }
    return self;
}



#pragma mark - Download Actions

///-----------------------------------
/// @name File to download
///-----------------------------------

/**
 * Method that create the resquest to download a specific file
 *
 * @param file -> FileDto
 */
- (void)fileToDownload:(FileDto *)file{
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //Get file object
    file = [ManageFilesDB getFileDtoByFileName:file.fileName andFilePath:[UtilsDtos getFilePathOnDBFromFilePathOnFileDto:file.filePath andUser:app.activeUser] andUser:app.activeUser];
    _fileDto=file;
    
    //Get the etag
    [self updateThisEtagWithTheLast];
}


///-----------------------------------
/// @name Process to download a file
///-----------------------------------

/**
 * This method download the _fileDto when we have the etag of the file
 */
- (void) processToDownloadTheFile {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //Get url path of server
    NSArray *splitedUrl = [app.activeUser.url componentsSeparatedByString:@"/"];
    NSString *serverUrl = [NSString stringWithFormat:@"%@%@%@",[NSString stringWithFormat:@"%@/%@/%@",[splitedUrl objectAtIndex:0],[splitedUrl objectAtIndex:1],[splitedUrl objectAtIndex:2]], _fileDto.filePath, _fileDto.fileName];
    
    serverUrl = [UploadUtils getUrlWithRedirectionByOriginalURL:serverUrl];
    
    serverUrl = [serverUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //get local path of server
    __block NSString *localPath;
    
    if (_fileDto.isNecessaryUpdate) {
        //Change the local name for a temporal one
        _temporalFileName = [NSString stringWithFormat:@"%@-%@", [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]], [_fileDto.fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        localPath = [NSString stringWithFormat:@"%@%@", _currentLocalFolder, _temporalFileName];
    } else {
        localPath = [NSString stringWithFormat:@"%@%@", _currentLocalFolder, [_fileDto.fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    _deviceLocalPath = localPath;
    
    DLog(@"SERVER URL: %@", serverUrl);
    DLog(@"LOCAL PATH: %@", localPath);
    
    if (!_fileDto.isNecessaryUpdate && (_fileDto.isDownload != overwriting)) {
        //Change file status in Data Base to downloading
        [ManageFilesDB setFileIsDownloadState:_fileDto.idFile andState:downloading];
    } else if (_fileDto.isNecessaryUpdate) {
        //Change file status in Data Base to updating
        [ManageFilesDB setFileIsDownloadState:_fileDto.idFile andState:updating];
    }
    
    [self reloadFileListForDataBase];
   
    
    //Set the right credentials
    if (k_is_sso_active) {
        [[AppDelegate sharedOCCommunication] setCredentialsWithCookie:app.activeUser.password];
    } else if (k_is_oauth_active) {
        [[AppDelegate sharedOCCommunication] setCredentialsOauthWithToken:app.activeUser.password];
    } else {
        [[AppDelegate sharedOCCommunication] setCredentialsWithUser:app.activeUser.username andPassword:app.activeUser.password];
    }
    
    
    __weak typeof(self) weakSelf = self;
    
    
    if ((IS_IOS7 || IS_IOS8) && !k_is_sso_active) {
         NSProgress *progressValue;
        
        _downloadTask = [[AppDelegate sharedOCCommunication] downloadFileSession:serverUrl  toDestiny:localPath defaultPriority:NO onCommunication:[AppDelegate sharedOCCommunication] withProgress:&progressValue successRequest:^(NSURLResponse *response, NSURL *filePath) {
            
            //Finalized the download
            [weakSelf updateDataDownload];
            [weakSelf setDownloadTaskIdentifierValid:NO];
            
        } failureRequest:^(NSURLResponse *response, NSError *error) {
            
            DLog(@"Error: %@", error);
            DLog(@"error.code: %ld", (long)error.code);
            
            if (!self.isForceCanceling) {
                
                [weakSelf setDownloadTaskIdentifierValid:NO];
                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                DLog(@"Operation error: %ld", (long)httpResponse.statusCode);
                
                //Update the fileDto
                _fileDto = [ManageFilesDB getFileDtoByIdFile:_fileDto.idFile];
                
                [self failureDownloadProcess];
                
                if ([error code] != NSURLErrorCancelled && weakSelf.isCancel==NO) {
                    
                    switch (error.code) {
                        case kCFURLErrorUserCancelledAuthentication: { //-1012
                            
                            [weakSelf.delegate downloadFailed:NSLocalizedString(@"not_possible_connect_to_server", nil) andFile:weakSelf.fileDto];
                            
                            CheckAccessToServer *mCheckAccessToServer = [CheckAccessToServer new];
                            [mCheckAccessToServer isConnectionToTheServerByUrl:app.activeUser.url];
                            
                            break;
                        }
                        case kCFURLErrorUserAuthenticationRequired:{
                            [weakSelf.delegate downloadFailed:nil andFile:weakSelf.fileDto];
                            [weakSelf.delegate errorLogin];
                            
                            break;
                        }
                        default:
                            
                            switch (httpResponse.statusCode) {
                                case kOCErrorServerUnauthorized:
                                    [weakSelf.delegate downloadFailed:nil andFile:weakSelf.fileDto];
                                    [weakSelf.delegate errorLogin];
                                    break;
                                case kOCErrorServerForbidden:
                                    [weakSelf.delegate downloadFailed:NSLocalizedString(@"not_establishing_connection", nil) andFile:weakSelf.fileDto];
                                    break;
                                case kOCErrorProxyAuth:
                                    [weakSelf.delegate downloadFailed:NSLocalizedString(@"not_establishing_connection", nil) andFile:weakSelf.fileDto];
                                    break;
                                case kOCErrorServerPathNotFound:
                                    [weakSelf.delegate downloadFailed:NSLocalizedString(@"download_file_exist", nil) andFile:weakSelf.fileDto];
                                    break;
                                default:
                                    [weakSelf.delegate downloadFailed:NSLocalizedString(@"not_possible_connect_to_server", nil) andFile:weakSelf.fileDto];
                                    break;
                            }
                    }
                }
                
                //Erase cache and cookies
                [weakSelf eraseURLCache];
        
            }
  
        }];
        
        // Observe fractionCompleted using KVO
        [progressValue addObserver:self
                        forKeyPath:@"fractionCompleted"
                           options:NSKeyValueObservingOptionNew
                           context:NULL];
        
        
    } else {
        
        //Create the block of NSOperation to download.
        _operation = [[AppDelegate sharedOCCommunication] downloadFile:serverUrl toDestiny:localPath withLIFOSystem:_isLIFO onCommunication:[AppDelegate sharedOCCommunication]
                                                      progressDownload:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                                                          
                                                          //If is first input of download
                                                          if (weakSelf.isFirstTime==YES) {
                                                              weakSelf.totalBytesOfFile=totalBytesExpectedToRead;
                                                              weakSelf.isFirstTime=NO;
                                                          }
                                                          
                                                          if(totalBytesExpectedToRead/1024 == 0) {
                                                              //Calculate the percent and the custom string
                                                              float percent = (float)totalBytesRead / totalBytesRead;
                                                              //Delegate percentage and progress string
                                                              [weakSelf.delegate percentageTransfer:percent andFileDto:weakSelf.fileDto];
                                                              NSString *progressString = [NSString stringWithFormat:@"%qu Bytes / %qu Bytes", totalBytesRead, totalBytesRead];
                                                              [weakSelf.delegate progressString:progressString andFileDto:weakSelf.fileDto];
                                                              
                                                          } else {
                                                              //Calculate the percent and the custom string
                                                              float percent = (float)totalBytesRead / weakSelf.totalBytesOfFile;
                                                              [weakSelf.delegate percentageTransfer:percent andFileDto:weakSelf.fileDto];
                                                              NSString *progressString = [NSString stringWithFormat:@"%qu KB / %qu KB", totalBytesRead/1024, weakSelf.totalBytesOfFile/1024];
                                                              [weakSelf.delegate progressString:progressString andFileDto:weakSelf.fileDto];
                                                          }
                                                          
                                                          
                                                      } successRequest:^(NSHTTPURLResponse *response, NSString *redirectedServer) {
                                                          
                                                          BOOL isSamlCredentialsError=NO;
                                                          
                                                          //Check the login error in shibboleth
                                                          if (k_is_sso_active && redirectedServer) {
                                                              //Check if there are fragmens of saml in url, in this case there are a credential error
                                                              isSamlCredentialsError = [FileNameUtils isURLWithSamlFragment:redirectedServer];
                                                              if (isSamlCredentialsError) {
                                                                  //Set not download or downloaded in database
                                                                  if (_fileDto.isNecessaryUpdate) {
                                                                      [ManageFilesDB setFileIsDownloadState:weakSelf.fileDto.idFile andState:downloaded];
                                                                      
                                                                  } else {
                                                                      [ManageFilesDB setFileIsDownloadState:weakSelf.fileDto.idFile andState:notDownload];
                                                                  }
                                                                  [weakSelf deleteFileFromLocalFolder];
                                                                  [weakSelf removeDownloadOfGlobalArray];
                                                                  [weakSelf removeFileOfFavorites];
                                                                  [weakSelf.delegate downloadFailed:nil andFile:weakSelf.fileDto];
                                                                  [weakSelf.delegate errorLogin];
                                                              }
                                                          }
                                                          if (!isSamlCredentialsError) {
                                                              //Finalized the download
                                                              [weakSelf updateDataDownload];
                                                          }
                                                          
                                                      } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
                                                          DLog(@"Error: %@", error);
                                                          DLog(@"error.code: %ld", (long)error.code);
                                                          DLog(@"response.statusCode: %ld", (long)response.statusCode);
                                                          //Update the fileDto
                                                          _fileDto = [ManageFilesDB getFileDtoByIdFile:_fileDto.idFile];
                                                          
                                                          [self failureDownloadProcess];
                                                          
                                                          if ([error code] != NSURLErrorCancelled && weakSelf.isCancel==NO) {
                                                              
                                                              switch (error.code) {
                                                                  case kCFURLErrorUserCancelledAuthentication: { //-1012
                                                                      
                                                                      [weakSelf.delegate downloadFailed:NSLocalizedString(@"not_possible_connect_to_server", nil) andFile:weakSelf.fileDto];
                                                                      
                                                                      CheckAccessToServer *mCheckAccessToServer = [CheckAccessToServer new];
                                                                      [mCheckAccessToServer isConnectionToTheServerByUrl:app.activeUser.url];
                                                                      
                                                                      break;
                                                                  }
                                                                  default:
                                                                      
                                                                      switch (response.statusCode) {
                                                                          case kOCErrorServerUnauthorized:
                                                                              [weakSelf.delegate downloadFailed:nil andFile:weakSelf.fileDto];
                                                                              [weakSelf.delegate errorLogin];
                                                                              break;
                                                                          case kOCErrorServerForbidden:
                                                                              [weakSelf.delegate downloadFailed:NSLocalizedString(@"not_establishing_connection", nil) andFile:weakSelf.fileDto];
                                                                              break;
                                                                          case kOCErrorProxyAuth:
                                                                              [weakSelf.delegate downloadFailed:NSLocalizedString(@"not_establishing_connection", nil) andFile:weakSelf.fileDto];
                                                                              break;
                                                                          case kOCErrorServerPathNotFound:
                                                                              [weakSelf.delegate downloadFailed:NSLocalizedString(@"download_file_exist", nil) andFile:weakSelf.fileDto];
                                                                              break;
                                                                          default:
                                                                              [weakSelf.delegate downloadFailed:NSLocalizedString(@"not_possible_connect_to_server", nil) andFile:weakSelf.fileDto];
                                                                              break;
                                                                      }
                                                              }
                                                          }
                                                          
                                                          //Erase cache and cookies
                                                          [weakSelf eraseURLCache];
                                                          
                                                      } shouldExecuteAsBackgroundTaskWithExpirationHandler:^{
                                                          //Cancel download
                                                          [weakSelf.delegate downloadFailed:nil andFile:weakSelf.fileDto];
                                                          [weakSelf cancelDownload];
                                                      }];
        

    }
    
    if (_downloadTask) {
        [self setDownloadTaskIdentifierValid:YES];
    }
    
    //Add this object to a global array of downloads
    [self addDownloadOfGlobalArray];
    
}

///-----------------------------------
/// @name Set Download Task Identifier
///-----------------------------------

/**
 * Method used to store a value of task identifier
 *
 * @param isValid -> BOOL {if is true, we store the taskidentifier of a download in background,
 * if not, we store invaid task identifier value
 *
 */
- (void) setDownloadTaskIdentifierValid:(BOOL)isValid {
    
    if (isValid) {
        [ManageFilesDB updateFile:self.fileDto.idFile withTaskIdentifier:self.downloadTask.taskIdentifier];
    }else{
        [ManageFilesDB updateFile:self.fileDto.idFile withTaskIdentifier:k_task_identifier_invalid];
    }
    
}

//KVO method for update the bar progress and the progress string
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"] && [object isKindOfClass:[NSProgress class]]) {
        NSProgress *progress = (NSProgress *)object;
        
        // Percent
        float percent = roundf (progress.fractionCompleted * 100) / 100.0;
        DLog(@"Download percent is: %f", percent);
        
        // Progress
        NSInteger currentProgressDownload = 0;
        NSInteger totalProgressDownload = 0;
        NSString *progressString;
        
        currentProgressDownload = (NSInteger)progress.completedUnitCount;
        if (currentProgressDownload) {
            
            totalProgressDownload = (NSInteger)progress.totalUnitCount;
            
            if (totalProgressDownload/1024 == 0) {
                progressString = [NSString stringWithFormat:@"%ld Bytes / %ld Bytes", (long)currentProgressDownload, (long)totalProgressDownload];
            }else{
                progressString = [NSString stringWithFormat:@"%ld KB / %ld KB", (long)(currentProgressDownload/1024), (long)(totalProgressDownload/1024)];
            }
        }

        //We make it on the main thread because we came from a delegate
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (percent > 0) {
                [self.delegate percentageTransfer:percent andFileDto:self.fileDto];
            }
            
            if (progressString) {
                [self.delegate progressString:progressString andFileDto:self.fileDto];
            }
            
        });
        
    }
    
}




///-----------------------------------
/// @name Update data Download
///-----------------------------------

/**
 * Method that update the data download
 *
 */
- (void)updateDataDownload{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //Obtain if the file is an updating one
    BOOL isNecessaryUpdate = _fileDto.isNecessaryUpdate;
    _isComplete=YES;
    
    if (isNecessaryUpdate) {
        //Delete the temporal file
        [self updateFile:_fileDto withTemporalFile:_deviceLocalPath];
    }
    
    //Update the datas of the new file
    _fileDto = [ManageFilesDB getFileDtoByFileName:_fileDto.fileName andFilePath:[UtilsDtos getFilePathOnDBFromFilePathOnFileDto:_fileDto.filePath andUser:app.activeUser] andUser:app.activeUser];
    
    //Set file status like downloaded in Data Base
    [ManageFilesDB setFileIsDownloadState:_fileDto.idFile andState:downloaded];
    
    _fileDto.isNecessaryUpdate = isNecessaryUpdate;
    
    //Set the store etag
    [ManageFilesDB updateEtagOfFileDtoByid:_fileDto.idFile andNewEtag:_etagToUpdate];
    
    [self finalizeDownload];
    
}


///-----------------------------------
/// @name Finalize Download
///-----------------------------------

/**
 * Method to finalize download task when download process has finished
 *
 */
- (void) finalizeDownload {

    //Remove the object of global download array
    [self removeDownloadOfGlobalArray];
    
    //Remove file of favorites sync
    [self removeFileOfFavorites];
    
     //Send that download is complete
    if ([(NSObject*)self.delegate respondsToSelector:@selector(downloadCompleted:)]) {
        [self.delegate downloadCompleted:self.fileDto];
    }
    
    //Reload file list with notification to FileListViewController class
    [self reloadFileList];
}



///-----------------------------------
/// @name Cancel Download
///-----------------------------------

/**
 * Method that cancel the download in progress
 *
 */
- (void)cancelDownload{
    
    //Check if the file is complete
    if (_isComplete==NO) {
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        //Get FileDto
        _fileDto = [ManageFilesDB getFileDtoByFileName:_fileDto.fileName andFilePath:[UtilsDtos getFilePathOnDBFromFilePathOnFileDto:_fileDto.filePath andUser:app.activeUser] andUser:app.activeUser];
        
        //If is downloaded or not
        if ([_fileDto isDownload] == downloaded && !_fileDto.isNecessaryUpdate) {
            DLog(@"Just downloaded");
            
        }else {
            DLog(@"Cancel download: %ld", (long)_fileDto.idFile);
            //Set boolean to YES
            _isCancel=YES;
            
            //Current upload
            if (_operation) {
                [_operation cancel];
                _operation = nil;
            }
            
            if (_downloadTask) {
                self.isForceCanceling = NO;
                [_downloadTask cancel];
                
                
            }
            
            //Clear the chache and cookies
            [self eraseURLCache];
            
            //Set not download in database            
            if (!_fileDto.isNecessaryUpdate) {
                [ManageFilesDB setFileIsDownloadState:_fileDto.idFile andState:notDownload];
            } else {
                [ManageFilesDB setFileIsDownloadState:_fileDto.idFile andState:downloaded];
            }
            
            [self reloadFileListForDataBase];
            
            if (_fileDto.isFavorite) {
                [self removeFileOfFavorites];
            }
            [self deleteFileFromLocalFolder];
        }
    }
    //Remove this object of the global array
    [self removeDownloadOfGlobalArray];
}


/*
 * Called when the download fails, it possible called outside
 */
- (void) failureDownloadProcess {
    
    //Update the fileDto
    _fileDto = [ManageFilesDB getFileDtoByIdFile:_fileDto.idFile];
    //Set not download or downloaded in database if the file is not on an overwritten process
    if (_fileDto.isDownload != overwriting) {
        if (_fileDto.isNecessaryUpdate) {
            [ManageFilesDB setFileIsDownloadState:self.fileDto.idFile andState:downloaded];
        } else {
            [ManageFilesDB setFileIsDownloadState:self.fileDto.idFile andState:notDownload];
        }
    }
    
    [self reloadFileListForDataBase];
    [self deleteFileFromLocalFolder];
    [self removeDownloadOfGlobalArray];
    [self removeFileOfFavorites];

    
}

#pragma mark - Delete cache of URL


///-----------------------------------
/// @name Erase URL Cache
///-----------------------------------

/**
 * Method that clear the URL cache
 *
 */
- (void)eraseURLCache
{
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
}

#pragma mark Global Download Array Manager

///-----------------------------------
/// @name Add Download Global Array
///-----------------------------------

/**
 * Method that add this object in a global array
 */
- (void)addDownloadOfGlobalArray{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.downloadManager addDownload:self];
}

/**
 * Method that remove this object of a global array
 */
- (void)removeDownloadOfGlobalArray{
    //Remove this objetc to a main class "AppDelegate"
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.downloadManager removeDownload:self];
}

#pragma mark - Favorites 

/*
 * Remove _fileDto of the sync process
 */
- (void) removeFileOfFavorites{
    
    [[AppDelegate sharedManageFavorites] removeOfSyncProcessFile:_fileDto];
}

#pragma mark - FilesViewController callBacks

///-----------------------------------
/// @name Reload File List
///-----------------------------------

/**
 * Method that post a Notification to reload the file list
 */
- (void)reloadFileList{
    [[NSNotificationCenter defaultCenter] postNotificationName: fileWasDownloadNotification object: _fileDto];
}

- (void)reloadFileListForDataBase{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app.presentFilesViewController reloadTableFromDataBase];
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
    if (_fileDto.isNecessaryUpdate) {
        fileToDelete = [NSString stringWithFormat:@"%@%@", _currentLocalFolder, _temporalFileName];
    } else {
        fileToDelete = [NSString stringWithFormat:@"%@%@", _currentLocalFolder, _fileDto.fileName];
    }
    NSError *error;
    if([[NSFileManager defaultManager] removeItemAtPath:fileToDelete error:&error]) {
        DLog(@"All ok");
    } else {
        DLog(@"Error: %@",[error localizedDescription]);
    }
}




#pragma mark - Video Store

///-----------------------------------
/// @name Delegate error while saving video in Gallery
///-----------------------------------

/**
 * This method is called when there are fails saving a videofile in the device gallery.
 */
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    DLog(@"Finished saving video with error: %@", error);
    
    if(error !=nil){
        [_delegate downloadFailed:NSLocalizedString(@"can_no_copy_to_gallery", nil)andFile:_fileDto];
    }
    
}

///-----------------------------------
/// @name Refresh
///-----------------------------------

/**
 * Method to set the last etag on this file on the DB
 */
- (void) updateThisEtagWithTheLast {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //Set the right credentials
    if (k_is_sso_active) {
        [[AppDelegate sharedOCCommunication] setCredentialsWithCookie:app.activeUser.password];
    } else if (k_is_oauth_active) {
        [[AppDelegate sharedOCCommunication] setCredentialsOauthWithToken:app.activeUser.password];
    } else {
        [[AppDelegate sharedOCCommunication] setCredentialsWithUser:app.activeUser.username andPassword:app.activeUser.password];
    }
    
    //FileName full path
    NSString *serverPath = [NSString stringWithFormat:@"%@%@", app.activeUser.url, k_url_webdav_server];
    NSString *path = [NSString stringWithFormat:@"%@%@%@",serverPath, [UtilsDtos getDbBFolderPathFromFullFolderPath:_fileDto.filePath andUser:app.activeUser], _fileDto.fileName];
    
    path = [path stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    __weak typeof(self) weakSelf = self;
    
    [[AppDelegate sharedOCCommunication] readFile:path onCommunication:[AppDelegate sharedOCCommunication] successRequest:^(NSHTTPURLResponse *response, NSArray *items, NSString *redirectedServer) {
        
        DLog(@"Operation response code: %ld", (long)response.statusCode);
        BOOL isSamlCredentialsError=NO;
        
        //Check the login error in shibboleth
        if (k_is_sso_active && redirectedServer) {
            //Check if there are fragmens of saml in url, in this case there are a credential error
            isSamlCredentialsError = [FileNameUtils isURLWithSamlFragment:redirectedServer];
            if (isSamlCredentialsError) {
                DLog(@"error login updating the etag");
                //Set not download or downloaded in database
                if (_fileDto.isNecessaryUpdate) {
                    [ManageFilesDB setFileIsDownloadState:weakSelf.fileDto.idFile andState:downloaded];
                    
                } else {
                    [ManageFilesDB setFileIsDownloadState:weakSelf.fileDto.idFile andState:notDownload];
                }
                [weakSelf deleteFileFromLocalFolder];
                [weakSelf removeDownloadOfGlobalArray];
                [weakSelf removeFileOfFavorites];
                [weakSelf.delegate downloadFailed:nil andFile:weakSelf.fileDto];
                [weakSelf.delegate errorLogin];
            }
        }
        if(response.statusCode < kOCErrorServerUnauthorized && !isSamlCredentialsError) {

            //Change the filePath from the library to our format
            for (FileDto *currentFile in items) {
                //Remove part of the item file path
                NSString *partToRemove = [UtilsUrls getRemovedPartOfFilePathAnd:app.activeUser];
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
                
                _etagToUpdate = currentFileDto.etag;
                [self processToDownloadTheFile];
            }
            
        }
    } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
        
        DLog(@"error: %@", error);
        DLog(@"Operation error: %ld", (long)response.statusCode);
        //Remove this file of favorites sync process
        [weakSelf removeFileOfFavorites];
        
        if ([error code] != NSURLErrorCancelled && weakSelf.isCancel==NO) {
            
            switch (error.code) {
                case kCFURLErrorUserCancelledAuthentication: { //-1012
                    
                    [weakSelf.delegate downloadFailed:NSLocalizedString(@"not_possible_connect_to_server", nil) andFile:weakSelf.fileDto];
                    
                    CheckAccessToServer *mCheckAccessToServer = [CheckAccessToServer new];
                    [mCheckAccessToServer isConnectionToTheServerByUrl:app.activeUser.url];
                    
                    break;
                }
                    
                case kCFURLErrorUserAuthenticationRequired:{
                    [weakSelf.delegate downloadFailed:nil andFile:weakSelf.fileDto];
                    [weakSelf.delegate errorLogin];
                    
                    break;
                }
                
                default:
                    
                    switch (response.statusCode) {
                        case kOCErrorServerUnauthorized:
                            [weakSelf.delegate downloadFailed:nil andFile:weakSelf.fileDto];
                            [weakSelf.delegate errorLogin];
                            break;
                        case kOCErrorServerForbidden:
                            [weakSelf.delegate downloadFailed:NSLocalizedString(@"not_establishing_connection", nil) andFile:weakSelf.fileDto];
                            break;
                        case kOCErrorProxyAuth:
                            [weakSelf.delegate downloadFailed:NSLocalizedString(@"not_establishing_connection", nil) andFile:weakSelf.fileDto];
                            break;
                        case kOCErrorServerPathNotFound:
                            [weakSelf.delegate downloadFailed:NSLocalizedString(@"download_file_exist", nil) andFile:weakSelf.fileDto];
                            break;
                        default:
                            [weakSelf.delegate downloadFailed:NSLocalizedString(@"not_possible_connect_to_server", nil) andFile:weakSelf.fileDto];
                            break;
                    }
                 break;
            }
        }
        //Erase cache
        [weakSelf eraseURLCache];
    }];
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
- (void) updateFile:(FileDto *)file withTemporalFile:(NSString *)temporalFile {
    
    //If the file has been updated
    DLog(@"Temporal local path: %@", temporalFile);
    DLog(@"Old local path: %@", file.localFolder);
    
    //Delete the old file
    DeleteFile *mDeleteFile = [[DeleteFile alloc] init];
    [mDeleteFile deleteItemFromDeviceByFileDto:file];
    
    //Change the name of the new updated file
    NSFileManager *filecopy=nil;
    filecopy =[NSFileManager defaultManager];
    NSError *error;
    if(![filecopy moveItemAtPath:temporalFile toPath:file.localFolder error:&error]){
        DLog(@"Error: %@",[error localizedDescription]);
    }
    else{
        DLog(@"All ok");
    }
}



@end
