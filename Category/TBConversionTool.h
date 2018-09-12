//
//  TBConversionTool.h
//  TimeBank
//
//  Created by Apple on 2018/4/3.
//  Copyright © 2018年 TimeBank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBConversionTool : NSObject
/**
 *  正则判断手机号码格式
 * http://www.wtoutiao.com/p/h55el9.html
 *
 *  @param phone 手机号码
 *
 *  @return 手机号码格式是否正确
 */
+ (BOOL)validatePhone:(NSString *)phone;

/**
 *  正则判断密码格式
 *
 *  @param Password 密码
 *
 *  @return 密码格式是否正确
 */
+ (BOOL)validatePassword:(NSString *)Password;
/**
 8-16位 数字 字母组合密码
 
 @param pass 密码
 @return yes
 */
+(BOOL)judgePassWordLegal:(NSString *)pass;
//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard;

/**
 按钮倒计时

 @param sender 按钮
 */
+ (void)countdown:(UIButton *)sender;
// 时间戳转格式化时间yyyy-MM
+ (NSString *)stampTurnDateYueWith:(NSString *)stamp;
// 时间戳转格式化时间yyyy-MM-dd
+ (NSString *)stampTurnDateWith:(NSString *)stamp;
// 时间戳转格式化时间yyyy-MM-dd HH:mm
+ (NSString *)dateTurnBJTimeStr:(NSString *)stamp;
//格式化时间转时间戳
//YYYY-MM
+ (NSString *)dateYueTurnStampWith:(NSString *)dateStr;
//YYYY-MM-dd
+ (NSString *)dateTurnStampWith:(NSString *)dateStr;
//YYYY-MM-dd HH:mm
+ (NSString *)dateLTurnStampWith:(NSString *)dateStr;
//字符串转时间戳 如：2017-4-10 17:15:10
+ (NSString *)getTimeStrWithString:(NSString *)str;

/**
 判断是否是纯数字

 @param str 字符串
 @return yes/no
 */
+ (BOOL) deptNumInputShouldNumber:(NSString *)str;
/**
 时间差转多久之前
 
 @param seconds 秒数差
 @return 多久之前
 */
+ (NSString *)timeDiffTurnString:(NSInteger)seconds;

/**
 剩余多少天
 
 @param seconds 秒
 @return 剩余
 */
+ (NSString *)laveTimeDiffTurnString:(NSInteger)seconds;
/**
 时间戳转年龄
 
 @param stamp 时间戳
 @return 年龄
 */
+ (NSString *)ageConstellationWithStamp:(NSString *)stamp;

/**
 根据时间戳转星座
 
 @param stamp 时间戳
 @return 星座
 */
+ (NSString *)calculateConstellationWithStamp:(NSString *)stamp;

/**
 *  根据生日计算星座
 *
 *  @param month 月份
 *  @param day   日期
 *
 *  @return 星座名称
 */
+(NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day;

/**
 秒数转时间 xx:xx:xx
 
 @param seconds 秒数
 @return return value description
 */
+ (NSString *)numberOfSecondsTurnString:(NSInteger)seconds;

/**
 根据银行卡号获得银行名称
 
 @param idCard 银行卡号
 @return 银行名字
 */
+ (NSString *)returnBankName:(NSString*) idCard;

/**
 图片转换data
 
 @param image image description
 @return data
 */
+ (NSData *)imgTurnDataWithImage:(UIImage *)image;

/**
 获取图片后缀

 @param image 图
 @return 后缀
 */
+ (NSString *)suffixWith:(UIImage *)image;
/**
 判断是否有emoji

 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

//判断中英混合的的字符串长度
+ (int)convertToInt:(NSString*)strtemp;

// 判断字符串是否有空格
+ (BOOL)isEmpty:(NSString *) str;
/**
 是否仅中文,英文,数字

 */
+ (BOOL)stringChineseNumEnglish:(NSString *)string;




@end
