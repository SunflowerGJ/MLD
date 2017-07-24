//
//  QLOrderPaymentVC.m
//  QLMLD
//
//  Created by syy on 2017/7/24.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLOrderPaymentVC.h"
#import "OrderForWXpay.h"

@interface QLOrderPaymentVC ()<GJSPayProtocol,UPPayPluginDelegate>{
    GJSPay *pay;
    NSString *_strNonce;
    NSString *wxOrderNo;
}


@end

@implementation QLOrderPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getWeiXinAccessToken{
    NSString *str = [NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%@&secret=%@",WXpay_APP_ID,WXpay_APP_SECRET];
    [QLHttpTool postWithTestBaseUrl:str Parameters:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"获取access==%@",responseObject);
        NSString *nonceStr = [NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=%@&type=jsapi",responseObject[@"access_token"]];
        [QLHttpTool postWithTestBaseUrl:nonceStr Parameters:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            QLLog(@"获取nonceStr==%@",responseObject);
            _strNonce = responseObject[@"ticket"];
        } whenFailure:^{
            
        }];
    } whenFailure:^{
        
    }];
}
- (void)weiXinPay {
    pay = [[GJSPay alloc] init];
    pay.delegate = self;
    
            NSString *strURl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,payWeiXin_interface];
            NSDictionary *dicParam;
                dicParam = @{@"orderno":self.strOrderNo,@"ordersum":self.strOrderSum};
    
            [QLHUDTool showLoading];
            [QLHttpTool postWithBaseUrl:strURl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                QLLog(@"支付返回：%@",responseObject);
                if ([responseObject[@"return_code"] isEqualToString:@"FAIL"]) {
                    [QLHUDTool showAlertMessage:responseObject[@"return_msg"]];
                    return  ;
                }
                [QLHUDTool dissmis];
                PaySDK = WXpayType;
                NSString *sign =               responseObject[@"sign"];
                NSString *prepayId= [NSString getValidStringWithObject:responseObject[@"prepay_id"]];
                NSString *nonceStr = [NSString getValidStringWithObject:responseObject[@"nonce_str"]];
                wxOrderNo = [NSString getValidStringWithObject:responseObject[@"out_trade_no"]];
                
                OrderForWXpay *orderItem = [[OrderForWXpay alloc]initWithDictionary:@{@"Partner":WXpay_PARTNER_ID, @"Mch": WXpay_MCH_ID, @"ProductName": @"货运付款", @"加吉速运": @"liChi",@"Amount":@"0.01",@"NotifyURL":[NSString stringWithFormat:@"%@%@",QLBaseUrlString,WXpay_NOTIFY_URL],@"SignedString":sign,@"AppID":WXpay_APP_ID,@"Noncestr":nonceStr,@"Prepayid":prepayId}];
                [pay payByWXpayOrder:(id)orderItem appId:WXpay_APP_ID partner:WXpay_PARTNER_ID mchId:WXpay_MCH_ID];
            } whenFailure:^{
            }];
}
#pragma mark GJSPayProtocol
/**
 *  支付成功代理
 */
- (void)paymentDidSuccess:(id)payment responseInfo:(id)response payType:(NSString *)type {
    [QLHUDTool dissmis];
    if ([type isEqualToString:AlipayType]) {//支付宝支付
        QLLog(@"支付宝成功代理==%@",response);
    } else if ([type isEqualToString:WXpayType]) {//微信支付
        QLLog(@"微信支付成功代理==");
        return;
    } else if ([type isEqualToString:UnionpayType]) {//银联支付
        QLLog(@"银联支付成功代理==%@",response);
        return;
    }
}
/**
 *  支付失败代理
 */
- (void)paymentDidFailed:(id)payment responseInfo:(id)response payType:(NSString *)type {
    [QLHUDTool dissmis];
    [QLHUDTool showAlertMessage:@"支付失败"];
    if ([type isEqualToString:AlipayType]) {//支付宝支付
        
    } else if ([type isEqualToString:WXpayType]) {//微信支付
        [QLHUDTool showAlertMessage:@"支付失败"];
    } else if ([type isEqualToString:UnionpayType]) {//银联支付
        //        if ([response isKindOfClass:[NSDictionary class]]) {
        //            response = (NSDictionary *)response;
        //            QLLog(@"支付失败：%@",response);
        //        } else {
        //            return;
        //        }
    }
}
/**
 *  支付取消代理
 */
- (void)paymentDidCanceled:(id)payment responseInfo:(id)response payType:(NSString *)type {
    [QLHUDTool dissmis];
    if ([response isKindOfClass:[NSDictionary class]]) {
        response = (NSDictionary *)response;
        QLLog(@"支付取消：%@",response);
    }
    [QLHUDTool showAlertMessage:@"支付取消"];
    if ([type isEqualToString:AlipayType]) {//支付宝支付
        
    } else if ([type isEqualToString:WXpayType]) {//微信支付
        
    } else if ([type isEqualToString:UnionpayType]) {//银联支付
        
    }
}
/**
 *  支付状态代理
 */
- (void)paymentStatus:(id)payment statusInfo:(id)info payType:(NSString *)type {
    if ([info isKindOfClass:[NSDictionary class]]) {
        info = (NSDictionary *)info;
        QLLog(@"支付状态：%@",info);
    }
    if ([type isEqualToString:AlipayType]) {//支付宝支付
        
    } else if ([type isEqualToString:WXpayType]) {//微信支付
        
    } else if ([type isEqualToString:UnionpayType]) {//银联支付
    }
}

#pragma mark - 银联支付回调
- (void)UPPayPluginResult:(NSString*)result {
    QLLog(@"pay == %@",result);
    if ([result isEqualToString:@"success"]) {//订单支付成功
//        [self jumpPage];
    } else if ([result isEqualToString:@"fail"]) {//订单支付失败
        [QLHUDTool showAlertMessage:@"支付失败"];
    } else if ([result isEqualToString:@"cancel"]) {//用户取消支付
        [QLHUDTool showAlertMessage:@"取消支付"];
    }
}

@end
