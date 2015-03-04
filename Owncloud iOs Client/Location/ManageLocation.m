//
//  ManageLocation.m
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


#import "ManageLocation.h"
#import "SettingsViewController.h"
#import "ManageAppSettingsDB.h"
#import "ManageAsset.h"

@implementation ManageLocation

+ (ManageLocation *)sharedSingleton {
    static ManageLocation *sharedSingleton;
    @synchronized(self)
    {
        if (!sharedSingleton){
            sharedSingleton = [[ManageLocation alloc] init];
        }
        return sharedSingleton;
    }
}

-(void)startSignificantChangeUpdates {
    
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.pausesLocationUpdatesAutomatically = NO;
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
            [self.locationManager requestAlwaysAuthorization];
        }
        
    }
    
    [self.locationManager startMonitoringSignificantLocationChanges];
}

-(void)stopSignificantChangeUpdates {
    
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation* location = [locations lastObject];
    
    DLog(@"latitude__ %+.6f, longitude__ %+.6f\n",location.coordinate.latitude, location.coordinate.longitude);
    
    [self.delegate changedLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    [self.delegate statusAuthorizationLocationChanged];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DLog(@"Unable to start location manager. Error:%@", [error description]);
    [self.delegate statusAuthorizationLocationChanged];
    
}

@end
