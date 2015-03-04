//
//  FileDto.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 8/6/12.
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

#import <Foundation/Foundation.h>

@class OCFileDto;

typedef enum {
    downloading = -1,
    notDownload = 0,
    downloaded = 1,
    updating = 2,
    overwriting = 3
    
} enumDownload;

@interface FileDto : NSObject {
}

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *fileName;
@property BOOL isDirectory;
@property long size;
@property long date;
@property (nonatomic, copy) NSString *etag;
@property NSInteger idFile;
@property NSInteger userId;
@property BOOL needRefresh;
@property NSInteger isDownload;
@property NSInteger fileId;
@property (nonatomic, copy) NSString *localFolder;
@property BOOL isFavorite;
@property BOOL isRootFolder;
@property BOOL isNecessaryUpdate;
@property NSInteger sharedFileSource;
@property (nonatomic, copy) NSString *permissions;
@property NSInteger taskIdentifier;
@property (nonatomic) NSInteger providingFileId;

- (id)initWithOCFileDto:(OCFileDto*)ocFileDto;

@end