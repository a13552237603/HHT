//
//  YKTUserDefaultsTool.h
//  HHT
//
//  Created by HHT on 2018/6/14.
//  Copyright © 2018年 HHT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKTUserDefaultsTool : NSObject

/** 往userDefault中存放内容 */
+ (void)saveToDefaultWithObj:(id)obj forKey:(NSString *)key;

/** 从userDefault中取内容 */
+ (id)getFromDefaultWithKey:(NSString *)key;

/** 从userDefault中删除key的值 */
+ (void)removeFromDefaultWithKey:(NSString *)key;

/** 转json */
+(NSString*)DataTOjsonString:(id)object;
/** JSON字符串转字典 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/** 字典转JSON字符串 */
+(NSString *)dictionaryToJson:(NSDictionary *)dic;
/** 数组转JSON字符串 */
+(NSString *)arrayToJson:(NSArray *)arr;
/** 把字符串进行GBK解码 */
+ (NSString *)dencode:(NSString *)base64String;
/** 把字符串进行base64编码 */
+ (NSString *)encoding:(NSString *)base64String;

/** 正则匹配用户身份证号15或18位 */
+(BOOL)validateIDCardNumber:(NSString *)value;

+ (NSString *) utf8ToUnicode:(NSString *)string;


/**
 不同业务增加日志埋点
 
 *  @param infoDic   必传，写入的日志信息
 *  @param appId     可选，子应用ID
 *  @param send      可选，埋点ID，现已更名为spm，若有则务必填写。
 */
+ (void)addLogStationType:(NSDictionary *)infoDic  toAppId:(NSString *)appId toseed:(NSString *)send;
+(NSString *)URLEncodedStringWithUrl:(NSString *)url;
/** 时间戳转换成时间 */
+ (NSString *)getTimeFromTimestamp:(NSString *)timeStr;

/** 判断某个时间是否处于当天内 */
+ (BOOL)validateWithDate:(NSDate *)date;

/** 获取当前屏幕中present出来的viewcontroller。 */
+ (UIViewController *)getPresentedViewController;

/**
 极光自定义计数增加日志埋点
 
 *  @param infoDic   写入的日志信息
 *  @param eventId   事件ID
 */
+ (void)addJPLogStationType:(NSDictionary *)infoDic  toEventId:(NSString *)eventId;

/** 判断用户是否越狱 */
+(BOOL)isiPhonePrisonBreak;

//获取设备类型
+ (NSString*)iphoneType;

/** 判断用户是否登录 */
+(BOOL)isLoginSuccee;
/** 判断用户是否实名 */
+(BOOL)isRealNameAuth;

/** 获取用户数据 */
+ (NSDictionary *)getUserDictionary;
/** 获取3.0接口登录token */
+ (NSString *)getUserDataToToken;


@end
