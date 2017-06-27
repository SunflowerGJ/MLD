//
//  QLLoginViewController.h
//  HeartNet
//
//  Created by Shrek on 15/12/9.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLLoginViewController : UIViewController

@property (nonatomic, assign) BOOL isFromMine;

/** 是否需要在登录后验证实名认证 */
@property (nonatomic,assign) BOOL shouldVerify;
/** 登陆成功,未认证 */
@property (nonatomic,copy) void (^blockNotPassVerify)();

/** 如果需要在登录后直接跳转到其他界面，可以通过这个block实现跳转，如发布 */
@property (nonatomic,copy) void (^blockShouldPushNextVC)();

@end
