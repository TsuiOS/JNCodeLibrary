//
//  JNUploadManager.m
//  JNCodeLibrary
//
//  Created by xuning on 2018/5/15.
//  Copyright © 2018年 Hsu. All rights reserved.
//

#import "JNUploadManager.h"
#import <HappyDNS.h>

#pragma mark ------------------------JNUploadHelper----------------------------------
@implementation JNUploadHelper
static id _instance = nil;
+ (id)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedUploadHelper {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    
    return _instance;
}
@end


#pragma mark ------------------------JNUploadFile----------------------------------

@implementation JNUploadFile


- (instancetype)initWithFile:(NSString *)filePath key:(NSString *)key token:(NSString *)token {
    if (self = [self init]) {
        self.filePath = filePath;
        self.key = key;
        self.token = token;
    }
    return self;
    
}

- (instancetype)initWithData:(NSData *)data key:(NSString *)key token:(NSString *)token {
    if (self = [self init]) {
        self.data = data;
        self.key = key;
        self.token = token;
    }
    return self;
    
}

@end

#pragma mark ------------------------JNUploadHelper----------------------------------

@interface JNUploadManager ()

@property (nonatomic, strong) QNUploadManager *upmanager;

// 上传完成的回调函数
@property (nonatomic, copy) JNUpCompletionHandler completionHandler;
// 上传进度的回调函数
@property (nonatomic, copy) JNUpProgressHandler progressHandler;

// 上传进度
@property (nonatomic, assign) CGFloat percent;

// 视频上传是否取消
@property (nonatomic, assign, getter=isCancelFlag) BOOL cancelFlag;

// data上传是否取消
@property (nonatomic, assign, getter=isDataCancelFlag) BOOL dataCancelFlag;
// 当前上传信息(便于继续上传)
@property (nonatomic, strong) JNUploadFile *file;
@property (nonatomic, strong) JNUploadFile *dateFile;

@end

@implementation JNUploadManager

//单例
+ (instancetype)defaultUploader {
    
    static JNUploadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

- (void)uploadFile:(NSString *)filePath
                  key:(NSString *)key
                token:(NSString *)token
      progressHandler:(JNUpProgressHandler)progressHandler
             complete:(JNUpCompletionHandler)completionHandler {
    
    self.file = [[JNUploadFile alloc]initWithFile:filePath key:key token:token];
    self.completionHandler = completionHandler;
    self.progressHandler = progressHandler;
    [self uploadFile:filePath key:key token:token];
    
}

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
          complete:(JNUpCompletionHandler)completionHandler {
    
    self.dateFile = [[JNUploadFile alloc]initWithData:data key:key token:token];
    self.completionHandler = completionHandler;
    self.progressHandler = progressHandler;
    [self uploadData:data key:key token:token];
    
}
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
                failure:(void (^)(void))failure {
    
    
    // 安全判断
    if (imagesArray.count > keys.count) {
        NSLog(@"图片上传超出限制");
        return;
    }
    
    NSMutableString *allKeys = [[NSMutableString alloc]init];
    
    __block CGFloat totalProgress = 0.0f;
    __block CGFloat partProgress = 1.0f / [imagesArray count];
    __block NSUInteger currentIndex = 0;
    
    
    JNUploadHelper *uploadHelper = [JNUploadHelper sharedUploadHelper];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    uploadHelper.progressHandler = ^(NSString *key, float percent) {
        if (progress) {
            progress(partProgress);
        }
    };
    uploadHelper.completionHandler = ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.ok) {
            [allKeys appendFormat:@"%@", [NSString stringWithFormat:@"%@,",key]];
            totalProgress += partProgress;
            currentIndex ++;
            if (currentIndex == imagesArray.count) { // 上传完成
                if (success) {
                    success(allKeys.copy);
                }
            }else{
                if (currentIndex < imagesArray.count) { // 安全判断
                    NSString *currentKey = [NSString stringWithFormat:@"%@%@",keys[currentIndex],[self suffixWith:imagesArray[currentIndex]]];
                    [self putData:[self imgTurnDataWithImage:imagesArray[currentIndex]] key:currentKey token:token progressHandler:weakHelper.progressHandler complete:weakHelper.completionHandler];
                }
            }
        }else{ // 失败处理
            if (failure) {
                failure();
            }
        }
        
    };
    
    NSString *key = [NSString stringWithFormat:@"%@%@",keys.firstObject,[self suffixWith:imagesArray.firstObject]];
    [self putData:[self imgTurnDataWithImage:imagesArray.firstObject] key:key token:token progressHandler:uploadHelper.progressHandler complete:uploadHelper.completionHandler];
    
    
}

/**
 图片格式
 
 @param image 图片
 @return 格式
 */
- (NSString *)suffixWith:(UIImage *)image
{
    NSString *suffixTemp = @".jpg";
    
    if (UIImageJPEGRepresentation(image,1) == nil)
    {
        suffixTemp = @".png";
    }
    return suffixTemp;
}



/**
 图片二进制数据
 
 @param image 图片
 @return 二进制数据
 */
- (NSData *)imgTurnDataWithImage:(UIImage *)image
{
    NSData *data;
    if (UIImageJPEGRepresentation(image,0.5) == nil) {
        
        data = UIImagePNGRepresentation(image);
        
    } else {
        
        data = UIImageJPEGRepresentation(image,0.5);
    }
    return data;
}



- (void)uploadFile:(NSString *)filePath key:(NSString *)key token:(NSString *)token {
    
    // 记录本次上传任务
    self.cancelFlag = NO;
    
    // 上传过程中实时执行此函数
    QNUploadOption *uploadOption = [[QNUploadOption alloc]initWithMime:nil progressHandler:^(NSString *key, float percent) {
        // 上传进度
        self.percent = percent;
        // 上传进度
        self.progressHandler(key, percent);
    } params:nil checkCrc:NO cancellationSignal:^BOOL{
        //上传中途取消函数 如果想取消，返回True, 否则返回No
        return self.cancelFlag;
    }];
    
    [self.upmanager putFile:filePath key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        // 完成回调
        self.completionHandler(info, key, resp);
        if (info.ok) { // 请求成功
            self.file = nil;
        }else{ // 请求失败, 这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
            
        }
    } option:uploadOption];
}

- (void)uploadData:(NSData *)data key:(NSString *)key token:(NSString *)token {
    
    self.dataCancelFlag = NO;
    
    QNUploadOption *uploadOption = [[QNUploadOption alloc]initWithMime:nil progressHandler:^(NSString *key, float percent) {
        self.progressHandler(key, percent);
    } params:nil checkCrc:NO cancellationSignal:^BOOL{
        return self.dataCancelFlag;
    }];
    
    [self.upmanager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        self.completionHandler(info,key,resp);
        
    } option:uploadOption];
    
}

// 取消上传
- (void) cancelUploadWithType:(JNUploadType)type {
    if (type == JNUploadVideo) {
        self.cancelFlag = YES;
    }else{
        self.dataCancelFlag = YES;
    }
    
}

// 继续上传
- (void) continueUploadWithType:(JNUploadType)type {
    if (type == JNUploadVideo) {
        self.cancelFlag = NO;
        [self uploadFile:self.file.filePath key:self.file.key token:self.file.token];
    }else{
        self.dataCancelFlag = NO;
        [self uploadData:self.dateFile.data key:self.dateFile.key token:self.dateFile.token];
    }
    
}



#pragma mark - lazy
- (QNUploadManager *)upmanager {
    if (_upmanager == nil) {
        QNConfiguration *config =[QNConfiguration build:^(QNConfigurationBuilder *builder) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:[QNResolver systemResolver]];
            QNDnsManager *dns = [[QNDnsManager alloc] init:array networkInfo:[QNNetworkInfo normal]];
            builder.dns = dns;
            //是否选择  https  上传
            //            builder.zone = [[QNAutoZone alloc] initWithHttps:YES dns:dns];
            builder.useHttps = YES;
            //设置断点续传
            NSError *error;
            builder.recorder =  [QNFileRecorder fileRecorderWithFolder:[NSTemporaryDirectory() stringByAppendingString:@"JNUploadFileRecord"] error:&error];
        }];
        
        _upmanager = [[QNUploadManager alloc]initWithConfiguration:config];
        
    }
    
    return _upmanager;
}

@end

