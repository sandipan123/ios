//
//  UploadCell.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 12/09/12.

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

#import <UIKit/UIKit.h>

@interface UploadCell : UITableViewCell{
    
    __weak UIProgressView * _progressView;
     UIButton *_cancelButton;  
    __weak UIButton *_pauseButton; 
    __weak UILabel *_labelTitle;  
    __weak UIImageView *_fileImageView;
    __weak UILabel *_labelErrorMessage;
    
}

@property(nonatomic, weak) IBOutlet UIProgressView * progressView;
@property(nonatomic, strong) IBOutlet UIButton *cancelButton;
@property(nonatomic, weak) IBOutlet UIButton *pauseButton;
@property(nonatomic, weak) IBOutlet UILabel *labelTitle;
@property(nonatomic, weak) IBOutlet UIImageView *fileImageView;
@property(nonatomic, weak) IBOutlet UILabel *labelErrorMessage;



@end
