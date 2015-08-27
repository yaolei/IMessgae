//
//  ViewController.m
//  ConnectAndLogin
//
//  Created by SVS_Mini on 13-12-19.
//  Copyright (c) 2013年 svs. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import "RecentViewController.h"
#import "FriendsViewController.h"
#import "MineViewController.h"
#import "DataModel.h"

@interface ViewController ()

@end

@implementation ViewController

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
    
    RecentViewController * chat = [[RecentViewController alloc] init];
    FriendsViewController * friend = [[FriendsViewController alloc] init];
    MineViewController * mine = [[MineViewController alloc] init];
    
    UINavigationController * chatNV = [[UINavigationController alloc] initWithRootViewController:chat];
    UINavigationController * fridNV = [[UINavigationController alloc] initWithRootViewController:friend];
    UINavigationController * mineNV = [[UINavigationController alloc] initWithRootViewController:mine];
    
    [self setViewControllers:@[chatNV, fridNV, mineNV]];
    
    [chat release];
    [friend release];
    [mine release];
    [chatNV release];
    [fridNV release];
    [mineNV release];
    
    //check login status
    BOOL isLogined = NO;[[DataModel sharedModel] isLoginUserInfoCached];
    if (!isLogined) {
        LoginViewController * login = [[LoginViewController alloc] init];
        [login showWithParentView:self.view];
    } else {
        [[DataModel sharedModel] loginWithCachedUsernameAndPassword];
    }
}

@end
