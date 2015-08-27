//
//  FriendsViewController.m
//  XMPPIOS
//
//  Created by wanglongyan on 15/6/1.
//  Copyright (c) 2015年 Dawn_wdf. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendListCell.h"
#import "ChattingViewController.h"
#import "AddFriendViewController.h"


@implementation FriendsViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Friends", nil);
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(onAddFriendClicked:)];
    [menuButton setTintColor:[UIColor blackColor]];
    [self.navigationItem setRightBarButtonItems:@[menuButton] animated:NO];
    [menuButton release];
}

-(void)initNotifications
{
    [self registerNotificationObserverWithName:G_NOTI_LOGIN_SUC];
    [self registerNotificationObserverWithName:G_NOTI_FRIEND_LIST_RECEIVED];
    [self registerNotificationObserverWithName:G_NOTI_FRIEND_ASK_SENT];

}

-(void)notificationHandlerWithNotification:(NSNotification *)notification
{
    NSString * name = notification.name;
    if ([name isEqualToString:G_NOTI_LOGIN_SUC]) {
        
        //login suc... Get the friend list
        [self performSelector:@selector(getAllNewData) withObject:nil afterDelay:0.1];
    } else if ([name isEqualToString:G_NOTI_FRIEND_LIST_RECEIVED]){
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:notification.object];
        [_tableView reloadData];
    } else if ([name isEqualToString:G_NOTI_FRIEND_ASK_SENT]) {
        [self getAllNewData];
    }
}

-(void)getAllNewData
{
    [_sharedDataModel getFriendList];
}

-(void)onAddFriendClicked:(id)sender
{
    AddFriendViewController * add = [[AddFriendViewController alloc] init];
    [add setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:add animated:YES];
    [add release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArray[indexPath.row];
    FriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:FriendListCellIdentifier];
    if (cell == nil) {
        cell = [[FriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FriendListCellIdentifier];
    }
    
    if (dic[@"name"]) {
        [cell.textLabel setText:dic[@"name"]];
    } else {
        [cell.textLabel setText:dic[@"_id"]];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArray[indexPath.row];
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
    info[USERDEFAULT_DETAIL_NAME] = dic[@"name"];
    info[USERDEFAULT_DETAIL_ID] = dic[@"toID"];
    ChattingViewController * vc = [[ChattingViewController alloc] initWithUserInfo:dic];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}
@end
