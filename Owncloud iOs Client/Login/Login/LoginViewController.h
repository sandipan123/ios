//
//  LoginViewController.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 10/8/12.
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

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CheckAccessToServer.h"
#import "SSOViewController.h"
#import "CheckSSOServer.h"

extern NSString *loginViewControllerRotate;

@interface LoginViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate, CheckAccessToServerDelegate, SSODelegate, CheckSSOServerDelegate> {

    CheckAccessToServer *mCheckAccessToServer;
    
    UITapGestureRecognizer *tapRecognizer;
    
    UIButton *refreshTestServerButton;
    UIButton *showPasswordCharacterButton;
    
    NSThread *threadToCheckUrl;
    
    CGRect refreshButtonFrame;
    CGRect showPasswordButtonFrame;
    CGRect lockImageFrame;
    CGRect okNokImageFrameFooter;
    CGRect textFooterFrame1;
    CGRect textFooterFrame2;
    CGRect footerSection1Frame;
    CGRect syncImageFrameForNoURL;
    
    IBOutlet UIImageView *logoImageView;
    UIImageView *checkConnectionToTheServerImage;
    UITextField *_usernameTextField;
    UITextField *_passwordTextField;
    
    //Alert
    UIAlertView *_alert;
    
    //Flags
    BOOL isUserTextUp;
    BOOL isPasswordTextUp;
    BOOL isConnectionToServer;
    BOOL isNeedToCheckAgain;
    BOOL isHttps;
    BOOL isHttpsSecure;
    BOOL isCheckingTheServerRightNow;
    BOOL isSSLAccepted;
    BOOL isErrorOnCredentials;
    BOOL isError500;
    BOOL isLoginButtonEnabled;
    BOOL urlEditable;
    BOOL userNameEditable;
    BOOL hasInvalidAuth;
    
}

@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong) UITextField *urlTextField;
@property(nonatomic,strong) UITextField *usernameTextField;
@property(nonatomic,strong) UITextField *passwordTextField;
@property(nonatomic,strong)IBOutlet UIView *backCompanyView;

@property(nonatomic,strong) NSString *auxUrlForReloadTable;
@property(nonatomic,strong) NSString *auxUsernameForReloadTable;
@property(nonatomic,strong) NSString *auxPasswordForReloadTable;
@property(nonatomic,strong) NSString *auxPasswordForShowPasswordOnEdit;

@property(nonatomic,strong) NSString *connectString;
@property(nonatomic,strong) NSString *loginButtonString;

@property(nonatomic)CGRect txtWithLogoWhenNoURLFrame;
@property(nonatomic)CGRect urlFrame;
@property(nonatomic)CGRect userAndPasswordFrame;
@property(nonatomic)CGRect imageTextFieldLeftFrame;


-(void)setTableBackGroundColor;
-(void)checkUrlManually;
-(void)hideOrShowPassword;
-(void)goTryToDoLogin;
-(void)badCertificateNoAcceptedByUser;
-(NSString *)getUrlChecked:(NSString *)byUrl;
-(void) hideTryingToLogin;
-(void) potraitViewiPhone;
-(void) addEditAccountsViewiPad;
//-----------------------------------
/// @name restoreTheCookiesOfActiveUserByNewUser
///-----------------------------------
- (void) restoreTheCookiesOfActiveUser;

@end
