//
//  UploadUtils.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 04/07/13.
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
#import <AssetsLibrary/AssetsLibrary.h>

@class FileDto;
@class UploadsOfflineDto;

extern NSString * PreviewFileNotification;

@interface UploadUtils : NSObject

/*
 * Method tha make the lengt of the file
 */
+ (NSString *)makeLengthString:(long)estimateLength;

/*
 * Method that make the path string
 */
+ (NSString *)makePathString:(NSString *)destinyFolder withUserUrl:(NSString *)userUrl;

/*
 *Method that updates a downloaded file when the user overwrites this file
 */
+(void) updateOverwritenFile:(FileDto *)file FromPath:(NSString *)path;

+ (NSString *) getUrlWithRedirectionByOriginalURL:(NSString *) originalUrl;

+ (FileDto *) getFileDtoByUploadOffline:(UploadsOfflineDto *) uploadsOfflineDto;

+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end


