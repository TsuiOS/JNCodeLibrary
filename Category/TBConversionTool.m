//
//  TBConversionTool.m
//  TimeBank
//
//  Created by Apple on 2018/4/3.
//  Copyright © 2018年 TimeBank. All rights reserved.
//

#import "TBConversionTool.h"

@implementation TBConversionTool

//正则判断手机号码格式
+ (BOOL)validatePhone:(NSString *)phone
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     *   补充：183 147
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    /*
     三大运营商最新号段

     115 - 119
     
     移动号段：
     134 135 136 137 138 139 147 150 151 152 157 158 159 178 182 183 184 187 188
     联通号段：
     130 131 132 145 155 156 171 175 176 185 186
     电信号段：
     133 149 153 173 177 180 181 189
     虚拟运营商:
     170
     */
//    NSString *MOBILE = @"^(0|86|17951)?(11[5-9]|13[0-9]|15[012356789]|17[0135678]|18[0-9]|14[579])[0-9]{8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    if (([regextestmobile evaluateWithObject:phone] == YES)) {
//        return YES;
//    }else{
//        return NO;
//    }
    
    if (phone.length == 11) {
        return YES;
    }
    else
    {
        return NO;
    }
}

//密码格式是否正确
+(BOOL)validatePassword:(NSString *)Password{
    BOOL result = NO;
    
    if (([Password length] >= 8)&&([Password length] <= 32) ){
        // 判断是否同时包含数字和字符的正则表达式
        NSString* regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)(?![~!@#$%^&*()+=|{}':;',\\[\\].<>/?~!@#￥%&*（）+|{}【】‘；：”“’。，、？]+$)[0-9A-Za-z~!@#$%^&*()+=|{}':;',\\[\\].<>/?~!@#￥%&*（）+|{}【】‘；：”“’。，、？]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:Password];
        
        result = YES;
    }
    return result;
}
// 按钮倒计时
+ (void)countdown:(UIButton *)sender
{
    __block int timeout = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(timeout<=0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                [sender setTitle:@"发送验证码" forState:UIControlStateNormal];
                
                sender.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                
                sender.titleLabel.text = [NSString stringWithFormat:@"%@s",strTime];
                [sender setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                
                sender.userInteractionEnabled = NO;
                
            });
            
            timeout--;
            
        }
        
    });
    
    dispatch_resume(_timer);
}

/**
 8-16位 数字 字母组合密码

 @param pass 密码
 @return yes
 */
+(BOOL)judgePassWordLegal:(NSString *)pass{
    BOOL result = false;
    if ([pass length] >= 8 && [pass length] <= 16){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:pass];
    }
    return result;
}


//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard{
    
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$|^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
    
}
// 时间戳转格式化时间yyyy-MM
+ (NSString *)stampTurnDateYueWith:(NSString *)stamp{
    NSTimeInterval _interval = [stamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM"];
    NSString * timeStampString = [objDateformat stringFromDate: date];
    DLog(@"------0-00---%@",timeStampString);
    return timeStampString;
}
+ (NSString *)stampTurnDateWith:(NSString *)stamp
{
    
    NSTimeInterval _interval = [stamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd"];
    NSString * timeStampString = [objDateformat stringFromDate: date];
    DLog(@"------0-00---%@",timeStampString);
    return timeStampString;
    
}

+ (NSString *)dateTurnBJTimeStr:(NSString *)stamp {
    
    NSTimeInterval _interval = [stamp doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * timeStampString = [objDateformat stringFromDate: date];
    DLog(@"------0-00---%@",timeStampString);
    return timeStampString;

}

//YYYY-MM
+ (NSString *)dateYueTurnStampWith:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]]; //设置本地时区
    [dateFormatter setDateFormat:@"yyyy-MM"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];//时间戳
    return timeSp;
}
+ (NSString *)dateTurnStampWith:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:dateStr]; //------------将字符串按formatter转成nsdate
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}
+ (NSString *)dateLTurnStampWith:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:dateStr]; //------------将字符串按formatter转成nsdate
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}
//字符串转时间戳 如：2017-4-10 17:15:10
+ (NSString *)getTimeStrWithString:(NSString *)str{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:str]; //------------将字符串按formatter转成nsdate
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}


/**
 时间差转多久之前（7天内）
 
 @param seconds 秒数差
 @return 多久之前
 */
+ (NSString *)timeDiffTurnString:(NSInteger)seconds
{
    if (seconds < 0) {
        return @"";
    }
    if (seconds < 60) {
        return @"刚刚";
    }else if (seconds < 3600) {
        return [NSString stringWithFormat:@"%ld分钟之前",seconds/60];
    }else if (seconds < 3600*24){
        return [NSString stringWithFormat:@"%ld小时之前",seconds/(3600)];
    }else if (seconds < (3600*24*30)){
        return [NSString stringWithFormat:@"%ld天之前",seconds/(3600*24)];
    }else if (seconds < (3600*24*30*12)){
        return [NSString stringWithFormat:@"%ld月之前",seconds/(3600*24*30)];
    }else{
        return [NSString stringWithFormat:@"%ld年之前",seconds/(3600*24*30*12)];
    }
}


/**
 剩余多少天
 
 @param seconds 秒
 @return 剩余
 */
+ (NSString *)laveTimeDiffTurnString:(NSInteger)seconds {
    if (seconds < 0) {
        return @"";
    }
    if (seconds < 60) {
        return @"马上";
    }else if (seconds < 3600) {
        return [NSString stringWithFormat:@"剩余%ld分钟",seconds/60];
    }else if (seconds < 3600*24){
        return [NSString stringWithFormat:@"剩余%ld小时",seconds/(3600)];
    }else {
        return [NSString stringWithFormat:@"剩余%ld天",seconds/(3600*24)];
    }
    
}

+ (NSString *)ageConstellationWithStamp:(NSString *)stamp
{
    NSDate*detaildate = [NSDate date];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    NSArray *strarr = [[self stampTurnDateWith:stamp] componentsSeparatedByString:@"-"];
    if (strarr.count == 3) {
        return [NSString stringWithFormat:@"%ld岁",[currentDateStr integerValue] - [strarr[0] integerValue]];
    }
    else
    {
        return @"未知年龄";
    }
}

//以字符串中的空格为分隔，将字符串分为字符串数组(此方法要求返回一个数组)
+ (NSString *)calculateConstellationWithStamp:(NSString *)stamp
{
    NSArray *strarr = [[self stampTurnDateWith:stamp] componentsSeparatedByString:@"-"];
    
    if (strarr.count == 3) {
        return [self calculateConstellationWithMonth:[strarr[1] integerValue] day:[strarr[2] integerValue]];
    }
    else
    {
        return @"未得到星座";
    }
}

+ (NSString *)calculateConstellationWithMonth:(NSInteger)month day:(NSInteger)day
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    if (month<1 || month>12 || day<1 || day>31){
        return @"错误日期格式!";
    }
    
    if(month==2 && day>29)
    {
        return @"错误日期格式!!";
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    
    return [NSString stringWithFormat:@"%@座",result];
}

+ (BOOL) deptNumInputShouldNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}


+ (NSString *)numberOfSecondsTurnString:(NSInteger)seconds
{
    if (seconds <= 60) {
        return [NSString stringWithFormat:@"00:00:%02ld",seconds];
    }
    else if ((seconds>60) && (seconds<=3600))
    {
        return [NSString stringWithFormat:@"00:%02ld:%02ld",seconds/60,seconds%60];
    }
    else
    {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",seconds/3600,seconds%3600/60,seconds%3600%60];
    }
}
+ (NSData *)imgTurnDataWithImage:(UIImage *)image
{
    NSData *data;
    if (UIImageJPEGRepresentation(image,0.5) == nil) {
        
        data = UIImagePNGRepresentation(image);
        
    } else {
        
        data = UIImageJPEGRepresentation(image,0.5);
    }
    return data;
}
+ (NSString *)suffixWith:(UIImage *)image
{
    NSString *suffixTemp = @".jpg";
    
    if (UIImageJPEGRepresentation(image,1) == nil)
    {
        suffixTemp = @".png";
    }
    return suffixTemp;
}
+ (NSString *)returnBankName:(NSString*) idCard{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"plist"];
    
    NSDictionary* resultDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSArray *bankName = [resultDic objectForKey:@"bankName"];
    
    NSArray *bankBin = [resultDic objectForKey:@"bankBin"];
    
    int index = -1;
    
    if(idCard==nil || idCard.length<16 || idCard.length>19){
        
        return @"";
        
    }
    
    //6位Bin号
    
    NSString* cardbin_6 = [idCard substringWithRange:NSMakeRange(0, 6)];
    
    for (int i = 0; i < bankBin.count; i++) {
        
        if ([cardbin_6 isEqualToString:bankBin[i]]) {
            
            index = i;
            
        }
        
    }
    
    if (index != -1) {
        
        return bankName[index];
        
    }
    
    //8位Bin号
    
    NSString* cardbin_8 = [idCard substringWithRange:NSMakeRange(0, 8)];
    
    for (int i = 0; i < bankBin.count; i++) {
        
        if ([cardbin_8 isEqualToString:bankBin[i]]) {
            
            index = i;
            
        }
        
    }
    
    if (index != -1) {
        
        return bankName[index];
        
    }
    
    return @"有误";
    
}
//判断是否有emoji
+(BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}


+ (int)convertToInt:(NSString*)strtemp//判断中英混合的的字符串长度
{
    int strlength = 0;
    char *p = (char *)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0; i < [strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}
// 判断字符串是否有空格
+ (BOOL)isEmpty:(NSString *) str {
    NSRange range = [str rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES; //yes代表包含空格
    }else {
        return NO; //反之
    }
}
/**
 仅中文,英文,数字
 
 @param string string description
 @return return value description
 */
+ (BOOL)stringChineseNumEnglish:(NSString *)string {
    
    //    [a-zA-Z0-9]*
    BOOL B = NO;
    NSString *regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    B = [pred evaluateWithObject:string];
    return B;
    
}
@end
