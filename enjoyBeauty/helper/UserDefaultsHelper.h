//
//  UserDefaultsHelper.h
//  enjoyBeauty
//
//  Created by 薛永伟 on 2017/4/29.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, viewerStyle) {
    viewerStyleBeauty,
    viewerStyleFuny,
};
@interface UserDefaultsHelper : NSObject
+(void)setViewType:(viewerStyle)style;
+(viewerStyle)currentViewerStyle;

+(void)setQuickBtnShow:(BOOL)show;
+(BOOL)showQuickBtn;
@end
