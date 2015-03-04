//
//  PrepareFilesToUpload.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 12/09/12.
//

/**
 *    @author Javier Gonzalez
 *    @author Gonzalo Gonzalez
 *    @author Noelia Alvarez
 *    @author Rebeca Martin de Leon
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


#import "PrepareFilesToUpload.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "CheckAccessToServer.h"
#import "AppDelegate.h"

#import "UserDto.h"
#import "constants.h"
#import "EditAccountViewController.h"
#import "UtilsDtos.h"
#import "ManageUploadsDB.h"
#import "FileNameUtils.h"
#import "UploadUtils.h"
#import "ManageUsersDB.h"
#import "ManageUploadRequest.h"
#import "OCAsset.h"
#import "ManageAsset.h"
#import "ManageAppSettingsDB.h"
#import "UtilsNetworkRequest.h"
#import "constants.h"
#import "Customization.h"
#import "UtilsUrls.h"
#import "OCCommunication.h"

//Notification to end and init loading screen
NSString *EndLoadingFileListNotification = @"EndLoadingFileListNotification";
NSString *InitLoadingFileListNotification = @"InitLoadingFileListNotification";
NSString *ReloadFileListFromDataBaseNotification = @"ReloadFileListFromDataBaseNotification";


@implementation PrepareFilesToUpload

#pragma  mark - Manage queue
- (void) addFilesToUpload:(NSArray *) info andRemoteFoldersToUpload:(NSMutableArray *) arrayOfRemoteurl {
    
    for (int i = 0 ; i < [info count] ; i++) {
        
        [self.listOfFilesToUpload addObject:[info objectAtIndex:i]];
        [self.arrayOfRemoteurl addObject:[arrayOfRemoteurl objectAtIndex:i]];
    }
    
    [self startWithTheNextFile];
}

- (void) startWithTheNextFile {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    BOOL isLastUploadFileOfThisArray = NO;
    
    if ([self.listOfFilesToUpload count] == 1 && [self.arrayOfRemoteurl count]== 1) {
        isLastUploadFileOfThisArray = YES;
    }
    
    [self uploadFileFromGallery:[self.listOfFilesToUpload objectAtIndex:0] andRemoteFolder:[self.arrayOfRemoteurl objectAtIndex:0] andCurrentUser:appDelegate.activeUser andIsLastFile:isLastUploadFileOfThisArray];
    
    [self.listOfFilesToUpload removeObjectAtIndex:0];
    [self.arrayOfRemoteurl removeObjectAtIndex:0];
}

- (void)sendFileToUploadByUploadOfflineDto:(UploadsOfflineDto *) currentUpload {
    
    DLog(@"self.currentUpload: %@", currentUpload.uploadFileName);
    DLog(@"isLast: %d", currentUpload.isLastUploadFileOfThisArray);
    
    ManageUploadRequest *currentManageUploadRequest = [ManageUploadRequest new];
    currentManageUploadRequest.delegate = self;
    currentManageUploadRequest.lenghtOfFile = [UploadUtils makeLengthString:currentUpload.estimateLength];
    
    [currentManageUploadRequest addFileToUpload:currentUpload];
    
}

- (void)uploadFileFromGallery:(NSDictionary *)info andRemoteFolder:(NSString *) remoteFolder andCurrentUser:(UserDto *) currentUser andIsLastFile:(BOOL) isLastUploadFileOfThisArray
{
    
    DLog(@"uploadFileFromGallery");
    
    //Hardik Comment: condition changed instead of "public.image" to "ALAssetTypePhoto"
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset){
        
        @autoreleasepool {
            
            NSString *currentFileName = nil;
            
            NSURL *assetURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
            NSString *assetPath = [assetURL absoluteString];
            DLog(@"assetPath :%@", assetPath);
            
            currentFileName = [self getComposeNameFromAsset:myasset];
            
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            //NSString *uniquePath= [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] stringByAppendingPathComponent:_uploadFileName];
            
            DLog(@"currentFileName: %@",currentFileName);
            DLog(@"remoteFolder: %@", remoteFolder);
            DLog(@"isLastUploadFileOfThisArray: %d", isLastUploadFileOfThisArray);
            
            //Use a temporal name with a date identification
            NSString *temporalFileName = [NSString stringWithFormat:@"%@-%@", [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]], [currentFileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

            NSString *localPath= [[UtilsUrls getTempFolderForUploadFiles] stringByAppendingPathComponent:temporalFileName];
            
            //Divide the file in chunks of 1024KB, then create the file with all chunks
            
            //Variables
            NSUInteger offset = 0;
            NSUInteger chunkSize = 1024 * 1024;
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            NSUInteger length = (NSUInteger)rep.size;
            
            DLog(@"rep size %lld", (rep.size/1024)/1024);
            DLog(@"rep size %lu", (unsigned long) (length/1024)/1024);
            
            if (length < (k_lenght_chunk *1024)) {
                Byte *buffer = (Byte*)malloc(length);
                NSUInteger k = [rep getBytes:buffer fromOffset: 0.0
                                      length:length error:nil];
                
                NSData *adata = [NSData dataWithBytesNoCopy:buffer length:k freeWhenDone:YES];
                [adata writeToFile:localPath atomically:YES];
            }else{
                
                //Create file
                NSFileManager *fm = [NSFileManager defaultManager];
                [fm createFileAtPath:localPath contents:nil attributes:nil];
                
                
                do {
                    Byte *buffer = (Byte*)malloc(chunkSize);
                    
                    //Store the chunk size
                    NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
                    
                    //Write data
                    NSUInteger k = [rep getBytes:buffer fromOffset: offset length:thisChunkSize error:nil];
                    
                    NSData *adata = [NSData dataWithBytes:buffer length:k];
                    
                    DLog(@"Write buffer in file: %@", localPath);
                    NSFileHandle *fileHandle=[NSFileHandle fileHandleForWritingAtPath:localPath];
                    [fileHandle seekToEndOfFile];
                    [fileHandle writeData:adata];
                    [fileHandle closeFile];
                    
                    
                    //Avanced position
                    offset += thisChunkSize;
                    
                    //Free memory
                    free(buffer);
                    fileHandle=nil;
                    adata=nil;
                } while (offset < length);
            }
            
            UploadsOfflineDto *currentUpload = [[UploadsOfflineDto alloc] init];
            currentUpload.originPath = localPath;
            currentUpload.destinyFolder = remoteFolder;
            currentUpload.uploadFileName = currentFileName;
            currentUpload.estimateLength = length;
            currentUpload.userId = currentUser.idUser;
            currentUpload.isLastUploadFileOfThisArray = isLastUploadFileOfThisArray;
            currentUpload.status = waitingAddToUploadList;
            currentUpload.chunksLength = k_lenght_chunk;
            currentUpload.uploadedDate = 0;
            currentUpload.kindOfError = notAnError;
            currentUpload.isInternalUpload = YES;
            currentUpload.taskIdentifier = 0;
            
            [self.listOfUploadOfflineToGenerateSQL addObject:currentUpload];
            
            if([self.listOfFilesToUpload count] > 0 && [self.arrayOfRemoteurl count] > 0) {
                //We have more files to process
                [self startWithTheNextFile];
            } else {
                
                //We finish all the files of this block
                DLog(@"self.listOfUploadOfflineToGenerateSQL: %lu", (unsigned long)[self.listOfUploadOfflineToGenerateSQL count]);
                
                //In this point we have all the files to upload in the Array
                [ManageUploadsDB insertManyUploadsOffline:self.listOfUploadOfflineToGenerateSQL];
                
                //if is the last one we reset the array
                self.listOfUploadOfflineToGenerateSQL = nil;
                self.listOfUploadOfflineToGenerateSQL = [[NSMutableArray alloc] init];
                
                self.positionOfCurrentUploadInArray = 0;
                
                [self performSelectorOnMainThread:@selector(endLoadingInFileList) withObject:nil waitUntilDone:YES];
                
                UploadsOfflineDto *currentFile = [ManageUploadsDB getNextUploadOfflineFileToUpload];
                
                //We begin with the first file of the array
                if (currentFile) {
                    [self sendFileToUploadByUploadOfflineDto:currentFile];
                }
            }
        }
    };
    ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror){
        DLog(@"Cannot get image - %@",[myerror localizedDescription]);
        
    };
    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    
    [assetslibrary assetForURL:videoURL resultBlock:resultblock failureBlock:failureblock];
}


#pragma mark - Upload camera assets, instant upload

- (void) addAssetsToUpload:(NSArray *) assetsToUpload andRemoteFolder:(NSString *) remoteFolder {
    
    self.nameRemoteInstantUploadFolder = remoteFolder;
    
    for (int i = 0 ; i < [assetsToUpload count] ; i++) {
        
        [self.listOfAssetsToUpload addObject:[assetsToUpload objectAtIndex:i]];
    }
    
    [self startWithTheNextAsset];
}

- (void) startWithTheNextAsset {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.pathRemoteInstantUpload = [[NSString alloc]initWithFormat:@"%@%@%@/",app.activeUser.url,k_url_webdav_server,[self nameRemoteInstantUploadFolder]];
    DLog(@"remoteFolder: %@", self.pathRemoteInstantUpload);

    BOOL isLastUploadFileOfThisArray = NO;
    
    if ([self.listOfAssetsToUpload count] == 1) {
        isLastUploadFileOfThisArray = YES;
    }
    
    OCAsset *assetToUpload = [self.listOfAssetsToUpload objectAtIndex:0];
    
    [self.listOfAssetsToUpload removeObjectAtIndex:0];

    [self uploadAssetFromGallery:assetToUpload andRemoteFolder:self.pathRemoteInstantUpload andCurrentUser:app.activeUser andIsLastFile:isLastUploadFileOfThisArray];

}

- (void) uploadAssetFromGallery:(OCAsset *) assetToUpload andRemoteFolder:(NSString *) remoteFolder andCurrentUser:(UserDto *) currentUser andIsLastFile:(BOOL) isLastUploadFileOfThisArray{
    DLog(@"uploadAssetFromGalleryToRemoteFolder");

    NSString *currentFileName = nil;
    
    DLog(@"assetPath :%@", [assetToUpload fullUrlString]);
    
    currentFileName = [self getComposeNameFromAsset:[assetToUpload asset]];
    
    DLog(@"currentFileName: %@",currentFileName);
    DLog(@"isLastUploadFileOfThisArray: %d", isLastUploadFileOfThisArray);
    
    //Use a temporal name with a date identification
    NSString *temporalFileName = [NSString stringWithFormat:@"%@-%@", [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]], [currentFileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *localPath = [[UtilsUrls getTempFolderForUploadFiles] stringByAppendingPathComponent:temporalFileName];
    DLog(@"localPath: %@", localPath);
    
    //Divide the file in chunks of 1024KB, then create the file with all chunks
    
    //Variables
    NSUInteger offset = 0;
    NSUInteger chunkSize = 1024 * 1024;
    NSUInteger length = (NSUInteger)[ [assetToUpload asset] defaultRepresentation].size;
    DLog(@"rep size %lu", (unsigned long) (length/1024)/1024);
    
    if (length < (k_lenght_chunk *1024)) {
        Byte *buffer = (Byte*)malloc(length);
        NSUInteger k = [[assetToUpload rep] getBytes:buffer fromOffset: 0.0
                                        length:length error:nil];
        
        NSData *adata = [NSData dataWithBytesNoCopy:buffer length:k freeWhenDone:YES];
        [adata writeToFile:localPath atomically:YES];
    } else {
        
        //Create file
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createFileAtPath:localPath contents:nil attributes:nil];
        
        
        do {
            Byte *buffer = (Byte*)malloc(chunkSize);
            
            //Store the chunk size
            NSUInteger thisChunkSize = length - offset > chunkSize ? chunkSize : length - offset;
            
            //Write data
            NSUInteger k = [[assetToUpload rep] getBytes:buffer fromOffset: offset length:thisChunkSize error:nil];
            
            NSData *adata = [NSData dataWithBytes:buffer length:k];
            
            DLog(@"Write buffer in file: %@", localPath);
            NSFileHandle *fileHandle=[NSFileHandle fileHandleForWritingAtPath:localPath];
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:adata];
            [fileHandle closeFile];
            
            
            //Avanced position
            offset += thisChunkSize;
            
            //Free memory
            free(buffer);
            fileHandle=nil;
            adata=nil;
        } while (offset < length);
    }
    
    UploadsOfflineDto *currentUpload = [[UploadsOfflineDto alloc] init];
    currentUpload.originPath = localPath;
    currentUpload.destinyFolder = remoteFolder;
    currentUpload.uploadFileName = currentFileName;
    currentUpload.estimateLength = length;
    currentUpload.userId = currentUser.idUser;
    currentUpload.isLastUploadFileOfThisArray = isLastUploadFileOfThisArray;
    currentUpload.status = waitingAddToUploadList;
    currentUpload.chunksLength = k_lenght_chunk;
    currentUpload.uploadedDate = 0;
    currentUpload.kindOfError = notAnError;
    currentUpload.isInternalUpload = YES;
    currentUpload.taskIdentifier = 0;

    [self.listOfUploadOfflineToGenerateSQL addObject:currentUpload];
    
    DLog(@"Date Database: %ld", [ManageAppSettingsDB getDateInstantUpload]);
    DLog(@"Date Asset: %ld", (long)[assetToUpload.date timeIntervalSince1970]);
    
    //update date last asset uploaded
    if ((long)[assetToUpload.date timeIntervalSince1970] > [ManageAppSettingsDB getDateInstantUpload]) {
        //assetDate later than startDate
        [ManageAppSettingsDB updateDateInstantUpload:[assetToUpload.date timeIntervalSince1970]];
    }
    
    if([self.listOfAssetsToUpload count] > 0) {
        //We have more files to process
        [self startWithTheNextAsset];
    } else {
        
        //We finish all the files of this block
        DLog(@"self.listOfUploadOfflineToGenerateSQL: %lu", (unsigned long)[self.listOfUploadOfflineToGenerateSQL count]);
        
        //In this point we have all the files to upload in the Array
        [ManageUploadsDB insertManyUploadsOffline:self.listOfUploadOfflineToGenerateSQL];
        
        //if is the last one we reset the array
        self.listOfUploadOfflineToGenerateSQL = nil;
        self.listOfUploadOfflineToGenerateSQL = [[NSMutableArray alloc] init];
        
        self.positionOfCurrentUploadInArray = 0;
        
        [self performSelectorOnMainThread:@selector(endLoadingInFileList) withObject:nil waitUntilDone:YES];
        
        UploadsOfflineDto *currentFile = [ManageUploadsDB getNextUploadOfflineFileToUpload];
        
        //We begin with the first file of the array
        if (currentFile) {
            [self sendFileToUploadByUploadOfflineDto:currentFile];
        }
    }
    
}


#pragma mark - Filename Utils

/*
 Method to generate the name of the file depending if it is a video or an image
 */
-(NSString *)getComposeNameFromAsset:(ALAsset *)asset{
    
    NSString *output = @"";
    NSString *fileName = nil;
    NSString *appleID = nil;
    NSString *mediaType = [asset valueForProperty:ALAssetPropertyType];
    NSDate *date = [asset valueForProperty:ALAssetPropertyDate];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSString* dateString; dateString = [df stringFromDate:date];
    DLog(@"DateString: %@", dateString);
    
    NSString *assetPath = asset.defaultRepresentation.url.absoluteString;
    NSString *ext = [self getExtension:assetPath];
    NSString *completeFileName = asset.defaultRepresentation.filename;
    DLog(@"FileName: %@", completeFileName);
    NSMutableArray *arr =[[NSMutableArray alloc] initWithArray: [completeFileName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]]];
    [arr removeLastObject];
    fileName = [arr firstObject];
    
    arr =[[NSMutableArray alloc] initWithArray: [fileName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]]];
    appleID = [arr lastObject];
    
    if ([mediaType isEqualToString:@"ALAssetTypePhoto"]) {
        output = [NSString stringWithFormat:@"Photo-%@_%@.%@", dateString, appleID, ext];
    } else {
        output = [NSString stringWithFormat:@"Video-%@.%@", dateString, ext];
    }
    
    return output;
    
}

/*
 * This method close the loading view in main screen by local notification
 */
- (void)endLoadingInFileList {
    //Set global loading screen global flag to NO
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.isLoadingVisible = NO;
    //Send notification to indicate to close the loading view
    [[NSNotificationCenter defaultCenter] postNotificationName:EndLoadingFileListNotification object: nil];
}

/*
 * This method close the loading view in main screen by local notification
 */
- (void)initLoadingInFileList {
    //Set global loading screen global flag to NO
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.isLoadingVisible = YES;
    //Send notification to indicate to close the loading view
    [[NSNotificationCenter defaultCenter] postNotificationName:InitLoadingFileListNotification object: nil];
}

/*
 * This method close the loading view in main screen by local notification
 */
- (void)reloadFromDataBaseInFileList {
    [[NSNotificationCenter defaultCenter] postNotificationName:ReloadFileListFromDataBaseNotification object: nil];
}


/*
 * Method to obtain the extension of the file in upper case
 */
- (NSString *)getExtension:(NSString*)string{

    NSArray *arr =[[NSArray alloc] initWithArray: [string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&ext="]]];
    NSString *ext = [NSString stringWithFormat:@"%@",[arr lastObject]];
    ext = [ext uppercaseString];
    
    return ext;
}



#pragma mark - ManageUploadRequestDelegate

/*
 * Method that is called when the upload is completed, its posible that the file
 * is not upload.
 */

- (void)uploadCompleted:(NSString *) currentRemoteFolder {
    DLog(@"uploadCompleted");
    
    if (_delegate) {
        [_delegate refreshAfterUploadAllFiles:currentRemoteFolder];
    } else {
        DLog(@"_delegate is nil");
    }
    
    //Update the Recent Tab for update the number of error in the badge
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [app updateRecents];
}

- (void)uploadFailed:(NSString*)string{
    
    //Error msg
    //Call showAlertView in main thread
    [self performSelectorOnMainThread:@selector(showAlertView:)
                           withObject:string
                        waitUntilDone:YES];
}

- (void)uploadFailedForLoginError:(NSString*)string {
    
    //Cancel all uploads
    //  [self cancelAllUploads];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateRecents];
    if ([(NSObject*)self.delegate respondsToSelector:@selector(errorWhileUpload)]) {
        [_delegate errorWhileUpload];
    }
    
    [self performSelectorOnMainThread:@selector(showAlertView:) withObject:string waitUntilDone:YES];
    
}

- (void)uploadCanceled:(NSObject*)up{
    DLog(@"uploadCanceled");
}

//Control of the number of lost connecition to send only one message for the user
- (void)uploadLostConnectionWithServer:(NSString*)string{
    DLog(@"uploadLostConnectionWithServer:%@", string);
    
    //Error msg
    //Call showAlertView in main thread
  /*  [self performSelectorOnMainThread:@selector(showAlertView:)
                           withObject:string
                        waitUntilDone:YES];*/
}

/*
 * This method is for show alert view in main thread.
 */

- (void) showAlertView:(NSString*)string {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:string message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [alertView show];
}


/*
 * Method to continue with the next file of the list (or the first)
 */
- (void)uploadAddedContinueWithNext {
    
    UploadsOfflineDto *currentFile = [ManageUploadsDB getNextUploadOfflineFileToUpload];
    
    if (currentFile) {
        [self sendFileToUploadByUploadOfflineDto:currentFile];
    }

}

/*
* Method to be sure that the loading of the file list is finish
*/
- (void) overwriteCompleted{
    
    [self initLoadingInFileList];
    [self reloadFromDataBaseInFileList];
    [self endLoadingInFileList];
}

@end
