//
//  StoreCartTableCell.h
//  technician
//
//  Created by syy on 2016/12/14.
//  Copyright © 2016年 cn.forp.app. All rights reserved.
//  购物车

#import <UIKit/UIKit.h>
#import "ShoppingCartModel.h"
@interface StoreCartTableCell : UITableViewCell
@property (nonatomic,copy) void (^blockShoppingSubtraction)();
@property (nonatomic,copy) void (^blockShoppingPlus)();
@property (nonatomic,copy) void (^blockShoppingEditCountNum)(NSInteger num);
@property (nonatomic,copy) void (^blockClickMarkButton)(ShoppingCartModel *model,NSIndexPath *path);
@property (nonatomic,copy) void (^blockDelete)();


+ (instancetype)cellWithShoppingCartTableView:(UITableView *)tableView;
- (void)setCellDataWithModel:(ShoppingCartModel *)model indexPath:(NSIndexPath *)path;
-(void)setCellSelected:(BOOL)isSelected;

@end
