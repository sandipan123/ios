//
//  FailedUploadCell.h
//  Owncloud iOs Client
//
//  Created by Rebeca Martín de León on 09/07/13.
//

/**
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

@interface FailedUploadCell : UITableViewCell{


__weak UILabel *_labelTitle;
__weak UILabel *_labelLengthAndError;
__weak UILabel *_labelUserName;
__weak UILabel *_labelPath;
__weak UIImageView *_fileImageView;
}


@property(nonatomic, weak) IBOutlet UILabel *labelTitle;
@property(nonatomic, weak) IBOutlet UILabel *labelLengthAndError;
@property(nonatomic, weak) IBOutlet UILabel *labelUserName;
@property(nonatomic, weak) IBOutlet UILabel *labelPath;
@property(nonatomic, weak) IBOutlet UIImageView *fileImageView;


@end
