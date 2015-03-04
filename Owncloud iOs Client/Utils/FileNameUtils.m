//
//  FileNameUtils.m
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

#import "FileNameUtils.h"
#import "Customization.h"


@implementation FileNameUtils


/*
 * Method to obtain the extension of the file in upper case
 * @fileName -> file name
 */
+ (NSString *)getExtension:(NSString*)fileName{
    
    NSMutableArray *fileNameArray =[[NSMutableArray alloc] initWithArray: [fileName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]]];
    NSString *extension = [NSString stringWithFormat:@"%@",[fileNameArray lastObject]];
    extension = [extension uppercaseString];
    //If the file has a ZIP extension obtain the previous one for check if it is a .pages.zip / .numbers.zip / .key.zip extension
    if ([extension isEqualToString:@"ZIP"]) {
        [fileNameArray removeLastObject];
        NSString *secondExtension = [NSString stringWithFormat:@"%@",[fileNameArray lastObject]];
        secondExtension = [secondExtension uppercaseString];
        if ([secondExtension isEqualToString:@"PAGES"] || [secondExtension isEqualToString:@"NUMBERS"] || [secondExtension isEqualToString:@"KEY"]) {
            extension = [NSString stringWithFormat:@"%@.%@",secondExtension,extension];
            return extension;
        }
    }
    return extension;
}


+ (NSInteger) checkTheTypeOfFile: (NSString*)fileName {
    NSInteger typeOfFile;
    if ([self isImageSupportedThisFile:fileName]) {
        typeOfFile = imageFileType;
    } else {
        if ([self isVideoFileSupportedThisFile:fileName]) {
            typeOfFile = videoFileType;
        } else if ([self isAudioSupportedThisFile:fileName]) {
            typeOfFile = audioFileType;
        } else if ([self isOfficeSupportedThisFile:fileName]){
            typeOfFile = officeFileType;
        } else {
            typeOfFile = otherFileType;
        }
    }
    return typeOfFile;
}


/*
 * Method to know if the file is an image support for the system
 * Only JPG, PNG, GIF, TIFF, TIF, BMP, and JPEG images files are supported for the moment.
 * @fileName -> file name
 */
+ (BOOL)isImageSupportedThisFile:(NSString*)fileName{
    
    
    NSString *ext=[self getExtension:fileName];
    
    if([ext isEqualToString:@"JPG"] || [ext isEqualToString:@"PNG"] || [ext isEqualToString:@"GIF"] || [ext isEqualToString:@"TIFF"] || [ext isEqualToString:@"TIF"] || [ext isEqualToString:@"BMP"] || [ext isEqualToString:@"JPEG"])
    {
        
        return YES;
    }
    
    return NO;
    
}


/*
 * Method to know if the file is an video file support for the system
 * Only MOV, MP4, M4V and 3GP video files are supported natively for iOS.
 * @fileName -> file name
 */
+ (BOOL)isVideoFileSupportedThisFile:(NSString*)fileName{
    
    
    NSString *ext=[self getExtension:fileName];
    
    if([ext isEqualToString:@"MOV"] || [ext isEqualToString:@"MP4"] || [ext isEqualToString:@"M4V"] || [ext isEqualToString:@"3GP"])
    {
        
        return YES;
    }
    
    return NO;
    
}

/*
 * Method to know if the file is an video file support for the system
 * Only MP3, AIFF, AAC, WAV and M4A audio files are supported natively for iOS.
 * @fileName -> file name
 */
+ (BOOL)isAudioSupportedThisFile:(NSString*)fileName{
    
    
    NSString *ext=[self getExtension:fileName];
    
    if([ext isEqualToString:@"MP3"] || [ext isEqualToString:@"AIFF"] || [ext isEqualToString:@"AAC"] || [ext isEqualToString:@"WAV"]|| [ext isEqualToString:@"M4A"])
    {
        
        return YES;
    }
    
    return NO;
    
}


/*
 * Method to know if the file is an office file support for the system
 * Only NUMBERS.ZIP, NUMBERS, PAGES.ZIP, PAGES, KEY.ZIP, KEY, TXT, PDF, DOC, XLS, PPT, RTF, DOCX, PPTX, XLSX, XML, HTM and HTML type of files
 * are supported for the moment.
 * @fileName -> file name
 */
+ (BOOL)isOfficeSupportedThisFile:(NSString*)fileName{
    
    
    NSString *ext=[self getExtension:fileName];
    
    if([ext isEqualToString:@"TXT"] || [ext isEqualToString:@"PDF"] || [ext isEqualToString:@"DOC"] || [ext isEqualToString:@"XLS"] || [ext isEqualToString:@"PPT"] || [ext isEqualToString:@"RTF"] || [ext isEqualToString:@"DOCX"] || [ext isEqualToString:@"PPTX"] || [ext isEqualToString:@"XLSX"] || [ext isEqualToString:@"XML"] || [ext isEqualToString:@"HTM"] || [ext isEqualToString:@"HTML"] || [ext isEqualToString:@"KEY.ZIP"] || [ext isEqualToString:@"NUMBERS.ZIP"] || [ext isEqualToString:@"PAGES.ZIP"] || [ext isEqualToString:@"PAGES"] || [ext isEqualToString:@"NUMBERS"] || [ext isEqualToString:@"KEY"] || [ext isEqualToString:@"CSS"]  || [ext isEqualToString:@"PY"]  || [ext isEqualToString:@"JS"])
    {
        return YES;
    }
    return NO;
}

/*
 * Method to know if the image file can be scaled.
 * Only JPG, PNG, BMP and JPEG images files can be scaled for the moment.
 * @fileName -> file name
 */
+ (BOOL)isScaledThisImageFile:(NSString*)fileName{
    
    NSString *ext=[self getExtension:fileName];
    
    if([ext isEqualToString:@"JPG"] || [ext isEqualToString:@"PNG"] || [ext isEqualToString:@"BMP"] || [ext isEqualToString:@"JPEG"])
    {
        
        return YES;
    }
    
    return NO;
    
}

/*
 * Method that return the name of the preview Image file in accordance with file name.
 * @fileName -> file name
 */
+ (NSString*)getTheNameOfTheImagePreviewOfFileName:(NSString*)fileName{
    
    NSString *ext=@"";
    ext = [self getExtension:fileName];
    
    NSString *previewFileName=@"";
    
    //Images
    if([ext isEqualToString:@"JPEG"] || [ext isEqualToString:@"JPG"] || [ext isEqualToString:@"TIF"] || [ext isEqualToString:@"TIFF"] || [ext isEqualToString:@"BMP"] || [ext isEqualToString:@"PNG"] || [ext isEqualToString:@"GIF"])
    {
        previewFileName=@"image_icon";
    }
    //Documents
    else if([ext isEqualToString:@"TXT"] || [ext isEqualToString:@"RTF"] || [ext isEqualToString:@"DOC"] || [ext isEqualToString:@"DOCX"] || [ext isEqualToString:@"PAGES.ZIP"] || [ext isEqualToString:@"PAGES"] || [ext isEqualToString:@"CSS"] || [ext isEqualToString:@"PY"]  || [ext isEqualToString:@"JS"]  || [ext isEqualToString:@"XML"]) {
        previewFileName=@"doc_icon";
    }
    //Spreadsheet
    else if([ext isEqualToString:@"XLS"] || [ext isEqualToString:@"XLSX"] || [ext isEqualToString:@"NUMBERS.ZIP"] || [ext isEqualToString:@"NUMBERS"]) {
        previewFileName=@"spreadsheet_icon";
    }
    //Presentation
    else if([ext isEqualToString:@"PPT"] || [ext isEqualToString:@"PPTX"] || [ext isEqualToString:@"KEY.ZIP"] || [ext isEqualToString:@"KEY"])
    {
        previewFileName=@"presentation_icon";
    }
    //Movies
    else if([ext isEqualToString:@"M4V"] || [ext isEqualToString:@"3GP"] || [ext isEqualToString:@"MOV"] || [ext isEqualToString:@"MP4"] || [ext isEqualToString:@"M4A"] || [ext isEqualToString:@"VIDEO"] || [ext isEqualToString:@"AVI"])
    {
        previewFileName=@"movie_icon";
    }
    //Audios
    else if([ext isEqualToString:@"WAV"] || [ext isEqualToString:@"MP3"] || [ext isEqualToString:@"AAC"])
    {
        previewFileName=@"sound_icon";
    }
    //Pdf
    else if([ext isEqualToString:@"PDF"])
    {
        previewFileName=@"pdf_icon";
    }
    //Packages
    else if([ext isEqualToString:@"ZIP"] || [ext isEqualToString:@"GZ"] || [ext isEqualToString:@"TAR"] || [ext isEqualToString:@"RAR"])
    {
        previewFileName=@"zip_icon";
    }
    //Others
    else
    {
        previewFileName=@"file_icon";
    }
    return previewFileName;
}


/*
 * Method that check the file name or folder name to find forbiden characters
 * This is the forbiden characters in server: "\", "/","<",">",":",""","|","?","*"
 * @fileName -> file name
 */
+ (BOOL)isForbidenCharactersInFileName:(NSString*)fileName{
    BOOL thereAreForbidenCharacters=NO;
    
    
    
    //Check the filename
    for(int i =0 ;i<[fileName length]; i++) {
        
        if ([fileName characterAtIndex:i]=='/'){
            thereAreForbidenCharacters=YES;
        }
        if ([fileName characterAtIndex:i]=='\\'){
            thereAreForbidenCharacters=YES;
        }
        
        if ([fileName characterAtIndex:i]=='<'){
            thereAreForbidenCharacters=YES;
        }
        if ([fileName characterAtIndex:i]=='>'){
            thereAreForbidenCharacters=YES;
        }
        if ([fileName characterAtIndex:i]=='"'){
            thereAreForbidenCharacters=YES;
        }
        if ([fileName characterAtIndex:i]==','){
            thereAreForbidenCharacters=YES;
        }
        if ([fileName characterAtIndex:i]==':'){
            thereAreForbidenCharacters=YES;
        }
        if ([fileName characterAtIndex:i]=='|'){
            thereAreForbidenCharacters=YES;
        }
        if ([fileName characterAtIndex:i]=='?'){
            thereAreForbidenCharacters=YES;
        }
        if ([fileName characterAtIndex:i]=='*'){
            thereAreForbidenCharacters=YES;
        }
        
        
    }
    
    return thereAreForbidenCharacters;
}

+ (NSString*) getUrlServerWithoutHttpOrHttps:(NSString*) url {
    
    if ([[url lowercaseString] hasPrefix:@"http://"]) {
        url = [url substringFromIndex:7];
    } else if ([[url lowercaseString] hasPrefix:@"https://"]) {
        url = [url substringFromIndex:8];
    }
    
    return url;
}

/*
 * This method check and url and look for a saml fragment
 * and return the bollean result
 @urlString -> url from redirect server
 */

+ (BOOL)isURLWithSamlFragment:(NSString*)urlString{
    
    BOOL isSaml = NO;
    
    urlString = [urlString lowercaseString];
    NSString *samlFragment1 = @"wayf";
   // NSString *samlFragment1 = @"AuthnEngine";
    NSString *samlFragment2 = @"saml";
    if((urlString && [urlString rangeOfString:samlFragment1 options:NSCaseInsensitiveSearch].location != NSNotFound)||(urlString && [urlString rangeOfString:samlFragment2 options:NSCaseInsensitiveSearch].location != NSNotFound)) {
        //shibboleth key is in the request url
        DLog(@"shibboleth fragment is in the request url");
        isSaml=YES;
    }
    
    return isSaml;
}

///-----------------------------------
/// @name Get the Name of the Brand Image
///-----------------------------------

+ (NSString *)getTheNameOfTheBrandImage{
    
    NSString *imageName;
    
    //Default name
    imageName = @"BackRootFolderIcon";
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    //The special icon for chritmats only for ownCloud app
    if ([appName isEqualToString:@"ownCloud"]) {
        // After day 354 of the year, the usual ownCloud icon is replaced by another icon
        NSCalendar *gregorian =
        [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSUInteger dayOfYear = [gregorian ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:[NSDate date]];
        if (dayOfYear >= 354)
            imageName = @"ownCloud-xmas";
        
    }
    
    return imageName;
}

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
+ (NSString*)getTheNameOfSharedPath:(NSString*)sharedPath isDirectory:(BOOL)isDirectory{
    
    NSString *output;
    
    NSArray *splitSharedPath = [sharedPath componentsSeparatedByString:@"/"];
    
    //If is directory the last object is a empty space
    if (isDirectory) {
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:splitSharedPath];
        [mArray removeLastObject];
        splitSharedPath = nil;
        splitSharedPath = [NSArray arrayWithArray:mArray];
    }
    
    output = [splitSharedPath lastObject];
    //Free memory
    splitSharedPath = nil;
    
    output = [output stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return output;

}

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

+ (NSString*)getTheParentPathOfFullSharedPath:(NSString*)sharedPath isDirectory:(BOOL)isDirectory{
   
    //If is directory remove the last character, is a /
    if (isDirectory) {
        sharedPath = [sharedPath substringToIndex:[sharedPath length]-1];
    }
    
    NSString *output;
    
    NSArray *splitSharedPath = [sharedPath componentsSeparatedByString:@"/"];
    
    NSMutableArray *mutableSplit = [NSMutableArray arrayWithArray:splitSharedPath];
    //Free memory
    splitSharedPath=nil;

    //Las objet is the name
    [mutableSplit removeLastObject];
    
    //First object is blank space
    [mutableSplit removeObjectAtIndex:0];
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    output = appName;
    
    NSString *word;
    for (NSString *part in mutableSplit) {
        word = [part stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        output = [NSString stringWithFormat:@"%@/%@", output, word];
        
    }
    
    //free memory
    mutableSplit = nil;
    
    //Add last /
    output = [NSString stringWithFormat:@"%@/", output];
    
    return output;
    
}


///-----------------------------------
/// @name markFileNameOnAlertView
///-----------------------------------

/**
 * This method marks the textField on an alert View
 *
 * @param textFieldToMark -> UITextField
 */
+ (void)markFileNameOnAlertView: (UITextField *) textFieldToMark {
    
    //1. Calculate lenght of name without extension
    NSArray *arr =[[NSArray alloc] initWithArray: [textFieldToMark.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]]];
    
    NSMutableArray *arrMutable = [NSMutableArray arrayWithArray:arr];
    if ([arr count]>1) {
        NSString *extension = [arr lastObject];
        extension = [extension uppercaseString];
        [arrMutable removeLastObject];
        if ([extension isEqualToString:@"ZIP"]) {
            NSString *secondExtension = [arrMutable lastObject];
            secondExtension = [secondExtension uppercaseString];
            if ([secondExtension isEqualToString:@"PAGES"] || [secondExtension isEqualToString:@"NUMBERS"] || [secondExtension isEqualToString:@"KEY"]) {
                [arrMutable removeLastObject];
            }
        }
    }
    
    NSMutableString *phrase = [[NSMutableString alloc]init];
    NSString *word;
    for (word in arrMutable) {
        [phrase appendString:word];
    }
    
    NSUInteger lenghtOfNAme = [phrase length];
    
    //+ points
    if (arrMutable.count >= 2) {
        NSInteger points=[arr count]-2;
        lenghtOfNAme=lenghtOfNAme+points;
    }
    
    //2. Calculate the range of positions
    UITextPosition* startPosition = [textFieldToMark positionFromPosition:textFieldToMark.beginningOfDocument offset:0];
    UITextPosition* endPosition = [textFieldToMark positionFromPosition:textFieldToMark.beginningOfDocument offset:lenghtOfNAme];
    UITextRange* selectionRange = [textFieldToMark textRangeFromPosition:startPosition toPosition:endPosition];
    
    // Set new range
    [textFieldToMark setSelectedTextRange:selectionRange];
}


@end
