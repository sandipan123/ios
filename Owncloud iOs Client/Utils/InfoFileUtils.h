//
//  InfoFileUtils.h
//  Owncloud iOs Client
//
//  Created by Rebeca Martín de León on 06/03/14.
//

/**
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

@class CustomCellFileAndDirectory;
@class FileDto;

@interface InfoFileUtils : NSObject

///-----------------------------------
/// @name getTheDifferenceBetweenDateOfUploadAndNow
///-----------------------------------

/**
 * This method obtains the difference between the upload date and the received date doing
 * a custom string like a:
 * seconds ago
 * minutes ago
 * hours ago
 * days ago
 * the date of upload (When the days > 30)
 *
 * @param NSDate -> date
 *
 * @return NSString -> The searched date
 */
+ (NSString *)getTheDifferenceBetweenDateOfUploadAndNow:(NSDate *)date;

///-----------------------------------
/// @name setTheStatusIconOntheFile:onTheCell:
///-----------------------------------

/**
 * This method set the status icon of the files and folders
 - The general icons of the icons
 - The general icons of the folder (shared by link, shared with user)
 - The shared icon on the right of the file list
 - The status icon of the files
 *
 * @param fileForSetTheStatusIcon -> FileDto, the file for set the status
 * @param fileCell -> CustomCellFileAndDirectory, the cell where the file is located
 * @param currentFolder -> FileDto, of the folder that contain the fileForSetTheStatusIcon
 */
+ (CustomCellFileAndDirectory *) getTheStatusIconOntheFile: (FileDto *)fileForSetTheStatusIcon onTheCell: (CustomCellFileAndDirectory *)fileCell andCurrentFolder:(FileDto *)currentFolder;

@end
