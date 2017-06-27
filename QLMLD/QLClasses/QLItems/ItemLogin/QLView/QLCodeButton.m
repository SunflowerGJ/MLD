//
//  QLCodeButton.m
//  HeartNet
//
//  Created by Shrek on 15/12/22.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "QLCodeButton.h"

@interface QLCodeButton ()
{
    NSString *_strSource;
    BOOL _neededNew;
}

@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) int lineCount;

@end

@implementation QLCodeButton

- (CGFloat)fontSize {
    NSArray *arrTemp = @[@16, @17, @18, @19];
    int index = arc4random_uniform((int)arrTemp.count);
    return [arrTemp[index] intValue];
}

- (CGFloat)lineWidth {
    NSArray *arrTemp = @[@1, @2, @3];
    int index = arc4random_uniform((int)arrTemp.count);
    return [arrTemp[index] intValue];
}

- (int)lineCount {
    return arc4random_uniform(3) + 2;
}

- (NSString *)strAuthCode {
    if (!_strAuthCode) {
        _strAuthCode = [self authCode];
    }
    
    if (_neededNew) {
        _strAuthCode = [self authCode];
        return _strAuthCode;
    } else {
        return _strAuthCode;
    }
}

- (NSString *)authCode {
    NSMutableString *strMTemp = [[NSMutableString alloc] initWithCapacity:self.charCount];
    for (int i = 0; i < self.charCount; i++) {
        NSInteger index = arc4random() % (_strSource.length-1);
        NSString *strTemp = [_strSource substringWithRange:NSMakeRange(index, 1)];
        strMTemp = (NSMutableString *)[strMTemp stringByAppendingString:strTemp];
    }
    NSString *code = [strMTemp copy];
    self.blkDidChangeValue(code);
    return code;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadDefaultSetting];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self loadDefaultSetting];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    self.charCount = 4;
    self.layer.cornerRadius = 5.0f;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    _strSource = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
}

#pragma mark 点击界面切换验证码
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _neededNew = YES;
    
    //setNeedsDisplay调用drawRect方法来实现view的绘制
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //根据要显示的验证码字符串，根据长度，计算每个字符串显示的位置
    NSString *text = [NSString stringWithFormat:@"%@", self.strAuthCode];
    
    CGSize cSize = [@"A" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    int width = rect.size.width/text.length - cSize.width;
    int height = rect.size.height - cSize.height;
    
    CGPoint point;
    
    //依次绘制每一个字符,可以设置显示的每个字符的字体大小、颜色、样式等
    float pX,pY;
    for ( int i = 0; i<text.length; i++) {
        pX = arc4random() % width + rect.size.width/text.length * i;
        pY = arc4random() % height;
        point = CGPointMake(pX, pY);
        
        unichar c = [text characterAtIndex:i];
        NSString *textC = [NSString stringWithFormat:@"%C", c];
        
        [textC drawAtPoint:point withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]}];
    }
    
    //调用drawRect：之前，系统会向栈中压入一个CGContextRef，调用UIGraphicsGetCurrentContext()会取栈顶的CGContextRef
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条宽度
    CGContextSetLineWidth(context, self.lineWidth);
    
    //绘制干扰线
    for (int i = 0; i < self.lineCount; i++) {
        UIColor *color = QLColorRandom;
        CGContextSetStrokeColorWithColor(context, color.CGColor);//设置线条填充色
        
        //设置线的起点
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextMoveToPoint(context, pX, pY);
        //设置线终点
        pX = arc4random() % (int)rect.size.width;
        pY = arc4random() % (int)rect.size.height;
        CGContextAddLineToPoint(context, pX, pY);
        //画线
        CGContextStrokePath(context);
    }
    
    _neededNew = NO;
}

@end
