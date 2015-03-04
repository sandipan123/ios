//
//  UtilsTableView.m
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 30/04/14.
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

#import "UtilsTableView.h"

@implementation UtilsTableView

#define k_status_bar_height 20
#define k_tableViewHeight_portrait 932
#define k_tableViewHeight_landscape 748
#define k_tableViewHeight_portrait_ios6 831
#define k_tableViewHeight_landscape_ios6 655

//-----------------------------------
/// @name getUITableViewHeightForSingleRowByNavigationBatHeight
///-----------------------------------

/**
 * Method to return the height of the UITableView to draw a cell with the exact size
 *
 * @param CGFloat -> navigationBarHeight
 * @param CGFloat -> tabBarControllerHeight
 * @param CGFloat -> tableViewHeightForIphone
 *
 * @return CGFloat
 */
+ (CGFloat) getUITableViewHeightForSingleRowByNavigationBatHeight:(CGFloat) navigationBarHeight andTabBarControllerHeight:(CGFloat) tabBarControllerHeight andTableViewHeight:(CGFloat) tableViewHeightForIphone {
    
    CGFloat height = 0.0;
    
    //Obtain the center of the table
    CGFloat tableViewHeight = 0.0;
    if (!IS_IPHONE) {
        
        if (IS_IOS7 || IS_IOS8) {
            
            if (IS_PORTRAIT) {
                tableViewHeight = k_tableViewHeight_portrait;
            } else {
                tableViewHeight = k_tableViewHeight_landscape;
            }
            
            height = tableViewHeight - tabBarControllerHeight - navigationBarHeight;
        } else {
            
            if (IS_PORTRAIT) {
                height = k_tableViewHeight_portrait_ios6;
            } else {
                height = k_tableViewHeight_landscape_ios6;
            }
        }
    } else {
        tableViewHeight = tableViewHeightForIphone;
        
        if (IS_IOS7) {
            height = tableViewHeight- tabBarControllerHeight - navigationBarHeight - k_status_bar_height;
        }else if (IS_IOS8){
            
            if (IS_PORTRAIT) {
                 height = tableViewHeight- tabBarControllerHeight - navigationBarHeight - k_status_bar_height;
            }else{
                height = tableViewHeight- tabBarControllerHeight - navigationBarHeight;
            }
        }else{
            height = tableViewHeight;
        }
    }
    
    return height;
}

@end
