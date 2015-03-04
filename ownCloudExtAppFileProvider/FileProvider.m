//
//  FileProvider.m
//  ownCloudExtAppFileProvider
//
//  Created by Gonzalo Gonzalez on 14/10/14.
//

/**
 *    @author Javier Gonzalez
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

#import "FileProvider.h"
#import <UIKit/UIKit.h>
#import "ProvidingFileDto.h"
#import "ManageProvidingFilesDB.h"
#import "FMDatabaseQueue.h"
#import "UtilsUrls.h"
#import "ManageFilesDB.h"
#import "FileDto.h"
#import "UploadsOfflineDto.h"
#import "UserDto.h"
#import "ManageUsersDB.h"
#import "constants.h"
#import "ManageUploadsDB.h"
#import "UtilsDtos.h"
#import "NSString+Encoding.h"


@interface FileProvider ()

@end

@implementation FileProvider

- (NSFileCoordinator *)fileCoordinator {
    NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
    [fileCoordinator setPurposeIdentifier:[self providerIdentifier]];
    return fileCoordinator;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self.fileCoordinator coordinateWritingItemAtURL:[self documentStorageURL] options:0 error:nil byAccessor:^(NSURL *newURL) {
            // ensure the documentStorageURL actually exists
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtURL:newURL withIntermediateDirectories:YES attributes:nil error:&error];
        }];
    }
    return self;
}

- (void)providePlaceholderAtURL:(NSURL *)url completionHandler:(void (^)(NSError *error))completionHandler {
    // Should call + writePlaceholderAtURL:withMetadata:error: with the placeholder URL, then call the completion handler with the error if applicable.
    NSString* fileName = [url lastPathComponent];
    
    NSURL *placeholderURL = [NSFileProviderExtension placeholderURLForURL:[self.documentStorageURL URLByAppendingPathComponent:fileName]];
    
    NSUInteger fileSize = 0;
    // TODO: get file size for file at <url> from model
    
    [self.fileCoordinator coordinateWritingItemAtURL:placeholderURL options:0 error:NULL byAccessor:^(NSURL *newURL) {
        
        NSDictionary* metadata = @{ NSURLFileSizeKey : @(fileSize)};
        [NSFileProviderExtension writePlaceholderAtURL:placeholderURL withMetadata:metadata error:NULL];
    }];
    if (completionHandler) {
        completionHandler(nil);
    }
}

- (void)startProvidingItemAtURL:(NSURL *)url completionHandler:(void (^)(NSError *))completionHandler {
    // Should ensure that the actual file is in the position returned by URLForItemWithIdentifier:, then call the completion handler
    NSError* error = nil;
   
    if (![[NSFileManager defaultManager] fileExistsAtPath:url.path])
    {
        error = [NSError errorWithDomain:NSPOSIXErrorDomain code:-1 userInfo:nil];
    }
    
    NSLog(@"Provider identifier : %@", self.description);
    
    if (completionHandler) {
        completionHandler(error);
    }
}


- (void)itemChangedAtURL:(NSURL *)url {
    // Called at some point after the file has changed; the provider may then trigger an upload
    NSLog(@"Item changed at URL %@", url);

    ProvidingFileDto *providingFile = [ManageProvidingFilesDB getProvidingFileDtoByPath:[UtilsUrls getRelativePathForDocumentProviderUsingAboslutePath:url.path]];
    
    if (providingFile) {
        FileDto *file = [ManageFilesDB getFileDtoRelatedWithProvidingFileId:providingFile.idProvidingFile ofUser:providingFile.userId];
        
        NSLog(@"File name %@", file.fileName);
        
        [self copyFileOnTheFileSystemByOrigin:url.path andDestiny:file.localFolder];
        
        [self createUploadOfflineWithFile:file fromPath:url.path withUser:file.userId];
        
        [self removeItemByUrl:url];
        
    }

}

- (void)stopProvidingItemAtURL:(NSURL *)url {
    // Called after the last claim to the file has been released. At this point, it is safe for the file provider to remove the content file.
    // Care should be taken that the corresponding placeholder file stays behind after the content file has been deleted.
    
    [self.fileCoordinator coordinateWritingItemAtURL:url options:NSFileCoordinatorWritingForDeleting error:NULL byAccessor:^(NSURL *newURL) {
        [[NSFileManager defaultManager] removeItemAtURL:newURL error:NULL];
    }];
    
    [self providePlaceholderAtURL:url completionHandler:NULL];
}


- (void) removeItemByUrl:(NSURL *)url {
    
    ProvidingFileDto *providingFile = [ManageProvidingFilesDB getProvidingFileDtoByPath:[UtilsUrls getRelativePathForDocumentProviderUsingAboslutePath:url.path]];
    
    if (providingFile) {
        FileDto *file = [ManageFilesDB getFileDtoRelatedWithProvidingFileId:providingFile.idProvidingFile ofUser:providingFile.userId];
        
        
        [ManageProvidingFilesDB removeProvidingFileDtoById:providingFile.idProvidingFile];
        [ManageFilesDB updateFile:file.idFile withProvidingFile:0];
        
        //TODO: For the moment we go to remove the file when the user finish to edit a file because the "stopProvidingItemAtURL" is not called never.
        NSString *folderPath = [url.path stringByDeletingLastPathComponent];
        [[NSFileManager defaultManager] removeItemAtPath:folderPath error:nil];
    }
    
}


- (void) copyFileOnTheFileSystemByOrigin:(NSString *) origin andDestiny:(NSString *) destiny {
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
 
    [filemgr removeItemAtPath:destiny error:nil];
    
    NSURL *oldPath = [NSURL fileURLWithPath:origin];
    NSURL *newPath= [NSURL fileURLWithPath:destiny];
    
    [filemgr copyItemAtURL:oldPath toURL:newPath error:nil];
    
}


- (void) createUploadOfflineWithFile:(FileDto *) file fromPath:(NSString *)path withUser:(NSInteger)userId {
    
    UserDto *user = [ManageUsersDB getUserByIdUser:userId];
    
    NSString *remotePath = [NSString stringWithFormat: @"%@%@%@", user.url, k_url_webdav_server,[UtilsDtos getDBFilePathOfFileDtoFilePath:file.filePath ofUserDto:user]];
    
    long long fileLength = [[[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] valueForKey:NSFileSize] unsignedLongLongValue];
    
    NSString *temp = [NSString stringWithFormat:@"%@%@", [UtilsUrls getTempFolderForUploadFiles], file.fileName];
    
    [self copyFileOnTheFileSystemByOrigin:file.localFolder andDestiny:temp];
    
    UploadsOfflineDto *upload = [UploadsOfflineDto new];
    
    upload.originPath = temp;
    upload.destinyFolder = remotePath;
    upload.uploadFileName = file.fileName;
    upload.kindOfError = notAnError;
    upload.estimateLength = (long)fileLength;
    upload.userId = userId;
    upload.isLastUploadFileOfThisArray = YES;
    upload.status = generatedByDocumentProvider;
    upload.chunksLength = k_lenght_chunk;
    upload.isNotNecessaryCheckIfExist = NO;
    upload.isInternalUpload = NO;
    upload.taskIdentifier = 0;
    
    
    //Set this file as an overwritten state
    [ManageFilesDB setFileIsDownloadState:file.idFile andState:overwriting];
    
    [ManageUploadsDB insertUpload:upload];
    
}

#pragma mark - FMDataBase

+ (FMDatabaseQueue*)sharedDatabase
{
     static FMDatabaseQueue* sharedDatabase = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[UtilsUrls getOwnCloudFilePath] stringByAppendingPathComponent:@"DB.sqlite"]]) {
        
        if (sharedDatabase == nil)
        {
            NSString *documentsDir = [UtilsUrls getOwnCloudFilePath];
            NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"DB.sqlite"];
            
            sharedDatabase = [[FMDatabaseQueue alloc] initWithPath: dbPath];
        }
    }
    
    return sharedDatabase;
    
}

@end
