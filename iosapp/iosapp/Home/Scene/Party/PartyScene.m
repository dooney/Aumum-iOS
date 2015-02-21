//
//  PartyScene.m
//  iosapp
//
//  Created by Simpson Du on 2/02/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "PartyScene.h"
#import "PartySceneModel.h"
#import "Party.h"

@interface PartyScene ()

@property(nonatomic, retain)PartySceneModel* sceneModel;

- (BaseSceneModel*)getSceneModel;

@end

@implementation PartyScene

- (BaseSceneModel*)getSceneModel {
    _sceneModel = [PartySceneModel sharedInstance];
    return _sceneModel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneModel.itemList.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SettingTableIdentifier = @"PostCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SettingTableIdentifier];
    Party* party = [self.sceneModel.itemList.results objectAtIndex:indexPath.row];
    cell.textLabel.text = party.title;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    cell.backgroundColor = [UIColor colorWithString:@"#F9F9F9"];
    return cell;
}

@end
