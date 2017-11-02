//
//  BeautyListRequest.h
//  enjoyBeauty
//
//  Created by xueyognwei on 2017/4/25.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeautyListRequest : NSObject
@property (nonatomic,strong) NSMutableArray *dataSource;
//@property (nonatomic,assign)NSInteger page;
@property (nonatomic,copy) NSString *max;
@property (nonatomic,copy) NSString *baseUrl;
+(instancetype)shareInstance;
-(void)requestNextPage:(void (^)(BOOL sucess))Complete;
-(void)setViewMaxID:(NSString *)maxID;
@end
