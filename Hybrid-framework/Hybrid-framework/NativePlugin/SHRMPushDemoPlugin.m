//
//  SHRMPushDemoPlugin.m
//  Hybrid-framework
//
//  Created by Kevin on 2019/4/8.
//  Copyright © 2019 王凯. All rights reserved.
//

#import "SHRMPushDemoPlugin.h"
#import "TestViewController.h"

@SHRMRegisterWebPlugin(SHRMPushDemoPlugin, 1)

@implementation SHRMPushDemoPlugin

- (void)pushTestVC:(SHRMMsgCommand *)command {
    UIViewController *rootVC = command.delegate.rootViewController;
    TestViewController *testVC = [[TestViewController alloc] init];
    [rootVC.navigationController pushViewController:testVC animated:YES];
}

@end
