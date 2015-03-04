//
//  SharedViewController.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 17/01/14.
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
#import "CheckAccessToServer.h"
#import "SWTableViewCell.h"
#import "ShareFileOrFolder.h"
#import "MBProgressHUD.h"

@interface SharedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, ShareFileOrFolderDelegate, MBProgressHUDDelegate> 

//Share Table
@property (nonatomic,strong) IBOutlet UITableView *sharedTableView;
//Refresh Control
@property(nonatomic, strong) UIRefreshControl *refreshControl;
//To check if there are access with the server
@property(nonatomic, retain) CheckAccessToServer *mCheckAccessToServer;
//Share file or folder
@property(nonatomic, strong) ShareFileOrFolder *mShareFileOrFolder;

//Loading view
@property(nonatomic, strong) MBProgressHUD  *HUD;


//Store if the refreshShared it's in progress
@property(nonatomic)BOOL isRefreshSharedInProgress;
//Number of folders and files in the share list
@property (nonatomic) int numberOfFolders;
@property (nonatomic) int numberOfFiles;

///-----------------------------------
/// @name Refresh Shared Path
///-----------------------------------

/**
 * This method do the request to the server, get the shared data of the all files
 * Then update the DataBase with the shared data in the files of the current path
 * Finally, reload the file list with the database data
 */
- (void) refreshSharedItems;




@end
