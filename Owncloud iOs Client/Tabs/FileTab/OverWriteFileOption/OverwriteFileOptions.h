//
//  OverwriteFileOptions.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 3/18/13.
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

#import <Foundation/Foundation.h>
#import "FileDto.h"

@protocol OverwriteFileOptionsDelegate
@optional
- (void)setNewNameToSaveFile:(NSString *) name;
- (void)overWriteFile;
@end

@interface OverwriteFileOptions : NSObject <UIActionSheetDelegate, UIAlertViewDelegate, UITextFieldDelegate> {
}

@property(nonatomic,strong)UIActionSheet *overwriteOptionsActionSheet;
@property(nonatomic,strong)UIView *viewToShow;
@property(nonatomic,strong)UIAlertView *renameAlertView;;
@property(nonatomic,weak) __weak id<OverwriteFileOptionsDelegate> delegate;
@property(nonatomic,strong) FileDto *fileDto;


-(void) showOverWriteOptionActionSheet;



@end
