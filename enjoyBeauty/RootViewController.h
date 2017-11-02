//
//  RootViewController.h
//  enjoyBeauty
//
//  Created by 薛永伟 on 2017/4/23.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic,strong)UIImage *placeHoldImage;
@property (nonatomic,copy) NSString *baseUrl;
@end

