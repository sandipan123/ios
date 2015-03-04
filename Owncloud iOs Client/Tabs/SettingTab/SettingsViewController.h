//
//  SettingsViewController.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 7/11/12.
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
#import "DetailViewController.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import "UserDto.h"
#import "KKPasscodeViewController.h"
#import "ManageLocation.h"


typedef enum {
    help=0,
    recommend = 1,
    feedback = 2,
    impress = 3,
    
} enumInfoSetting;

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, KKPasscodeViewControllerDelegate, ManageLocationDelegate>{

    UISwitch *_switchPasscode;  
    UITableView *_settingsTableView;
    DetailViewController *_detailViewController;
    UserDto *_user;
}

@property(nonatomic,strong)IBOutlet UITableView *settingsTableView;
@property(nonatomic,strong)UISwitch *switchPasscode;
@property(nonatomic,strong)UISwitch *switchInstantUpload;
@property(nonatomic, strong)DetailViewController *detailViewController;
@property(nonatomic, strong)UserDto *user;

//App pin
@property (nonatomic,strong) KKPasscodeViewController* vc;

//Social
@property (nonatomic,strong) UIActionSheet *popupQuery;
@property (nonatomic,strong) SLComposeViewController *twitter;
@property (nonatomic,strong) SLComposeViewController *facebook;
@property (nonatomic,strong) MFMailComposeViewController *mailer;
@property (nonatomic) BOOL isMailComposeVisible;

-(IBAction)changeSwitchPasscode:(id)sender;
-(IBAction)changeSwitchInstantUpload:(id)sender;
-(void)disconnectUser;
//-(void)internazionaliceTheInitialInterface;

@end
