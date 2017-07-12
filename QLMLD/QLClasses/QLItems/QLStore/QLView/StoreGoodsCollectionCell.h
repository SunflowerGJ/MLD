//
//  StoreGoodsCollectionCell.h
//  technician
//
//  Created by syy on 2016/12/13.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLGoodsModel.h"
@interface StoreGoodsCollectionCell : UICollectionViewCell
@property (nonatomic ,strong)IBOutlet UILabel *lblName;
@property (nonatomic ,strong)IBOutlet UIImageView *imgLogo;
@property (nonatomic ,strong)IBOutlet UILabel *lblPrice;
@property (nonatomic ,strong)IBOutlet UILabel *lblAssessCount;
@property (nonatomic ,strong)IBOutlet UILabel *lblGoodAssessPercent;
- (void)setCellDataWithGoodsModel:(QLGoodsModel *)model;
@end
