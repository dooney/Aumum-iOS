//
//  CountryScene.m
//  iosapp
//
//  Created by Simpson Du on 22/07/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "CountryScene.h"
#import "CountryCell.h"
#import "UIView+FLKAutoLayout.h"

@interface CountryScene()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* dataSet;
@property (strong, nonatomic) SceneTableView* tableView;

@end

@implementation CountryScene

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self addControls];
    [self initSceneModel];
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addControls {
    self.tableView = [[SceneTableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView alignToView:self.view];
    [self.tableView registerClass:[CountryCell class] forCellReuseIdentifier:@"CountryCell"];
}

- (void)initSceneModel {
    Country* au = [[Country alloc] initWithName:@"Australia" code:@"+61"];
    Country* nz = [[Country alloc] initWithName:@"New Zealand" code:@"+64"];
    Country* us = [[Country alloc] initWithName:@"United States" code:@"+1"];
    Country* ca = [[Country alloc] initWithName:@"Canada" code:@"+1"];
    self.dataSet = @[ au, nz, us, ca ];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CountryCell" forIndexPath:indexPath];
    NSString* country = [self.dataSet objectAtIndex:indexPath.row];
    [cell reloadData:country];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Country* country = [self.dataSet objectAtIndex:indexPath.row];
    [self.delegate getCountry:country];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
