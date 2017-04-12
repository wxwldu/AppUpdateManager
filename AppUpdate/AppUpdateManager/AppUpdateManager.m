//
//  AppUpdateManager.m
//  demo
//
//  Created by Sam on 2017/4/12.
//  Copyright © 2017年 HuiLian. All rights reserved.
//

#import "AppUpdateManager.h"
#import "AppStoreInfoObject.h"

@interface AppUpdateManager ()
@property (nonatomic, strong) NSDictionary *infoDic;

@end
@implementation AppUpdateManager

- (NSDictionary *)infoDic {
    if (!_infoDic) {
        _infoDic = [NSBundle mainBundle].infoDictionary;
    }
    
    return  _infoDic;
}


//单例
+ (instancetype)shareManager {
    static AppUpdateManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance =[[self alloc] init];
        
    });
    return instance;
}


//检测版本，系统提示框

+ (void)checkNewVersionWithAppid:(NSString *)appid viewController:(UIViewController *)ctrl{
    [[self shareManager] checkNewVersion:appid ctrl:ctrl];
    
}


//获取版本信息
+ (void)checkNewVersionWithAppid:(NSString *)appid info:(VersionInfoBlock )versionBlock{
    
    [[self shareManager] getAppStoreVersion:appid sucess:^(AppStoreInfoObject *model) {
        if(versionBlock)
            versionBlock(model);
    }];
    
    
}

- (void)checkNewVersion:(NSString *)appID ctrl:(UIViewController *)containCtrl {
    [self getAppStoreVersion:appID sucess:^(AppStoreInfoObject *model) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"有新的版本(%@)",model.version] message:model.releaseNotes preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self updateRightNow:model];
        }];
        UIAlertAction *delayAction = [UIAlertAction actionWithTitle:@"稍后再说" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *ignoreAction = [UIAlertAction actionWithTitle:@"忽略" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self ignoreNewVersion:model.version];
        }];
        
        [alertController addAction:updateAction];
        [alertController addAction:delayAction];
        [alertController addAction:ignoreAction];
        [containCtrl presentViewController:alertController animated:YES completion:nil];
    }];
}

#pragma mark - 立即升级
- (void)updateRightNow:(AppStoreInfoObject *)model {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.trackViewUrl]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.trackViewUrl] options:@{} completionHandler:nil];
    }
    
}


#pragma mark - 忽略新版本
- (void)ignoreNewVersion:(NSString *)version {
    //保存忽略的版本号
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"ingoreVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取AppStore上的版本信息
- (void)getAppStoreVersion:(NSString *)appID sucess:(void(^)(AppStoreInfoObject *))update {
    
    [self getAppStoreInfo:appID success:^(NSDictionary *respDict) {
        NSInteger resultCount = [respDict[@"resultCount"] integerValue];
        if (resultCount == 1) {
            NSArray *results = respDict[@"results"];
            NSDictionary *appStoreInfo = [results firstObject];
            
            //字典转模型
            AppStoreInfoObject *model = [[AppStoreInfoObject alloc] init];
            [model setValuesForKeysWithDictionary:appStoreInfo];
            //是否提示更新
            BOOL result = [self isEqualEdition:model.version];
            if (result) {
                if(update)update(model);
            }
        } else {
#ifdef DEBUG
            NSLog(@"AppStore上面没有找到对应id的App");
#endif
        }
    }];
    
}


#pragma mark - 返回是否提示更新
-(BOOL)isEqualEdition:(NSString *)newEdition {
    NSString *ignoreVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"ingoreVersion"];
    if([self.infoDic[@"CFBundleShortVersionString"] compare:newEdition] == NSOrderedDescending || [ignoreVersion isEqualToString:newEdition]) {
        return NO;
    } else {
        return YES;
    }
}


- (void)getAppStoreInfo:(NSString *)appid success:(void(^)(NSDictionary *))success
{
    
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/CN/lookup?id=%@",appid ]];
    [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
       dispatch_async(dispatch_get_main_queue(), ^{
          
           if (error == nil && data != nil && data.length >0) {
               NSDictionary *response =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
               
               if (success) {
                   success(response);
               }
           }
       });
    }];
}

@end
