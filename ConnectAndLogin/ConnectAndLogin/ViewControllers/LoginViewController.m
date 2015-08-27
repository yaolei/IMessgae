//
//  LoginViewController.m
//  XMPPIOS
//
//  Created by wanglongyan on 15/6/1.
//  Copyright (c) 2015年 Dawn_wdf. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //test
    _nameField.text = @"user110";
    _pwdField.text = @"1111";
        
    [_pwdConfirmField setHidden:YES];
    [_logButton setTitle:NSLocalizedString(@"Log in", nil) forState:UIControlStateNormal];
    [_backButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    
    [_backButton setHidden:YES];
}

-(void)onLogButtonClicked:(id)sender
{
    [_sharedDataModel loginWithUsername:_nameField.text AndPassword:_pwdField.text];
}

//over ride... here should go to register view.
-(void)onBackButtonClicked:(id)sender
{
    [self goRegisterVC];
}

-(void)goRegisterVC
{
    RegisterViewController * reg = [[RegisterViewController alloc] init];
    [reg showWithParentView:self.view];
}

#pragma mark - notificaitons
-(void)initNotifications
{
    [self registerNotificationObserverWithName:G_NOTI_LOGIN_SUC];
    [self registerNotificationObserverWithName:G_NOTI_LOGIN_FAIL];
}

-(void)notificationHandlerWithNotification:(NSNotification *)notification
{
    NSString * name = notification.name;
    
    if ([name isEqualToString:G_NOTI_LOGIN_SUC]) {
        [self dismiss];
    } else if ([name isEqualToString:G_NOTI_LOGIN_FAIL]) {

    }
}
@end
