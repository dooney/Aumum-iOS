//
//  ContactListScene.m
//  iosapp
//
//  Created by Simpson Du on 19/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "ContactListScene.h"
#import "UIView+FLKAutoLayout.h"
#import "ContactListSceneModel.h"
#import "ContactCell.h"
#import "Profile.h"
#import "pinyin.h"
#import "URLManager.h"

@interface ContactListScene()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ContactListSceneModel* sceneModel;
@property (strong, nonatomic) SceneTableView* tableView;

@end

@implementation ContactListScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addControls];
    [self initSceneModel];
}

- (void)addControls {
    self.tableView = [[SceneTableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView alignToView:self.view];
    [self.tableView registerClass:[ContactCell class] forCellReuseIdentifier:@"ContactCell"];
}

- (void)initSceneModel {
    self.sceneModel = [ContactListSceneModel SceneModel];
    
    Profile* profile = [Profile get];
    [self.sceneModel.userListRequest send:profile.contacts];
    [self.sceneModel.userListRequest onRequest:^{
        [self.sceneModel.contactList addObjectsFromArray:[self sortDataArray:self.sceneModel.userListRequest.list.results]];
        [_tableView reloadData];
    } error:^(NSError *error) {
        [self showError:error];
    }];
}

- (NSMutableArray *)sortDataArray:(NSArray *)dataArray {
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    [self.sceneModel.sectionTitles addObjectsFromArray:[indexCollation sectionTitles]];
    NSInteger highSection = [self.sceneModel.sectionTitles count];
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i < highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    for (User *user in dataArray) {
        NSString *firstLetter = [HTFirstLetter firstLetter:user.screenName];
        NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
        NSMutableArray *array = [sortedArray objectAtIndex:section];
        [array addObject:user];
    }
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(User *user1, User *user2) {
            NSString *firstLetter1 = [HTFirstLetter firstLetter:user1.screenName];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            NSString *firstLetter2 = [HTFirstLetter firstLetter:user2.screenName];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    return sortedArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sceneModel.contactList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sceneModel.contactList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ContactCell" forIndexPath:indexPath];
    User* user = [[self.sceneModel.contactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell reloadData:user];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User* user = [[self.sceneModel.contactList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString* url = [NSString stringWithFormat:@"iosapp://user?userId=%@", user.objectId];
    [URLManager pushURLString:url animated:YES];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([[self.sceneModel.contactList objectAtIndex:section] count] == 0) {
        return 0;
    }
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([[self.sceneModel.contactList objectAtIndex:section] count] == 0) {
        return nil;
    }
    UIView* view = [[UIView alloc] init];
    view.backgroundColor = HEX_RGB(0xf4f4f4);
    UILabel *label = [[UILabel alloc] init];
    [label setText:[self.sceneModel.sectionTitles objectAtIndex:section]];
    [view addSubview:label];
    [label alignCenterYWithView:label.superview predicate:@"0"];
    [label alignLeadingEdgeWithView:label.superview predicate:@"10"];
    return view;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray * existTitles = [NSMutableArray array];
    for (int i = 0; i < [self.sceneModel.sectionTitles count]; i++) {
        if ([[self.sceneModel.contactList objectAtIndex:i] count] > 0) {
            [existTitles addObject:[self.sceneModel.sectionTitles objectAtIndex:i]];
        }
    }
    return existTitles;
}

@end
