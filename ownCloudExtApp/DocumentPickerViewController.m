//
//  DocumentPickerViewController.m
//  ownCloudExtApp
//
//  Created by Gonzalo Gonzalez on 14/10/14.
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

#import "DocumentPickerViewController.h"

#import "ManageUsersDB.h"
#import "ManageFilesDB.h"
#import "UserDto.h"
#import "UtilsUrls.h"
#import "FileListDocumentProviderViewController.h"
#import "OCNavigationController.h"
#import "OCCommunication.h"
#import "OCFrameworkConstants.h"
#import "OCURLSessionManager.h"
#import "CheckAccessToServer.h"
#import "OCKeychain.h"
#import "CredentialsDto.h"
#import "FileListDBOperations.h"
#import "ManageAppSettingsDB.h"
#import "KKPasscodeViewController.h"
#import "OCPortraitNavigationViewController.h"
#import "UtilsFramework.h"
#import "constants.h"
#import "ProvidingFileDto.h"
#import "ManageProvidingFilesDB.h"
#import "NSString+Encoding.h"

@interface DocumentPickerViewController ()

@end

@implementation DocumentPickerViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOwnCloudNavigationOrShowErrorLogin) name:userHasChangeNotification object:nil];
}

- (void) viewWillDisappear:(BOOL)animated{
   
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName: userHasCloseDocumentPicker object: nil];
    
}

- (IBAction)openDocument:(id)sender {
    NSURL* documentURL = [self.documentStorageURL URLByAppendingPathComponent:@"Untitled.txt"];
    
    // TODO: if you do not have a corresponding file provider, you must ensure that the URL returned here is backed by a file
    [self dismissGrantingAccessToURL:documentURL];
}

-(void)prepareForPresentationInMode:(UIDocumentPickerMode)mode {
    // TODO: present a view controller appropriate for picker mode here
    
    
    if ([ManageAppSettingsDB isPasscode]) {
        [self showPassCode];
    } else {
        [self showOwnCloudNavigationOrShowErrorLogin];
    }
}

- (void) showOwnCloudNavigationOrShowErrorLogin {
    
    self.user = [ManageUsersDB getActiveUser];
    
    if (self.user) {
        
        [UtilsFramework deleteAllCookies];
        
        FileDto *rootFolder = [ManageFilesDB getRootFileDtoByUser:self.user];
        
        if (!rootFolder) {
            rootFolder = [FileListDBOperations createRootFolderAndGetFileDtoByUser:self.user];
        }
        
        FileListDocumentProviderViewController *fileListTableViewController = [[FileListDocumentProviderViewController alloc] initWithNibName:@"FileListDocumentProviderViewController" onFolder:rootFolder];
        fileListTableViewController.delegate = self;
        
        OCNavigationController *navigationViewController = [[OCNavigationController alloc] initWithRootViewController:fileListTableViewController];
        
        if (IS_IPHONE && [ManageAppSettingsDB isPasscode] && self.view.frame.size.height < self.view.frame.size.width) {
            fileListTableViewController.isNecessaryAdjustThePositionAndTheSizeOfTheNavigationBar = YES;
        }

        [self presentViewController:navigationViewController animated:NO completion:^{
            //We check the connection here because we need to accept the certificate on the self signed server before go to the files tab
            CheckAccessToServer *mCheckAccessToServer = [[CheckAccessToServer alloc] init];
            mCheckAccessToServer.viewControllerToShow = fileListTableViewController;
            mCheckAccessToServer.delegate = fileListTableViewController;
            [mCheckAccessToServer isConnectionToTheServerByUrl:self.user.url];
        }];
        
    } else {
        //TODO: show the login view
        NSString *message = NSLocalizedString(@"error_login_doc_provider", nil);
        _labelErrorLogin.text = message;
        _labelErrorLogin.textAlignment = NSTextAlignmentCenter;
        
    }
}


#pragma mark - FMDataBase
+ (FMDatabaseQueue*)sharedDatabase
{
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[[UtilsUrls getOwnCloudFilePath] stringByAppendingPathComponent:@"DB.sqlite"]];
    
    static FMDatabaseQueue* sharedDatabase = nil;
    if (sharedDatabase == nil)
    {
        NSString *documentsDir = [UtilsUrls getOwnCloudFilePath];
        NSString *dbPath = [documentsDir stringByAppendingPathComponent:@"DB.sqlite"];
        
        
        //NSString* bundledDatabasePath = [[NSBundle mainBundle] pathForResource:@"DB" ofType:@"sqlite"];
        sharedDatabase = [[FMDatabaseQueue alloc] initWithPath: dbPath];
    }
    
    return sharedDatabase;
}

#pragma mark - OCCommunications
+ (OCCommunication*)sharedOCCommunication
{
    static OCCommunication* sharedOCCommunication = nil;
    if (sharedOCCommunication == nil)
    {
        sharedOCCommunication = [[OCCommunication alloc] init];
        
        //Acive the cookies functionality if the server supports it

        UserDto *user = [ManageUsersDB getActiveUser];
        
        if (user) {
            if (user.hasCookiesSupport == serverFunctionalitySupported) {
                sharedOCCommunication.isCookiesAvailable = YES;
            }
        }
        
    }
    return sharedOCCommunication;
}


#pragma mark - FileListDocumentProviderViewControllerDelegate

- (void) openFile:(FileDto *)fileDto {
    
    NSURL *originUrl = [NSURL fileURLWithPath:fileDto.localFolder];
    NSString *folder = [NSString stringWithFormat: @"file_%@/", fileDto.etag];
    NSURL *destinationUrl = [self.documentStorageURL URLByAppendingPathComponent:folder];
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationUrl.path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:destinationUrl.path withIntermediateDirectories:NO attributes:nil error:&error];
        DLog(@"Error: %@", [error localizedDescription]);
    }
    
    destinationUrl = [destinationUrl URLByAppendingPathComponent:fileDto.fileName];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destinationUrl.path]) {
        if (![[NSFileManager defaultManager] removeItemAtURL:destinationUrl error:&error]) {
            NSLog(@"Error removing file: %@", error);
        }
    }
    
    if (![[NSFileManager defaultManager] copyItemAtURL:originUrl toURL:destinationUrl error:&error]) {
        NSLog(@"Error copyng file: %@", error);
    }
    
    NSDictionary *attributes = nil;
    
    if (!error) {
        attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:destinationUrl.path error:&error];
         NSLog(@"Error getting the artributtes of the file: %@", error);
    }
    
    
    //Some error in the process to send the file to the document picker.
   if (attributes && !error) {
       
       ProvidingFileDto *providingFile = [ManageProvidingFilesDB insertProvidingFileDtoWithPath:[UtilsUrls getRelativePathForDocumentProviderUsingAboslutePath:destinationUrl.path] byUserId:self.user.idUser];
       [ManageFilesDB updateFile:fileDto.idFile withProvidingFile:providingFile.idProvidingFile];
       
       [self dismissGrantingAccessToURL:destinationUrl];
        
    }else{
        
        OCNavigationController *navigationController = (OCNavigationController*) self.presentedViewController;
        FileListDocumentProviderViewController *fileListController = (FileListDocumentProviderViewController*) [navigationController.viewControllers objectAtIndex:0];
        [fileListController showErrorMessage:NSLocalizedString(@"error_sending_file_to_document_picker", nil)];
    }
}

#pragma mark - Pass Code

- (void)showPassCode {
    
    KKPasscodeViewController* vc = [[KKPasscodeViewController alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    
    OCNavigationController *oc = [[OCNavigationController alloc]initWithRootViewController:vc];
    vc.mode = KKPasscodeModeEnter;
    
    UIViewController *rootController = [[UIViewController alloc]init];
    rootController.view.backgroundColor = [UIColor darkGrayColor];
    
    [self presentViewController:oc animated:NO completion:^{
    }];
}

#pragma mark - KKPasscodeViewControllerDelegate

- (void)didPasscodeEnteredCorrectly:(KKPasscodeViewController*)viewController{
    DLog(@"Did pass code entered correctly");
    
    [self performSelector:@selector(showOwnCloudNavigationOrShowErrorLogin) withObject:nil afterDelay:0.1];
}

- (void)didPasscodeEnteredIncorrectly:(KKPasscodeViewController*)viewController{
    DLog(@"Did pass code entered incorrectly");

}

/*
- (NSURL *)documentStorageURL {
    
    NSString *path = [self.documentStorageURL path];
    path = [path stringByAppendingString:@"PEPE/"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        DLog(@"Error: %@", [error localizedDescription]);
    }
    
    return [NSURL fileURLWithPath:path];
}*/

@end
