//
//  ManageCookiesStorageDB.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 10/07/14.
//

/**
 *    @author Javier Gonzalez
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

@class CookiesStorageDto;
@class UserDto;

@interface ManageCookiesStorageDB : NSObject

//-----------------------------------
/// @name insertCookie
///-----------------------------------

/**
 * Method to insert a cookie on the Database
 *
 * @param CookiesStorageDto -> cookie
 *
 */
+ (void) insertCookie:(CookiesStorageDto *) cookie;

//-----------------------------------
/// @name getCookiesByUser
///-----------------------------------

/**
 * Method to return the list of cookies of a user
 *
 * @param UserDto -> user
 *
 * @return NSMutableArray -> output
 */
+ (NSMutableArray *) getCookiesByUser:(UserDto *) user;

//-----------------------------------
/// @name deleteCookiesByUser
///-----------------------------------

/**
 * Method delete the cookies of a user
 *
 * @param UserDto -> user
 *
 */
+ (void) deleteCookiesByUser:(UserDto *) user;

@end
