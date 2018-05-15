//
//  JNJWTManager.m
//  JNCodeLibrary
//
//  Created by xuning on 2018/5/15.
//  Copyright © 2018年 Hsu. All rights reserved.
//

#import "JNJWTManager.h"
#import <JWT.h>
@implementation JNJWTManager

+ (NSString *)JWTWithParams:(NSDictionary *)payload {
    
    
    
    NSString *algorithmName = @"RS256";
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"];
    NSData *privateKeySecretData = [NSData dataWithContentsOfFile:filePath];
    
    NSString *passphraseForPrivateKey = @"p12密码";
    
    JWTBuilder *builder = [JWTBuilder encodePayload:payload].secretData(privateKeySecretData).privateKeyCertificatePassphrase(passphraseForPrivateKey).algorithmName(algorithmName);
    NSString *token = builder.encode;
    // check error
    if (builder.jwtError == nil) {
    }
    else {
        
    }
    return token;
    
}

@end
