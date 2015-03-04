//
//  UploadUtils.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 04/07/13.
//

/**
 *    @author Javier Gonzalez
 *    @author Gonzalo Gonzalez
 *    @author Noelia Alvarez
 *    @author Rebeca Martin de Leon
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

#import "UploadUtils.h"
#import "Customization.h"
#import "AppDelegate.h"
#import "ManageFilesDB.h"
#import "DeleteFile.h"
#import "FilePreviewViewController.h"
#import "constants.h"
#import "UtilsDtos.h"
#import "UploadsOfflineDto.h"
#import "ManageFilesDB.h"

NSString * PreviewFileNotification=@"PreviewFileNotification";

@implementation UploadUtils

/*
 * Method tha make the lengt of the file
 */
+ (NSString *)makeLengthString:(long)estimateLength{
    //Lengh
    float lengh=estimateLength;
    lengh=lengh/1024; //KB
    
    NSString *lenghString;
    
    if (lengh>=1000) {
        //MB
        lengh=lengh/1024;
        lenghString=[NSString stringWithFormat:@"%.1f MB",lengh];
    }else {
        //KB
        lenghString=[NSString stringWithFormat:@"%.1f KB",lengh];
    }
    
    NSString *temp =[NSString stringWithFormat:@"%@", lenghString];
    
    return temp;
}

/*
 * Method that make the path string
 */
+ (NSString *)makePathString:(NSString *)destinyFolder withUserUrl:(NSString *)userUrl{
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSArray *splitedUrlFromServer = [userUrl componentsSeparatedByString:@"/"];
    DLog(@"splitedUrlFromServer: %lu", (unsigned long)[splitedUrlFromServer count]);
    
    NSString *utf8String;
    
    utf8String = [destinyFolder stringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding)NSUTF8StringEncoding];
    
    NSString *tempString= appName;
    NSString *temp;
    NSArray *splitedUrl = [utf8String componentsSeparatedByString:@"/"];
    
    for (int i=0;i<[splitedUrl count]; i++) {
        
        if (i>[splitedUrlFromServer count]) {
            temp=[NSString stringWithFormat:@"/%@", [splitedUrl objectAtIndex:i]];
            DLog(@"Temp paht string: %@", temp);
            tempString=[tempString stringByAppendingString:temp];
        }
    }
    
    if ([tempString isEqualToString:@""] || [tempString isEqualToString:@"/"]) {
        tempString=appName;
    }
    
    
    return tempString;
    
}


/*
 *Method that updates a downloaded file when the user overwrites this file
 */
+(void) updateOverwritenFile:(FileDto *)file FromPath:(NSString *)path{
    
    //Delete the file in the device
    DeleteFile *mDeleteFile = [[DeleteFile alloc] init];
    [mDeleteFile deleteItemFromDeviceByFileDto:file];
    
    //Update the file
    DLog(@"oldPath: %@",path);
    DLog(@"newPath: %@",file.localFolder);
    NSFileManager *filecopy=nil;
    filecopy =[NSFileManager defaultManager];
    NSError *error;
    
    if(![filecopy copyItemAtPath:path toPath:file.localFolder error:&error]){
        DLog(@"Error: %@",[error localizedDescription]);
    }
    else{
        DLog(@"All ok");
    }
    //Maintain the state as overwriting
    [ManageFilesDB setFileIsDownloadState:file.idFile andState:overwriting];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //Obtain the remotePath: https://s3.owncloud.com/owncloud/remote.php/webdav
    NSString *remoteFolder = [NSString stringWithFormat: @"%@%@", app.activeUser.url, k_url_webdav_server];
    //With the filePath obtain the folder name: A/
    NSString *folderName= [UtilsDtos getDbBFolderPathFromFullFolderPath:file.filePath andUser:app.activeUser];
    //Obtain the complete path: https://s3.owncloud.com/owncloud/remote.php/webdav/A/
    remoteFolder=[NSString stringWithFormat:@"%@%@",remoteFolder, folderName];
    DLog(@"remote folder: %@",remoteFolder);
    
    //Post a notification to inform to the PreviewFileViewController class
    NSString *pathFile= [NSString stringWithFormat:@"%@%@", remoteFolder,file.fileName];
    [[NSNotificationCenter defaultCenter] postNotificationName:PreviewFileNotification object:pathFile];
}

//-----------------------------------
/// @name Get an URL with the Redirected
///-----------------------------------

/**
 * Method to modify a URL changing the domain and the protocol (http/https) with the urlServerRedirected if it is not nil
 *
 * @param NSString -> originalUrl
 *
 * @return NSString
 *
 */
+ (NSString *) getUrlWithRedirectionByOriginalURL:(NSString *) originalUrl {
    
    NSString *output = originalUrl;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    //If app.urlServerRedirected is nil the server is not redirected
    if (app.urlServerRedirected) {
        NSString *textToBeRemoved = [UtilsDtos getHttpAndDomainByURL:originalUrl];
        NSString *textWithoutOriginalDomain = [originalUrl substringFromIndex:textToBeRemoved.length];
        
        output = [app.urlServerRedirected stringByAppendingString:textWithoutOriginalDomain];

    }
    
    
    return output;
    
}

//-----------------------------------
/// @name Get a fileDto by the UploadOffline
///-----------------------------------

/**
 * Method to get a fileDto from the DB with the information of a UploadOffline
 *
 * @param UploadsOfflineDto -> UploadsOfflineDto
 *
 * @return FileDto
 *
 *
 * @warning if the FileDto does not exist we will return a nil
 */
+ (FileDto *) getFileDtoByUploadOffline:(UploadsOfflineDto *) uploadsOfflineDto {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *partToRemoveOfPah = [app.activeUser.url stringByAppendingString:k_url_webdav_server];
    
    NSString *filePath = [uploadsOfflineDto.destinyFolder substringFromIndex:partToRemoveOfPah.length];
    
    FileDto *output = [ManageFilesDB getFileDtoByFileName:uploadsOfflineDto.uploadFileName andFilePath:filePath andUser:app.activeUser];
    
    return output;
}


+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

@end



