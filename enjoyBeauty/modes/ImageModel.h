//
//  ImageModel.h
//  enjoyBeauty
//
//  Created by 薛永伟 on 2017/4/23.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, imageSizeType) {
    imageSizeTypeSmall,
    imageSizeTypeNormal,
    imageSizeTypeOriginal,
};
@interface ImageModel : NSObject
@property (nonatomic,copy) NSString *pin_id;
@property (nonatomic,assign) NSInteger width;
@property (nonatomic,assign) NSInteger height;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *key;
@property (nonatomic,copy)NSString *bucket;
-(NSString *)imageUrlWithSizeTye:(imageSizeType)type;
@end
