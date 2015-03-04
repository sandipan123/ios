//
//  OCKeychain.m
//  Owncloud iOs Client
//
//  Created by Noelia Alvarez on 22/10/14.
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

#import "OCKeychain.h"
#import <Security/Security.h>
#import "CredentialsDto.h"
#import "UtilsUrls.h"


@implementation OCKeychain


+(BOOL)setCredentialsById:(NSString *)idUser withUsername:(NSString *)userName andPassword:(NSString *)password{
    
    BOOL output = NO;
    
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    [keychainItem setObject:(__bridge id)(kSecClassGenericPassword) forKey:(__bridge id)kSecClass];
    [keychainItem setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)kSecAttrAccessible];
    [keychainItem setObject:idUser forKey:(__bridge id)kSecAttrAccount];
    [keychainItem setObject:userName forKey:(__bridge id)kSecAttrDescription];
    [keychainItem setObject:[UtilsUrls getFullBundleSecurityGroup] forKey:(__bridge id)kSecAttrAccessGroup];

    
    OSStatus stsExist = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL);
    
    if(stsExist == errSecSuccess) {
        DLog(@"Unable add item with id =%@ error",idUser);
    }else {
        [keychainItem setObject:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
        OSStatus stsAdd = SecItemAdd((__bridge CFDictionaryRef)keychainItem, NULL);
        
        DLog(@"(setCredentials)Error Code: %d", (int)stsAdd);
        if (stsAdd == errSecSuccess) {
            output = YES;
        }
        
    }
    
    return output;
}



+(CredentialsDto *)getCredentialsById:(NSString *)idUser{
    
    CredentialsDto *output = nil;
    
    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    [keychainItem setObject:(__bridge id)(kSecClassGenericPassword) forKey:(__bridge id)kSecClass];
    [keychainItem setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)kSecAttrAccessible];
    [keychainItem setObject:idUser forKey:(__bridge id)kSecAttrAccount];
    [keychainItem setObject:[UtilsUrls getFullBundleSecurityGroup] forKey:(__bridge id)kSecAttrAccessGroup];
    
    [keychainItem setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainItem setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    
    CFDictionaryRef result = nil;
    
    OSStatus stsExist = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, (CFTypeRef *)&result);
    
    DLog(@"(getCredentials)Error Code %d", (int)stsExist);

    if(stsExist != errSecSuccess) {
        DLog(@"Unable to get the item with id =%@ ",idUser);
        
    }else {
        
        NSDictionary *resultDict = (__bridge_transfer NSDictionary *)result;
       
        NSData *pswd = resultDict[(__bridge id)kSecValueData];
        NSString *password = [[NSString alloc] initWithData:pswd encoding:NSUTF8StringEncoding];
        output = [CredentialsDto new];
        
        output.password = password;
        output.userName = resultDict[(__bridge id)kSecAttrDescription];
    }
    
    return output;

}

+(BOOL)removeCredentialsById:(NSString *)idUser{
    
    BOOL output = NO;

    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    [keychainItem setObject:(__bridge id)(kSecClassGenericPassword) forKey:(__bridge id)kSecClass];
    [keychainItem setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)kSecAttrAccessible];
    [keychainItem setObject:idUser forKey:(__bridge id)kSecAttrAccount];
    [keychainItem setObject:[UtilsUrls getFullBundleSecurityGroup] forKey:(__bridge id)kSecAttrAccessGroup];
    

    OSStatus stsExist = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL);
    
    DLog(@"(removeCredentials)Error Code: %d", (int)stsExist);
    
    if(stsExist != errSecSuccess) {
        DLog(@"Unable to delete the item with id =%@ ",idUser);
    } else {
        OSStatus sts = SecItemDelete((__bridge CFDictionaryRef)keychainItem);
        DLog(@"Error Code: %d", (int)sts);
        if (sts == errSecSuccess) {
            output = YES;
        }
    }
   
    return output;

}

+(BOOL)updatePasswordById:(NSString *)idUser withNewPassword:(NSString *)password{
    
    BOOL output = NO;

    NSMutableDictionary *keychainItem = [NSMutableDictionary dictionary];
    
    [keychainItem setObject:(__bridge id)(kSecClassGenericPassword) forKey:(__bridge id)kSecClass];
    [keychainItem setObject:(__bridge id)(kSecAttrAccessibleWhenUnlocked) forKey:(__bridge id)kSecAttrAccessible];
    [keychainItem setObject:idUser forKey:(__bridge id)kSecAttrAccount];
    [keychainItem setObject:[UtilsUrls getFullBundleSecurityGroup] forKey:(__bridge id)kSecAttrAccessGroup];
    
    OSStatus stsExist = SecItemCopyMatching((__bridge CFDictionaryRef)keychainItem, NULL);
    
    if(stsExist != errSecSuccess) {
        DLog(@"Unable to update item with id =%@ ",idUser);
        
    }else {
        
        NSMutableDictionary *attrToUpdate = [NSMutableDictionary dictionary];

        [attrToUpdate setObject:[password dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
        
        OSStatus stsUpd = SecItemUpdate((__bridge CFDictionaryRef)(keychainItem), (__bridge CFDictionaryRef)(attrToUpdate));
        
        DLog(@"(updateCredentials)Error Code: %d", (int)stsUpd);
        
        if (stsUpd == errSecSuccess) {
            output = YES;
        }
        
    }
    
    return output;

}

+(BOOL)resetKeychain{
    
    BOOL output = NO;

    NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionary];
    
    [keychainQuery setObject:(__bridge id)(kSecClassGenericPassword) forKey:(__bridge id)kSecClass];
    [keychainQuery setObject:[UtilsUrls getFullBundleSecurityGroup] forKey:(__bridge id)kSecAttrAccessGroup];
    
    OSStatus sts = SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    DLog(@"Reset keychain Error Code: %d", (int)sts);
    if (sts == errSecSuccess) {
        output = YES;
    }

    
    return output;
    
}


@end
