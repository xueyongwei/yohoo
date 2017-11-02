//
//  DataViewController.m
//  enjoyBeauty
//
//  Created by 薛永伟 on 2017/4/23.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "DataViewController.h"
#import <UIImageView+YYWebImage.h>
#import <UIImage+YYAdd.h>
#import "BeautyListRequest.h"
@interface DataViewController ()
//@property (weak, nonatomic) IBOutlet VICMAImageView *VimageView;
@property (weak, nonatomic) IBOutlet HZPhotoBrowserView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong)UIImage *currentImage;
@end

@implementation DataViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *imageSmallStr = [self.imageModel imageUrlWithSizeTye:imageSizeTypeSmall];
    
    self.imageView.imageview.image = nil;
    
    [self.bgImageView setImageWithURL:[NSURL URLWithString:imageSmallStr] placeholder:nil options:YYWebImageOptionProgressiveBlur manager:nil progress:nil transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
//        return [image imageByBlurSoft];
        return [image imageByBlurRadius:5 tintColor:[UIColor clearColor] tintMode:kCGBlendModeNormal saturation:1.2 maskImage:nil];
    } completion:nil];
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.haveAppear = YES;
    NSString *imageStr = [self.imageModel imageUrlWithSizeTye:imageSizeTypeOriginal];
    [self.imageView setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil];
    [[BeautyListRequest shareInstance] setViewMaxID:self.imageModel.pin_id];
//    [self.imageView animateShowImage];
//    [UIView animateWithDuration:0.5 animations:^{
//        self.imageView.scrollview.zoomScale = 1.02;
//    } completion:^(BOOL finished) {
//        if (finished) {
//            [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                self.imageView.scrollview.zoomScale = 1.0;
//            } completion:^(BOOL finished) {
//                self.view.userInteractionEnabled = YES;
//            }];
//        }
//    }];
//    [UIView animateWithDuration:1.0 animations:^{
//        self.imageView.scrollview.zoomScale = 1.5;
////        [self.imageView.scrollview setZoomScale:1.5 animated:YES];
//    }];
    
//    [self showImageAnimate];
}
-(void)showImageAnimate{
//    if (self.currentImage) {
//        
//        self.imageView.image = self.currentImage;
////        [UIView animateWithDuration:0.5 animations:^{
////            
////        } completion:^(BOOL finished) {
////            
////        }];
//        [UIView animateWithDuration:0.5 animations:^{
//            self.imageView.alpha = 1;
//        } completion:nil];
//    }else{
//        dispatch_after(0.5, dispatch_get_main_queue(), ^{
//            [self showImageAnimate];
//        });
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"被释放了");
}

@end
