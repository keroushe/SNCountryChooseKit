//
//  SNCityCListVC.h
//  Video
//
//  Created by saina on 2020/12/10.
//  Copyright © 2020 cnest. All rights reserved.
//

#import "SNCountryChooseBaseVC.h"
#import "SNCountryListData.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNCityCListVC : SNCountryChooseBaseVC

@property (nonatomic, strong) SNCountryListData *chooseInfo;
@property (nonatomic, strong) id<SNCountryListDataProtocol> dataInfo;

@end

NS_ASSUME_NONNULL_END
