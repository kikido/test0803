//
//  GeneralTool.m
//  shengYunEmployee
//
//  Created by dqh on 17/2/20.
//  Copyright © 2017年 dqh. All rights reserved.
//

#import "GeneralTool.h"

@implementation GeneralTool

CGSize boundingRect(CGSize size,CGFloat font,NSString *text)
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize retSize = [text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    CGSize jsSize = CGSizeMake(retSize.width + 1, retSize.height);
    return jsSize;
}

UIColor* colorWithHex(NSString *hexColor)
{
    
    if (hexColor == nil) {
        return nil;
    }
    if ([hexColor length] < 7 ) {
        return nil;
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

BOOL isNotNull(id anObject)
{
//    if ([anObject isKindOfClass:[NSString class]]) {
//        NSString *tmpString = (NSString *)anObject;
//        if (tmpString.length == 0) {
//            return NO;
//        }
//    }
    if (anObject && ![anObject isKindOfClass:[NSNull class]]) {
        return YES;
    } else { 
        return NO;
    }
}

BOOL isNull(id anObject)
{
    if (!anObject || [anObject isKindOfClass:[NSNull class]]) {
        return YES;
    } else {
        return NO;
    }
}

UIColor* colorWithValue(CGFloat redValue, CGFloat greenValue, CGFloat blueValue)
{
    return [UIColor colorWithRed:redValue/255.0 green:greenValue/255.0 blue:blueValue/255.0 alpha:1];
}

BOOL checkPhoneNumInput(NSString *phoneNumber)
{
    NSString * MOBILE = @"^[1][0-9]{10}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL res1 = [regextestmobile evaluateWithObject:phoneNumber];
    
    if (res1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma 正则匹配用户身份证号15或18位
BOOL checkUserIdCard(NSString *idname)
{
    NSString *identityCard = [NSString stringWithFormat:@"%@",idname];
    //判断是否为空
    if (identityCard==nil||identityCard.length <= 0) {
        return NO;
    }
    //判断是否是18位，末尾是否是x
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    if(![identityCardPredicate evaluateWithObject:identityCard]){
        return NO;
    }
    //判断生日是否合法
    NSRange range = NSMakeRange(6,8);
    NSString *datestr = [identityCard substringWithRange:range];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone =  [NSTimeZone timeZoneWithName:@"UTC"];
    [formatter setDateFormat : @"yyyyMMdd"];
    if([formatter dateFromString:datestr]==nil){
        return NO;
    }
    
    //判断校验位
    if(identityCard.length==18)
    {
        NSArray *idCardWi= @[ @"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2" ]; //将前17位加权因子保存在数组里
        NSArray * idCardY=@[ @"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2" ]; //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        int idCardWiSum=0; //用来保存前17位各自乖以加权因子后的总和
        for(int i=0;i<17;i++){
            idCardWiSum+=[[identityCard substringWithRange:NSMakeRange(i,1)] intValue]*[idCardWi[i] intValue];
        }
        
        int idCardMod=idCardWiSum%11;//计算出校验码所在数组的位置
        NSString *idCardLast=[identityCard substringWithRange:NSMakeRange(17,1)];//得到最后一位身份证号码
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast intValue]==[idCardY[idCardMod] intValue]){
                return YES;
            }else{
                return NO;
            }
        }
    }
    return NO;
}


NSString* currentDateString()
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSDate *date = [[NSDate alloc] init];
    
    return [formatter stringFromDate:date];
}

NSString* getTempFilePath(NSString *fileName)
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileName]];
}

NSString* getDocumentFilePath(NSString *fileName)
{
    return [SY_DocumentPhoto_Path stringByAppendingPathComponent:fileName];
}

+ (void)showAlertWithViewController:(UIViewController *)viewController title:(NSString *)title
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [viewController presentViewController:alertVC animated:YES completion:nil];
}

+ (void)showAlertWithViewController:(UIViewController *)viewController title:(NSString *)title sureBlock:(void(^)(UIViewController *viewController))sureBlock
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    @weakify(viewController)
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(viewController)
        sureBlock(viewController);
    }]];
    [viewController presentViewController:alertVC animated:YES completion:nil];
}

+ (void)showAlertWithViewController:(UIViewController *)viewController title:(NSString *)title sureBlock:(void(^)(UIViewController *viewController))sureBlock cancleBlock:(void(^)(UIViewController *viewController))cancleBlock
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    @weakify(viewController)
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(viewController)
        if (cancleBlock) {
            cancleBlock(viewController);
        }
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(viewController)
        if (sureBlock) {
            sureBlock(viewController);
        }
    }]];
    [viewController presentViewController:alertVC animated:YES completion:nil];
}

+ (NSString*)encodeString:(NSString*)unencodedString
{
    NSString *encodedString= (NSString*)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              
                                                              (CFStringRef)unencodedString,
                                                              
                                                              NULL,
                                                              
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

+ (long long)getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init] ;
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = fileDic.fileSize;
        filesize = 1*size;
    }
    return filesize;
}

+ (NSString *)dateStringWithTimeInterval:(NSUInteger)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
