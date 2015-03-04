//
//  FilesViewController.h
//  Owncloud iOs Client
//
//  This class controlled the view of the file list with all of it's options
//  - Show files an folders
//  - Navigation between the folders
//  - Refresh with pull down to refresh
//  - Show options of + menu:
//      - Upload files
//      - Create folder
//  - Swipe and long press gestures support
//  - Open with option with download file if it's necessary
//  - Move file/folder option
//  - Rename file/folder option
//  - Delete file/folder option
//  
//
//  Created by Javier Gonzalez on 7/11/12.
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
#import "FileDto.h"
#import "UserDto.h"
#import "MBProgressHUD.h"
#import "DeleteFile.h"
#import "OpenWith.h"
#import "DownloadViewController.h"
#import "CheckAccessToServer.h"
#import "ELCImagePickerController.h"
#import "PrepareFilesToUpload.h"
#import "RenameFile.h"
#import "MoveFile.h"
#import "EditAccountViewController.h"
#import "ShareFileOrFolder.h"
#import "SWTableViewCell.h"
#import "OverwriteFileOptions.h"
#import "ManageNetworkErrors.h"
#import "SelectFolderViewController.h"
#import "SelectFolderNavigation.h"

@interface FilesViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,
ELCImagePickerControllerDelegate, UISearchBarDelegate, UIAlertViewDelegate, MBProgressHUDDelegate, UITextFieldDelegate, DeleteFileDelegate, OpenWithDelegate, DownloadViewControllerDelegate, CheckAccessToServerDelegate, RenameDelegate, MoveFileDelegate, ShareFileOrFolderDelegate, SWTableViewCellDelegate, ManageNetworkErrorsDelegate>

//Table view
@property(nonatomic, strong) IBOutlet UITableView *tableView;

// Array that contains the files ordered alphabetically
@property(nonatomic, strong) NSArray *sortedArray;
//The current directory array
@property(nonatomic, strong) NSArray *currentDirectoryArray;
//Path for remote folder for upload
@property(nonatomic, strong) NSString *remoteFolderToUpload;
//Path for remote folder
@property(nonatomic, strong) NSString *currentRemoteFolder;
//Path for current local folder
@property(nonatomic, strong) NSString *currentLocalFolder;
//Path for next remote folder
@property(nonatomic, strong) NSString *nextRemoteFolder;
//The user of the file list
@property(nonatomic, strong) UserDto *mUser;
//FileDto for the selected file
@property(nonatomic, strong) FileDto *selectedFileDto;
//FileDto file to show files
@property(nonatomic, strong) FileDto *fileIdToShowFiles;
//View for Create Folder
@property(nonatomic, strong) UIAlertView *folderView;
//Delete file/folder option
@property(nonatomic, strong) DeleteFile *mDeleteFile;
//OpenWith option
@property(nonatomic, strong) OpenWith *openWith;
//Share file/folder option
@property(nonatomic, strong) ShareFileOrFolder *mShareFileOrFolder;
//Download view for the open with option
@property(nonatomic, strong) DownloadViewController *downloadView;
//Rename file/folder option
@property(nonatomic, strong) RenameFile *rename;
//Move file or folder option
@property(nonatomic, strong) MoveFile *moveFile;
//FilDto current file show files on the server to update
@property(nonatomic, strong) FileDto *currentFileShowFilesOnTheServerToUpdateTheLocalFile;
//View for loading screen
@property(nonatomic, strong) MBProgressHUD  *HUD;
//To check if there are access with the server
@property(nonatomic, retain) CheckAccessToServer *mCheckAccessToServer;
//Move task in background
@property(nonatomic)UIBackgroundTaskIdentifier moveTask;
//Refresh Control
@property(nonatomic, strong) UIRefreshControl *refreshControl;
//View about credentials error
@property (nonatomic,strong) EditAccountViewController *resolvedCredentialError;
//UIActionSheet for "more" option on swipe
@property (nonatomic,strong) UIActionSheet *moreActionSheet;
//UIActionSheet for + button
@property (nonatomic,strong) UIActionSheet *plusActionSheet;
//An exist file
@property (nonatomic, strong) OverwriteFileOptions *overWritteOption;
//Class to manage the Network erros
@property (nonatomic, strong) ManageNetworkErrors *manageNetworkErrors;
@property (nonatomic, strong) UIView *viewToShow;

//Select folder views used by move options
@property (nonatomic, strong) SelectFolderViewController *selectFolderViewController;
@property (nonatomic, strong) SelectFolderNavigation *selectFolderNavigation;

//Flags
//Boleean that indicate if the loading screen is showing
@property(nonatomic) BOOL showLoadingAfterChangeUser;
//Boleean that indicate if is checking the Etag
@property(nonatomic) BOOL checkingEtag;
//Boleean that indicate if is necesary etag request
@property(nonatomic) BOOL isEtagRequestNecessary;
//Alert to show any alert on Files view. Property to can cancel it on rotate
@property(nonatomic) UIAlertView *alert;
//Select indexpath to indicate the cell where we have to put the arrow of the popover
@property(nonatomic) NSIndexPath *selectedIndexPath;
//Selected file for iPad
@property(nonatomic, strong) NSIndexPath *selectedCell;
//Number of folders and files in the file list
@property (nonatomic) int numberOfFolders;
@property (nonatomic) int numberOfFiles;

@property (nonatomic) BOOL isLoadingForNavigate;


// init method to load view from nib with an array of files
- (id) initWithNibName:(NSString *) nibNameOrNil onFolder:(NSString *) currentFolder andFileId:(NSInteger) fileIdToShowFiles andCurrentLocalFolder:(NSString *)currentLocalFoler;

- (void)initLoading;
- (void)endLoading;
- (void)refreshTableFromWebDav;
- (void)reloadTableFromDataBase;

- (void) goToSelectedFileOrFolder:(FileDto *) selectedFile;

@end;

