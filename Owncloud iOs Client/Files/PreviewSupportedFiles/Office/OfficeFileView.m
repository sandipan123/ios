//
//  OffieFileViewController.m
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

#import "OfficeFileView.h"
#import "UIColor+Constants.h"
#import "FileNameUtils.h"
#import "constants.h"

@interface OfficeFileView ()

@end

@implementation OfficeFileView
@synthesize webView=_webView;
@synthesize activity=_activity;
@synthesize isDocument=_isDocument;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


///-----------------------------------
/// @name Go Back
///-----------------------------------

/**
 * Method to go back in the navigation
 */
- (void)goBack{
    
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

///-----------------------------------
/// @name Go Forward
///-----------------------------------

/**
 * Method to go Forward in the navigation
 */
- (void)goForward{
    
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}

///-----------------------------------
/// @name Add Control Panel to Navigate
///-----------------------------------

/**
 * This method add control panel to navigate between the pages
 *
 */
- (void)addControlPanelToNavigate{
    
    //BackButton
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(_webView.frame.size.width - 150, 10, 50, 30)];
    [backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    //FordwardButton
    UIButton *forwardButton = [[UIButton alloc]initWithFrame:CGRectMake(_webView.frame.size.width - 75, 10, 70, 30)];
    [forwardButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [forwardButton setTitle:@"Forwd" forState:UIControlStateNormal];
    
    [forwardButton addTarget:self action:@selector(goForward) forControlEvents:UIControlEventTouchUpInside];
    
    [_webView addSubview:backButton];
    [_webView addSubview:forwardButton];
}


- (void)configureWebView{
    
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.frame];
    }
    _webView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

/*
 * Method to load a document by filePath.
 */
- (void)openOfficeFileWithPath:(NSString*)filePath andFileName: (NSString *) fileName {
    _isDocument=YES;
    
    [self configureWebView];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    NSString *ext=@"";
    ext = [FileNameUtils getExtension:fileName];
    
    if ( [ext isEqualToString:@"CSS"] || [ext isEqualToString:@"PY"] || [ext isEqualToString:@"XML"] || [ext isEqualToString:@"JS"] ) {
        NSMutableURLRequest *headRequest = [NSMutableURLRequest requestWithURL:url];
        [headRequest setHTTPMethod:@"HEAD"];
        NSHTTPURLResponse *headResponse;
        NSError *error = nil;
        [NSURLConnection sendSynchronousRequest:headRequest
                              returningResponse:&headResponse
                                          error:&error];
        if (error != nil) {
            NSLog(@"loadURLWithString %@",[error localizedDescription]);
        }
      
        
        NSString *dataFile = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:url] encoding:NSASCIIStringEncoding];

        if (IS_IPHONE) {
       
            [self.webView  loadHTMLString:[NSString stringWithFormat:@"<div style='font-size:%@;font-family:%@;'><pre>%@",k_txt_files_font_size_iphone,k_txt_files_font_family,dataFile] baseURL:nil];
        }else{

            [self.webView  loadHTMLString:[NSString stringWithFormat:@"<div style='font-size:%@;font-family:%@;'><pre>%@",k_txt_files_font_size_ipad,k_txt_files_font_family,dataFile] baseURL:nil];
        }
       
        
    }else if ([ext isEqualToString:@"TXT"] ) {
        NSMutableURLRequest *headRequest = [NSMutableURLRequest requestWithURL:url];
        [headRequest setHTTPMethod:@"HEAD"];
        NSHTTPURLResponse *headResponse;
        NSError *error = nil;
        [NSURLConnection sendSynchronousRequest:headRequest
                              returningResponse:&headResponse
                                          error:&error];
        if (error != nil) {
            NSLog(@"loadURLWithString %@",[error localizedDescription]);
        }
        NSString *mimeType = [headResponse MIMEType];
        
        [_webView loadData:[NSData dataWithContentsOfURL: url] MIMEType:mimeType
          textEncodingName:@"utf-8" baseURL:nil];
    }else if ([ext isEqualToString:@"PDF"]) {
        NSURL *targetURL = [NSURL fileURLWithPath:filePath];
        NSData *pdfData = [[NSData alloc] initWithContentsOfURL:targetURL];
        [self.webView loadData:pdfData MIMEType:@"application/pdf" textEncodingName:@"utf-8" baseURL:nil];
    } else {
        [self.webView loadRequest:[NSMutableURLRequest requestWithURL:url]];
    }
    
    [_webView setHidden:NO];
    [_webView setScalesPageToFit:YES];
}

/*
 * Method to load a link by path
 */
- (void)openLinkByPath:(NSString*)path {
    _isDocument=NO;
    
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self configureWebView];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    _webView.hidden=NO;
    _webView.delegate = self;
    
    [_webView loadRequest:request];
}

#pragma mark - UIWebView Delegate Methods
#pragma mark UIWebView Delegate methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"Office webview an error happened during load");
    [_activity stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    DLog(@"Office webview loading started");
    
    if (_activity==nil) {
        _activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.center=CGPointMake(_webView.center.x, _webView.center.y);
        [_webView addSubview:_activity];
    }
    _activity.center=CGPointMake(_webView.center.x, _webView.center.y);
    [_activity startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    DLog(@"webViewDidFinishLoad");
    [_activity stopAnimating];
    
    [_webView setHidden:NO];
    [_webView setScalesPageToFit:YES];
    
    if (_isDocument==NO) {
        [_delegate finishLinkLoad];        
    }
}

@end
