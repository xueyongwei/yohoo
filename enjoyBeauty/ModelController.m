//
//  ModelController.m
//  enjoyBeauty
//
//  Created by 薛永伟 on 2017/4/23.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "ModelController.h"
#import "DataViewController.h"
#import "AFHTTPSessionManager+ShareManger.h"
#import <NSObject+YYModel.h>
#import "ImageModel.h"
#import "BeautyListRequest.h"
//#import <AFNetworking.h>

#define khuabanBeautyUrl = @"http://api.huaban.com/favorite/beauty"

@interface ModelController ()

@end

@implementation ModelController


- (instancetype)init {
    self = [super init];
    if (self) {
//        [self prepareData];
    }
    return self;
}
-(NSMutableArray *)pageData{
    return [BeautyListRequest shareInstance].dataSource;
}
-(BeautyListRequest *)request{
    return [BeautyListRequest shareInstance];
}
- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
//    if ([self.pageData count] == 0) {
//        return nil;
//    }
    // Create a new view controller and pass suitable data.
    DataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
//    dataViewController.dataObject = self.pageData[index];
    if (index < [self.pageData count]) {
        dataViewController.imageModel = self.pageData[index];
        dataViewController.index = index;
    }
    
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(DataViewController *)viewController {
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.imageModel];
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    if (index+5>[self pageData].count) {
        NSLog(@"请求下一页数据");
        [self.request requestNextPage:nil];
    }
    index++;
    if (index == [[self pageData]count]) {
        index =0;
    }
    //不管有没有数据，都给这个新的vc，没有数据再加载
//    if (index == [self.pageData count]) {
//        return nil;
//    }
    if (!((DataViewController *)viewController).haveAppear) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
