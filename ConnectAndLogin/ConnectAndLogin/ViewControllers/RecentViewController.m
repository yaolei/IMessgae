//
//  RecentViewController.m
//  XMPPIOS
//
//  Created by wanglongyan on 15/6/3.
//  Copyright (c) 2015年 Dawn_wdf. All rights reserved.
//

#import "RecentViewController.h"
#import "RecentCell.h"
#import "ChattingViewController.h"

@implementation RecentViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Recent", nil);
    }
    return self;
}

-(void)getAllNewData
{
    self.dataArray = [[_sharedDataModel getRecentChatListData] mutableCopy];
    
    [_tableView reloadData];
}

#pragma mark - notificaitons
-(void)initNotifications
{
    [self registerNotificationObserverWithName:G_NOTI_LOGIN_SUC];
    [self registerNotificationObserverWithName:G_NOTI_RECENT_UPDATED];
    [self registerNotificationObserverWithName:G_NOTI_USER_BRIEF_INFO];
}

-(void)notificationHandlerWithNotification:(NSNotification *)notification
{
    NSString * name = notification.name;
    
    if ([name isEqualToString:G_NOTI_LOGIN_SUC] ||
        [name isEqualToString:G_NOTI_RECENT_UPDATED] ||
        [name isEqualToString:G_NOTI_USER_BRIEF_INFO]) {
        [self getAllNewData];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
    
    RecentCell * cell = [tableView dequeueReusableCellWithIdentifier:RecentCellIdentifier];
    if (cell == nil) {
        cell = [[RecentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecentCellIdentifier];
    }
    [cell updateUIWithData:dic];
    
    if ([dic[USERDEFAULT_DETAIL_NAME] isEqualToString:@""]) {
        [_sharedDataModel getUserBriefInfo:dic[USERDEFAULT_DETAIL_ID]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = [self.dataArray objectAtIndex:indexPath.row];
    NSDictionary * info = @{
                          @"name" : dic[USERDEFAULT_DETAIL_NAME],
                          @"toID" : dic[USERDEFAULT_DETAIL_ID]};
    ChattingViewController * chat = [[ChattingViewController alloc] initWithUserInfo:info];
    [chat setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:chat animated:YES];
    [chat release];
}

@end
