//
//  SimpleFileListTableViewController.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 04/11/14.
//
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
#import "MBProgressHUD.h"
#import "CheckAccessToServer.h"
#import "ManageNetworkErrors.h"

@class UserDto;
@class FileDto;

@class SimpleFileListTableViewController;

@interface SimpleFileListTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MBProgressHUDDelegate, CheckAccessToServerDelegate, ManageNetworkErrorsDelegate>

///-----------------------------------
/// @name Init SimpleFileListTable
///-----------------------------------

/**
 * This method init the SimpleFileListTable or the Class that subclass the SimpleFileListTable
 *
 * @param NSString -> nibNameOrNil Xib to be loaded
 * @param FileDto -> currentFolder folder to be loaded
 *
 * @return self
 *
 * @warning This method is not necessary to be overwritten
 */
- (id) initWithNibName:(NSString *) nibNameOrNil onFolder:(FileDto *) currentFolder;

///-----------------------------------
/// @name fillTheArraysFromDatabase
///-----------------------------------

/**
 * This method fill the arrays (currentDirectoryArray and sortedArray) with the info that is on the Database
 *
 * @warning This method can be overwritten if we do not need all the files of a concret folder. For example if we need only the folders
 */
- (void) fillTheArraysFromDatabase;

///-----------------------------------
/// @name checkBeforeNavigationToFolder
///-----------------------------------

/**
 * This method init the navigation to the next folder
 *
 * @param FileDto -> file Folder where we want naviagte
 *
 * @warning This method should not be overwritten
 * @warning This method should be called on the didSelectRowAtIndexPath to init a navigation
 */
- (void) checkBeforeNavigationToFolder:(FileDto *) file;

///-----------------------------------
/// @name navigateToFile
///-----------------------------------

/**
 * This method launch the navigation between views on the UINavigationController
 *
 * @param FileDto -> file Folder where we want naviagte
 *
 * @warning This method should be overwritten using the correct Class and Xib to navigate
 */
- (void) navigateToFile:(FileDto *) file;

///-----------------------------------
/// @name reloadCurrentFolder
///-----------------------------------

/**
 * This method launch a request to the server to load the current folder
 *
 * @warning This method should not be overwritten
 */
- (void) reloadCurrentFolder;

- (void) loadRemote:(FileDto *) file andNavigateIfIsNecessary:(BOOL) isNecessaryNavigate;

///-----------------------------------
/// @name partitionObjects
///-----------------------------------

/**
 * This method sort the array of files and folders alphabetically
 *
 * 
 * @param NSArray -> array of files and folders to be sorted
 * @param SEL -> object about what will be sorted
 *
 * @return NSArray of files sorted
 *
 * @warning This method should not be overwritten
 */
- (NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector;

//Loading methods
- (void)initLoading;
- (void)endLoading;

//Table of files and folders
@property (nonatomic, strong) IBOutlet UITableView *tableView;
//User used to obtain the info from the server
@property (nonatomic, strong) UserDto *user;
//Folder where we want to obtain the files and folders
@property (nonatomic, strong) FileDto *currentFolder;
//Array of files and folders obtained from the Database
@property (nonatomic, strong) NSArray *currentDirectoryArray;
//Array of files and folders sorted by fileName
@property (nonatomic, strong) NSArray *sortedArray;
//Flag to not launch the refresh in background (Etag) at the same time that we request the info manually from the server
@property BOOL isRefreshInProgress;
//Next List of files to navigate
@property (nonatomic, strong) SimpleFileListTableViewController *simpleFilesViewController;

//View for loading screen
@property(nonatomic, strong) MBProgressHUD  *HUD;
//Refresh Control
@property(nonatomic, strong) UIRefreshControl *refreshControl;
//Manage network errors
@property(nonatomic, strong) ManageNetworkErrors *manageNetworkErrors;

@end
