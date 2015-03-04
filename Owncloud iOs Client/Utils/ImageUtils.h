//
//  ImageUtils.h
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

#import <Foundation/Foundation.h>

@interface ImageUtils : NSObject

/**
 * This method receive a color and return a image based in this color
 *
 * @param color -> UIColor
 *
 * @return UIImage
 *
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
