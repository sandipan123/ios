//
//  MainPopOverBarckground.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 19/09/12.
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

#import "MainPopOverBarckground.h"

@implementation MainPopOverBarckground

  @synthesize arrowOffset, arrowDirection;

-(id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"popover_backgroud.png"] resizableImageWithCapInsets: UIEdgeInsetsMake(40.0, 10.0, 30.0, 10.0)]];
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popover_arrow.png"]];
        
        
        
        self.backgroundColor =  _arrowView.backgroundColor =  _imageView.backgroundColor = [UIColor clearColor];
        
        //Hidden the _imageView (Border) in order to do a iOS 7 style
         [_imageView setHidden:YES];
        
        
        [self addSubview:_imageView];
        
        [self addSubview:_arrowView];
        
    }
    
    return self;
    
}



- (void)drawRect:(CGRect)rect {
    
    
    
}



-(void)layoutSubviews{
    
    
    
    if (arrowDirection == UIPopoverArrowDirectionUp) {  
        
        _imageView.frame = CGRectMake(1, [MainPopOverBarckground arrowHeight], self.superview.frame.size.width, self.superview.frame.size.height - [MainPopOverBarckground arrowHeight]);
        
        
        
        _arrowView.frame = CGRectMake((self.superview.frame.size.width / 2 + arrowOffset - [MainPopOverBarckground arrowBase] / 2)+8, 2, [MainPopOverBarckground arrowBase], [MainPopOverBarckground arrowHeight]);
        
    }
    
    
    
    if (arrowDirection == UIPopoverArrowDirectionRight) {  
        
        
        
        _imageView.frame = CGRectMake(1, 0, self.superview.frame.size.width - [MainPopOverBarckground arrowHeight], self.superview.frame.size.height);
        
        
        
        _arrowView.image = [[UIImage alloc] initWithCGImage: _arrowView.image.CGImage scale: 1.0 orientation: UIImageOrientationRight];
        
        
        
        _arrowView.frame = CGRectMake((self.superview.frame.size.width - [MainPopOverBarckground arrowHeight] - 1)+8, self.superview.frame.size.height / 2 + arrowOffset - [MainPopOverBarckground arrowBase] / 2, [MainPopOverBarckground arrowHeight], [MainPopOverBarckground arrowBase]);
        
    }
    
}



+(UIEdgeInsets)contentViewInsets{

    return UIEdgeInsetsMake(1, 1, 1, 1);
    
}



+(CGFloat)arrowHeight{
    
    return 21.0;
    
}



+(CGFloat)arrowBase{
    
    return 35.0;
    
}



@end

