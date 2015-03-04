//
//  WebViewController.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 08/10/12.
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

#import "WebViewController.h"
#import "AppDelegate.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self openLink:_urlString];
    [self setNameScreen:_navigationTitleString];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
    
    // return YES;
}

- (void) openLink:(NSString*)urlString{
    
    DLog(@"Open Link");
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // [_previewWebView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
  //  [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    _webView.hidden=NO;
    _webView.delegate = self;
    [_webView setScalesPageToFit:YES];
    [_webView loadRequest:request];
}

- (void) setNameScreen:(NSString*)name{   
    
    [self setTitle:name];    
}

#pragma mark UIWebView Delegate methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"An error happened during load: %@", error);
    [_activity stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    DLog(@"loading started");
    
    if (_activity==nil) {
        _activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.center=CGPointMake(self.webView.center.x, self.webView.center.y);
        [_webView addSubview:_activity];
    }
    _activity.center=CGPointMake(self.webView.center.x, self.webView.center.y);
    [_activity startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    DLog(@"webViewDidFinishLoad");
    [_activity stopAnimating];    
    [_webView setHidden:NO];
    [_webView setScalesPageToFit:YES];
    
    
}


@end
