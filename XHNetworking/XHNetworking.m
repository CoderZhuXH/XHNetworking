//
//  XHNetworking.m
//  XHNetworkingExample
//
//  Created by xiaohui on 15/10/29.
//  Copyright © 2015年 qiantou. All rights reserved.
//  https://github.com/CoderZhuXH/XHNetworking

#import "XHNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFHTTPSessionManager.h"

#ifdef DEBUG
#define DebugLog(...) NSLog(__VA_ARGS__)
#else
#define DebugLog(...)
#endif


#pragma mark-@interface XHNetworkCache
@interface XHNetworkCache()


@end

@implementation XHNetworkCache


+(BOOL)saveJsonResponseToCacheFile:(id)jsonResponse andURL:(NSString *)URL
{
    NSDictionary *json = jsonResponse;
    BOOL success;
    if(json!=nil)
    {
        success =[NSKeyedArchiver archiveRootObject:jsonResponse toFile:[self cacheFilePathWithURL:URL]];
    }
    if(success)
    {
        DebugLog(@"缓存写入/更新成功");
    }
    return success;
}

+(id )cacheJsonWithURL:(NSString *)URL
{
    NSString *path = [self cacheFilePathWithURL:URL];
    id cacheJson;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil] == YES) {
        cacheJson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    return cacheJson;
}

+ (NSString *)cacheFilePathWithURL:(NSString *)URL {
    
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"XHNetworkCache"];
    
    [self checkDirectory:path];//check路径
    DebugLog(@"path = %@",path);
    
    //文件名
    NSString *cacheFileNameString = [NSString stringWithFormat:@"URL:%@ AppVersion:%@",URL,[self appVersionString]];
    NSString *cacheFileName = [self md5StringFromString:cacheFileNameString];
    path = [path stringByAppendingPathComponent:cacheFileName];
    return path;
}

+(void)checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}

+ (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (error) {
        DebugLog(@"create cache directory failed, error = %@", error);
    } else {
        
        [self addDoNotBackupAttribute:path];
    }
}
+ (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        DebugLog(@"error to set do not backup attribute, error = %@", error);
    }
}

+ (NSString *)md5StringFromString:(NSString *)string {
    
    if(string == nil || [string length] == 0)  return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}
+ (NSString *)appVersionString {
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
@end

#pragma mark- @interface XHNetworking
@interface XHNetworking()

@end
@implementation XHNetworking

+(AFHTTPSessionManager *)createManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //申明请求类型:HTTP
    //(AFJSONRequestSerializer,AFHTTPRequestSerializer)
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //申明返回的结果:JSON
    //AFJSONResponseSerializer,AFHTTPResponseSerializer
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    return manager;
}
/**
 *  POST请求
 */
+(void)POST:(NSString *)URL parameters:(NSDictionary *)dic  success:(httpRequestSucess)success failure:(httpRequestFailed)failure
{
    AFHTTPSessionManager *manager = [self createManager];
    [manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DebugLog(@"error=%@",error);
        
        failure(error);
    }];
}

/**
 *  POST请求,自动缓存
 */
+(void)POST:(NSString *)URL parameters:(NSDictionary *)dic jsonCache:(httpRequestCache)jsonCache  success:(httpRequestSucess)success failure:(httpRequestFailed)failure;
{
    //缓存
    jsonCache([XHNetworkCache cacheJsonWithURL:URL]);
    
    AFHTTPSessionManager *manager = [self createManager];
    [manager POST:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);

        [XHNetworkCache saveJsonResponseToCacheFile:responseObject andURL:URL];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DebugLog(@"error=%@",error);
        
        failure(error);
    }];
}

/**
 *  GET请求
 */
+(void)GET:(NSString *)URL parameters:(NSDictionary *)dic success:(httpRequestSucess)success failure:(httpRequestFailed)failure
{
    AFHTTPSessionManager *manager = [self createManager];
    [manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DebugLog(@"error=%@",error);
        
        failure(error);
        
    }];
}

/**
 *  GET请求,自动缓存
 */
+(void)GET:(NSString *)URL parameters:(NSDictionary *)dic  jsonCache:(httpRequestCache)jsonCache success:(httpRequestSucess)success failure:(httpRequestFailed)failure{
    
    //缓存
    jsonCache([XHNetworkCache cacheJsonWithURL:URL]);
    
    AFHTTPSessionManager *manager = [self createManager];
    [manager GET:URL parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
      
        [XHNetworkCache saveJsonResponseToCacheFile:responseObject andURL:URL];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DebugLog(@"error=%@",error);
        
        failure(error);
        
    }];
    
}
@end
