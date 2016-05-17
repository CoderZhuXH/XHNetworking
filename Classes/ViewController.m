//
//  ViewController.m
//  XHNetworkingExample
//
//  Created by xiaohui on 16/5/16.
//  Copyright © 2016年 qiantou. All rights reserved.
//

#import "ViewController.h"

#import "CacheViewController.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/**
 *  POST/GET请求,手动缓存
 */
- (IBAction)cacheAction:(UIButton *)sender {
    
    CacheViewController *controller = [[CacheViewController alloc] init];
    controller.cacheType = CacheTypeNormal;
    [self.navigationController pushViewController:controller animated:YES];
    
}

/**
 *  POST/GET请求,自动缓存
 */
- (IBAction)autoCacheAction:(UIButton *)sender {

    CacheViewController *controller = [[CacheViewController alloc] init];
    controller.cacheType = CacheTypeAuto;
    [self.navigationController pushViewController:controller animated:YES];
 
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
