//
//  OpenWith.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 21/08/12.
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
#import <Foundation/Foundation.h>
#import "Download.h"
#import "FileDto.h"


@protocol OpenWithDelegate

@optional
- (void)percentageTransfer:(float)percent andFileDto:(FileDto*)fileDto;
- (void)progressString:(NSString*)string andFileDto:(FileDto*)fileDto;
- (void)downloadCompleted:(FileDto*)fileDto;
- (void)downloadFailed:(NSString*)string andFile:(FileDto*)fileDto;
- (void)reloadTableFromDataBase;
- (void)errorLogin;
@end


@interface OpenWith : NSObject <UIDocumentInteractionControllerDelegate, DownloadDelegate>

@property(nonatomic, strong) FileDto *file;
@property(nonatomic,weak) __weak id<OpenWithDelegate> delegate; 
@property(nonatomic, strong) UIView *parentView;
@property(nonatomic, strong) UIActivityViewController *activityView;
@property(nonatomic, strong) UIBarButtonItem *parentButton;
@property(nonatomic, strong) Download *download;
@property(nonatomic, strong) NSString *currentLocalFolder;
//this bool is to indicate if the parent view is a cell
@property(nonatomic)  BOOL isTheParentViewACell;
//this CGRect is to pass the cell frame of the file list
@property(nonatomic) CGRect cellFrame;
@property (nonatomic, strong) UIPopoverController *activityPopoverController;


- (void) downloadAndOpenWithFile: (FileDto *) file;
- (void) openWithFile: (FileDto *) file;
- (void) cancelDownload;
- (void) errorLogin;

@end
