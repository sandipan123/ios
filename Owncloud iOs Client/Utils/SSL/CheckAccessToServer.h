//
//  CheckAccessToServer.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 8/21/12.
//

/**
 *    @author Javier Gonzalez
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
#import <Foundation/Foundation.h>

@protocol CheckAccessToServerDelegate

@optional
-(void)connectionToTheServer:(BOOL)isConnection;
-(void)repeatTheCheckToTheServer;
-(void)badCertificateNoAcceptedByUser;
@end

@interface CheckAccessToServer : NSObject <UIAlertViewDelegate, NSURLConnectionDataDelegate> {
    __weak id<CheckAccessToServerDelegate> _delegate;
}


- (void) isConnectionToTheServerByUrl:(NSString *) url;
- (BOOL) isNetworkIsReachable;
- (NSString *) getConnectionToTheServerByUrlAndCheckTheVersion:(NSString *)url;
- (void)createFolderToSaveCertificates;
- (void)saveCertificate:(SecTrustRef) trust withName:(NSString *) certName;


@property (nonatomic, weak) __weak id<CheckAccessToServerDelegate> delegate;
@property (nonatomic, strong) NSString *urlStatusCheck;
@property (nonatomic, strong) UIViewController *viewControllerToShow;


@end

