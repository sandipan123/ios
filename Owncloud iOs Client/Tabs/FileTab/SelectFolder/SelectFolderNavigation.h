//
//  SelectFolderNavigation.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 01/10/12.
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
#import "UINavigationController+KeyboardDismiss.h"
#import "OCNavigationController.h"


@interface SelectFolderNavigation : OCNavigationController {
    
    __weak id delegate;    
}

@property (nonatomic, weak) id delegate;


-(void)selectFolder:(NSString*)folder;


-(void)cancelSelectedFolder;


@end

@protocol SelectFolderDelegate


- (void)folderSelected:(NSString*)folder;
- (void)cancelFolderSelected;


@end

