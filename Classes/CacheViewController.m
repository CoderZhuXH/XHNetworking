//
//  CacheViewController.m
//  XHNetworkingExample
//
//  Created by xiaohui on 16/5/17.
//  Copyright © 2016年 qiantou. All rights reserved.
//

#import "CacheViewController.h"
#import "XHNetworking.h"

#define RequestURL  @"http://www.qinto.com/wap/index.php?ctl=article_cate&act=api_app_getarticle_cate&num=1&p=1"
#define RequestURL1 @"http://www.qinto.com/wap/index.php?ctl=article_cate&act=api_app_getarticle_cate&num=1&p=2"


@interface CacheViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cacheDataLab;

@property (weak, nonatomic) IBOutlet UILabel *requestDataLab;
@end

@implementation CacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_cacheType==CacheTypeNormal)
    {
        /**
         *  POST 请求,手动缓存
         */
        [self post];
        
        /**
         *  GET 请求,手动缓存
         */
       // [self get];
        
    }
    else
    {
        
        /**
         *  POST 请求,自动缓存
         */
        [self postAndCache];
        
        /**
         *  GET 请求,自动缓存
         */
        //[self getAndCache];
        
    }
    
    // Do any additional setup after loading the view from its nib.
}

/**
 *  POST 请求,自动缓存
 */
-(void)postAndCache
{
    [XHNetworking POST:RequestURL parameters:nil jsonCache:^(id cache) {
        
        //缓存
        NSLog(@"缓存:\n%@",cache);
        //缓存取数据
        _cacheDataLab.text = [self toJSONString:cache];
        
    } success:^(id responseObject) {
        
        //成功
        NSLog(@"success:%@\n",responseObject);
        //刷新数据
        _requestDataLab.text = [self toJSONString:responseObject];
        
    } failure:^(NSError *error) {
        
        //失败
        NSLog(@"error:%@\n",error);
        
    }];
}
/**
 *  GET 请求,自动缓存
 */
-(void)getAndCache
{
    
    [XHNetworking GET:RequestURL parameters:nil jsonCache:^(id cache) {
        
        //缓存
        NSLog(@"缓存:\n%@",cache);
        //缓存取数据
        _cacheDataLab.text = [self toJSONString:cache];
        
    } success:^(id responseObject) {
        
        //成功
        NSLog(@"success:%@\n",responseObject);
        
        //刷新数据
         _requestDataLab.text = [self toJSONString:responseObject];
        
    } failure:^(NSError *error) {
        
        //失败
        NSLog(@"error:%@\n",error);
        
    }];
}

/**
 *  POST 请求,手动缓存
 */
-(void)post{
    
    NSString *URL =RequestURL1;
    //手动获取缓存
    NSDictionary *cache = [XHNetworkCache cacheJsonWithURL:URL];
    //缓存取数据
     _cacheDataLab.text = [self toJSONString:cache];
    
    NSLog(@"缓存:\n%@",cache);
    
    [XHNetworking POST:URL parameters:nil success:^(id responseObject) {
        
        //成功
        NSLog(@"success:%@\n",responseObject);
        
        //刷新数据
         _requestDataLab.text = [self toJSONString:responseObject];
        
        //手动写入/更新缓存
        [XHNetworkCache saveJsonResponseToCacheFile:responseObject andURL:URL];
        
        
    } failure:^(NSError *error) {
        
        //失败
        NSLog(@"error:%@\n",error);
        
    }];
    
}
/**
 *  GET 请求,手动缓存
 */
-(void)get{
    
    NSString *URL =RequestURL1;
    //手动获取缓存
    NSDictionary *cache = [XHNetworkCache cacheJsonWithURL:URL];
    
    //缓存取数据
    _cacheDataLab.text = [self toJSONString:cache];
    
    NSLog(@"缓存:\n%@",cache);
    
    [XHNetworking GET:RequestURL parameters:nil success:^(id responseObject) {
        
        //成功
        NSLog(@"success:%@\n",responseObject);
        
        //刷新数据
        _requestDataLab.text = [self toJSONString:responseObject];
        
        //手动写入/更新缓存
        [XHNetworkCache saveJsonResponseToCacheFile:responseObject andURL:URL];
        
    } failure:^(NSError *error) {
        
        //失败
        NSLog(@"error:%@\n",error);
    }];
}

-(NSString *)toJSONString:(NSDictionary *)dic
{
    if(dic==nil) return nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
