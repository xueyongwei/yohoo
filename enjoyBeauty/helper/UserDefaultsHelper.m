//
//  UserDefaultsHelper.m
//  enjoyBeauty
//
//  Created by 薛永伟 on 2017/4/29.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "UserDefaultsHelper.h"

@implementation UserDefaultsHelper
//+ (void)setUsf:(id)value forKey:(id)key{
//    [[NSUserDefaults standardUserDefaults]setValue:value forKey:key];
//}
//+(id)usfForKey:(id)key{
//    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
//}
+(NSUserDefaults *)userDefaults{
    
    return [NSUserDefaults standardUserDefaults];
}


+(void)setViewType:(viewerStyle)style{
    [[self userDefaults] setInteger:style forKey:@"viewerStyle"];
    [[self userDefaults] synchronize];
}
+(viewerStyle)currentViewerStyle{
    return [[self userDefaults] integerForKey:@"viewerStyle"];
}


+(void)setQuickBtnShow:(BOOL)show{
    [[self userDefaults]setBool:show forKey:@"QuickBtnShow"];
    
}
+(BOOL)showQuickBtn{
    return [[self userDefaults] boolForKey:@"QuickBtnShow"];
}
@end
