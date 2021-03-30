//
//  YKTUserDefaultsTool.m
//  HHT
//
//  Created by HHT on 2018/6/14.
//  Copyright © 2018年 HHT. All rights reserved.
//

#import "YKTUserDefaultsTool.h"

@implementation YKTUserDefaultsTool

/** 往userDefault中存放内容 */
+ (void)saveToDefaultWithObj:(id)obj forKey:(NSString *)key;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:obj forKey:key];
    [userDefaults synchronize];
}

/** 从userDefault中取内容 */
+ (id)getFromDefaultWithKey:(NSString *)key;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

/** 从userDefault中删除key的值 */
+ (void)removeFromDefaultWithKey:(NSString *)key{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}
/** 转json */
+(NSString*)DataTOjsonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted                                                          error:&error];
    if (! jsonData) {
        NSLog(@"解析失败: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
//JSON字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//字典转JSON
+(NSString *)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    return [[NSString alloc] initWithData:jsonData encoding:enc];
}
//数组转JSON
+(NSString *)arrayToJson:(NSArray *)arr{
    if (arr == nil) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:0 error:&error];
    if ([jsonData length] && error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}
//GBK解码
+ (NSString *)dencode:(NSString *)base64String{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString * string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    if (ProductSever) {
//        string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    }else{
//    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    string = [[NSString alloc] initWithData:data encoding:gbkEncoding];
//    }
    return string;
}

//base64编码
+ (NSString *)encoding:(NSString *)base64String{
    NSData *data = [base64String dataUsingEncoding:NSUTF8StringEncoding];
    NSString *string = [data base64EncodedStringWithOptions:0];
    return string;
}
+(BOOL)validateIDCardNumber:(NSString *)value{
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        //不满足15位和18位，即身份证错误
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    // 检测省份身份行政区代码
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO; //标识省份代码是否正确
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return NO;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    //分为15位、18位身份证进行校验
    switch (length) {
        case 15:
            //获取年份对应的数字
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
                
                int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 3：获取校验位
                //4：检测ID的校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }

}

+ (NSString *) utf8ToUnicode:(NSString *)string{
    
    NSUInteger length = [string length];
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
//    NSString *ss = @"\\";
    for (int i = 0;i < length; i++){
        NSMutableString *s = [NSMutableString stringWithCapacity:0];
        [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
        [str appendFormat:@"%@",s];
    }
    return str;
}
+(NSString *)URLEncodedStringWithUrl:(NSString *)url{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)url,NULL,(CFStringRef) @"!*'();:@&=+$,%#[]|",kCFStringEncodingUTF8));
    return encodedString;
}

#pragma mark ---- 将时间戳转换成时间

+ (NSString *)getTimeFromTimestamp:(NSString *)timeStr{
    
    //将对象类型的时间转换为NSDate类型
    
    NSTimeInterval time=[timeStr doubleValue] ;
    NSDate * myDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //设置时间格式
    
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //将时间转换为字符串
    
    NSString *timestr=[formatter stringFromDate:myDate];
    
    return timestr;
    
}
/** 判断某个时间是否处于当天内 */
+ (BOOL)validateWithDate:(NSDate *)date{
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *now = [NSDate date];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:now];
    //    components.hour = 8;
        // 当天起始时间
        NSDate *startDate = [calendar dateFromComponents:components];
        // 当天结束时间
        NSDate *expireDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
        
        if ([date compare:startDate] == NSOrderedDescending && [date compare:expireDate] == NSOrderedAscending) {
            return YES;
        } else {
            return NO;
        }
}
//+ (void)addLogStationType:(NSDictionary *)infoDic  toAppId:(NSString *)appId toseed:(NSString *)send{
//    if(infoDic){
//        NSArray * extParams = @[@"",@"",@"",infoDic];
//        [APRemoteLogger writeLogWithActionId:KActionID_Event extParams:extParams appId:appId seed:send ucId:@""];
//    }
//}

//+ (void)addJPLogStationType:(NSDictionary *)infoDic  toEventId:(NSString *)eventId{
//    JANALYTICSCountEvent * event = [[JANALYTICSCountEvent alloc] init];
//     event.eventID = eventId;
//     event.extra = infoDic;
//    [JANALYTICSService eventRecord:event];
//}

+ (UIViewController *)getPresentedViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
      
    return topVC;
}

/** 判断用户是否越狱 */
+(BOOL)isiPhonePrisonBreak{
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"]){
    return YES; }
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/MobileSubstrate.dylib"]){
    return YES; }
    if([[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/cydia"]){
    return YES; }
    return NO;
}

/** 判断用户是否登录 */
+(BOOL)isLoginSuccee{
    return NO;
}
/** 判断用户是否实名 */
+(BOOL)isRealNameAuth{
//    NSDictionary *userDic = [self getUserDictionary];
//    if (userDic) {
//        NSArray *authArray = [userDic[@"authSttType"] componentsSeparatedByString:@"|"];
//        BOOL authBool = [authArray containsObject:@"2"] || [authArray containsObject:@"7"];
//        return authBool;
//    }
    return NO;
}

/** 获取用户数据 */
+ (NSDictionary *)getUserDictionary{
    return nil;
}
/** 获取3.0接口登录token */
+ (NSString *)getUserDataToToken{
    NSString *token = @"";
    NSDictionary *dic = [self getUserDictionary];
    if (dic) {
        token = [NSString stringWithFormat:@"%@ %@",dic[@"token_type"],dic[@"access_token"]];
    }
    return token;
}

@end
