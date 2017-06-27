//
//  QLCodeButton.h
//  HeartNet
//
//  Created by Shrek on 15/12/22.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLCodeButton : UIButton

@property (nonatomic, assign) int charCount;

@property (nonatomic, copy) NSString *strAuthCode;
@property (nonatomic, copy) void (^blkDidChangeValue)(NSString *code);

@end
