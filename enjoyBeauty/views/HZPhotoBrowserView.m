//
//  HZPhotoBrowserView.m
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "HZPhotoBrowserView.h"
#import "HZPhotoBrowserConfig.h"
#import <YYKit.h>

@interface HZPhotoBrowserView() <UIScrollViewDelegate>
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, assign) BOOL hasLoadedImage;//图片下载成功为YES 否则为NO
@property (nonatomic, assign) BOOL showImageing;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) UIImage *placeHolderImage;
//@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIButton *reloadButton;
@end

@implementation HZPhotoBrowserView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollview];
        //添加单双击事件
        [self addGestureRecognizer:self.doubleTap];
        [self addGestureRecognizer:self.singleTap];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addSubview:self.scrollview];
        //添加单双击事件
        [self addGestureRecognizer:self.doubleTap];
        [self addGestureRecognizer:self.singleTap];
    }
    return self;
}
- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.frame = self.bounds;
        [_scrollview addSubview:self.imageview];
        _scrollview.delegate = self;
        _scrollview.clipsToBounds = YES;
    }
    return _scrollview;
}

- (UIImageView *)imageview
{
    if (!_imageview) {
        _imageview = [[UIImageView alloc] init];
        _imageview.frame = self.bounds;
        _imageview.userInteractionEnabled = YES;
        _imageview.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageview;
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired  =1;
    }
    return _doubleTap;
}

- (UITapGestureRecognizer *)singleTap
{
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        //只能有一个手势存在
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
        
    }
    return _singleTap;
}

#pragma mark 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    //图片加载完之后才能响应双击放大
    if (!self.hasLoadedImage) {
        return;
    }
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scrollview.zoomScale <= 1.0) {
        
        CGFloat scaleX = touchPoint.x + self.scrollview.contentOffset.x;//需要放大的图片的X点
        CGFloat sacleY = touchPoint.y + self.scrollview.contentOffset.y;//需要放大的图片的Y点
        [self.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [self.scrollview setZoomScale:1.0 animated:YES]; //还原
    }

}
#pragma mark 单击
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.singleTapBlock) {
        self.singleTapBlock(recognizer);
    }
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    if (_reloadButton) {
        [_reloadButton removeFromSuperview];
    }
    _imageUrl = url;
    _placeHolderImage = placeholder;
    
    
    __weak __typeof(self)weakSelf = self;
    _imageview.alpha = 0;
    [_imageview setImageWithURL:url placeholder:placeholder options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (error) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            //图片加载失败的处理，此处可以自定义各种操作（...）
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            strongSelf.reloadButton = button;
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            button.bounds = CGRectMake(0, 0, 200, 40);
            button.center = weakSelf.center;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
            [button setTitle:@"加载失败，点击重试" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:strongSelf action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
            
            [strongSelf addSubview:button];
            return;
        }
        [weakSelf setNeedsLayout];
        [weakSelf layoutIfNeeded];
        
        [weakSelf layoutSubviews];
        weakSelf.currentImage = image;
        weakSelf.hasLoadedImage = YES;//图片加载成功
        [UIView animateWithDuration:0.8 animations:^{
            weakSelf.imageview.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                
            }
        }];
        
//        [weakSelf animateShowImage];
    }];
}
#pragma mark -- show image
-(void)animateShowImage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showImageing = YES;
        if (self.hasLoadedImage) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowImageAnimate" object:nil];
//            self.imageview.image = self.currentImage;
//            self.imageview.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollview.zoomScale = 0.96;
//                self.imageview.alpha = 1;
            } completion:^(BOOL finished) {
//                if (finished) {
//                    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                        self.scrollview.zoomScale = 1.0;
//                    } completion:^(BOOL finished) {
//                        
//                    }];
//                }
            }];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self animateShowImage];
            });
        }
    });
//    if (self.hasLoadedImage) {
//        self.imageview.image = self.currentImage;
//        self.imageview.alpha = 0;
//        [UIView animateWithDuration:0.5 animations:^{
//            self.scrollview.zoomScale = 1.02;
//            self.imageview.alpha = 1;
//        } completion:^(BOOL finished) {
//            if (finished) {
//                [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                    self.scrollview.zoomScale = 1.0;
//                } completion:^(BOOL finished) {
//                    
//                }];
//            }
//        }];
    
        
//        self.imageview.transform = CGAffineTransformMakeScale(0.9, 0.9);
//        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            self.imageview.alpha = 1;
//            self.imageview.transform = CGAffineTransformMakeScale(1.0, 1.0);
//        } completion:^(BOOL finished) {
//            
//        }];
//    }else{//等待网络回来自己动画
//        
//    }
}
- (void)reloadImage
{
    [self setImageWithURL:_imageUrl placeholderImage:_placeHolderImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    _indicatorView.center = _scrollview.center;
    _scrollview.frame = self.bounds;
    _reloadButton.center = self.center;
    [self adjustFrames];
}

- (void)adjustFrames
{
    CGRect frame = self.scrollview.frame;
    if (self.imageview.image) {
        CGSize imageSize = self.imageview.image.size;
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        if (kIsFullWidthForLandScape) {
            CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        } else{
            if (frame.size.width<=frame.size.height) {
           
                CGFloat ratio = frame.size.width/imageFrame.size.width;
                imageFrame.size.height = imageFrame.size.height*ratio;
                imageFrame.size.width = frame.size.width;
            }else{
                CGFloat ratio = frame.size.height/imageFrame.size.height;
                imageFrame.size.width = imageFrame.size.width*ratio;
                imageFrame.size.height = frame.size.height;
            }
        }
        
        self.imageview.frame = imageFrame;
        self.scrollview.contentSize = self.imageview.frame.size;
        self.imageview.center = [self centerOfScrollViewContent:self.scrollview];
        

        CGFloat maxScale = frame.size.height/imageFrame.size.height;
        maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
        maxScale = maxScale>kMaxZoomScale?maxScale:kMaxZoomScale;

        self.scrollview.minimumZoomScale = kMinZoomScale;
        self.scrollview.maximumZoomScale = maxScale;
        self.scrollview.zoomScale = 1.0f;
    }else{
        frame.origin = CGPointZero;
        self.imageview.frame = frame;
        self.scrollview.contentSize = self.imageview.frame.size;
    }
    self.scrollview.contentOffset = CGPointZero;
    
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.zoomScale);
    self.imageview.center = [self centerOfScrollViewContent:scrollView];
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self.scrollview setZoomScale:1.0 animated:YES];
}
@end
