//
//  JNPayManager.m
//  JNCodeLibrary
//
//  Created by xuning on 2018/5/15.
//  Copyright © 2018年 Hsu. All rights reserved.
//

#import "JNPayManager.h"
#import <WXApi.h>
#import <AlipaySDK/AlipaySDK.h>

#define  kAppScheme @"appScheme"
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

@interface JNPayManager()

/**
 成功的回调
 */
@property (nonatomic, copy) void(^successBlock)(JNPayCode code);
/**
 失败的回调
 */
@property (nonatomic, copy) void(^failureBolck)(JNPayCode code);

@end

@implementation JNPayManager

/**
支付管理类
*/
+ (instancetype)sharedPayManager {
    static dispatch_once_t onceToken;
    static JNPayManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark -----------------------------------微信-----------------------------------

/**
 微信支付
 
 @param dict 微信订单字典(全部由后台拼接好给iOS端)
 @param successBlock 成功的回调
 @param failureBolck 失败的回调
 */
- (void)WXPayWithPayDict:(NSDictionary *)dict
                 success:(void(^)(JNPayCode code)) successBlock
                 failure:(void(^)(JNPayCode code)) failureBolck {
    self.successBlock = successBlock;
    self.failureBolck = failureBolck;
    NSString *strMsg = nil;
    //1. 判断是否安装微信
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"您尚未安装\"微信App\",请先安装后再返回支付");
        strMsg = @"您尚未安装\"微信App\",请先安装后再返回支 付";
        [self tipMessageAlert:nil message:strMsg];
        return;
    }
    
    //2.判断微信的版本是否支持最新Api
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"您微信当前版本不支持此功能,请先升级微信应用");
        strMsg = @"您微信当前版本不支持此功能,请先升级微信应用";
        [self tipMessageAlert:nil message:strMsg];
        return;
    }
    
    if (!kDictIsEmpty(dict)) {
        
        //调起微信支付
        PayReq *req = [[PayReq alloc]init];
        req.openID = dict[@"appid"];
        req.partnerId = dict[@"partnerid"];
        req.prepayId = dict[@"prepayid"];
        req.nonceStr = dict[@"noncestr"];
        req.timeStamp = [dict[@"timestamp"] intValue];
        req.package = @"Sign=WXPay";
        req.sign = dict[@"sign"];
        [WXApi sendReq:req];
        
    }
    
}

#pragma mark - WXApiDelegate
//支付结果回调
/// - see [支付结果回调](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_5)
- (void)onResp:(BaseResp *)resp {
    
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d",resp.errCode];
    
    //回调中errCode值列表：
    // 0 成功 展示成功页面
    //-1 错误 可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
    //-2 用户取消 无需处理。发生场景：用户不支付了，点击取消，返回APP
    
    if ([resp isKindOfClass:[PayResp class]]) {
        // 支付返回结果,实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case WXSuccess:{
                strMsg = @"支付结果：成功！";
                if (self.successBlock) {
                    self.successBlock(WXSUCESS);
                }
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
            }
            case WXErrCodeUserCancel:{
                strMsg = @"支付结果：取消";
                if (self.failureBolck) {
                    self.failureBolck(WXSCANCEL);
                }
                NSLog(@"支付取消－PayCancel，retcode = %d", resp.errCode);
            }
            default:{
                strMsg = @"支付结果：失败";
                if (self.failureBolck) {
                    self.failureBolck(WXERROR);
                }
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
            }
        }
        [self tipMessageAlert:@"支付结果" message:strMsg];
    }
    
}

#pragma mark -----------------------------------支付宝-----------------------------------

/**
 支付宝支付
 
 @param params 支付宝支付参数(全部由后台拼接好给iOS端)
 @param successBlock 成功的回调
 @param failureBolck 失败的回调
 */
- (void)ALIPayWithPayParams:(NSString *)params
                    success:(void(^)(JNPayCode code)) successBlock
                    failure:(void(^)(JNPayCode code)) failureBolck {
    
    self.successBlock = successBlock;
    self.failureBolck = failureBolck;
#warning 需要填写 appScheme
    [[AlipaySDK defaultService] payOrder:params fromScheme:kAppScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"我这里是payVC%@",resultDic);
        NSLog(@"%@",resultDic[@"memo"]);
        [self aliPayResult:resultDic];
    }];
    
    
}

- (void)ALIAuth_V2WithInfo:(NSString *)infoStr
                   success:(void(^)(void))successBlock
                   failure:(void(^)(void))failureBolck {
    
#warning 需要填写 appScheme
    [[AlipaySDK defaultService] auth_V2WithInfo:infoStr fromScheme:kAppScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"结果: = %@",resultDic);
        
        //授权成功后resultStatus为9000 authCode会在result中,需要解析出来
        // 解析 auth code
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    break;
                }
            }
        }
        NSLog(@"授权结果 authCode = %@", authCode?:@"");
        NSString *resultStatus = resultDic[@"resultStatus"];
        if ([resultStatus isEqualToString:@"9000"]) { //请求处理成功
            
        }else if ([resultStatus isEqualToString:@"6001"]){ //您已取消认证
            
        }else{ //系统繁忙,请稍后再试
            
        }
        
    }];
    
    
    
}


#pragma mark - 支付宝支付结果处理

- (void)aliPayResult:(NSDictionary *)resultDic {
    
    // 返回结果需要通过 resultStatus 以及 result 字段的值来综合判断并确定支付结果。 在 resultStatus=9000,并且 success="true"以及 sign="xxx"校验通过的情况下,证明支付成功。其它情况归为失败。较低安全级别的场合,也可以只通过检查 resultStatus 以及 success="true"来判定支付结果
    NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
    
    if (resultDic && [resultDic objectForKey:@"resultStatus"]) {
        switch (resultStatus) {
            case 9000:
                [self tipMessageAlert:@"支付结果" message:@"订单支付成功"];
                if (self.successBlock) {
                    self.successBlock(ALIPAYSUCESS);
                }
                break;
            case 8000:
                [self tipMessageAlert:@"支付结果" message:@"正在处理中"];
                if (self.failureBolck) {
                    self.failureBolck(ALIPAYERROR);
                }
                break;
            case 4000:
                [self tipMessageAlert:@"支付结果" message:@"订单支付失败,请稍后再试"];
                if (self.failureBolck) {
                    self.failureBolck(ALIPAYERROR);
                }
                break;
            case 6001:
                [self tipMessageAlert:@"支付结果" message:@"已取消支付"];
                if (self.failureBolck) {
                    self.failureBolck(ALIPAYCANCEL);
                }
                break;
            case 6002:
                [self tipMessageAlert:@"支付结果" message:@"网络连接错误,请稍后再试"];
                if (self.failureBolck) {
                    self.failureBolck(ALIPAYERROR);
                }
                break;
            default:
                break;
        }
    }
    
}

#pragma mark - 单例类回调
- (BOOL)handleOpenURL:(NSURL *)url {
    
    if ([url.host isEqualToString:@"safepay"])
    {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSLog(@"openURL : 支付宝回调 ： result = %@",resultDic);
            [self aliPayResult:resultDic];
        }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
        return [url.host isEqualToString:@"safepay"];
    }
    else
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
}

#pragma mark - 提示

/**
 提示
 
 @param title 标题
 @param message 信息
 */
- (void)tipMessageAlert:(NSString *)title message:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertController addAction:cancelAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
