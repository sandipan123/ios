//
//  DownloadUtils.h
//  Owncloud iOs Client
//
//  Created by Rebeca Martín de León on 29/05/14.
//

/**
 *    @author Gonzalo Gonzalez
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
#import "AppDelegate.h"

@interface DownloadUtils : NSObject

///-----------------------------------
/// @name thereAreDownloadingFilesOnTheFolder
///-----------------------------------

/**
 * This method checks if there are any files on a download process on the selected folder
 *
 * @return thereAreDownloadingFilesOnTheFolder -> BOOL, return YES if there is a file on a download process inside this folder
 */
+ (BOOL) thereAreDownloadingFilesOnTheFolder: (FileDto *) selectedFolder;


///-----------------------------------
/// @name removeDownloadFileWithPath
///-----------------------------------

/**
 * This method removed a downloaded file from the files system.
 *
 * @param path -> local path of the file.
 */
+ (void) removeDownloadFileWithPath:(NSString *)path;


@end
