//
//  ManageCookiesStorageDB.m
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 10/07/14.
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

#import "ManageCookiesStorageDB.h"
#import "FMDatabaseQueue.h"
#import "FMDatabase.h"
#import "CookiesStorageDto.h"
#import "AppDelegate.h"
#import "UtilsCookies.h"

@implementation ManageCookiesStorageDB

//-----------------------------------
/// @name insertCookie
///-----------------------------------

/**
 * Method to insert a cookie on the Database
 *
 * @param CookiesStorageDto -> cookie
 *
 */
+ (void) insertCookie:(CookiesStorageDto *) cookie {
    FMDatabaseQueue *queue = [AppDelegate sharedDatabase];
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL correctQuery=NO;
        
        correctQuery = [db executeUpdate:@"INSERT INTO cookies_storage (cookie, user_id) Values (?,?)", [NSKeyedArchiver archivedDataWithRootObject:cookie.cookie], [NSNumber numberWithInteger:cookie.userId]];
        
        if (!correctQuery) {
            DLog(@"Error insert cookie");
        }
    }];
}

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
+ (NSMutableArray *) getCookiesByUser:(UserDto *) user {
    
    __block NSMutableArray *output = [NSMutableArray new];
    
    FMDatabaseQueue *queue = [AppDelegate sharedDatabase];
    
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"SELECT id, cookie, user_id FROM cookies_storage WHERE user_id = ?", [NSNumber numberWithInteger:user.idUser]];
        
        while ([rs next]) {
            
            CookiesStorageDto *current = [CookiesStorageDto new];
            
            current.idCookieStorage = [rs intForColumn:@"id"];
            current.cookie = [NSKeyedUnarchiver unarchiveObjectWithData:[rs dataForColumn:@"cookie"]];
            current.userId = [rs intForColumn:@"user_id"];
        
            [output addObject:current];
        }
        
        [rs close];
        
    }];
    
    return output;
}

//-----------------------------------
/// @name deleteCookiesByUser
///-----------------------------------

/**
 * Method delete the cookies of a user
 *
 * @param UserDto -> user
 *
 */
+ (void) deleteCookiesByUser:(UserDto *) user {
    FMDatabaseQueue *queue = [AppDelegate sharedDatabase];
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL correctQuery=NO;
        
        correctQuery = [db executeUpdate:@"DELETE FROM cookies_storage WHERE user_id = ?", [NSNumber numberWithInteger:user.idUser]];
        
        if (!correctQuery) {
            DLog(@"Error deleting an upload offline");
        }
    }];
}

@end
