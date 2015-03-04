//
//  OCPortraitNavigationViewController.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 30/09/13.
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

#import "OCPortraitNavigationViewController.h"


@interface OCPortraitNavigationViewController ()

@end

@implementation OCPortraitNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (IS_IPHONE) {
        //iPhone
        return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    } else {
        //iPad
        return YES;
    }
    
    
}
-(NSUInteger)supportedInterfaceOrientations
{
    if (IS_IPHONE) {
        //iPhone
         return UIInterfaceOrientationMaskPortrait;
    } else {
        //iPad
         return UIInterfaceOrientationMaskAll;
    }
    
   
}

@end
