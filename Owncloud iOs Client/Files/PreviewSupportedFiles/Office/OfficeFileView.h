//
//  OffieFileViewController.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 03/04/13.
//

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

#import <UIKit/UIKit.h>

@protocol OfficeFileDelegate

@optional
- (void)finishLinkLoad;
@end


@interface OfficeFileView : UIView<UIWebViewDelegate>{
    
    UIWebView *_webView;
    UIActivityIndicatorView *_activity;
    BOOL _isDocument;
    
    __weak id<OfficeFileDelegate> _delegate;
}

@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) UIActivityIndicatorView *activity;
@property (nonatomic) BOOL isDocument;
@property(nonatomic,weak) __weak id<OfficeFileDelegate> delegate;


/*
 * Method to load a document by filePath.
 */
- (void)openOfficeFileWithPath:(NSString*)filePath andFileName: (NSString *)fileName;

/*
 * Method to load a link by path
 */
- (void)openLinkByPath:(NSString*)path;


@end
