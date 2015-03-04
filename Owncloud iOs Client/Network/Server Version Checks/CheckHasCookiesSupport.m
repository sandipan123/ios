//
//  CheckHasCookiesSupport.m
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 06/08/14.
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

#import "CheckHasCookiesSupport.h"
#import "AppDelegate.h"
#import "ManageUsersDB.h"
#import "OCCommunication.h"

@implementation CheckHasCookiesSupport

///-----------------------------------
/// @name Check if server has cookies support
///-----------------------------------

/**
 * This method check the current server looking for cookies support
 * and store (YES/NO) in the library to use cookies or not.
 *
 */
- (void)checkIfServerHasCookiesSupport {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (app.activeUser.username==nil) {
        app.activeUser=[ManageUsersDB getActiveUser];
    }
    
    if (app.activeUser) {
        
        [[AppDelegate sharedOCCommunication] hasServerCookiesSupport:app.activeUser.url onCommunication:[AppDelegate sharedOCCommunication] successRequest:^(NSHTTPURLResponse *response, BOOL hasSupport, NSString *redirectedServer) {
            
            //Update the support on the library
            [AppDelegate sharedOCCommunication].isCookiesAvailable = hasSupport;
            
            if (hasSupport) {
                app.activeUser.hasCookiesSupport = serverFunctionalitySupported;
            } else {
                app.activeUser.hasCookiesSupport = serverFunctionalityNotSupported;
            }
            
            [ManageUsersDB updateUserByUserDto:app.activeUser];
                
        } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
            DLog(@"error when try to get the cookies support: %@", error);
        }];
    }
}

@end
