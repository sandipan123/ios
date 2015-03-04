//
//  UtilsTableView.h
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

#import <Foundation/Foundation.h>

@interface UtilsTableView : NSObject

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
+ (CGFloat) getUITableViewHeightForSingleRowByNavigationBatHeight:(CGFloat) navigationBarHeight andTabBarControllerHeight:(CGFloat) tabBarControllerHeight andTableViewHeight:(CGFloat) tableViewHeightForIphone;

@end
