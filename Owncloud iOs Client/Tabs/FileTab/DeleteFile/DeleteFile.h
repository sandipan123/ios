//
//  DeleteFile.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 8/17/12.
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
#import <Foundation/Foundation.h>
#import "FileDto.h"
#import "ManageNetworkErrors.h"

@protocol DeleteFileDelegate

@optional
- (void)refreshTableFromWebDav;
- (void)initLoading;
- (void)endLoading;
- (void)reloadTableFromDataBase;
- (void)errorLogin;
- (void)removeSelectedIndexPath;
@end

@interface DeleteFile : NSObject <UIAlertViewDelegate, UIActionSheetDelegate, ManageNetworkErrorsDelegate>
  
typedef enum {
    deleteFromServerAndLocal=1,
    deleteFromLocal=2
    
} enumDeleteFrom;

@property(nonatomic, strong) FileDto *file;
@property(nonatomic,weak) __weak id<DeleteFileDelegate> delegate; 
@property(nonatomic,strong)NSString *currentLocalFolder;
@property(nonatomic,strong)UIView *viewToShow;
@property(nonatomic,strong)UIActionSheet *popupQuery;
@property int deleteFromFlag;
@property(nonatomic)BOOL deleteFromFilePreview;
@property(nonatomic)BOOL isFilesDownloadedInFolder;
@property(nonatomic, strong) ManageNetworkErrors *manageNetworkErrors;

- (void)askToDeleteFileByFileDto: (FileDto *) file;
- (void)deleteItemFromDeviceByFileDto: (FileDto *) file;
- (void)errorLogin;

@end
