//
//  EditAccountViewController.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 10/5/12.
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
#import "LoginViewController.h"
#import "UserDto.h"

//Define a extern notification
extern NSString *relaunchErrorCredentialFilesNotification;

@interface EditAccountViewController : LoginViewController {
    UserDto *_selectedUser;
    
}

@property(nonatomic,strong)UserDto *selectedUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andUser:(UserDto *) selectedUser;
- (void)setBarForCancelForLoadingFromModal;
- (void)setBrandingNavigationBarWithCancelButton;
- (IBAction)cancelClicked:(id)sender;

@end
