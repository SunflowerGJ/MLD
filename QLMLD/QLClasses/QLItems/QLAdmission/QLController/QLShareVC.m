//
//  QLShareVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/22.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLShareVC.h"
#import "WXApi.h"
@interface QLShareVC ()

@end

@implementation QLShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnCircle:(id)sender {
    [self weChatCircle];
}
- (IBAction)btnFriends:(id)sender {
    [self weChatFriend];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)weChatCircle {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"";
    message.description = @"";
    [message setThumbImage:[UIImage imageNamed:@"check"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"";
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}

- (void)weChatFriend{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"";
    message.description = @"";
    [message setThumbImage:[UIImage imageNamed:@"check"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"";
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}

@end
