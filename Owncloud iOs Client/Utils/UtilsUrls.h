//
//  UtilsUrls.h
//  Owncloud iOs Client
//
//  Created by Javier Gonzalez on 16/10/14.
//

/**
 *    @author Javier Gonzalez
 *    @author Gonzalo Gonzalez
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

@class UserDto;

@interface UtilsUrls : NSObject

+ (NSString *) getOwnCloudFilePath;
+ (NSString *) getBundleOfSecurityGroup;
+ (NSString *) bundleSeedID;
+ (NSString *) getFullBundleSecurityGroup;

//Method to skip a file to a iCloud backup
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

//We remove the part of the remote file path that is not necesary
+ (NSString *) getRemovedPartOfFilePathAnd:(UserDto *)mUserDto;

//We generate de local path of the files dinamically
+ (NSString *)getLocalFolderByFilePath:(NSString*) filePath andFileName:(NSString*) fileName andUserDto:(UserDto *) mUser;


//Get the relative path of the document provider using an absolute path
+ (NSString *)getRelativePathForDocumentProviderUsingAboslutePath:(NSString *) abosolutePath;

//Get the path of the temp folder where there are the temp files for the uploads
+ (NSString *) getTempFolderForUploadFiles;

@end
