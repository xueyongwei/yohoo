//
//  BeautyListRequest.m
//  enjoyBeauty
//
//  Created by xueyognwei on 2017/4/25.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "BeautyListRequest.h"
#import "AFHTTPSessionManager+ShareManger.h"
#import "ImageModel.h"
//#import <NSObject+YYModel.h>
#import <YYKit.h>
@interface BeautyListRequest()
@property (nonatomic,assign) BOOL requesting;
//@property (nonatomic,copy) NSString *max;
//@property (nonatomic,copy) NSString *baseUrl;
@end
@implementation BeautyListRequest
static BeautyListRequest *request = nil;
-(NSString *)boadrUrl{
    return self.max.length>1?[self.baseUrl stringByAppendingString:[@"&max=" stringByAppendingString:self.max]]:self.baseUrl;
}
+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[self alloc]init];
        request.max = [[NSUserDefaults standardUserDefaults] objectForKey:@"RequestMaxString"];
    });
    return request;
}

-(void)setViewMaxID:(NSString *)maxID{
    [[NSUserDefaults standardUserDefaults] setObject:maxID forKey:self.baseUrl];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(void)setBaseUrl:(NSString *)baseUrl
{
    _baseUrl = baseUrl;
    [self.dataSource removeAllObjects];
}
-(void)requestNextPage:(void (^)(BOOL sucess))Complete
{
    if (self.requesting) {
        return;
    }
    self.requesting  = YES;
    
    NSString *url= [self boadrUrl];
    NSLog(@"reauest url %@",url);
    [[AFHTTPSessionManager sharedManager]GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *pins = [responseObject objectForKey:@"pins"];
        for (NSDictionary *pin in pins) {
            NSNumber *pin_id = pin[@"pin_id"];
            NSDictionary *file = pin[@"file"];
            ImageModel *image = [ImageModel modelWithDictionary:file];
            image.pin_id = pin_id.stringValue;
            [self.dataSource addObject:image];
            [self preloadSmallImage:image];
        }
//        self.page++;
        self.requesting  = NO;
        ImageModel *lastImage = self.dataSource.lastObject;
//        ImageModel *firstImage = self.dataSource.firstObject;
        self.max = pins.count>0?lastImage.pin_id:nil;
        if (Complete) {
            Complete(YES);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.requesting  = NO;
        NSLog(@"%@",error.localizedDescription);
        if (Complete) {
            Complete(NO);
        }
    }];
}


/**
 预加载小图，并毛玻璃

 @param model 要请求的model
 */
-(void)preloadSmallImage:(ImageModel *)model{
    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:[model imageUrlWithSizeTye:imageSizeTypeSmall]] options:YYWebImageOptionAllowInvalidSSLCertificates progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
//        return [image imageByBlurSoft];
        return [image imageByBlurRadius:5 tintColor:[UIColor clearColor] tintMode:kCGBlendModeNormal saturation:1.2 maskImage:nil];

    } completion:nil];
}

-(void)preloadOrgImage:(ImageModel *)model{
    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:[model imageUrlWithSizeTye:imageSizeTypeOriginal]] options:YYWebImageOptionAllowInvalidSSLCertificates progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
    }];
}
@end
