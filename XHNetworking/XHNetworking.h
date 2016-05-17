//
//  XHNetworking.h
//  XHNetworkingExample
//
//  Created by xiaohui on 15/10/29.
//  Copyright © 2015年 qiantou. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface XHNetworkCache : NSObject

/**
 *  手动写入/更新缓存
 *
 *  @param jsonResponse 要写入的数据
 *  @param URL    请求URL
 *
 *  @return 是否写入成功
 */
+(BOOL)saveJsonResponseToCacheFile:(id)jsonResponse andURL:(NSString *)URL;

/**
 *  获取缓存的对象
 *
 *  @param URL 请求URL
 *
 *  @return 缓存对象
 */
+(id )cacheJsonWithURL:(NSString *)URL;

@end


/**
 *  成功
 */
typedef void(^httpRequestSucess) (id responseObject);
/**
 *  失败
 */
typedef void(^httpRequestFailed) (NSError *error);

/**
 *  缓存
 */
typedef void(^httpRequestCache) (id jsonCache);


@interface XHNetworking : NSObject

/**
 *  POST请求
 *
 *  @param URL     URL String
 *  @param dic     参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)POST:(NSString *)URL parameters:(NSDictionary *)dic success:(httpRequestSucess)success failure:(httpRequestFailed)failure;


/**
 *  POST请求,自动缓存
 *
 *  @param URL       URL String
 *  @param dic       参数
 *  @param jsonCache 缓存回调
 *  @param success   成功回调
 *  @param failure   失败回调
 */
+(void)POST:(NSString *)URL parameters:(NSDictionary *)dic jsonCache:(httpRequestCache)jsonCache  success:(httpRequestSucess)success failure:(httpRequestFailed)failure;


/**
 *  GET请求
 *
 *  @param URL     URL String
 *  @param dic     参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+(void)GET:(NSString *)URL parameters:(NSDictionary *)dic success:(httpRequestSucess)success failure:(httpRequestFailed)failure;

/**
 *  GET请求,自动缓存
 *
 *  @param URL           URL String
 *  @param dic           参数
 *  @param jsonCache 缓存回调
 *  @param success       成功回调
 *  @param failure       失败回调
 */
+(void)GET:(NSString *)URL parameters:(NSDictionary *)dic  jsonCache:(httpRequestCache)jsonCache success:(httpRequestSucess)success failure:(httpRequestFailed)failure;

@end
