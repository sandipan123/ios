//
//  OCTabBarController.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 09/10/13.
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
#import "OCTabBarController.h"
#import "Customization.h"
#import "UIColor+Constants.h"
#import "ImageUtils.h"


@interface OCTabBarController ()

@end

@implementation OCTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // If the tab bar is customized
        if (k_is_customize_uitabbar) {
            
            [self.tabBar setBarTintColor:[UIColor colorOfTintUITabBar]];
            [self.tabBar setBackgroundImage:[ImageUtils imageWithColor:[UIColor colorOfBackgroundNavBarImage]]];
            [self.tabBar setTintColor:[UIColor colorOfTintSelectedUITabBar]];
            
            [self manageBackgroundView:NO];

        }
    }
   
    
    //Set the color of the tab labels
    if (k_is_customize_unselectedUITabBarItems ) {
        //Unselected label
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorOfTintNonSelectedUITabBar] } forState:UIControlStateNormal];
        //Selected label
        [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor colorOfTintSelectedUITabBar] } forState:UIControlStateSelected];
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

///-----------------------------------
/// @name Manage Background View
///-----------------------------------

/**
 * This method add or hide the background view into toolBar
 *
 * @param isShow -> Indicate if the tool bar is show or not
 */
- (void)manageBackgroundView:(BOOL)isShow{
    
    if (!isShow) {
        
        CGRect bgFrame = self.tabBar.bounds;
        _backgroundView = [[PassthroughView alloc] initWithFrame:bgFrame];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor = [UIColor colorOfNavigationBar];
        _backgroundView.alpha = 0.6;
        [self.tabBar addSubview:_backgroundView];
        [self.tabBar sendSubviewToBack:_backgroundView];
        
        
    } else {
        
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        
    }
    
}



@end
