//
//  ChattingViewController.m
//  XMPPIOS
//
//  Created by wanglongyan on 15/6/1.
//  Copyright (c) 2015年 Dawn_wdf. All rights reserved.
//

#import "ChattingViewController.h"
#import "SendMsgCell.h"
#import "RecvMsgCell.h"


@interface ChattingViewController ()
{
    id _userInfo;
    
    UITextView * _textInputView;
    
    UIAlertView * alert;

}

@end

@implementation ChattingViewController

- (instancetype)initWithUserInfo:(id)userInfo
{
    self = [super init];
    if (self) {
        _userInfo = [userInfo retain];
        
        NSString * titleString = _userInfo[@"name"];
        self.title = titleString;
        
        [_sharedDataModel setRecentHaveRead:_userInfo[@"toID"]];
        
        [self setHidesBottomBarWhenPushed:YES];
    }
    return self;
}

-(void)initNotifications
{
    [self registerNotificationObserverWithName:UIKeyboardWillChangeFrameNotification];
    [self registerNotificationObserverWithName:UIKeyboardWillHideNotification];
    [self registerNotificationObserverWithName:G_NOTI_MESSAGE_RECEIVE];
    [self registerNotificationObserverWithName:G_NOTI_MESSAGE_SENT_FAIL];
    [self registerNotificationObserverWithName:G_NOTI_MESSAGE_SENT_SUC];
    [self registerNotificationObserverWithName:G_NOTI_MESSAGE_SENDING];
    [self registerNotificationObserverWithName:G_NOTI_MESSAGE_LIST_ALL];
    [self registerNotificationObserverWithName:G_NOTI_MESSAGE_LIST_NEW];
    [self registerNotificationObserverWithName:G_NOTI_MESSAGE_LIST_OLD];
    [self registerNotificationObserverWithName:G_NOTI_MESSAGE_HAVE_NEW];
}

-(void)notificationHandlerWithNotification:(NSNotification *)notification
{
    NSString * name = notification.name;
    
    if ([name isEqualToString:UIKeyboardWillChangeFrameNotification]) {
        NSDictionary *info = [notification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        [self updateLayoutPostion:kbSize.height];
    } else if ([name isEqualToString:UIKeyboardWillHideNotification]) {
        [self updateLayoutPostion:0];
    } else if ([name isEqualToString:G_NOTI_MESSAGE_RECEIVE]) {
        [self performSelector:@selector(receiveMsg) withObject:nil afterDelay:0.1];
    } else if ([name isEqualToString:G_NOTI_MESSAGE_SENT_SUC]) {
        [self performSelector:@selector(sendSuc:) withObject:notification.object afterDelay:0.1];
    } else if ([name isEqualToString:G_NOTI_MESSAGE_SENT_FAIL]) {
        [self performSelector:@selector(sendFail:) withObject:notification.object afterDelay:0.1];
    } else if ([name isEqualToString:G_NOTI_MESSAGE_SENDING]) {
        [self performSelector:@selector(sendingMsg:) withObject:notification.object afterDelay:0.1];
    } else if ([name isEqualToString:G_NOTI_MESSAGE_LIST_ALL]
               || [name isEqualToString:G_NOTI_MESSAGE_LIST_NEW]) {
        [self reloadMessagesFromModel:notification.object scrollToBottom:YES animated:NO];
    } else if ([name isEqualToString:G_NOTI_MESSAGE_LIST_OLD]) {
        [self reloadMessagesFromModel:notification.object scrollToBottom:NO animated:NO];
    } else if ([name isEqualToString:G_NOTI_MESSAGE_HAVE_NEW]) {
        [self performSelector:@selector(getMoreDownData) withObject:nil afterDelay:0.1];
    }
}

-(void)getAllNewData
{
    [_sharedDataModel getAllMessages:_userInfo[@"toID"]];
}

-(void)getMoreUpData
{
    [_sharedDataModel getOldMessages:_userInfo[@"toID"]];
}

-(void)getMoreDownData
{
    [_sharedDataModel getNewMessages:_userInfo[@"toID"]];
}

-(void)updateLayoutPostion:(float)keyboardHeight
{
    CGRect r = self.view.frame;
    
    [_textInputView setFrame:CGRectMake(0, r.size.height - keyboardHeight - 30, r.size.width, 30)];
    [_tableView setFrame:CGRectMake(0, 0, r.size.width, r.size.height - keyboardHeight - 30)];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect r = self.view.frame;
    
    _textInputView = [[UITextView alloc] initWithFrame:CGRectMake(0, r.size.height - 30, r.size.width, 30)];
    [_textInputView setBackgroundColor:[UIColor redColor]];
    [_textInputView setDelegate:self];
    [_textInputView setReturnKeyType:UIReturnKeySend];
    [self.view addSubview:_textInputView];
    [_textInputView release];
    
    [_tableView setIsHeader:YES andIsFooter:NO];
    
    [self updateLayoutPostion:0];
    
    [self getAllNewData];
}

-(void)dealloc
{
    [_userInfo release];
    
    [super dealloc];
}

-(void)reloadMessagesFromModel:(NSArray*)modelArray scrollToBottom:(BOOL)bottom animated:(BOOL)animated
{
    [_tableView RTPullTableViewDidFinishLoad];
    
    NSInteger oldcount = [self.dataArray count];
    NSInteger newcount = [modelArray count];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:modelArray];
    [_tableView reloadData];
    
    if (!self.dataArray || [self.dataArray count] <= 0) {
        return;
    }
    
    if (bottom) {
        NSIndexPath * i = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
        [_tableView scrollToRowAtIndexPath:i atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    } else if ([modelArray count] > 0) {
        NSIndexPath * i = [NSIndexPath indexPathForRow:newcount - oldcount inSection:0];
        [_tableView scrollToRowAtIndexPath:i atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

-(void)sendMsg
{
    NSString * msg = _textInputView.text;
    if (msg == nil || [msg length] == 0) {
        return;
    }
    [_sharedDataModel sendTextMessage:msg toUser:_userInfo[@"toID"]];
    _textInputView.text = @"";
}

-(void)receiveMsg
{
    [self getMoreDownData];
}

-(void)sendingMsg:(NSArray*)msgs
{
    [self reloadMessagesFromModel:msgs scrollToBottom:YES animated:YES];
}

-(void)sendSuc:(Message *)msg
{
    [self getMoreDownData];
}

-(void)sendFail:(Message *)msg
{
    
}

#pragma mark - text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (textView == _textInputView) {
        return YES;
    }
    return  NO;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView == _textInputView) {
        return YES;
    }
    return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if (textView == _textInputView) {
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            [self sendMsg];
            return NO;
        }
    }
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Message * msg = self.dataArray[indexPath.row];
    
    BOOL isSent = [_sharedDataModel isCurrentUser:msg.fromID];
    
    SendMsgCell * cell = nil;
    if (isSent) {
        cell = [_tableView dequeueReusableCellWithIdentifier:SendMsgCellIdentifier];
        if (cell == nil) {
            cell = [[SendMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SendMsgCellIdentifier];
        }
    } else {
        cell = [_tableView dequeueReusableCellWithIdentifier:RecvMsgCellIdentifier];
        if (cell == nil) {
            cell = [[RecvMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RecvMsgCellIdentifier];
        }
    }
    
    [cell setMessage:msg];
    [cell updateUI];

    return cell;
}

@end
