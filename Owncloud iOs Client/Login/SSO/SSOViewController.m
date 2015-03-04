//
//  SSOViewController.m
//  Owncloud iOs Client
//
// This class have the methods for allow to the users login in
// Shibboleth servers
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

#import "AppDelegate.h"
#import "SSOViewController.h"
#import "UserDto.h"
#import "ManageUsersDB.h"
#import "UIColor+Constants.h"
#import "Customization.h"
#import "UIColor+Constants.h"
#import "constants.h"
#import "OCCommunication.h"
#import "OCErrorMsg.h"
#import "UtilsFramework.h"
#import "UtilsCookies.h"
#import "ManageCookiesStorageDB.h"
#import "UIAlertView+Blocks.h"

//Cookie
#define k_cookie_user_value_name @"oc_username"

//JSON structure values
#define k_json_ocs @"ocs"
#define k_json_ocs_data @"data"
#define k_json_ocs_data_display_name @"display-name"


@interface SSOViewController ()

@end

@implementation SSOViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (app.activeUser) {
        //1- Storage the active account cookies on the Database
        [UtilsCookies setOnDBStorageCookiesByUser:app.activeUser];
    }
    //2- Delete the current cookies because we delete the current active user
    [UtilsFramework deleteAllCookies];
    
    [self openLink:_urlString];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    
    /*UIBarButtonItem *retryButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"retry", nil) style:UIBarStyleDefault target:self action:@selector(retry:)];
    self.navigationItem.leftBarButtonItem = retryButton;*/
    
    //Set Background color
    [_webView setBackgroundColor:[UIColor colorOfWebViewBackground]];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void) openLink:(NSString*) urlString {
    
    self.urlStringToRetryTheWholeProcess = urlString;
    
    NSString *connectURL =[NSString stringWithFormat:@"%@%@",urlString, k_url_webdav_server];
    DLog(@"URL of shibbolet:%@",connectURL);
    _ownCloudServerUrlString = connectURL;
    
    [self clearAllCookies];
    
    NSURL *url = [NSURL URLWithString:connectURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:40.0];
    [UtilsFramework deleteAllCookies];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    _webView.delegate = self;
    [_webView setScalesPageToFit:YES];
    [_webView loadRequest:request];
}

- (void) retryOpenLink:(NSString*) urlString {
    
    self.urlStringToRetryTheWholeProcess = urlString;
    
    NSString *connectURL =[NSString stringWithFormat:@"%@%@",urlString, k_url_webdav_server];
    DLog(@"URL of shibbolet:%@",connectURL);
    _ownCloudServerUrlString = connectURL;
    
    NSURL *url = [NSURL URLWithString:connectURL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:40.0];
    
    _webView.delegate = self;
    [_webView setScalesPageToFit:YES];
    [_webView loadRequest:request];
}

- (void)clearAllCookies {
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        DLog(@"Delete cookie");
        [storage deleteCookie:cookie];
    }
    
}

#pragma mark UIWebView Delegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    DLog(@"Did start loading: %@ auth:%d", [[request URL] absoluteString], _isCredentialsWritten);
    
    //We storage the request to use it again after make login
    self.authRequest = request;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delay) object:nil];
    [self performSelector:@selector(delay) withObject:nil afterDelay:15.0];
    
    return YES;
}

- (void) delay {
    //We make a NSURLConnection to detect if we receive an authentication challenge
    [NSURLConnection connectionWithRequest:self.authRequest delegate:self];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"An error happened during load: %@", error);
    
    if ([error code] != -999) {
        [_activity stopAnimating];
        [_webView setHidden:NO];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    DLog(@"loading started: %@", webView.request.URL.absoluteString);
    
    [_webView endEditing:YES];
    
    [_webView setHidden:YES];
    
    if (_activity==nil) {
        _activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.center=CGPointMake(self.view.center.x, self.view.center.y);
        [self.view addSubview:_activity];
    }
    _activity.center=CGPointMake(self.view.center.x, self.view.center.y);
    [_activity startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    DLog(@"webViewDidFinishLoad");
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delay) object:nil];
    
    NSCachedURLResponse *resp = [[NSURLCache sharedURLCache] cachedResponseForRequest:webView.request];
    
    DLog(@"Response: %@", [(NSHTTPURLResponse*)resp.response allHeaderFields]);
    
    NSString *currentURL = webView.request.URL.absoluteString;
    DLog(@"currentURL: %@", currentURL);
    
    [_activity stopAnimating];
    [_webView setScalesPageToFit:YES];
    
    
    //Check for the reddirection to the first server
    if ([currentURL isEqualToString:_ownCloudServerUrlString]) {
        //Login is success with the third part server
        
        
        //Catch the cookie storage
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        //Get the cookies for specific url
        NSArray *cookiesArray = [cookieJar cookiesForURL:webView.request.URL];
        
        NSMutableString * cookieString = nil;
        cookieString = [NSMutableString new];
        
        NSString *samlNameUser=nil;
        
        //DLog(@" %d cookies", cookiesArray.count);
        
        //Loop for the cookies
        for (NSHTTPCookie * cookie in cookiesArray) {
            
            if ([cookie.name isEqualToString:k_cookie_user_value_name]) {
                samlNameUser = cookie.value;
            }
            
           // DLog(@"url: %@", webView.request.URL.absoluteString);
            //DLog(@"cookie: %@", cookie);
            [cookieString appendFormat:@"%@=%@;", cookie.name, cookie.value];
        }
        
        samlNameUser = [self requestForUserNameByCookie: cookieString];
        
        if (samlNameUser) {
            DLog(@"samlNameUser: %@", samlNameUser);
            DLog(@"currentURL: %@", currentURL);
        }
        
        //Send to the delegate class the cookie receive from the server
        [_delegate setCookieForSSO:cookieString andSamlUserName:samlNameUser];
        
        //Close this view
        [self cancel:nil];
    } else {
        [_webView setHidden:NO];
    }
}

/*
 * This method force to dismiss the keyboard automatically
 */
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

#pragma mark -
#pragma mark NSURLConnection Delegate Methods

- (void) connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    DLog(@"Challenge currentRequest URL: %@", connection.currentRequest.URL.absoluteString);
    
    if ([challenge previousFailureCount] == 0) {
        if (self.isCredentialsWritten && self.user && self.password) {
            //Second time. We reset the credentials to not enter here more than onceNSURLCredentialPersistenceNone
            [[challenge sender] useCredential:[NSURLCredential credentialWithUser:self.user password:self.password persistence:NSURLCredentialPersistenceNone] forAuthenticationChallenge:challenge];
            self.user = nil;
            self.password = nil;
        } else {
            //The first time. We do not have the credentials
            self.authRequest = self.webView.request;
            self.challenge = challenge;
            self.is401ErrorDetected = YES;
            [self showLoginInterface];
        }
    } else {
        //Error credentials
        [UIAlertView showWithTitle:NSLocalizedString(@"error_login_message", nil) message:@"" cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == [alertView cancelButtonIndex]) {
                //OK
                self.isCredentialsWritten = NO;
                self.authRequest = self.webView.request;
                self.challenge = challenge;
                self.is401ErrorDetected = YES;
                [self showLoginInterface];
            }
        }];
    }
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    if (self.is401ErrorDetected && self.isCredentialsWritten) {
        DLog(@"self.authRequest: %@", self.authRequest.URL.absoluteString);
        self.is401ErrorDetected = NO;
        //With the right credentials we try to repeat the last request
        [_webView loadRequest:self.authRequest];
    }
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    DLog(@"Error connection: %@", error);
    
    //Too many HTTP redirects error. This error happens sometimes.
    if (error.code == -1007) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"unknow_response_server", nil) message:NSLocalizedString(@"", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
        [alert show];
        [self retry:nil];
    }
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
{
    return NO;
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    
    DLog(@"Request: %@", request.URL.absoluteString);
    DLog(@"redirectResponse: %@", redirectResponse.URL.absoluteString);
    
    return request;
}
   
#pragma mark - Buttons
/*
 * This method close the view
 */
- (IBAction)cancel:(id)sender {
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 *  This method repeat the original request that shown the initial UIWebView
 */
- (IBAction)retry:(id)sender {
    self.isCredentialsWritten = NO;
    self.user = nil;
    self.password = nil;
    self.is401ErrorDetected = NO;
    [self retryOpenLink:self.urlStringToRetryTheWholeProcess];
}

///-----------------------------------
/// @name Request For User Name
///-----------------------------------

/**
 * This method gets the user display name for the ownCloud api and
 * then return this. 
 *
 * @param cookieString --> saml cookie
 *
 * @return userName
 *
 */
- (NSString *) requestForUserNameByCookie:(NSString *) cookieString {
    
    __block NSString *userName = nil;

    //We create a semaphore to wait until we recive the responses from Async calls
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    
    //Set the right credentials
    [[AppDelegate sharedOCCommunication] setCredentialsWithCookie:cookieString];
    
    [[AppDelegate sharedOCCommunication] getUserNameByCookie:cookieString ofServerPath:_urlString onCommunication:[AppDelegate sharedOCCommunication] success:^(NSHTTPURLResponse *response, NSData *responseData, NSString *redirectedServer) {
        
        //NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        //DLog(@"Response: %@", responseString);
        NSError *jsonError = nil;
        //Get the json dictionary object
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
        
        if (!jsonDict) {
            //Error
            // DLog(@"json error: %@", jsonError);
        } else {
            
            //Get the ocs dictionary object
            NSDictionary *ocsDict = [jsonDict objectForKey:k_json_ocs];
            
            //Get the data dictionary object
            NSDictionary *userDataDict = [ocsDict objectForKey:k_json_ocs_data];
            
            //Display Name
            userName = [userDataDict objectForKey:k_json_ocs_data_display_name];
            // DLog(@"UserName is: %@", userName);
        }
        
        dispatch_semaphore_signal(semaphore);
        
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        
        DLog(@"Error: %@", error);
        
        //Error we do not have user
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    // Run loop
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:30.0]];
    }
    
    return userName;
}

#pragma mark - Credentials interface

- (void) showLoginInterface {
    
    if (!_loginAlertView || ![_loginAlertView isVisible]) {
        _loginAlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"go_to_login", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"login", nil), nil];
        _loginAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        [[_loginAlertView textFieldAtIndex:0] setAutocorrectionType:UITextAutocorrectionTypeNo];
        [[_loginAlertView textFieldAtIndex:0] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        
        [_loginAlertView show];
    }
}

#pragma mark - UIalertViewDelegate

- (void) alertView: (UIAlertView *) alertView willDismissWithButtonIndex: (NSInteger) buttonIndex {
    // cancel
    switch (buttonIndex) {
        case 0:
            //Cancel
            [self openLink:_urlString];
            break;
        case 1: {
            //Do login with the credendial
            self.isCredentialsWritten = YES;
            self.user = [_loginAlertView textFieldAtIndex:0].text;
            self.password = [_loginAlertView textFieldAtIndex:1].text;
            
            //After make login we send the credential to the request
            [[self.challenge sender] useCredential:[NSURLCredential credentialWithUser:self.user password:self.password persistence:NSURLCredentialPersistenceNone] forAuthenticationChallenge:self.challenge];
            }
            break;
        default:
            break;
    }
}

/*
 *  Method to active or not the login button
 */
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    BOOL output = NO;
    
    NSString *username = [alertView textFieldAtIndex:0].text;
    NSString *password = [alertView textFieldAtIndex:1].text;
    
    if ([username length] > 0 && [password length] > 0) {
        output = YES;
    }
    
    return output;
}

@end
