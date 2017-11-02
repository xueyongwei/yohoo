//
//  ImageModel.m
//  enjoyBeauty
//
//  Created by 薛永伟 on 2017/4/23.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "ImageModel.h"

static NSString *const  baseImage = @"http://img.hb.aicdn.com/";
static NSString *const  baseFile = @"http://hbfile.b0.upaiyun.com/";
static NSString *const  baseTopic = @"http://hb-topic-img.b0.upaiyun.com/";


//let imageSize192 = "_fw192"
//let imageSize320 = "_fw320"
//let imageSize554 = "_fw554"
//let imageSize658 = "_fw658"
@implementation ImageModel
-(NSString *)imageSizeOfType:(imageSizeType)type{
    NSArray *sizes = @[@"_fw192",@"_fw320",@""];
    return sizes[type];
}
-(NSString *)imageUrlWithSizeTye:(imageSizeType)type{
    NSString *baseUrl = [self imageBaseUrl];
    NSString *typeImageUrl = [NSString stringWithFormat:@"%@%@%@",baseUrl,self.key,[self imageSizeOfType:type]];
    return typeImageUrl;
//    return [[self imageBaseUrl] stringByAppendingFormat:@"%@%@",self.key,[self imageUrlWithSizeTye:type]];
    
//    switch (type) {
//        case imageSizeTypeSmall:
//        {
//            return [[[self imageBaseUrl]stringByAppendingPathComponent:self.key]stringByAppendingString:@""];
//        }
//            break;
//        case imageSizeTypeNormal:
//        {
//            return [[[self imageBaseUrl]stringByAppendingPathComponent:self.key]stringByAppendingString:@""];
//        }
//            break;
//        default:{
//            return [[[self imageBaseUrl]stringByAppendingPathComponent:self.key]stringByAppendingString:@""];
//        }
//            break;
//    }
//    return nil;
}
-(NSString *)imageBaseUrl{
    if ([self.bucket isEqualToString:@"hb-topic-img"]) {
        return baseTopic;
    }else if ([self.bucket isEqualToString:@"hbfile"]){
        return baseFile;
    }else{
        return baseImage;
    }
}
@end
