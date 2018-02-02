//
//  SYCommon.h
//  shengYunEmployee
//
//  Created by dqh on 17/3/27.
//  Copyright © 2017年 dqh. All rights reserved.
//

#ifndef SYCommon_h
#define SYCommon_h

//|--------------------------
//MAS
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//window
#define CURRENT_WINDOW [[UIApplication sharedApplication].delegate window]


/**
 本地存储
 */
#define WRITE_TO_LOCAL(key, value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define READ_FROM_LOCAL(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define REMOVE_From_LOCAL(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]

#define SY_SavePhotoPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SY"]
#define SY_CarLimitPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/carLimit.plist"]
#define SY_CarBrandPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/carBrand.plist"]
#define SY_CarCityPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/carCity.plist"]
#define SY_DocumentPhoto_Path [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/jsphoto"]
#define SY_UnUploadPhotoSql_Path [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/jsphoto/photo.sqlite"]


//
//
#define isIphoneX (SCREEN_HEIGHT==812. ? YES : NO)

#define JSB_SafeAreaTopHeight (SCREEN_HEIGHT == 812.0 ? 88 : 64)

#define JSB_SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 83. : 49.)

#define JSB_SafeAreaTopMargin (SCREEN_HEIGHT == 812.0 ? 20. : 0.)

#define JSB_SafeAreaBottomMargin (SCREEN_HEIGHT == 812.0 ? 34. : 0.)






//存储push信息的path
#define JPushPath @"JPushPath"
#define JPushPhoneKey @"fphoneno"
#define JPushMode @"JPushMode"

//语音视频
#define SY_DocumentFile_Path [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/jsfile"]

#define SY_FileName_VideoUrl @"SY_FileName_VideoUrl"

#define SY_VideoMeet_FilePath @"SY_VideoMeet_FilePath"


////////////////////////////////////////////////////////////
//////////// 版本号
//////////////////////////////////////////////////////////////
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//|--------------------------
//MAS
#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS

//|--------------------------
//输出相关
#ifndef __OPTIMIZE__
#define SYStatus NO
#define NSLog(format, ...) printf("\n[%s] %s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define SYStatus YES
#define NSLog(...) {}
#endif


#endif /* SYCommon_h */
