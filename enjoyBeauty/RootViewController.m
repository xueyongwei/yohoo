//
//  RootViewController.m
//  enjoyBeauty
//
//  Created by 薛永伟 on 2017/4/23.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "RootViewController.h"
#import "ModelController.h"
#import "DataViewController.h"
#import "BeautyListRequest.h"
#import <YYKit.h>
#import <YYWebImageManager.h>
#import "ImageModel.h"
#import "InfoViewController.h"
#import "UserDefaultsHelper.h"
@interface RootViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (readonly, strong, nonatomic) ModelController *modelController;
@property ( strong, nonatomic) UILabel *naviTItle;
@end

@implementation RootViewController

@synthesize modelController = _modelController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavi];
    NSLog(@"创建个新的连接");
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) wkself = self;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = [UIColor darkGrayColor];
    } completion:^(BOOL finished) {
        
    }];
    NSString *maxID = [[NSUserDefaults standardUserDefaults] objectForKey:self.baseUrl];
    BeautyListRequest *request =[BeautyListRequest shareInstance];
    request.baseUrl = self.baseUrl;
    request.max = maxID;
    [request requestNextPage:^(BOOL sucess) {
        [wkself configPageVC];
    }];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(animateShowTitleView) name:@"ShowImageAnimate" object:nil];
    [self.navigationController.navigationBar setBackgroundImage:
     self.placeHoldImage forBarMetrics:UIBarMetricsDefault];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)animateShowTitleView{
    [self changeTitleColorWhti:self.naviTItle];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self changeTitleColorWhti:self.naviTItle];
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.naviTItle.alpha = 1;
    self.naviTItle.transform = CGAffineTransformMakeScale(1, 1);
    [self.naviTItle.layer removeAllAnimations];
}

-(void)customNavi{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    label.font = [UIFont fontWithName:@"SnellRoundhand" size:30];
    label.text = NSLocalizedString(@"YoHoo", ni);
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    label.textColor = [UIColor lightGrayColor];
    self.navigationItem.titleView = label;
    self.naviTItle = label;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNaviTitle:)];
    [label addGestureRecognizer:tap];
    
}
-(void)changeTitleColorWhti:(UILabel *)label{
    [label.layer removeAllAnimations];
    if ([label.text isEqualToString:NSLocalizedString(@"Click here to return", ni)]) {
        label.text = NSLocalizedString(@"YoHoo", ni);
        label.font = [label.font fontWithSize:30];
    }else{
        label.text =NSLocalizedString(@"Click here to return", ni);
        label.font = [label.font fontWithSize:18];
    }
//    label.text = [label.text isEqualToString:@"点我返回"]?@"YoHoo!":@"点我返回";
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeScale(0.9, 0.9);
        label.alpha = 0.3;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
                label.transform = CGAffineTransformMakeScale(1.0, 1.0);
                label.alpha = 1;
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self changeTitleColorWhti:label];
                });
            }];
        }
    }];
}
-(void)tapNaviTitle:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}
-(void)configPageVC{
//    Do any additional setup after loading the view, typically from a nib.
//    Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;
    
    self.pageViewController.dataSource = self.modelController;
    
    self.pageViewController.view.alpha = 0;
    
    DataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
    }
    self.pageViewController.view.frame = pageViewRect;
    
    [self.pageViewController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.pageViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (ModelController *)modelController {
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[ModelController alloc] init];
//        _modelController.pageData = self.pageData;
    }
    return _modelController;
}


#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
        
        UIViewController *currentViewController = self.pageViewController.viewControllers[0];
        NSArray *viewControllers = @[currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }

    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
    DataViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = nil;
    
    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
        UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
        viewControllers = @[currentViewController, nextViewController];
    } else {
        UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
        viewControllers = @[previousViewController, currentViewController];
    }
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    return UIPageViewControllerSpineLocationMid;
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
