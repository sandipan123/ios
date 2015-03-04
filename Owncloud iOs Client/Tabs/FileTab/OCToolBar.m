//
//  OCToolBar.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 08/10/13.
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
#import "OCToolBar.h"
#import "UIColor+Constants.h"
#import "ImageUtils.h"



@implementation OCToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self setBarTintColor:[UIColor colorOfToolBar]];
        [self setBackgroundImage:[ImageUtils imageWithColor:[UIColor colorOfBackgroundToolBarImage]] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self manageBackgroundView:NO];
        [self setTintColor:[UIColor colorOfToolBarButtons]];
        //Option for normal tint adjustment.
        [self setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    }
    return self;
    
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
        
        CGRect bgFrame = self.bounds;
        PassthroughView *backgroundView = [[PassthroughView alloc] initWithFrame:bgFrame];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.backgroundColor = [UIColor colorOfNavigationBar];
        backgroundView.alpha = 0.6;
        [self addSubview:backgroundView];
        [self sendSubviewToBack:backgroundView];

        
    } else {
        
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
