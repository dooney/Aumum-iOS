//
//  Profile.m
//  iosapp
//
//  Created by Simpson Du on 8/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "Profile.h"
#import "KeyChainUtil.h"

@implementation Profile

+ (id)get {
    NSString* currentUserId = [KeyChainUtil getCurrentUserId];
    Profile* profile = [[self findByColumn:@"objectId" value:currentUserId] firstObject];
    profile.contacts = [NSMutableArray arrayWithArray:[profile.contactList componentsSeparatedByString:@","]];
    return profile;
}

+ (User*)getUser {
    Profile* profile = [Profile get];
    User* user = [User new];
    user.avatarUrl = [profile.avatarUrl copy];
    user.screenName = [profile.screenName copy];
    user.objectId = [profile.objectId copy];
    return user;
}

- (void)updateContactList {
    self.contactList = [self.contacts firstObject];
    for(int i = 1; i < self.contacts.count; i++) {
        self.contactList = [self.contactList stringByAppendingFormat:@",%@", self.contacts[i]];
    }
}

@end
