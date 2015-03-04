//
//  AddAccountViewController.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 10/2/12.
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
#import "LoginViewController.h"

@protocol AddAccountDelegate

@optional
- (void)refreshTable;
@end

@interface AddAccountViewController : LoginViewController

@property(nonatomic,weak) __weak id<AddAccountDelegate> delegate; 

- (IBAction)cancelClicked:(id)sender;

@end
