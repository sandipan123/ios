//
//  ManageFavorites.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 21/04/14.
//

/**
 *    @author Javier Gonzalez
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
#import "Download.h"
#import "FileDto.h"

extern NSString *FavoriteFileIsSync;


@interface ManageFavorites : NSObject <DownloadDelegate>

@property (nonatomic, strong)NSMutableArray *favoritesSyncing;

///-----------------------------------
/// @name isOnAnUpdatingProcessThisFavoriteFile
///-----------------------------------

/**
 * This method checks if the file is currently on an updating process. It is check by fileName, filePath and userId
 *
 * @param favoriteFile > FileDto. The file which is going to be checked
 */
- (BOOL) isOnAnUpdatingProcessThisFavoriteFile:(FileDto *)favoriteFile;


///-----------------------------------
/// @name Update All Favorites of User
///-----------------------------------

/**
 * Method that begin a process to update all favorites files of a specific user
 *
 * 1.- Get all favorites of a specific user
 *
 * 2.- Send the list to a specific method to update the favorites
 *
 * @param NSInteger -> userId
 *
 */
- (void) syncAllFavoritesOfUser:(NSInteger)userId;


///-----------------------------------
/// @name Sync Favorites of Folder with User
///-----------------------------------

/**
 * Method that begin a process to sync favorites of a specific path and user
 *
 * @param idFolder -> NSInteger
 * @param userId -> NSInteger
 *
 */
- (void) syncFavoritesOfFolder:(NSInteger)idFolder withUser:(NSInteger)userId;


///-----------------------------------
/// @name Remove of sync process file
///-----------------------------------

/**
 * Method that find the equal file stored in _favoritesSyncing and remove it
 *
 * @param file -> FileDto
 */
- (void) removeOfSyncProcessFile:(FileDto*)file;


///-----------------------------------
/// @name thereIsANewVersionAvailableOfThisFile
///-----------------------------------

/**
 * This method check if there is a new version on the server for a concret file
 *
 * @param favoriteFile -> FileDto
 */
- (BOOL) thereIsANewVersionAvailableOfThisFile: (FileDto *)favoriteFile;

@end
