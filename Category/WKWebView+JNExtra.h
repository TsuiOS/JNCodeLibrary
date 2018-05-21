//
//  WKWebView+JNExtra.h
//  JNCodeLibrary
//
//  Created by xuning on 2018/5/21.
//  Copyright © 2018年 Hsu. All rights reserved.
//

#import <WebKit/WebKit.h>

/**
 方式一
 NSString * jsonParam =[NSString stringWithFormat:@"{"paramJson":{"page":"1","user_id":"%@"}}",@"101020"];
 NSMutableURLRequest * requestShare = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:_url]];
 [requestShare setHTTPMethod: @"POST"];
 [requestShare setHTTPBody: [jsonParam dataUsingEncoding: NSUTF8StringEncoding]];
 [self.webView loadRequest:requestShare];
 
 方式二:
 字典转成json字符串
 
 */

@interface WKWebView (JNExtra)

@end
