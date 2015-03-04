//
//  CustomCellFileAndDirectory.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 29/07/12.
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

#import "CustomCellFileAndDirectory.h"

@implementation CustomCellFileAndDirectory

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

///-----------------------------------
/// @name scrollViewWillBeginDecelerating
///-----------------------------------

/**
 * Method to initialize the position where we make the swipe in order to detect the direction
 *
 * @param UIScrollView -> scrollView
 */
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    _lastContentOffset = scrollView.contentOffset.x;
}

@end
