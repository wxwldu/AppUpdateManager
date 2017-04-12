//
//  ViewController.m
//  AppUpdate
//
//  Created by Sam on 2017/4/12.
//  Copyright © 2017年 wuxuwen. All rights reserved.
//

#import "ViewController.h"
#import "AppUpdateManager.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //第一种
    [AppUpdateManager checkNewVersionWithAppid:@"XXXX" viewController:self];
    
    //第二种
    [AppUpdateManager checkNewVersionWithAppid:@"XXXX" info:^(AppStoreInfoObject *appInfo) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
