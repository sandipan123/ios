//
//  DocumentPickerViewController.h
//  ownCloudExtApp
//
//  Created by Gonzalo Gonzalez on 14/10/14.
//

/**
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
#import "FMDatabaseQueue.h"
#import "FileListDocumentProviderViewController.h"
#import "KKPasscodeViewController.h"


@class SimpleFileListTableViewController;
@class OCCommunication;
@class UserDto;


@interface DocumentPickerViewController : UIDocumentPickerExtensionViewController <KKPasscodeViewControllerDelegate, FileListDocumentProviderViewControllerDelegate>


+ (FMDatabaseQueue*)sharedDatabase;
+ (OCCommunication*)sharedOCCommunication;

@property (weak, nonatomic) IBOutlet UILabel *labelErrorLogin;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLogo;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewError;

@property (nonatomic, strong) UserDto *user;

@end
