//
//  MomentDetailsScene.m
//  iosapp
//
//  Created by Simpson Du on 2/08/2015.
//  Copyright (c) 2015 YU XING TECHNOLOGY PTY. LTD. All rights reserved.
//

#import "MomentDetailsScene.h"
#import "AvatarImageView.h"
#import "CommentCell.h"
#import "UIView+FLKAutoLayout.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MomentDetailsSceneModel.h"
#import "NSDate+Category.h"
#import "URLManager.h"
#import "NSArray+EasyExtend.h"
#import "KeyChainUtil.h"
#import "Profile.h"
#import "URLManager.h"

@interface MomentDetailsScene()
{
    NSString* _momentId;
}

@property (nonatomic, strong)MomentDetailsSceneModel* sceneModel;
@property (nonatomic, strong)AvatarImageView* avatarImage;
@property (nonatomic, strong)UILabel* screenName;
@property (nonatomic, strong)UILabel* createdAt;
@property (nonatomic, strong)UIImageView* momentImage;

@end

@implementation MomentDetailsScene

- (id)init {
    return [super initWithTableViewStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _momentId = self.params[@"momentId"];
    [self initView];
    [self initSceneModel];
}

- (void)initView {
    self.inverted = NO;
    [self.rightButton setTitle:NSLocalizedString(@"label.send", nil) forState:UIControlStateNormal];
    [self.rightButton setTitleColor:HEX_RGB(0xff6060) forState:UIControlStateNormal];
    
    self.tableView.fd_debugLogEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[CommentCell class] forCellReuseIdentifier:@"CommentCell"];
    
    if (self.params[@"promptInput"]) {
        [self.textView becomeFirstResponder];
    }
    self.textView.placeholder = NSLocalizedString(@"label.writeAComment", nil);
}

- (void)initSceneModel {
    self.sceneModel = [MomentDetailsSceneModel SceneModel];
    self.sceneModel.userId = [KeyChainUtil getCurrentUserId];
    self.sceneModel.moment = [Moment getById:_momentId];
    self.sceneModel.moment.user = [User getById:self.sceneModel.moment.userId];
    
    [self.sceneModel.request send:self.sceneModel.moment.objectId];
    [self.sceneModel.request onRequest:^{
        if (self.sceneModel.request.list &&
            self.sceneModel.request.list.results.count > 0) {
            if (!self.sceneModel.comments) {
                self.sceneModel.comments = [NSMutableArray array];
            }
            [self.sceneModel.comments pushTailN:self.sceneModel.request.list.results];
            NSMutableArray* userIdList = [NSMutableArray array];
            for (Moment* moment in self.sceneModel.request.list.results) {
                if (![userIdList containsObject:moment.userId]) {
                    [userIdList addObject:moment.userId];
                }
            }
            [self.sceneModel.userListRequest send:userIdList];
        }
    } error:^(NSError *error) {
    }];
    [self.sceneModel.userListRequest onRequest:^() {
        for (Comment* comment in self.sceneModel.comments) {
            for (User* user in self.sceneModel.userListRequest.list.results) {
                if ([comment.userId isEqualToString:user.objectId]) {
                    comment.user = user;
                }
            }
        }
        [self.tableView reloadData];
    } error:^(NSError* error) {
    }];
}

- (void)backButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addControls:(UIView*)view {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImagePressed)];
    self.avatarImage = [[AvatarImageView alloc] init];
    [self.avatarImage addGestureRecognizer:tap];
    self.avatarImage.userInteractionEnabled = YES;
    self.avatarImage.multipleTouchEnabled = YES;
    [view addSubview:self.avatarImage];
    
    self.screenName = [[UILabel alloc] init];
    self.screenName.textColor = HEX_RGB(0xff6060);
    [view addSubview:self.screenName];
    
    self.createdAt = [[UILabel alloc] init];
    self.createdAt.font = [UIFont systemFontOfSize:14];
    self.createdAt.textColor = [UIColor lightGrayColor];
    [view addSubview:self.createdAt];
    
    self.momentImage = [[UIImageView alloc] init];
    self.momentImage.contentMode = UIViewContentModeScaleAspectFit;
    self.momentImage.layer.shadowColor = [UIColor blackColor].CGColor;
    self.momentImage.layer.shadowOffset = CGSizeZero;
    self.momentImage.layer.shadowRadius = 3;
    self.momentImage.layer.shadowOpacity = 0.3;
    [view addSubview:self.momentImage];
}

- (void)loadAutoLayout {
    [self.avatarImage alignTop:@"10" leading:@"10" toView:self.avatarImage.superview];
    [self.avatarImage constrainWidth:@"40" height:@"40"];
    
    [self.screenName constrainLeadingSpaceToView:self.avatarImage predicate:@"10"];
    [self.screenName alignTopEdgeWithView:self.avatarImage predicate:nil];
    
    [self.createdAt alignLeadingEdgeWithView:self.screenName predicate:nil];
    [self.createdAt alignBottomEdgeWithView:self.avatarImage predicate:nil];
    
    [self.momentImage constrainTopSpaceToView:self.avatarImage predicate:@"10"];
    [self.momentImage alignCenterXWithView:self.momentImage.superview predicate:@"0"];
}

- (void)loadData:(Moment*)moment {
    self.screenName.text = moment.user.screenName;
    NSDate* createdAt = [NSDate dateWithString:self.sceneModel.moment.createdAt format:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" zone:@"UTC"];
    self.createdAt.text = [createdAt timeIntervalDescription];
    [self.avatarImage fromUrl:self.sceneModel.moment.user.avatarUrl diameter:40];
    CGFloat imageWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat imageHeight = imageWidth * self.sceneModel.moment.ratio;
    [self.momentImage constrainWidth:[NSString stringWithFormat:@"%.0f", imageWidth]
                              height:[NSString stringWithFormat:@"%.0f", imageHeight]];
    [self.momentImage sd_setImageWithURL:[NSURL URLWithString:self.sceneModel.moment.imageUrl]];
}

- (void)avatarImagePressed {
    NSString* url = [NSString stringWithFormat:@"iosapp://user?userId=%@", self.sceneModel.moment.userId];
    [URLManager pushURLString:url animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneModel.comments.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    Comment* comment = [self.sceneModel.comments objectAtIndex:indexPath.row];
    [cell reloadData:comment];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"CommentCell" cacheByIndexPath:indexPath configuration:^(CommentCell *cell) {
        Comment* comment = [self.sceneModel.comments objectAtIndex:indexPath.row];
        [cell reloadData:comment];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* view = [[UIView alloc] init];
    [self addControls:view];
    [self loadAutoLayout];
    [self loadData:self.sceneModel.moment];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat imageWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat imageHeight = imageWidth * self.sceneModel.moment.ratio;
    return 10 + 40 + 10 + imageHeight;
}

- (void)didPressRightButton:(id)sender {
    Comment* comment = [self sendComment];
    
    [self.textView refreshFirstResponder];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewRowAnimation rowAnimation = UITableViewRowAnimationTop;
    UITableViewScrollPosition scrollPosition = UITableViewScrollPositionTop;
    [self.tableView beginUpdates];
    [self.sceneModel.comments insertObject:comment atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:YES];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [super didPressRightButton:sender];
}

- (Comment*)sendComment {
    Comment* comment = [Comment new];
    comment.createdAt = [NSDate utcNow];
    comment.userId = self.sceneModel.userId;
    comment.user = [Profile getUser];
    comment.parentId = self.sceneModel.moment.objectId;
    comment.content = [self.textView.text copy];
    [self.sceneModel.commentRequest send:comment];
    return comment;
}

@end
