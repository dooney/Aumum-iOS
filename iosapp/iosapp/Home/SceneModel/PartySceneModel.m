//
//  PartySceneModel.m
//  iosapp
//
//  Created by Simpson Du on 2/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "PartySceneModel.h"
#import "RestApi.h"

@interface PartySceneModel ()

- (void)loadData;

@end

@implementation PartySceneModel

- (void)loadData {
    [RestApi getPartyList:^(NSDictionary* data) {
        self.data = data;
    }
                    error:^(NSString* error) {
                        self.error = error;
                    }];
}

@end
