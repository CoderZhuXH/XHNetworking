//
//  CacheViewController.h
//  XHNetworkingExample
//
//  Created by xiaohui on 16/5/17.
//  Copyright © 2016年 qiantou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,CacheType){
    
    CacheTypeNormal,
    CacheTypeAuto
};

@interface CacheViewController : UIViewController

@property (nonatomic, assign) CacheType cacheType;

@end
