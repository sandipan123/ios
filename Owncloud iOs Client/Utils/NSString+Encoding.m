//
//  NSString+Encoding.m
//  Owncloud iOs Client
//
//  Created by Gonzalo Gonzalez on 11/12/13.
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

#import "NSString+Encoding.h"

@implementation NSString (encode)
- (NSString *)encodeString:(NSStringEncoding)encoding
{
    
    /*NSString *output = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self,
     NULL, (CFStringRef)@";/?:@&=$+{}<>,",
     CFStringConvertNSStringEncodingToEncoding(encoding));*/
    
    CFStringRef stringRef = CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self,
                                                                    NULL, (CFStringRef)@";?@&=$+{}<>,",
                                                                    CFStringConvertNSStringEncodingToEncoding(encoding));
    
    NSString *output = (NSString *)CFBridgingRelease(stringRef);
    
    
    
    
    int countCharactersAfterPercent = -1;
    
    for(int i = 0 ; i < [output length] ; i++) {
        NSString * newString = [output substringWithRange:NSMakeRange(i, 1)];
        //NSLog(@"newString: %@", newString);
        
        if(countCharactersAfterPercent>=0) {
            
            //NSLog(@"newString lowercaseString: %@", [newString lowercaseString]);
            output = [output stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:[newString lowercaseString]];
            countCharactersAfterPercent++;
        }
        
        if([newString isEqualToString:@"%"]) {
            countCharactersAfterPercent = 0;
        }
        
        if(countCharactersAfterPercent==2) {
            countCharactersAfterPercent = -1;
        }
    }
    
    NSLog(@"output: %@", output);
    
    return output;
}

@end

