//
//  UserDto.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 7/18/12.
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

typedef enum {
    serverFunctionalityNotChecked = 0,
    serverFunctionalitySupported =1 ,
    serverFunctionalityNotSupported = 2
    
} enumHasShareApiSupport;

@interface UserDto : NSObject

@property NSInteger idUser;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property BOOL ssl;
@property BOOL activeaccount;
@property long storageOccupied;
@property long storage;
@property NSInteger hasShareApiSupport;
@property NSInteger hasCookiesSupport;
@property BOOL instant_upload;
@property (nonatomic, copy) NSString *path_instant_upload;
@property BOOL only_wifi_instant_upload;
@property long date_instant_upload;

@end
