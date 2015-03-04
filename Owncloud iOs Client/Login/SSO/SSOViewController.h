//
//  SSOViewController.h
//  Owncloud iOs Client
//
// This class have the methods for allow to the users login in
// Shibboleth servers
//
//
//  Created by Javier González Pérez on 17/08/13.
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

#import <UIKit/UIKit.h>


@protocol SSODelegate

@optional
- (void)setCookieForSSO:(NSString *) cookieString andSamlUserName:(NSString*)samlUserName;
@end

@interface SSOViewController : UIViewController <UIWebViewDelegate, UIAlertViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate>



@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
@property (nonatomic, strong) NSString *ownCloudServerUrlString;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic,weak) __weak id<SSODelegate> delegate;

#pragma mark - Properties for SAML server with 401 error. Like Microsoft NTLM
//Object used to show the login alert view just once
@property (nonatomic, strong) UIAlertView *loginAlertView;
//Authentication challenge to try to do login just after hide the loginAlertView
@property (nonatomic, strong) NSURLAuthenticationChallenge *challenge;

@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *password;
//Request to repeat after make login
@property (nonatomic, strong) NSURLRequest *authRequest;

@property (nonatomic, strong) NSURLConnection *connection;

//Retry link
@property (nonatomic, strong) NSString *urlStringToRetryTheWholeProcess;

//Bools to control if the credentials was shown
@property BOOL is401ErrorDetected;
@property BOOL isCredentialsWritten;

- (IBAction)cancel:(id)sender;

@end
