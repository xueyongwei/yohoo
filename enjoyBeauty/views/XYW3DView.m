//
//  XYW3DView.m
//  enjoyBeauty
//
//  Created by xueyognwei on 2017/5/19.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "XYW3DView.h"
#import <QuartzCore/QuartzCore.h>
#import <Masonry.h>
#define CATransform3DPerspective(t, x, y) (CATransform3DConcat(t, CATransform3DMake(1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, 0, 0, 0, 0, 1)))
#define CATransform3DMakePerspective(x, y) (CATransform3DPerspective(CATransform3DIdentity, x, y))

CG_INLINE CATransform3D
CATransform3DMake(CGFloat m11, CGFloat m12, CGFloat m13, CGFloat m14,
                  CGFloat m21, CGFloat m22, CGFloat m23, CGFloat m24,
                  CGFloat m31, CGFloat m32, CGFloat m33, CGFloat m34,
                  CGFloat m41, CGFloat m42, CGFloat m43, CGFloat m44)
{
    CATransform3D t;
    t.m11 = m11; t.m12 = m12; t.m13 = m13; t.m14 = m14;
    t.m21 = m21; t.m22 = m22; t.m23 = m23; t.m24 = m24;
    t.m31 = m31; t.m32 = m32; t.m33 = m33; t.m34 = m34;
    t.m41 = m41; t.m42 = m42; t.m43 = m43; t.m44 = m44;
    return t;
}
@interface XYW3DView ()
@property (nonatomic,assign) CGRect orgniamFrame;
@property (nonatomic,assign) CGPoint orgnicenter ;
@property (nonatomic,assign) CGAffineTransform orgniTransfrom;
@property (nonatomic,assign) BOOL canTransForm ;
@end

@implementation XYW3DView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self commonInit];
    }
    return self;
}
-(void)setImage:(UIImage *)image
{
    _image = image;
    [self showImage];
}
- (id) init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(void)setImage:(UIImage *)image andTitle:(NSString *)title
{
    _image = image;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:self.image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    label.font = [UIFont systemFontOfSize:25];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}
-(void)showImage{
//    self.layer.fillMode =
    UIImageView *imageView = [[UIImageView alloc]initWithImage:self.image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    label.font = [UIFont systemFontOfSize:25];
    label.text = @"每日精选";
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}
-(void) commonInit {
    //enable the shadow
    [self enableShadow];
    self.orgniamFrame = CGRectZero;
    self.orgnicenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    self.userInteractionEnabled = YES;
    self.clipsToBounds = YES;
    
    //    self.layer.contentsAreFlipped
}
-(void) enableShadow {
    //shadow part
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, -3);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 10.0;
    
    //set shadow path
    self.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
}
-(void)setTransform:(CGAffineTransform)transform
{
    [super setTransform:transform];
    NSLog(@"transform %@",NSStringFromCGAffineTransform(transform));
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.orgniamFrame.size.height ==0 ) {
        self.orgniamFrame = self.frame;
        self.orgniTransfrom = self.transform;
    }
    self.canTransForm = YES;
    UITouch *touch = [touches anyObject];
    [self trans3DWithTouch:touch];
    [UIView animateWithDuration:0.1 animations:^{
        //        self.transform = CGAffineTransformScale(self.transform, 1.05, 1.05);
    } completion:^(BOOL finished) {
        if (finished) {
            self.canTransForm = YES;
            //            [self trans3DWithTouch:touch];
            //            [UIView animateWithDuration:0.1 animations:^{
            //                self.transform = transfrom;
            //            } completion:^(BOOL finished) {
            //                if (finished) {
            //
            //                }
            //            }];
        }
    }];
    
    
}
-(void)animationOnce{
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformScale(self.transform, 1.05, 1.05);
    } completion:^(BOOL finished) {
        if (finished) {
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }
    }];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [self trans3DWithTouch:touch];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self trans2orignal];
    //    self.transform = CGAffineTransformScale(self.transform, 1.0, 1.0);
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self trans2orignal];
}
-(void)trans3DWithTouch:(UITouch *)touch{
    
    if (!self.canTransForm) {
        return;
    }
    __block CATransform3D transform3d;
    // 获取当前作用手势位置
    CGPoint currentPoint = [touch locationInView:self];
    CGFloat detX = 0;
    CGFloat detY = 0;
    if ([self.layer containsPoint:currentPoint]) {
        NSLog(@"change");
        detX= currentPoint.x-self.orgnicenter.x;
        detY = currentPoint.y-self.orgnicenter.y;
        NSLog(@"x=%f,y=%f",detX,detY);
        transform3d = CATransform3DPerspective(CATransform3DIdentity, detX*0.000005, detY*0.000005);
        
        [UIView animateWithDuration:0.3 animations:^{
            self.layer.zPosition = 10000;
            self.layer.transform = transform3d;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        
    }
}
-(void)trans2orignal{
    self.canTransForm = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.layer.zPosition = 10000;
        CATransform3D transform = CATransform3DMakeRotation(0, 1, 0, 0);
        transform.m34 = 1.0 / -1000;
        self.layer.transform = transform;
        self.layer.frame = self.orgniamFrame;
    } completion:^(BOOL finished) {
        if (finished) {
            self.layer.zPosition = 0;
            self.transform = self.orgniTransfrom;
        }
    }];
}


@end
