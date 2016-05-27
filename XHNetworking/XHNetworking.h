//
//  XHNetworking.h

//  Copyright (c) 2016 XHNetworking (https://github.com/CoderZhuXH/XHNetworking)

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
