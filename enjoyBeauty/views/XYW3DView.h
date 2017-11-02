//
//  XYW3DView.h
//  enjoyBeauty
//
//  Created by xueyognwei on 2017/5/19.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYW3DView : UIView
@property (nonatomic,strong)UIImage *image;
-(void)setImage:(UIImage *)image andTitle:(NSString *)title;
-(void)animationOnce;
@end
