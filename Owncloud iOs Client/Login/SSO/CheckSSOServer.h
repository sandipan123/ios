//
//  CheckSSOServer.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 16/10/13.
//

/**
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

#import <Foundation/Foundation.h>


@protocol CheckSSOServerDelegate

@optional
- (void)showSSOLoginScreen;
- (void)showSSOErrorServer;
- (void)showErrorConnection;

@end


@interface CheckSSOServer: NSObject <NSURLConnectionDelegate>

@property (nonatomic,strong) NSString *urlString;
@property (nonatomic) BOOL isSSOServer;
@property (nonatomic,weak) __weak id<CheckSSOServerDelegate> delegate;


///-----------------------------------
/// @name Check URL Server For Shibboleth
///-----------------------------------

/**
 * This method checks the URL in URLTextField in order to know if
 * is a valid SSO server.
 *
 * @warning This method uses a NSURLConnection delegate methods
 */

-(void) checkURLServerForSSOForThisPath:(NSString *)urlString;

@end
