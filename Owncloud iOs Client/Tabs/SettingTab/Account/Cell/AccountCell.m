//
//  AccountCell.m
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 10/1/12.
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

#import "AppDelegate.h"
#import "AccountCell.h"
#import "CheckAccessToServer.h"
#import "UtilsFramework.h"
#import "ManageUsersDB.h"
#import "Customization.h"

@implementation AccountCell
@synthesize userName = _userName;
@synthesize urlServer = _urlServer;
@synthesize activeButton = _activeButton;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)activeAccount:(id)sender {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //We check the connection here because we need to accept the certificate on the self signed server before go to the files tab
    CheckAccessToServer *mCheckAccessToServer = [[CheckAccessToServer alloc] init];
    [mCheckAccessToServer isConnectionToTheServerByUrl:self.urlServer.text];
    
    //We delete the cookies on SAML
    if (k_is_sso_active) {
        app.activeUser.password = @"";
        [ManageUsersDB updatePassword:app.activeUser];
    }
    [UtilsFramework deleteAllCookies];
    
    [self.delegate activeAccountByPosition:self.activeButton.tag];

}

@end
