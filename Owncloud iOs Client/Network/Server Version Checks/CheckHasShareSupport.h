//
//  CheckHasShareSupport.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 05/08/14.
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

@interface CheckHasShareSupport : NSObject

///-----------------------------------
/// @name Check if server has share support
///-----------------------------------

/**
 * This method check the current server looking for support Share API
 * and store (YES/NOT) in the global variable.
 *
 */
- (void)checkIfServerHasShareSupport;

///-----------------------------------
/// @name updateSharesFromServer
///-----------------------------------

/**
 * Method that force to check the shares files and folders
 *
 */

- (void) updateSharesFromServer;

@end
