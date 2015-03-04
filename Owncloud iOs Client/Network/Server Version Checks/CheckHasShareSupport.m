//
//  CheckHasShareSupport.m
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 05/08/14.
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
#import "CheckHasShareSupport.h"
#import "AppDelegate.h"
#import "ManageUsersDB.h"
#import "OCCommunication.h"
#import "SharedViewController.h"

@implementation CheckHasShareSupport


///-----------------------------------
/// @name Check if server has share support
///-----------------------------------

/**
 * This method check the current server looking for support Share API
 * and store (YES/NOT) in the global variable.
 *
 */
- (void)checkIfServerHasShareSupport {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (app.activeUser.username==nil) {
        app.activeUser=[ManageUsersDB getActiveUser];
    }
    
    if (app.activeUser) {
        
        [[AppDelegate sharedOCCommunication] hasServerShareSupport:app.activeUser.url onCommunication:[AppDelegate sharedOCCommunication] successRequest:^(NSHTTPURLResponse *response, BOOL hasSupport, NSString *redirectedServer) {
            
            if (hasSupport) {
                app.activeUser.hasShareApiSupport = serverFunctionalitySupported;
            } else {
                app.activeUser.hasShareApiSupport = serverFunctionalityNotSupported;
            }
            
            [ManageUsersDB updateUserByUserDto:app.activeUser];
            
            if (app.activeUser.hasShareApiSupport) {
                //Launch the notification
                [self updateSharesFromServer];
            }
            
            [self updateSharedView];
            
        } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
            
            DLog(@"error when try to get the share support: %@", error);
            
            [self updateSharedView];
            
        }];
    }
}

///-----------------------------------
/// @name Update Shared View
///-----------------------------------

/**
 * Update shared view
 */
- (void) updateSharedView {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (app.sharedViewController) {
        [app.sharedViewController refreshSharedItems];
    }
}

///-----------------------------------
/// @name updateSharesFromServer
///-----------------------------------

/**
 * Method that force to check the shares files and folders
 *
 */

- (void) updateSharesFromServer {
    [[NSNotificationCenter defaultCenter] postNotificationName: RefreshSharesItemsAfterCheckServerVersion object: nil];
}

@end
