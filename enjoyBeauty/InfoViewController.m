//
//  InfoViewController.m
//  enjoyBeauty
//
//  Created by 薛永伟 on 2017/4/29.
//  Copyright © 2017年 xueyongwei. All rights reserved.
//

#import "InfoViewController.h"
#import "UserDefaultsHelper.h"
#import <YYKit.h>
#define random(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define randomColor random(20+arc4random_uniform(200), 20+arc4random_uniform(200), 20+arc4random_uniform(200))
@interface InfoViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *openQuickbtn;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavi];
//    self.tableView.backgroundColor =[UIColor colorWithPatternImage:[[UIImage imageNamed:@"lanch.JPG"] imageByBlurSoft]];
    self.openQuickbtn.on = [UserDefaultsHelper showQuickBtn];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (IBAction)onSwitchClick:(UISwitch *)sender {
    [UserDefaultsHelper setQuickBtnShow:sender.on];
}

-(void)customNavi{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 44)];
    label.font = [UIFont fontWithName:@"PingFangSC-Light" size:25];
    label.text = @"悦乎？";
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    label.textColor = [UIColor darkGrayColor];
    self.navigationItem.titleView = label;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNaviTitle:)];
    [label addGestureRecognizer:tap];
    [self performSelector:@selector(changeTitleColorWhti:) withObject:label afterDelay:3];
}
-(void)changeTitleColorWhti:(UILabel *)label{
    [UIView animateWithDuration:2.0 animations:^{
        label.alpha = 0.1;
    } completion:^(BOOL finished) {
        if (finished) {
            label.textColor = randomColor;
            [UIView animateWithDuration:1.0 animations:^{
                label.alpha = 1;
            } completion:^(BOOL finished) {
                
                [self performSelector:@selector(changeTitleColorWhti:) withObject:label afterDelay:3];
                
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self changeTitleColorWhti:label];
//                });
            }];
        }
    }];
}
-(void)tapNaviTitle:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        
        NSLog(@"%@",cell.accessoryView);
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
