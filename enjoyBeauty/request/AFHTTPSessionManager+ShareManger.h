//
//  AFHTTPSessionManager+ShareManger.h
//  enjoyBeauty
//
//  Created by 薛永伟 on 2017/4/23.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface AFHTTPSessionManager (ShareManger)
+(AFHTTPSessionManager *)sharedManager;
@end
