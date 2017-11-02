//
//  AFHTTPSessionManager+ShareManger.m
//  enjoyBeauty
//
//  Created by 薛永伟 on 2017/4/23.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "AFHTTPSessionManager+ShareManger.h"

@implementation AFHTTPSessionManager (ShareManger)

+(AFHTTPSessionManager *)sharedManager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = 30.0;
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    });
    return manager;
}

@end
