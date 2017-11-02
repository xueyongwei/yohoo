//
//  HomeViewController.m
//  enjoyBeauty
//
//  Created by xueyognwei on 2017/5/18.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "HomeViewController.h"
#import "RootViewController.h"
#import <YYKit.h>
#import "XYW3DView.h"
//#import "UIViewController+WXSTransition.h"
#import "UINavigationController+WXSTransition.h"
@interface HomeViewController ()
//@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet XYW3DView *item1ImageView;
@property (weak, nonatomic) IBOutlet XYW3DView *item2ImageView;
@property (weak, nonatomic) IBOutlet XYW3DView *item3ImageView;
@property ( strong, nonatomic) UILabel *naviTItle;
@end

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.item1ImageView animationOnce];
//    [self.item2ImageView animationOnce];
//    [self.item3ImageView animationOnce];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
    [self customNavi];
}
-(NSArray *)baseUrls{
    return @[@"http://api.huaban.com/boards/28187419/pins/?limit=20",
             @"http://api.huaban.com/boards/15729161/pins/?limit=20",
      @"http://api.huaban.com/boards/19241298/pins/?limit=20"
      ];
}
-(void)customUI{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.item1ImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.item1ImageView.tag = 100;
    self.item1ImageView.layer.cornerRadius = 5;
    
    [self.item1ImageView setImage:[[UIImage imageNamed:@"lanch.JPG"] imageByBlurSoft]andTitle:NSLocalizedString(@"Recommend", nil)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageViewRecognizer:)];
    [self.item1ImageView addGestureRecognizer:tap1];
    
    self.item2ImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.item2ImageView.tag = 101;
    self.item2ImageView.layer.cornerRadius = 5;
    [self.item2ImageView setImage:[[UIImage imageNamed:@"2.jpeg"] imageByBlurSoft]andTitle:NSLocalizedString(@"Modern", nil)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageViewRecognizer:)];
    [self.item2ImageView addGestureRecognizer:tap2];
    
    self.item3ImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.item3ImageView.tag = 102;
    self.item3ImageView.layer.cornerRadius = 5;
    [self.item3ImageView setImage:[[UIImage imageNamed:@"1.jpeg"] imageByBlurSoft]andTitle:NSLocalizedString(@"Ancient costume", nil)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageViewRecognizer:)];
    [self.item3ImageView addGestureRecognizer:tap3];
    UIImage *bgImage = [[[UIImage imageNamed:@"lanch.JPG"]  imageByResizeToSize:self.view.bounds.size contentMode:UIViewContentModeScaleAspectFill] imageByBlurSoft];
//    UIImage *bgImage = [[UIImage imageNamed:@"bg"] imageByBlurRadius:10 tintColor:[UIColor clearColor] tintMode:kCGBlendModeNormal saturation:1.0 maskImage:nil];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
//    self.bgImageView.image = nil;
//    self.bgImageView.image = [[UIImage imageNamed:@"lanch.JPG"] imageByBlurRadius:30 tintColor:[UIColor clearColor] tintMode:kCGBlendModeNormal saturation:1.0 maskImage:nil];
}
-(void)customNavi{
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    label.font = [UIFont fontWithName:@"SnellRoundhand" size:30];
    label.text = @"Yohoo!";
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    self.naviTItle = label;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNaviTitle:)];
    [label addGestureRecognizer:tap];
    
}
-(void)tapNaviTitle:(UITapGestureRecognizer *)tap{
    [self changeTitleColorWhti:self.naviTItle];
}
-(void)changeTitleColorWhti:(UILabel *)label{
    [label.layer removeAllAnimations];
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeScale(0.9, 0.9);
        label.alpha = 0.3;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
                label.transform = CGAffineTransformMakeScale(1.0, 1.0);
                label.alpha = 1;
            } completion:^(BOOL finished) {
            }];
        }
    }];
}

-(void)tapImageViewRecognizer:(UITapGestureRecognizer *)recognizer{
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    RootViewController *rootVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RootViewController"];
    UIImage *currengImage = [((UIImageView *)recognizer.view).image imageByResizeToSize:CGSizeMake(YYScreenSize().width, 64) contentMode:UIViewContentModeScaleAspectFill];
    
    rootVC.placeHoldImage = [currengImage imageByBlurDark];
    rootVC.baseUrl = [[self baseUrls] objectAtIndex:recognizer.view.tag-100];
    [self wxs_presentViewController:[[UINavigationController alloc]initWithRootViewController:rootVC] makeTransition:^(WXSTransitionProperty *transition) {
        transition.animationType = WXSTransitionAnimationTypeViewMoveNormalToNextVC;
        transition.animationTime = 0.6;
//        transition.autoShowAndHideNavBar = NO;
        transition.startView  = recognizer.view;
        transition.targetView = rootVC.navigationController.navigationBar;
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
