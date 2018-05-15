//
//  JNUploadManager.h
//  JNCodeLibrary
//
//  Created by xuning on 2018/5/15.
//  Copyright © 2018年 Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QiniuSDK.h>
// 上传文件类型

typedef NS_ENUM(NSInteger, JNUploadType) {
    JNUploadVideo = 0, // video
    JNUploadImage = 1, // image
};
/**
 *    上传完成后的回调函数
 *
 *    @param info 上下文信息，包括状态码，错误值
 *    @param key  上传时指定的key，原样返回
 *    @param resp 上传成功会返回文件信息，失败为nil; 可以通过此值是否为nil 判断上传结果
 */
typedef void (^JNUpCompletionHandler)(QNResponseInfo *info, NSString *key, NSDictionary *resp);

/**
 *    上传进度回调函数
 *
 *    @param key     上传时指定的存储key
 *    @param percent 进度百分比
 */
typedef void (^JNUpProgressHandler)(NSString *key, float percent);


#pragma mark ------------------------JNUploadHelper----------------------------------
@interface JNUploadHelper : NSObject


@property (copy, nonatomic) JNUpCompletionHandler completionHandler;

@property (copy, nonatomic) JNUpProgressHandler progressHandler;

+ (instancetype)sharedUploadHelper;

@end

#pragma mark ------------------------JNUploadFile----------------------------------
// 文件管理
@interface JNUploadFile : NSObject

@property (nonatomic, strong) NSString* filePath;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSData *data;

- (instancetype)initWithFile:(NSString *)filePath key:(NSString *)key token:(NSString *)token;
- (instancetype)initWithData:(NSData *)data key:(NSString *)key token:(NSString *)token;

@end

#pragma mark ------------------------JNUploadManager----------------------------------

@interface JNUploadManager : NSObject


//单例
+ (instancetype)defaultUploader;


/**
 *    上传文件
 *
 *    @param filePath          文件路径
 *    @param key               上传到云存储的key，为nil时表示是由七牛生成
 *    @param token             上传需要的token, 由服务器生成
 *    @param completionHandler 上传完成后的回调函数
 *    @param progressHandler   上传进度回调函数
 */
- (void)uploadFile:(NSString *)filePath
                  key:(NSString *)key
                token:(NSString *)token
      progressHandler:(JNUpProgressHandler)progressHandler
             complete:(JNUpCompletionHandler)completionHandler;


/**
 *    直接上传数据(图片)
 *
 *    @param data              待上传的数据
 *    @param key               上传到云存储的key，为nil时表示是由七牛生成
 *    @param token             上传需要的token, 由服务器生成
 *    @param completionHandler 上传完成后的回调函数
 *    @param progressHandler   上传进度回调函数
 */
- (void)putData:(NSData *)data
               key:(NSString *)key
             token:(NSString *)token
   progressHandler:(JNUpProgressHandler)progressHandler
          complete:(JNUpCompletionHandler)completionHandler;


/**
 上传多张图片
 
 @param imagesArray 图片数组
 @param keys 文件名数组
 @param token token
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
- (void)uploadImages:(NSArray <UIImage *>*)imagesArray
                   keys:(NSArray <NSString *>*)keys
                  token:(NSString *)token
               progress:(void (^)(CGFloat percent))progress
                success:(void (^)(NSString *imageKeys))success
                failure:(void (^)(void))failure;


//取消上传某个文件;
- (void)cancelUploadWithType:(JNUploadType)type;

//继续上传某个文件
- (void)continueUploadWithType:(JNUploadType)type;


@end
