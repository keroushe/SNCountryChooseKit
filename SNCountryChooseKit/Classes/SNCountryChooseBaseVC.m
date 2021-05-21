//
//  SNCountryChooseBaseVC.m
//  Video
//
//  Created by saina on 2020/12/10.
//  Copyright © 2020 cnest. All rights reserved.
//

#import "SNCountryChooseBaseVC.h"
#import "UIImage+SNCountryChoose.h"
#import "NSBundle+SNCountryChoose.h"

@interface SNCountryChooseBaseVC ()


@end

@implementation SNCountryChooseBaseVC

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavgationBar];
}

- (void)initNavgationBar
{
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, 0, 51, 44);
    [self.backBtn setImage:[UIImage imageWithContentsOfFile:[[NSBundle sn_countryChooseBundle] pathForResource:@"nav_back_white@3x" ofType:@"png"]] forState:UIControlStateNormal];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage sn_imageWithColor:[UIColor colorWithRed:87/255.0 green:79/255.0 blue:97/255.0 alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.backBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
#ifdef __IPHONE_9_0
    //iOS11上如果在UIBarButtonItem的customView上添加红点或者其它的控件，那么通过customView的bounds设置宽高是无效的，而在系统版本iOS11以下的设备上运行是正常的。
    if ([self.backBtn respondsToSelector:@selector(widthAnchor)]) {
        [self.backBtn.widthAnchor constraintEqualToConstant:51].active = YES;
    }
    if ([self.backBtn respondsToSelector:@selector(heightAnchor)]) {
        [self.backBtn.heightAnchor constraintEqualToConstant:44].active = YES;
    }
#endif
    UIBarButtonItem *backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.navigationItem.leftBarButtonItem = backBtnItem;
}

#pragma mark - back Action
- (void)goBack:(UIButton *)sender
{
    if (self.navigationController.viewControllers.count <= 1)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)chooseFinishedWithlocationInfo:(KHLocationInfo *)locationInfo
{
    if (_chooseCityCompletion)
    {
        _chooseCityCompletion(locationInfo);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
