//
//  UtilsCookies.m
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

#import "UtilsCookies.h"
#import "UserDto.h"
#import "ManageCookiesStorageDB.h"
#import "CookiesStorageDto.h"

@implementation UtilsCookies

//-----------------------------------
/// @name setOnDBStorageCookiesByUser
///-----------------------------------

/**
 * Method set on the Database the current cookies that are on the system Cookies Storage
 *
 * @param UserDto -> user
 *
 */
+ (void) setOnDBStorageCookiesByUser:(UserDto *) user {
    //We add the cookies of that URL
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:user.url]];
    
    DLog(@"cookieStorage: %@", cookies);
    
    for (NSHTTPCookie *current in cookies) {
        
        CookiesStorageDto *newCookieStorage = [CookiesStorageDto new];
        newCookieStorage.cookie = current;
        newCookieStorage.userId = user.idUser;
        
        [ManageCookiesStorageDB insertCookie:newCookieStorage];
    }
}

//-----------------------------------
/// @name setOnDBStorageCookiesByUser
///-----------------------------------

/**
 * Method set on the System storage the cookies that are on Database of a user
 *
 * @param UserDto -> user
 *
 */
+ (void) setOnSystemStorageCookiesByUser:(UserDto *) user {
    
    NSArray *listOfCookiesStorageDto = [ManageCookiesStorageDB getCookiesByUser:user];
    
    for (CookiesStorageDto *current in listOfCookiesStorageDto) {
        NSLog(@"Current: %@", current.cookie);
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:current.cookie];
    }
}

@end
