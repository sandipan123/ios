//
//  UploadRecentCell.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 13/09/12.

/**
 *    @author Javier Gonzalez
 *    @author Gonzalo Gonzalez
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

#import "UploadRecentCell.h"

@implementation UploadRecentCell

@synthesize labelTitle=_labelTitle;
@synthesize labelLengthAndDate=_labelLengthAndDate;
@synthesize labelUserName=_labelUserName;
@synthesize labelPath=_labelPath;
@synthesize fileImageView=_fileImageView;



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

@end
