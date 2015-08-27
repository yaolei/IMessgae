//
//  RegisterViewController.m
//  XMPPIOS
//
//  Created by wanglongyan on 15/6/2.
//  Copyright (c) 2015年 Dawn_wdf. All rights reserved.
//

#import "RegisterViewController.h"

@implementation RegisterViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [_tableView setHidden:YES];
    
    CGRect r = self.view.frame;
    
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(40, 60, r.size.width - 80, 30)];
    [self.view addSubview:_nameField];
    [_nameField setPlaceholder:NSLocalizedString(@"input user name", nil)];
    [_nameField setTextAlignment:NSTextAlignmentLeft];
    [_nameField release];
    
    _pwdField = [[UITextField alloc] initWithFrame:CGRectMake(40, 100, r.size.width - 80, 30)];
    [self.view addSubview:_pwdField];
    [_pwdField setPlaceholder:NSLocalizedString(@"input password", nil)];
    [_pwdField setSecureTextEntry:YES];
    [_pwdField setTextAlignment:NSTextAlignmentLeft];
    [_pwdField release];
    
    _pwdConfirmField = [[UITextField alloc] initWithFrame:CGRectMake(40, 140, r.size.width - 80, 30)];
    [self.view addSubview:_pwdConfirmField];
    [_pwdConfirmField setPlaceholder:NSLocalizedString(@"input password again", nil)];
    [_pwdConfirmField setSecureTextEntry:YES];
    [_pwdConfirmField setTextAlignment:NSTextAlignmentLeft];
    [_pwdConfirmField release];
    
    _logButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 200, r.size.width - 80, 40)];
    [self.view addSubview:_logButton];
    [_logButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [_logButton addTarget:self action:@selector(onLogButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_logButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_logButton release];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 250, r.size.width - 80, 40)];
    [self.view addSubview:_backButton];
    [_backButton setTitle:NSLocalizedString(@"Log in", nil) forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(onBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_backButton release];
}

-(void)showWithParentView:(UIView *)parentView
{
    [parentView addSubview:self.view];
}

-(void)onLogButtonClicked:(id)sender
{
    if ([_pwdField.text isEqualToString:_pwdConfirmField.text]) {
//        [_sharedDataModel registerWithUsername:_nameField.text andPassword:_pwdField.text];
    }
}
-(void)onBackButtonClicked:(id)sender
{
    [self dismiss];
}

-(void)dismiss
{
    [self.view removeFromSuperview];
    [self release];
}

#pragma mark - notificaitons
-(void)initNotifications
{
    [self registerNotificationObserverWithName:G_NOTI_REGISTER_SUC];
    [self registerNotificationObserverWithName:G_NOTI_REGISTER_FAIL];
}

-(void)notificationHandlerWithNotification:(NSNotification *)notification
{
    NSString * name = notification.name;
    
    if ([name isEqualToString:G_NOTI_REGISTER_SUC]) {
        [self dismiss];
    } else if ([name isEqualToString:G_NOTI_REGISTER_FAIL]) {
        
    }
}
@end
