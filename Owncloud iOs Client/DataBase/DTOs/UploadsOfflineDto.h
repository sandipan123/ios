//
//  UploadsOfflineDto.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 6/7/13.
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

@interface UploadsOfflineDto : NSObject

typedef enum {
    waitingAddToUploadList=0,
    waitingForUpload=1,
    uploading=2,
    uploaded=3,
    errorUploading = 4,
    pendingToBeCheck = 5,
    generatedByDocumentProvider = 6
} enumUpload;

typedef enum {
    notAnError = -1,
    errorCredentials = 0,
    errorDestinyNotExist = 1,
    errorFileExist = 2,
    errorNotPermission = 3,
    errorUploadFileDoesNotExist = 4,
    errorUploadInBackground = 5
} enumKindOfError;

@property NSInteger idUploadsOffline;
@property (nonatomic, copy) NSString *originPath;
@property (nonatomic, copy) NSString *destinyFolder;
@property (nonatomic, copy) NSString *uploadFileName;
@property long estimateLength;
@property NSInteger userId;
@property BOOL isLastUploadFileOfThisArray;
@property NSInteger chunkPosition;
@property NSInteger chunkUniqueNumber;
@property long chunksLength;
@property NSInteger status;
@property long uploadedDate;
@property NSInteger kindOfError;
@property BOOL isNotNecessaryCheckIfExist;
@property BOOL isInternalUpload;
@property NSInteger taskIdentifier;


@end
