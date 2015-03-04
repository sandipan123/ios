//
//  ManageAppSettingsDB.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 24/06/13.
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

@interface ManageAppSettingsDB : NSObject

/*
 * Method that return if exist pass code or not
 */
+(BOOL)isPasscode;


/*
 * Method that insert pin code
 * @passcode -> pin code
 */
+(void) insertPasscode: (NSString *) passcode;

/*
 * Method that return the pin code
 */
+(NSString *) getPassCode;

/*
 * Method that remove the pin code
 */
+(void) removePasscode;

/*
 * Method that insert certificate
 * @certificateLocation -> path of certificate
 */
+(void) insertCertificate: (NSString *) certificateLocation;


/*
 * Method that return an array with all of certifications
 */
+(NSMutableArray*) getAllCertificatesLocation;


/*
 * Methods manage instant uploads photos
 */
+(BOOL)isInstantUpload;
+(void)updateInstantUploadTo:(BOOL)instantUpload;
+(void)updatePathInstantUpload:(NSString *)newValue;
+(void)updateDateInstantUpload:(long )newValue;
+(void)updateInstantUploadAllUser;
+(long)getDateInstantUpload;
+(void)updateOnlyWifiInstantUpload:(BOOL)newValue;


@end
