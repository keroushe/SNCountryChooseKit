//
//  SNCountryChooseBaseVC.h
//  Video
//
//  Created by saina on 2020/12/10.
//  Copyright © 2020 cnest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KHLocationManage/KHLocationInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNCountryChooseBaseVC : UIViewController

@property (nonatomic,strong) UIButton *backBtn;
/* 选择回调 */
@property (nonatomic, copy) void(^chooseCityCompletion)(KHLocationInfo *locationInfo);

#pragma mark - protoect method
// 选择完成
- (void)chooseFinishedWithlocationInfo:(KHLocationInfo *)locationInfo;
#pragma mark - back Action
- (void)goBack:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
