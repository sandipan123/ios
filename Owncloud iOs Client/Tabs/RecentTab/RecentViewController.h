//
//  RecentViewController.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 8/6/12.
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
#import "SelectFolderNavigation.h"
#import "OverwriteFileOptions.h"


@class UploadsOfflineDto;
@interface RecentViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, OverwriteFileOptionsDelegate, SelectFolderDelegate, UIAlertViewDelegate>
 
@property (nonatomic,strong) IBOutlet UITableView *uploadsTableView;
@property (nonatomic,strong) NSArray *currentsUploads;
@property (nonatomic,strong) NSArray *recentsUploads;
@property (nonatomic,strong) NSArray *failedUploads;
@property (nonatomic,strong) UploadsOfflineDto *selectedUploadToResolveTheConflict;

@property (nonatomic,strong) NSMutableArray *progressViewArray;

@property (nonatomic, strong) NSString *currentRemoteFolder;
@property (nonatomic, strong) NSString *locationInfo;

@property (nonatomic, strong) OverwriteFileOptions *overWritteOption;

@property (nonatomic, strong) UploadsOfflineDto *selectedFileDtoToResolveNotPermission;


- (void)updateRecents;
- (void) updateProgressView:(NSUInteger)num withPercent:(float)percent;

@end
