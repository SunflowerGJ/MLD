//
//  QLKinderCollectionViewCell.h
//  QLMLD
//
//  Created by 英英 on 2017/7/12.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLChannelListDataModel.h"
@interface QLKinderCollectionViewCell : UICollectionViewCell
- (void)setCellIndexValue:(NSInteger)value withData:(NSMutableAttributedString *)str;
- (void)setCellDataWithModel:(QLChannelListDataModel *)model IndexValue:(NSInteger)value;
@property (nonatomic,copy) void (^blockLongGesture)();

@end
