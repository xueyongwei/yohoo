//
//  DataViewController.h
//  enjoyBeauty
//
//  Created by 薛永伟 on 2017/4/23.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageModel.h"
#import <VICMAImageView.h>
#import "HZPhotoBrowserView.h"
@interface DataViewController : UIViewController
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,assign) BOOL haveAppear;
//@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
//@property (strong, nonatomic) id dataObject;
@property (strong, nonatomic) ImageModel *imageModel;

@end

