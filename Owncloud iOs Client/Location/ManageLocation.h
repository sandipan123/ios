//
//  ManageLocation.h
//  Owncloud iOs Client
//
//  Created by Noelia Alvarez on 09/12/14.
//
//

/**
 *    @author Noelia Alvarez
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
#import <CoreLocation/CoreLocation.h>

@protocol ManageLocationDelegate

@optional
- (void)statusAuthorizationLocationChanged;
- (void)changedLocation;
@end

@interface ManageLocation : NSObject <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property BOOL firstChangeAuthorizationDone;
@property(nonatomic,weak) __weak id<ManageLocationDelegate> delegate;

+ (ManageLocation *) sharedSingleton;
-(void)startSignificantChangeUpdates;
-(void)stopSignificantChangeUpdates;

@end
