//
//  CustomDatabase.m
//  iosapp
//
//  Created by Simpson Du on 5/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "CustomDatabase.h"

#define DB_VER 5

@implementation CustomDatabase

- (void)runMigrations {
    if ([self databaseVersion] < DB_VER) {
        NSArray* tableNames = [self tableNames];
        NSArray* excludes = @[ @"ApplicationProperties", @"sqlite_sequence" ];
        for (NSString* table in tableNames) {
            if (![excludes containsObject:table]) {
                [self executeSql:[NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", table]];
            }
        }
    }
    [super runMigrations];
    [self setDatabaseVersion:DB_VER];
}

@end
