//
//  FileListDocumentProviderViewController.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 24/11/14.
//
//

/**
 *    @author Javier Gonzalez
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
#import "SimpleFileListTableViewController.h"
#import "DPDownload.h"

@protocol FileListDocumentProviderViewControllerDelegate

@optional
- (void) openFile:(FileDto*)fileDto;
@end

@interface FileListDocumentProviderViewController : SimpleFileListTableViewController <DPDownloadDelegate>

//Notification to notify that the user has change
extern NSString *userHasChangeNotification;
extern NSString *userHasCloseDocumentPicker;

@property (nonatomic) BOOL isLockedApperance;
@property (nonatomic, strong) FileDto *selectedFile;
@property (nonatomic, strong) NSOperation *downloadOperation;
@property (nonatomic, strong) DPDownload *download;
@property(nonatomic,weak) __weak id<FileListDocumentProviderViewControllerDelegate> delegate;
@property BOOL isNecessaryAdjustThePositionAndTheSizeOfTheNavigationBar;
@property (nonatomic, strong) FileListDocumentProviderViewController *filesViewController;

- (void) showErrorMessage:(NSString *)string;

@end
