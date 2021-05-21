//
//  SNViewController.m
//  SNCountryChooseKit
//
//  Created by keroushe on 05/21/2021.
//  Copyright (c) 2021 keroushe. All rights reserved.
//

#import "SNViewController.h"
#import <SNCountryChooseKit/SNCountryListVC.h>

@interface SNViewController ()

@end

@implementation SNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    SNCountryListVC *listVC = [[SNCountryListVC alloc] init];
    listVC.chooseCityCompletion = ^(KHLocationInfo * _Nonnull locationInfo) {
        NSLog(@"locationInfo = %@", locationInfo);
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:listVC];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
