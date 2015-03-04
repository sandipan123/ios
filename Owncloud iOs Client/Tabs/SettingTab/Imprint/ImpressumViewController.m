//
//  ImpressumViewController.m
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 2/7/13.
//


/**
 *    @author Javier Gonzalez
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
#import "ImpressumViewController.h"
#import "AppDelegate.h"
#import "UIColor+Constants.h"

@interface ImpressumViewController ()

@end

@implementation ImpressumViewController

@synthesize previewWebView = _previewWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.currentViewVisible = self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib
    
    [self.navigationItem setTitle:NSLocalizedString(@"imprint_button", nil)];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ok", nil) style:UIBarButtonItemStylePlain target:self action:@selector(removeView)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    _previewWebView.delegate = self;
    _previewWebView.hidden=NO;
    
    [_previewWebView setScalesPageToFit:YES];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Impressum" ofType:@"rtf"];
    
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [_previewWebView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)removeView {
    [self.navigationController popToRootViewControllerAnimated:NO];
    //iOS6
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIWebView Delegate methods

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    DLog(@"An error happened during load");
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    DLog(@"loading started");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    DLog(@"webViewDidFinishLoad");    
}

@end
