//
//  SelectFolderViewController.h
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

#import <UIKit/UIKit.h>
#import "UserDto.h"
#import "CheckAccessToServer.h"
#import "MBProgressHUD.h"
#import "FileDto.h"
#import "OCToolBar.h"
#import "SimpleFileListTableViewController.h"


@interface SelectFolderViewController : SimpleFileListTableViewController <CheckAccessToServerDelegate, UIAlertViewDelegate, UITextFieldDelegate>{
    
    //Inteface
    UIBarButtonItem *_createButton;
    UIBarButtonItem *_chooseButton;
    UILabel *_toolBarLabel;
    OCToolBar *_toolBar;
    
    //Info
    UserDto *_mUser;
    CheckAccessToServer *_mCheckAccessToServer; 
    FileDto *_selectedFileDto;
    __weak id parent;
    
    //Folders
    NSArray *_sortedArray;
    NSArray *_currentDirectoryArray;    
    NSString *_currentRemoteFolder;
    NSString *_currentLocalFolder;
    NSString *_nextRemoteFolder; 
    FileDto *_fileIdToShowFiles;
    
    NSString *_toolBarLabelTxt;
    
    //Create Folder    
    UIAlertView *_folderView;
    
    //Alert
    UIAlertView *_alert;
}

@property (nonatomic, strong) IBOutlet UIBarButtonItem *createButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *chooseButton;
@property (nonatomic, strong) IBOutlet UILabel *toolBarLabel;
@property (nonatomic, strong) IBOutlet OCToolBar *toolBar;
@property(nonatomic, retain) CheckAccessToServer *mCheckAccessToServer;
@property(nonatomic, strong) FileDto *selectedFileDto;
@property (nonatomic, weak) id parent;
@property(nonatomic, strong) NSArray *sortedArray;
@property(nonatomic, strong) NSArray *currentDirectoryArray;
@property(nonatomic, strong) NSString *currentRemoteFolder;
@property(nonatomic, strong) NSString *currentLocalFolder;
@property(nonatomic, strong) NSString *nextRemoteFolder;
@property(nonatomic, strong) FileDto *fileIdToShowFiles;
@property(nonatomic, strong) NSString *toolBarLabelTxt;
@property(nonatomic, strong) UIAlertView *folderView;
@property(nonatomic, strong) UIAlertView *alert;
@property(nonatomic, strong) SelectFolderViewController *selectFolderViewController;


//Actions
- (IBAction)chooseFolder;
- (IBAction)showCreateFolder;

@end
