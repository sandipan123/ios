//
//  UtilsNetworkRequest.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 7/10/13.
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
#import "UserDto.h"

typedef enum {
    isNotInThePath = 0,
    isInThePath = 1,
    errorSSL = 2,
    credentialsError = 3,
    serverConnectionError = 4
} enumTheFileIsInThePathResponse;

@protocol UtilsNetworkRequestDelegate
- (void) theFileIsInThePathResponse:(NSInteger) response;
@end


@interface UtilsNetworkRequest : NSObject

@property(nonatomic,strong) id<UtilsNetworkRequestDelegate> delegate;

- (void)checkIfTheFileExistsWithThisPath:(NSString*)path andUser:(UserDto *) user;

@end
