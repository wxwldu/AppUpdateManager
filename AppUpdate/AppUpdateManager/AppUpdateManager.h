//
//  AppUpdateManager.h
//  demo
//
//  Created by Sam on 2017/4/12.
//  Copyright © 2017年 HuiLian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class AppStoreInfoObject;

typedef void(^VersionInfoBlock)(AppStoreInfoObject *appInfo);

@interface AppUpdateManager : NSObject


//检测版本，系统提示框

+ (void)checkNewVersionWithAppid:(NSString *)appid viewController:(UIViewController *)ctrl;


//获取版本信息
+ (void)checkNewVersionWithAppid:(NSString *)appid info:(VersionInfoBlock )versionBlock;



@end
