//
//  DownloadViewController.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 22/08/12.
//

/**
 *    @author Javier Gonzalez
 *    @author Gonzalo Gonzalez
 *    @author Noelia Alvarez
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

@protocol DownloadViewControllerDelegate

@optional
- (void)cancelDownload;
@end

@interface DownloadViewController : UIViewController{
    
    UIProgressView *_progressView;
    UIButton *_cancelButton;
    UILabel *_progressLabel;
    __weak id<DownloadViewControllerDelegate> delegate;
    
    IBOutlet NSLayoutConstraint *_heightProgressBar;
    
}

@property(nonatomic, strong) IBOutlet UIProgressView *progressView;
@property(nonatomic, strong) IBOutlet UIButton *cancelButton;
@property(nonatomic, strong) IBOutlet UILabel *progressLabel;
@property(nonatomic,weak) __weak id<DownloadViewControllerDelegate> delegate; 


-(IBAction)cancelButtonPressed:(id)sender;
-(void)configureView;
-(void)potraitView;
-(void)landscapeView;

@end
