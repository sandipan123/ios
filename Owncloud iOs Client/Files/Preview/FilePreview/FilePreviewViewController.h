//
//  FilePreviewViewController.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 10/11/2012.
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
#import "FileDto.h"
#import "Download.h"
#import "OpenWith.h"
#import "DeleteFile.h"
#import "MediaViewController.h"
#import "OfficeFileView.h"
#import "GalleryView.h"
#import "CheckAccessToServer.h"
#import "OCToolBar.h"
#import "CWStatusBarNotification.h"
#import "ShareFileOrFolder.h"

extern NSString * iPhoneCleanPreviewNotification;
extern NSString * iPhoneShowNotConnectionWithServerMessageNotification;


@interface FilePreviewViewController : UIViewController <UIAlertViewDelegate, DeleteFileDelegate, CheckAccessToServerDelegate, DownloadDelegate, MediaViewControllerDelegate, GalleryViewDelegate, ShareFileOrFolderDelegate>
{
    //Autolayout attributes
    IBOutlet NSLayoutConstraint *_progressViewHeightConstraint;
    IBOutlet UIBarButtonItem *_favoriteButtonBar;
    
    NSString *nameFileToUpdate;
}

//File object
@property(nonatomic, strong) FileDto *file;

//Objects of the screen
@property(nonatomic, strong) IBOutlet UIImageView *previewImageView;
@property(nonatomic, strong) IBOutlet UIProgressView *progressView;
@property(nonatomic, strong) IBOutlet UIButton *cancelButton;
@property(nonatomic, strong) IBOutlet UILabel *progressLabel;

//View for show the updating progress bar
@property (nonatomic, strong) IBOutlet UIView *updatingFileView;
@property (nonatomic, strong) IBOutlet UIProgressView *updatingFileProgressView;
@property (nonatomic, strong) IBOutlet UIButton *updatingCancelButton;
@property (nonatomic, strong) CWStatusBarNotification *notification;

@property(nonatomic, strong) IBOutlet OCToolBar *toolBar;

//Features objects
@property(nonatomic, strong) DeleteFile *mDeleteFile;
@property(nonatomic) OpenWith *openWith;
@property(nonatomic, strong) ShareFileOrFolder *mShareFileOrFolder;

//Local folder
@property(nonatomic, strong) NSString *currentLocalFolder;

//Owncloud preview objects
@property(nonatomic, strong) OfficeFileView *officeView;
@property(nonatomic, strong) MediaViewController *moviePlayer;
@property(nonatomic, strong) GalleryView *galleryView;
//Control the type of files
@property(nonatomic) NSInteger typeOfFile;

@property(nonatomic) BOOL isDownloading;
//Flag to check if the cancel was clicked before launch automatically the favorite download
@property(nonatomic) BOOL isCancelDownloadClicked;

//GALLERY
//Array with the order images to the Gallery
@property(nonatomic, strong) NSArray *sortedArray;

//Fullscreen option for the Gallery
@property(nonatomic) CGRect transitionFrame;





/*
 * Init method
 */
- (id) initWithNibName:(NSString *) nibNameOrNil selectedFile:(FileDto *) file;

/*
 * Open With feature. Action to show the apps that can open the selected file
 */
- (IBAction)didPressOpenWithButton:(id)sender;

/*
 * Share by link feature. Action to share the selected file by link.
 */
- (IBAction)didPressShareLinkButton:(id)sender;

/*
 * Future option
 */
- (IBAction)didPressFavoritesButton:(id)sender;

/*
 * Delete feaure. Action to show a menu to select one delete option of a selected file
 */
- (IBAction)didPressDeleteButton:(id)sender;

/*
 * Cancel download feature. Action to cancel the download of a selected file.
 */
- (IBAction)didPressCancelButton:(id)sender;

/*
 * Action button. Cancel the current download in progress
 */
- (IBAction)didPressUpdatingCancelButton:(id)sender;


@end
