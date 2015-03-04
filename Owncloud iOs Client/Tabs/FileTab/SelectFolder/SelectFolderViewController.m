//
//  SelectFolderViewController.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 28/09/12.
//

/**
 *    @author Javier Gonzalez
 *    @author Gonzalo Gonzalez
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

#import "SelectFolderViewController.h"
#import "SelectedFolderCell.h"
#import "FileDto.h"
#import "SelectFolderNavigation.h"
#import "UIColor+Constants.h"
#import "NSString+Encoding.h"
#import "constants.h"
#import "AppDelegate.h"
#import "UIColor+Constants.h"
#import "FileNameUtils.h"
#import "Customization.h"
#import "FileListDBOperations.h"
#import "UtilsDtos.h"
#import "ManageFilesDB.h"
#import "EditAccountViewController.h"
#import "DetailViewController.h"
#import "OCNavigationController.h"
#import "OCCommunication.h"
#import "OCErrorMsg.h"
#import "UtilsUrls.h"
#import "ManageUsersDB.h"

@interface SelectFolderViewController ()

@end

@implementation SelectFolderViewController
@synthesize createButton=_createButton;
@synthesize chooseButton=_chooseButton;
@synthesize toolBarLabel=_toolBarLabel;
@synthesize toolBar=_toolBar;
@synthesize sortedArray=_sortedArray;
@synthesize currentDirectoryArray=_currentDirectoryArray;
@synthesize currentLocalFolder=_currentLocalFolder;
@synthesize nextRemoteFolder=_nextRemoteFolder;
@synthesize mCheckAccessToServer=_mCheckAccessToServer;
@synthesize fileIdToShowFiles=_fileIdToShowFiles;
@synthesize selectedFileDto=_selectedFileDto;
@synthesize parent;
@synthesize folderView=_folderView;
@synthesize toolBarLabelTxt = _toolBarLabelTxt;
@synthesize alert = _alert;

#pragma mark Load View Life


- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	[self.navigationItem setRightBarButtonItem:cancelButton];
    
    _toolBarLabel.text = self.toolBarLabelTxt;
    
    _createButton.title=NSLocalizedString(@"create_button", nil);
    _chooseButton.title=NSLocalizedString(@"choose_button", nil);
    
    //If the default langauge is german we change the size of letter on iphone portrait only
    [self configTheBottomLabelIfIsGermanLanguageInIPhone];    
    
    _toolBarLabel.textColor=[UIColor colorOfNavigationTitle];
    
    //Set the observers of the notifications
    [self setNotificationForCommunicationBetweenViews];

}

-(void)viewDidLayoutSubviews
{
    
    if (IS_IOS8) {
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
}

- (void) fillTheArraysFromDatabase {
    self.currentDirectoryArray = [ManageFilesDB getFoldersByFileIdForActiveUser: (NSInteger)self.currentFolder.idFile];
    self.sortedArray = [self partitionObjects:self.currentDirectoryArray collationStringSelector:@selector(fileName)];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (IS_IOS8) {
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
}

///-----------------------------------
/// @name Set the notification
///-----------------------------------

/**
 * Set the notification for the communication
 * between diferent views
 */
- (void) setNotificationForCommunicationBetweenViews {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeAlertView) name:CloseAlertViewWhenApplicationDidEnterBackground object:nil];
}

///-----------------------------------
/// @name Close the Alert View pop-up
///-----------------------------------

/**
 * Close the alertView pop-up when the app
 * go to background
 */
- (void) closeAlertView {
    [_folderView dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
   // DLog(@"SelectedFolderView will Rotate");
   
    if (!IS_IPHONE) {
        if (_folderView) {
            [_folderView dismissWithClickedButtonIndex:0 animated:NO];
        }
        
    } else {
        if (toInterfaceOrientation  == UIInterfaceOrientationPortrait) {
        } else {
            if (IS_IPHONE) {
                //Cancel TSAlert View of Create Folder and Close keyboard
                if (_folderView) {
                    [_folderView dismissWithClickedButtonIndex:0 animated:NO];
                }
                
                if (_alert) {
                    [_alert dismissWithClickedButtonIndex:0 animated:NO];
                }
            }
        }
    }
    
     [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //If the default langauge is german we change the size of letter on iphone portrait only
    [self configTheBottomLabelIfIsGermanLanguageInIPhone];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_IPHONE) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

/*
 * This method configure the bottom label (_toolBarLabel) in the case of german language on iPhone only.
 * Different font size in portrait and landscape
 */
- (void) configTheBottomLabelIfIsGermanLanguageInIPhone{
    
    if (IS_PORTRAIT) {
        
        if (IS_IPHONE) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
            NSString *currentLanguage = [languages objectAtIndex:0];
            
            if ([currentLanguage isEqualToString:@"de"]) {
                [_toolBarLabel setFont:[UIFont boldSystemFontOfSize:11.0]];
            }
        }
        
    }else{
        
        if (IS_IPHONE) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
            NSString *currentLanguage = [languages objectAtIndex:0];
            
            if ([currentLanguage isEqualToString:@"de"]) {
                [_toolBarLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
            }
        }
    }
    
}


#pragma mark Action Buttons

/*
 * Method that remove this view
 */

- (void)cancel{
    
    if (_alert) {
        _alert = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/*
 * Method that inform to the controller of the folder selected by user.
 */
- (IBAction)chooseFolder{
    
    if (_alert) {
        _alert = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSString *remotePath = [UtilsDtos getRemoteUrlByFile:self.currentFolder andUserDto:self.user];
    
    [(SelectFolderNavigation*)self.parent selectFolder:remotePath];

}

#pragma mark - Create Folder

/*
 * This method show an pop up view to create folder
 */
- (IBAction)showCreateFolder{
    
    _folderView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"create_folder", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"save", nil), nil];
    _folderView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [_folderView textFieldAtIndex:0].delegate = self;
    [[_folderView textFieldAtIndex:0] setAutocorrectionType:UITextAutocorrectionTypeNo];
    [[_folderView textFieldAtIndex:0] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    [_folderView show];
}

/*
 * This method check for the folder with the same name that the user want create.
 * @string -> in the string to compare
 */

-(BOOL)checkForSameName:(NSString *)string
{
    string = [string stringByAppendingString:@"/"];
    string = [string stringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding)NSUTF8StringEncoding];
    DLog(@"string: %@",string);
    NSString *dicName;
    FileDto *fileDto=nil;
    
    for (int i=0; i<[_currentDirectoryArray count]; i++) {
        
        fileDto = [_currentDirectoryArray objectAtIndex:i];       
        
        //DLog(@"%@", fileDto.fileName);
        dicName=[fileDto.fileName stringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding)NSUTF8StringEncoding];
        
        if([string isEqualToString:dicName])
        {
            return YES;
        }
        
    }
    return NO;
}

/*
 * This method create new folder in path
 */
-(void) newFolderSaveClicked:(NSString*)name {
    
    //Check if the folder name has "/"
    BOOL thereAreForbidenCharacters = NO;
    for(int i = 0 ;i < [name length]; i++) {
        if ([name characterAtIndex:i] == '/'){
            thereAreForbidenCharacters = YES;
        }
    }
    if (!thereAreForbidenCharacters) {
        
        //Check if exist a folder with the same name
        if ([self checkForSameName:name] == NO) {
            
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            
            NSString *remotePath = [UtilsDtos getRemoteUrlByFile:self.currentFolder andUserDto:self.user];
            
            NSString *newURL = [NSString stringWithFormat:@"%@%@",remotePath,[name encodeString:NSUTF8StringEncoding]];
            NSString *rootPath = [UtilsDtos getDbBFilePathFromFullFilePath:newURL andUser:app.activeUser];
            
            //Set the right credentials
            if (k_is_sso_active) {
                [[AppDelegate sharedOCCommunication] setCredentialsWithCookie:app.activeUser.password];
            } else if (k_is_oauth_active) {
                [[AppDelegate sharedOCCommunication] setCredentialsOauthWithToken:app.activeUser.password];
            } else {
                [[AppDelegate sharedOCCommunication] setCredentialsWithUser:app.activeUser.username andPassword:app.activeUser.password];
            }
            
            NSString *pathOfNewFolder = [newURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [[AppDelegate sharedOCCommunication] createFolder:pathOfNewFolder onCommunication:[AppDelegate sharedOCCommunication] successRequest:^(NSHTTPURLResponse *response, NSString *redirectedServer) {
                DLog(@"Folder created");
                BOOL isSamlCredentialsError=NO;
                
                //Check the login error in shibboleth
                if (k_is_sso_active && redirectedServer) {
                    //Check if there are fragmens of saml in url, in this case there are a credential error
                    isSamlCredentialsError = [FileNameUtils isURLWithSamlFragment:redirectedServer];
                    if (isSamlCredentialsError) {
                        [self errorLogin];
                    }
                }
                if (!isSamlCredentialsError) {
                
                    //Obtain the path where the folder will be created in the file system
                    NSString *currentLocalFileToCreateFolder = [NSString stringWithFormat:@"%@/%ld/%@",[UtilsUrls getOwnCloudFilePath],(long)app.activeUser.idUser,[rootPath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

                    
                    DLog(@"Name of the folder: %@ to create in: %@",name, currentLocalFileToCreateFolder);
                    
                    //Create the new folder in the file system
                    [FileListDBOperations createAFolder:name inLocalFolder:currentLocalFileToCreateFolder];
                    [self reloadCurrentFolder];
                }
            } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
                DLog(@"error: %@", error);
                [self endLoading];
                DLog(@"Operation error: %ld", (long)response.statusCode);
                [self.manageNetworkErrors manageErrorHttp:response.statusCode andErrorConnection:error andUser:self.user];

            } errorBeforeRequest:^(NSError *error) {
                if (error.code == OCErrorForbidenCharacters) {
                    [self endLoading];
                    DLog(@"The folder have problematic characters");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"forbiden_characters", nil) message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        } else {
            [self endLoading];
            DLog(@"Exist a folder with the same name");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"folder_exist", nil) message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    } else {
        [self endLoading];
        DLog(@"The folder have problematic characters");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"forbiden_characters", nil) message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}


/*
 * Show the standar message of the error connection.
 */
- (void)showErrorConnectionPopUp{
    _alert = nil;
    _alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"not_possible_connect_to_server", nil)
                                                    message:@"" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil, nil];
    [_alert show];

    
}

#pragma mark - UITableViewDelegate 

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath: indexPath animated:YES];
    
    FileDto *file = (FileDto *)[[self.sortedArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    [self checkBeforeNavigationToFolder:file];
}

- (void) navigateToFile:(FileDto *) file {
    //Method to be overwritten
    _selectFolderViewController = [[SelectFolderViewController alloc] initWithNibName:@"SelectFolderViewController" onFolder:file];
    _selectFolderViewController.parent = self.parent;
    
    [self.parent pushViewController:_selectFolderViewController animated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView willDismissWithButtonIndex: (NSInteger) buttonIndex{

    DLog(@"Selected");
    
   // UIView* firstResponder = [keyWindow performSelector:@selector(firstResponder)];
   // [_folderView.inputTextField resignFirstResponder];
    
    // cancel
    if( buttonIndex == 1 ){
        //Save "Create Folder"
        //Clear the spaces of the left and the right of the sentence
        
        NSString* result = [[_folderView textFieldAtIndex:0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self initLoading];
        [self performSelector:@selector(newFolderSaveClicked:) withObject:result];
        
        
    }else if (buttonIndex == 0) {
        //Cancel 
        
    }else {
        //Nothing
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    BOOL output = YES;
    
    NSString *stringNow = [alertView textFieldAtIndex:0].text;
    
    
    //Active button of folderview only when the textfield has something.
    NSString *rawString = stringNow;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    
    if ([trimmed length] == 0) {
        // Text was empty or only whitespace.
        output = NO;
    }
    
    //Button save disable when the textfield is empty
    if ([stringNow isEqualToString:@""]) {
        output = NO;
    }
    
    return output;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    DLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];    
    return YES;
}

#pragma mark - UITableView datasource

// Asks the data source to return the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
}

// Returns the table view managed by the controller object.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [[self.sortedArray objectAtIndex:section] count];
}

// Returns the table view managed by the controller object.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //Only show the section title if there are rows in it
    BOOL showSection = [[self.sortedArray objectAtIndex:section] count] != 0;
    NSArray *titles = [[UILocalizedIndexedCollation currentCollation] sectionTitles];
    
    if(k_minimun_files_to_show_separators > [self.currentDirectoryArray count]) {
        showSection = NO;
    }
    
    return (showSection) ? [titles objectAtIndex:section] : nil;
}

// Asks the data source to return the titles for the sections for a table view.
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if(k_minimun_files_to_show_separators > [self.currentDirectoryArray count]) {
        return nil;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
    }
}

// Returns the table view managed by the controller object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"SelectedFolderCell";
    
    SelectedFolderCell *fileCell = (SelectedFolderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (fileCell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SelectedFolderCell" owner:self options:nil];
        fileCell = (SelectedFolderCell *)[topLevelObjects objectAtIndex:0];
    }
    
    FileDto *file = (FileDto *)[[self.sortedArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    //Font for folder
    UIFont *fileFont = [UIFont fontWithName:@"HelveticaNeue" size:17];
    fileCell.labelTitle.font = fileFont;
    
    //Is directory
    NSString *folderName =  [file.fileName stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    //Quit the last character
    folderName = [folderName substringToIndex:[folderName length]-1];
    
    //Put the name
    fileCell.labelTitle.text = folderName;
    
    NSString *nameImage = @"folder_icon.png";
    fileCell.fileImageView.image = [UIImage imageNamed:nameImage];
    cell = fileCell;
    
    return cell;
}

@end
