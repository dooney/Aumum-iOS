//
//  KeyChainUtil.m
//  iosapp
//
//  Created by Simpson Du on 8/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "KeyChainUtil.h"
#import "UICKeyChainStore.h"

@implementation KeyChainUtil

+ (UICKeyChainStore *)getKeyChainStore {
    return [UICKeyChainStore keyChainStoreWithService:@"com.aumum.iosapp-keychain"];
}

+ (NSString*) getToken {
    UICKeyChainStore *keychain = [KeyChainUtil getKeyChainStore];
    return keychain[@"token"];
}

+ (void)setToken:(NSString*)token {
    UICKeyChainStore *keychain = [KeyChainUtil getKeyChainStore];
    keychain[@"token"] = token;
}

+ (NSString*)getCurrentUserId {
    UICKeyChainStore *keychain = [KeyChainUtil getKeyChainStore];
    return keychain[@"currentUserId"];
}

+ (void)setCurrentUserId:(NSString*)userId {
    UICKeyChainStore *keychain = [KeyChainUtil getKeyChainStore];
    keychain[@"currentUserId"] = userId;
}

@end
