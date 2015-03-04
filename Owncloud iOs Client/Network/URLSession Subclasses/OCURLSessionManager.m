//
//  OCURLSessionManager.m
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 05/06/14.
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

#import "OCURLSessionManager.h"
#import "AppDelegate.h"
#import "ManageAppSettingsDB.h"
#import "CheckAccessToServer.h"
#import "UtilsUrls.h"

@implementation OCURLSessionManager
 
/*
 *  Delegate called when try to upload a file to a self signed server
 */
- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    
    DLog(@"willSendRequestForAuthenticationChallenge");
    
    BOOL trusted = NO;
    SecTrustRef trust;
    NSURLProtectionSpace *protectionSpace;
    
    protectionSpace = [challenge protectionSpace];
    trust = [protectionSpace serverTrust];
    
    CheckAccessToServer *mCheck = [CheckAccessToServer new];
    
    [mCheck createFolderToSaveCertificates];
    
    if(trust != nil) {
        [mCheck saveCertificate:trust withName:@"tmp.der"];
        
        NSString *documentsDirectory = [UtilsUrls getOwnCloudFilePath];
        
        NSString *localCertificatesFolder = [NSString stringWithFormat:@"%@/Certificates/",documentsDirectory];
        
        NSMutableArray *listCertificateLocation = [ManageAppSettingsDB getAllCertificatesLocation];
        
        for (int i = 0 ; i < [listCertificateLocation count] ; i++) {
            
            NSString *currentLocalCertLocation = [listCertificateLocation objectAtIndex:i];
            NSFileManager *fileManager = [ NSFileManager defaultManager];
            if([fileManager contentsEqualAtPath:[NSString stringWithFormat:@"%@tmp.der",localCertificatesFolder] andPath:[NSString stringWithFormat:@"%@",currentLocalCertLocation]]) {
                DLog(@"Is the same certificate!!!");
                trusted = YES;
            }
        }
    } else {
        trusted = NO;
    }
    
    __block NSURLCredential *credential = nil;
    credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    
    if (trusted) {
        completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
    } else {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, credential);
    }
}

@end
