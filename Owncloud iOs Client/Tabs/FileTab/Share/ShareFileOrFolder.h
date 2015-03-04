//
//  ShareFileOrFolder.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 1/10/14.
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

#import <Foundation/Foundation.h>
#import "FileDto.h"
#import "OCSharedDto.h"

@protocol ShareFileOrFolderDelegate

@optional
- (void)initLoading;
- (void)endLoading;
- (void)errorLogin;
@end

@interface ShareFileOrFolder : NSObject <UIActionSheetDelegate>

@property (nonatomic, assign) FileDto *file;
@property (nonatomic, assign) OCSharedDto *shareDto;
@property (nonatomic, strong) UIActionSheet *shareActionSheet;
//This view is to show the shareActionSheet
@property (nonatomic, strong) UIView *viewToShow;
@property (nonatomic, weak) __weak id<ShareFileOrFolderDelegate> delegate;
@property (nonatomic, strong) UIPopoverController *activityPopoverController;
//this bool is to indicate if the parent view is a cell
@property (nonatomic)  BOOL isTheParentViewACell;
//this CGRect is to pass the cell frame of the file list
@property (nonatomic) CGRect cellFrame;
@property (nonatomic, strong) UIBarButtonItem *parentButton;
//This view is to show the Popover with the share link options
@property (nonatomic, strong) UIView *parentView;

- (void) showShareActionSheetForFile:(FileDto *) file;

///-----------------------------------
/// @name Present Share Action Sheet For Token
///-----------------------------------

/**
 * This method show a Share View using a share token
 *
 * @param token -> NSString
 *
 */
- (void) presentShareActionSheetForToken:(NSString *)token;



///-----------------------------------
/// @name Unshare the file
///-----------------------------------

/**
 * This method unshares the file/folder
 *
 * @param OCSharedDto -> The shared file/folder
 */
- (void) unshareTheFile: (OCSharedDto *)sharedByLink;

///-----------------------------------
/// @name Click on share link from file
///-----------------------------------

/**
 * Method to share the file from file or from sharedDto
 *
 * @param isFile -> BOOL. Distinct between is fileDto or shareDto
 */
- (void) clickOnShareLinkFromFileDto:(BOOL)isFileDto;

@end
