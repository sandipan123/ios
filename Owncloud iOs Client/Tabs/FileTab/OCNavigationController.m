//
//  OCNavigationController.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 13/09/13.
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

#import "OCNavigationController.h"
#import "UIColor+Constants.h"
#import "Customization.h"
#import "ImageUtils.h"

@interface OCNavigationController ()

@end

@implementation OCNavigationController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIFont *appFont = [UIFont fontWithName:@"HelveticaNeue" size:18];
        
        self.navigationBar.barTintColor = [UIColor colorOfNavigationBar];
        
        [self.navigationBar setBackgroundImage:[ImageUtils imageWithColor:[UIColor colorOfBackgroundNavBarImage]] forBarMetrics:UIBarMetricsDefault];
        
        //Add background view in nav bar
        [self manageBackgroundView:NO];
        
        [self.navigationBar setTintColor:[UIColor colorOfNavigationItems]];
        
        //Set the title color
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor colorOfNavigationTitle];
        shadow.shadowOffset = CGSizeMake(0.7, 0);
        
        
       NSDictionary *titleAttributes = @{NSForegroundColorAttributeName: [UIColor colorOfNavigationTitle],
                                          NSShadowAttributeName: shadow,
                                          NSFontAttributeName: appFont};
        
        
        
        [self.navigationBar setTitleTextAttributes:titleAttributes];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NavBar color
   
    
}

///-----------------------------------
/// @name Manage Background View
///-----------------------------------

/**
 * This method add or hide the background view into nav bar
 *
 * @param isShow -> Indicate if the nav bar is show or not
 */
- (void)manageBackgroundView:(BOOL)isShow{
    
    if (!isShow) {
        
        CGRect bgFrame = self.navigationBar.bounds;
        bgFrame.origin.y -= 20.0;
        bgFrame.size.height += 20.0;
        _backgroundView = [[PassthroughView alloc] initWithFrame:bgFrame];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor = [UIColor colorOfNavigationBar];
        _backgroundView.alpha = 0.6;
        [self.navigationBar addSubview:_backgroundView];
        [self.navigationBar sendSubviewToBack:_backgroundView];
        
    } else {
        
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
