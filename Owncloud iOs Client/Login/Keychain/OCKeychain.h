//
//  OCKeychain.h
//  Owncloud iOs Client
//
//  Created by Noelia Alvarez on 22/10/14.
//

/**
 *    @author Noelia Alvarez
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
#import "CredentialsDto.h"

@interface OCKeychain : NSObject

+(BOOL)setCredentialsById:(NSString *)idUser withUsername:(NSString *)userName andPassword:(NSString *)password;
+(CredentialsDto *)getCredentialsById:(NSString *)idUser;
+(BOOL)removeCredentialsById:(NSString *)idUser;
+(BOOL)updatePasswordById:(NSString *)idUser withNewPassword:(NSString *)password;
+(BOOL)resetKeychain;


@end
