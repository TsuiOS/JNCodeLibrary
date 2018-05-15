//
//  JNJWTManager.h
//  JNCodeLibrary
//
//  Created by xuning on 2018/5/15.
//  Copyright © 2018年 Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNJWTManager : NSObject

+ (NSString *)JWTWithParams:(NSDictionary *)payload;

@end
