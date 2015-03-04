//
//  EditAccountViewController.m
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 10/5/12.
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

#import "EditAccountViewController.h"
#import "UserDto.h"

#import "constants.h"
#import "AppDelegate.h"
#import "UIColor+Constants.h"
#import "Customization.h"
#import "ManageUsersDB.h"
#import "ManageUploadsDB.h"
#import "UtilsCookies.h"
#import "UtilsFramework.h"


//Initialization the notification
NSString *relaunchErrorCredentialFilesNotification = @"relaunchErrorCredentialFilesNotification";


@interface EditAccountViewController ()

@end

@implementation EditAccountViewController
@synthesize selectedUser = _selectedUser;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andUser:(UserDto *) selectedUser {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectedUser = selectedUser;
        
        self.auxUrlForReloadTable = self.selectedUser.url;
        self.auxUsernameForReloadTable = self.selectedUser.username;
        self.auxPasswordForReloadTable = self.selectedUser.password;
        
        urlEditable = NO;
        userNameEditable = NO;
        
        DLog(@"self.auxUrlForReloadTable: %@", self.auxUrlForReloadTable);
        
        isSSLAccepted = YES;
        isErrorOnCredentials = NO;
        isCheckingTheServerRightNow = YES;
        isConnectionToServer = NO;
        isNeedToCheckAgain = YES;
        
        
        // Custom initialization
        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked:)];
            
            self.navigationItem.leftBarButtonItem = cancelButton;
        }
    }
    return self;
}

- (void)setTableBackGroundColor {
    [self.tableView setBackgroundView: nil];
    [self.tableView setBackgroundColor:[UIColor colorOfLoginBackground]];
}

- (void)setBarForCancelForLoadingFromModal {
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeViewController)];
	//[self.navigationItem setRightBarButtonItem:cancelButton];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
}

- (void)setBrandingNavigationBarWithCancelButton{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.navigationController.navigationBar setTintColor:[UIColor colorOfNavigationBar]];
    }else{
        [self.navigationController.navigationBar setTintColor:[UIColor colorOfNavigationBar]];
    }
    //If the client want his custom bar
    if(k_have_image_background_navigation_bar) {
        UIImage *imageBack = [UIImage imageNamed:@"topBar.png"];
        [self.navigationController.navigationBar setBackgroundImage:imageBack forBarMetrics:UIBarMetricsDefault];
    }
    
    [self setBarForCancelForLoadingFromModal];
}

- (void) closeViewController {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self dismissModalViewControllerAnimated:NO];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{    

    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void) viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self textFieldDidEndEditing:self.urlTextField];
    
    //Hide the show password button until the user write something
    showPasswordCharacterButton.hidden = YES;
    self.auxPasswordForShowPasswordOnEdit = self.selectedUser.password;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self restoreTheCookiesOfActiveUser];

    mCheckAccessToServer.delegate = nil;
}


- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isErrorLoginShown=NO;
}

- (void) viewWillAppear:(BOOL)animated {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //Clear the cookies before to try to do login
    //1- Storage the new cookies on the Database
    [UtilsCookies setOnDBStorageCookiesByUser:app.activeUser];
    //2- Clean the cookies storage
    [UtilsFramework deleteAllCookies];
    
    [super viewWillAppear:animated];
    
}


-(void)internazionaliceTheInitialInterface {
    self.loginButtonString = NSLocalizedString(@"save_changes", nil);
}

-(void)potraitViewiPad{
    
    DLog(@"Potrait iPad");
    
    [self addEditAccountsViewiPad];
}

-(void)landscapeViewiPad{
    
    DLog(@"Landscape iPad");
    
    [self addEditAccountsViewiPad];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up {
    
    if (textField==self.usernameTextField) {
        isUserTextUp=YES;
    }
    
    if (textField==self.passwordTextField) {
        isPasswordTextUp=YES;
    }
    
    
    NSIndexPath *scrollIndexPath = nil;
    
    if(k_hide_url_server) {
        
        if(textField == self.usernameTextField) {
            scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        } else if(textField == self.passwordTextField) {
            scrollIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        }
    } else {
        
        if(textField == self.usernameTextField) {
            scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        } else if(textField == self.passwordTextField) {
            scrollIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        }
    }
    
    DLog(@"Before the scroll To Row At IndexPath Medhod");
    
    
    [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    
}


/*
 * Overwrite method of LoginViewController to check the username after continue the login process
 */
- (void)setCookieForSSO:(NSString *) cookieString andSamlUserName:(NSString*)samlUserName {
    
    //We check if the user that we are editing is the same that we are using
    if ([_selectedUser.username isEqualToString:samlUserName]) {
        
        _usernameTextField = [UITextField new];
        _usernameTextField.text = samlUserName;
        
        _passwordTextField = [UITextField new];
        _passwordTextField.text = cookieString;
        [self goTryToDoLogin];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"credentials_different_user", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
}


///-----------------------------------
/// @name Create data with server data
///-----------------------------------

/**
 * This method is called when the app receive the data of the login proffind
 *
 * @param items -> Items of the proffind
 * @param requestCode -> webdav server response
 *
 * @warning This method is overwrite of the parent class (LoginViewController) and it's present also in AddAcountViewController
 */
-(void)createUserAndDataInTheSystemWithRequest:(NSArray *)items andCode:(int) requestCode {
    
    //DLog(@"Request Did Fetch Directory Listing And Test Authetification");
    
    if(requestCode >= 400) {
        isError500 = YES;
        [self hideTryingToLogin];
        
        [self.tableView reloadData];
    } else {
        
        UserDto *userDto = [[UserDto alloc] init];
        
        //We check if start with http or https to concat it
        if([self.urlTextField.text hasPrefix:@"http://"] || [self.urlTextField.text hasPrefix:@"https://"]) {
            userDto.url = [self getUrlChecked: self.urlTextField.text];
            
        } else {
            if(isHttps) {
                userDto.url = [NSString stringWithFormat:@"%@%@",@"https://", [self getUrlChecked: self.urlTextField.text]];
            } else {
                userDto.url = [NSString stringWithFormat:@"%@%@",@"http://", [self getUrlChecked: self.urlTextField.text]];
            }
        }
        
        self.selectedUser.password = self.passwordTextField.text;
        
        [self hideTryingToLogin];
        [ManageUsersDB updatePassword:self.selectedUser];
        
        //Change the state of the of the user uploads with credential error
        [ManageUploadsDB updateErrorCredentialFiles:_selectedUser.idUser];
        
        //Cancel current uploads with the same user
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate cancelTheCurrentUploadsOfTheUser:_selectedUser.idUser];
            
         [[NSNotificationCenter defaultCenter] postNotificationName:relaunchErrorCredentialFilesNotification object:_selectedUser];
        
        [[self navigationController] popViewControllerAnimated:YES];
       
        
        [self performSelector:@selector(closeViewController) withObject:nil afterDelay:0.5];
        
    }
}

/*- (void)sendErrorCredentialFilesNotification{
    
    //Notification to indicate that shouled be relaunch the uploads with Credentials Error
    [[NSNotificationCenter defaultCenter] postNotificationName:relaunchErrorCredentialFilesNotification object:_selectedUser];
}*/



#pragma mark - Buttons
/*
 * This method close the view
 */
- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end