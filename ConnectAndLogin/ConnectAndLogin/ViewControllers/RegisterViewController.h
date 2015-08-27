//
//  RegisterViewController.h
//  XMPPIOS
//
//  Created by wanglongyan on 15/6/2.
//  Copyright (c) 2015年 Dawn_wdf. All rights reserved.
//

#import "BasicViewController.h"
#import "DataModel.h"

@interface RegisterViewController : BasicViewController
{
    @public
    UITextField * _nameField;
    UITextField * _pwdField;
    UITextField * _pwdConfirmField;
    UIButton * _logButton;
    UIButton * _backButton;
}

-(void)showWithParentView:(UIView *)parentView;
-(void)dismiss;

-(void)onLogButtonClicked:(id)sender;
-(void)onBackButtonClicked:(id)sender;

@end
