//
//  GeneralTool.h
//  shengYunEmployee
//
//  Created by dqh on 17/2/20.
//  Copyright © 2017年 dqh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface GeneralTool : NSObject

/**
 计算文本高度
 
 @param size 宽度
 @param font 字体大小
 @param text 文本
 
 @return size
 */
CGSize boundingRect(CGSize size,CGFloat font,NSString *text);


/**
 hex->返回颜色
 
 @param hexColor hex
 
 @return uicolor
 */
UIColor* colorWithHex(NSString *hexColor);


/**
 *  判断一个对象(类型和内容)是否不为空（只使用与数组，字典，字符串）。
 *
 *  @param anObject 传入对象
 *
 *  @return 若为空，返回NO； 若不为空，返回YES
 */
BOOL isNotNull(id anObject);

BOOL isNull(id anObject);



/**
 创建颜色
 
 @param redValue   red
 @param greenValue green
 @param blueValue  blue
 
 @return 颜色
 */
UIColor* colorWithValue(CGFloat redValue, CGFloat greenValue, CGFloat blueValue);


/**
 检测号码格式
 
 @param phoneNumber 手机号码
 
 @return 检测结果
 */
BOOL checkPhoneNumInput(NSString *phoneNumber);


/**
 检测身份证格式是否正确

 @param idCard 身份证

 @return bool
 */
BOOL checkUserIdCard(NSString *idCard);



/**
 计算的日期时间

 @return 时间yyyyMMddHHmmss
 */
NSString* currentDateString();


/**
 文件在临时文件夹中的位置

 @param fileName 文件名

 @return 文件的路径
 */
NSString* getTempFilePath(NSString *fileName);



/**
 文件在document/juesheng文件夹中的位置

 @param fileName 文件名
 @return 文件路径
 */
NSString* getDocumentFilePath(NSString *fileName);


/**
 在vc中调用alert

 @param viewController 当前的vc
 @param title          显示的title
 */
+ (void)showAlertWithViewController:(UIViewController *)viewController title:(NSString *)title;



/**
 不带取消的alert

 @param viewController <#viewController description#>
 @param title          <#title description#>
 @param sureBlock      <#sureBlock description#>
 */
+ (void)showAlertWithViewController:(UIViewController *)viewController title:(NSString *)title sureBlock:(void(^)(UIViewController *viewController))sureBlock;


/**
带取消的alert

 @param viewController <#viewController description#>
 @param title          <#title description#>
 @param sureBlock      <#sureBlock description#>
 @param cancleBlock    <#cancleBlock description#>
 */
+ (void)showAlertWithViewController:(UIViewController *)viewController title:(NSString *)title sureBlock:(void(^)(UIViewController *viewController))sureBlock cancleBlock:(void(^)(UIViewController *viewController))cancleBlock;


+(NSString*)encodeString:(NSString*)unencodedString;

+ (long long)getFileSize:(NSString *)path;

+ (NSString *)dateStringWithTimeInterval:(NSUInteger)time;


/**
 字典转换成json

 @param dic 字典

 @return 字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end
