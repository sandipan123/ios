//
//  FileNameUtils.h
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 02/04/13.
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

#import <Foundation/Foundation.h>




typedef NS_ENUM (NSInteger, kindOfFileEnum){
    imageFileType = 0,
    videoFileType = 1,
    audioFileType = 2,
    officeFileType = 3,
    otherFileType = 4,
};

@interface FileNameUtils : NSObject



/*
 * Method to obtain the extension of the file in upper case
 * @fileName -> file name
 */
+ (NSString *)getExtension:(NSString*)fileName;


+ (NSInteger) checkTheTypeOfFile: (NSString*)fileName;


/*
 * Method to know if the file is an image support for the system
 * Only JPG, PNG, GIF, TIFF, TIF, BMP, and JPEG images files are supported for the moment.
 * @fileName -> file name 
 */
+ (BOOL)isImageSupportedThisFile:(NSString*)fileName;

/*
 * Method to know if the file is an video file support for the system
 * Only MOV, MP4, M4V and 3GP video files are supported natively for iOS.
 * @fileName -> file name 
 */
+ (BOOL)isVideoFileSupportedThisFile:(NSString*)fileName;

/*
 * Method to know if the file is an video file support for the system
 * Only MP3, AIFF, AAC, WAV and M4A audio files are supported natively for iOS.
 * @fileName -> file name 
 */
+ (BOOL)isAudioSupportedThisFile:(NSString*)fileName;

/*
 * Method to know if the file is an office file support for the system
 * Only TXT, PDF, DOC, XLS, PPT, RTF, DOCX, PPTX and XLSX type of files
 * are supported for the moment.
 * @fileName -> file name 
 */
+ (BOOL)isOfficeSupportedThisFile:(NSString*)fileName;

/*
 * Method to know if the image file can be scaled.
 * Only JPG, PNG, BMP and JPEG images files can be scaled for the moment.
 * @fileName -> file name 
 */
+ (BOOL)isScaledThisImageFile:(NSString*)fileName;

/*
 * Method that return the name of the preview Image file in accordance with file name.
 * @fileName -> file name 
 */
+ (NSString*)getTheNameOfTheImagePreviewOfFileName:(NSString*)fileName;


/*
 * Method that check the file name or folder name to find forbiden characters
 * This is the forbiden characters in server: "\", "/","<",">",":",""","|","?","*"
 * @fileName -> file name
 */
+ (BOOL)isForbidenCharactersInFileName:(NSString*)fileName;

/*Method to remove the first http or https from an url
 *@url -> url from the server
 */
+ (NSString*) getUrlServerWithoutHttpOrHttps:(NSString*) url;

/*
 * This method check and url and look for a saml fragment
 * and return the bollean result
 @urlString -> url from redirect server
 */

+ (BOOL)isURLWithSamlFragment:(NSString*)urlString;

///-----------------------------------
/// @name Get the Name of the Brand Image
///-----------------------------------

/**
 * This method return a string with the name of the brand image
 * Used by ownCloud and other brands
 *
 * If the day of the year is 354 or more the string return is an
 * especial image for Christmas day.
 *
 * @return image name -> NSString
 */

+ (NSString *)getTheNameOfTheBrandImage;


///-----------------------------------
/// @name Get the Name of shared path
///-----------------------------------

/**
 * This method get the name of Share Path
 * Share path is like this: /documents/example.doc
 *
 * This method must be return "example.doc"
 *
 * @param sharePath -> NSString
 *
 * @param isDirectory -> BOOL
 *
 * @return NSString
 *
 */
+ (NSString*)getTheNameOfSharedPath:(NSString*)sharedPath isDirectory:(BOOL)isDirectory;

///-----------------------------------
/// @name Get the Parent Path of the Full Shared Path
///-----------------------------------

/**
 * This method make the parent path using the full path
 *
 * @param sharedPath -> NSString (/parentPath/path)
 *
 * @param isDirectory -> BOOL
 *
 * @return output -> NSString
 *
 */

+ (NSString*)getTheParentPathOfFullSharedPath:(NSString*)sharedPath isDirectory:(BOOL)isDirectory;


///-----------------------------------
/// @name markFileNameOnAlertView
///-----------------------------------

/**
 * This method marks the text on an alert View
 *
 * @param alertView -> UIAlertView
 */
+ (void)markFileNameOnAlertView: (UITextField *) textFieldToMark;

@end
