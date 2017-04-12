//
//  AppStoreInfoObject.h
//  demo
//
//  Created by Sam on 2017/4/12.
//  Copyright © 2017年 HuiLian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppStoreInfoObject : NSObject

//版本号
@property (nonatomic, copy) NSString *version;

//更新日志
@property(nonatomic,copy)NSString *releaseNotes;

//更新时间
@property (nonatomic, copy) NSString *currentVersionReleaseDate;

//APPId
@property(nonatomic,copy)NSString *APPId;

//bundleId
@property (nonatomic, copy) NSString *bundleId;

//AppStore地址
@property(nonatomic,copy)NSString *trackViewUrl;

//开发商
@property (nonatomic, copy) NSString *sellerName;

//文件大小
@property(nonatomic,copy)NSString *fileSizeBytes;

//展示图
@property (nonatomic, copy) NSString *screenshotUrls;

@end