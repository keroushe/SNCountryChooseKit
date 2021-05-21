//
//  SNCountryListCell.h
//  Video
//
//  Created by hexs on 2021/1/29.
//  Copyright © 2021 cnest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNCountryListData.h"

NS_ASSUME_NONNULL_BEGIN

/// 国家列表cell
@interface SNCountryListCell : UITableViewCell

- (void)loadCellData:(SNCountryListCountryData *)celldata;
- (void)loadCodeCellData:(SNCountryListCountryData *)celldata;
- (void)reloadCellData;

@end

NS_ASSUME_NONNULL_END
