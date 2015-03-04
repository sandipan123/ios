//
//  FileListDBOperations.h
//  Owncloud iOs Client
//
// This class have the methods to management the files in
// the database and system
//
//
//  Created by Gonzalo Gonzalez on 09/05/13.
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
#import "FileDto.h"

@class UserDto;

@interface FileListDBOperations : NSObject

/*
 *  Method to create the directories in the system
 * with the list of files information
 * @listOfFiles --> List of files and folder of a folder
 */
+ (void) createAllFoldersByArrayOfFilesDto: (NSArray *) listOfFiles andLocalFolder:(NSString *)localFolder;

/*
 * Method that create the root folder
 * @FileDto -> FileDto object of root folder
 */
+ (FileDto*)createRootFolderAndGetFileDtoByUser:(UserDto *) user;


/*
 * Method that realice the refresh process
 *
 */
+ (void)makeTheRefreshProcessWith:(NSMutableArray*)arrayFromServer inThisFolder:(NSInteger)idFolder;


/*
 *  Method to create a folder when the user choose delete a folder in the device
 */
+ (void) createAFolder: (NSString *)folderName inLocalFolder:(NSString *)localFolder;

@end
