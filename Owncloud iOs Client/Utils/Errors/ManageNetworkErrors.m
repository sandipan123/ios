//
//  ManageNetworkErrors.m
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 26/06/14.
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

#import "ManageNetworkErrors.h"
#import "UserDto.h"
#import "CheckAccessToServer.h"
#import "OCErrorMsg.h"

@implementation ManageNetworkErrors

/*
 * Method called when receive an error from server
 * @errorHttp -> WebDav Server Error of NSURLResponse
 * @errorConnection -> NSError of NSURLConnection
 */

- (void)manageErrorHttp:(NSInteger)errorHttp andErrorConnection:(NSError *)errorConnection andUser:(UserDto *) user {
    
    DLog(@"Error code from  web dav server: %ld", (long) errorHttp);
    DLog(@"Error code from server: %ld", (long)errorConnection.code);
    
    //Server connection error
    switch (errorConnection.code) {
        case kCFURLErrorUserCancelledAuthentication: { //-1012
            
            [_delegate showError:NSLocalizedString(@"not_possible_connect_to_server", nil)];
            
            CheckAccessToServer *mCheckAccessToServer = [CheckAccessToServer new];
            [mCheckAccessToServer isConnectionToTheServerByUrl:user.url];
            
            break;
        }
        default:
            //Web Dav Error Code
            switch (errorHttp) {
                case kOCErrorServerUnauthorized:
                    //Unauthorized (bad username or password)
                    [self.delegate errorLogin];
                    break;
                case kOCErrorServerForbidden:
                    //403 Forbidden
                    [_delegate showError:NSLocalizedString(@"error_not_permission", nil)];
                    break;
                case kOCErrorServerPathNotFound:
                    //404 Not Found. When for example we try to access a path that now not exist
                    [_delegate showError:NSLocalizedString(@"error_path", nil)];
                    break;
                case kOCErrorServerMethodNotPermitted:
                    //405 Method not permitted
                    [_delegate showError:NSLocalizedString(@"not_possible_create_folder", nil)];
                    break;
                case kOCErrorServerTimeout:
                    //408 timeout
                    [_delegate showError:NSLocalizedString(@"not_possible_connect_to_server", nil)];
                    break;
                default:
                    [_delegate showError:NSLocalizedString(@"not_possible_connect_to_server", nil)];
                    break;
            }
            break;
    }
}

@end
