//
//  AddFriendViewController.m
//  XMPPIOS
//
//  Created by wanglongyan on 15/6/3.
//  Copyright (c) 2015年 Dawn_wdf. All rights reserved.
//

#import "AddFriendViewController.h"
#import "FriendListCell.h"

@interface AddFriendViewController()
{
    UISearchBar * _searchBar;
}
@end
@implementation AddFriendViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Add Friend", nil);
    }
    return self;
}

-(void)initNotifications
{
    [self registerNotificationObserverWithName:G_NOTI_FRIEND_SEARCH_RESULT];
    [self registerNotificationObserverWithName:G_NOTI_FRIEND_ASK_SENT];
    [self registerNotificationObserverWithName:G_NOTI_FRIEND_ASK_SENT_FAIL];
}

-(void)notificationHandlerWithNotification:(NSNotification *)notification
{
    NSString * name = notification.name;
    if ([name isEqualToString:G_NOTI_FRIEND_SEARCH_RESULT]) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:notification.object];
        [_tableView reloadData];
    } else if ([name isEqualToString:G_NOTI_FRIEND_ASK_SENT]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tip", nil)
                                                         message:NSLocalizedString(@"Add Friend Succ", nil)
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                               otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else if ([name isEqualToString:G_NOTI_FRIEND_ASK_SENT_FAIL]) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tip", nil)
                                                         message:notification.object
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"ok", nil)
                                               otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect r = self.view.frame;

    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, r.size.width, 40)];
    [_searchBar setDelegate:self];
    [self.view addSubview:_searchBar];
    [_searchBar release];
    
    [_tableView setFrame:CGRectMake(0, 40, r.size.width, r.size.height - 40)];
}

-(void)onSearchResultReceived
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_sharedDataModel searchUserList:searchBar.text];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"normal"];
    if (cell == nil) {
        cell = [[FriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"normal"];
    }
    NSInteger index = indexPath.row;
    NSDictionary * dic = self.dataArray[index];
    [cell.textLabel setText:dic[@"name"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = self.dataArray[indexPath.row];
    if (dic) {
        [_sharedDataModel addFriend:dic[@"_id"]];
    }
}
@end
