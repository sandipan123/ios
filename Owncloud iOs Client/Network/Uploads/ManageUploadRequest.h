//
//  ManageUploadRequest.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 11/11/13.
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


#import <Foundation/Foundation.h>
#import "UtilsNetworkRequest.h"

@class UploadsOfflineDto;
@class UserDto;
@class FileDto;

extern NSString *fileDeleteInAOverwriteProcess;
extern NSString *uploadOverwriteFileNotification;

@protocol ManageUploadRequestDelegate

- (void) uploadCompleted:(NSString*) currentRemoteFolder;
- (void) uploadCanceled:(NSObject*)up;
- (void) uploadFailed:(NSString*)string;
- (void) uploadFailedForLoginError:(NSString*)string;
- (void) uploadLostConnectionWithServer:(NSString*)string;
- (void) uploadAddedContinueWithNext;
- (void) overwriteCompleted;

@end

@interface ManageUploadRequest : NSObject <UtilsNetworkRequestDelegate>

@property(nonatomic, strong) UploadsOfflineDto *currentUpload;
@property(nonatomic, strong) id<ManageUploadRequestDelegate> delegate;
@property(nonatomic, strong) NSString *originPathFile; //*pathOfUpload;
@property(nonatomic, strong) NSString *destinationPath;

@property(nonatomic, strong) UserDto *userUploading;
@property(nonatomic, strong) UtilsNetworkRequest *utilsNetworkRequest;

@property(nonatomic, strong) NSOperation *operation;
@property(nonatomic, strong) NSURLSessionUploadTask *uploadTask;

@property(nonatomic) BOOL isFinishTransferLostServer;
@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSString *pathOfUpload;
@property(nonatomic, strong) NSString *lenghtOfFile;
@property(nonatomic) float transferProgress;
@property(nonatomic) BOOL isCanceled;
@property(nonatomic) BOOL isUploadBegan;
@property(nonatomic) BOOL isFromBackground;


@property(nonatomic) NSUInteger progressTag;

- (void) addFileToUpload:(UploadsOfflineDto*) currentUpload;

- (void) changeTheStatusToFailForCredentials;
- (void) changeTheStatusToWaitingToServerConnection;
- (void) cancelUpload;
- (void) updateProgressWithPercent:(float)per;
- (void) updateTheEtagOfTheFile: (FileDto *) overwrittenFile;


@end
