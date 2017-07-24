//
//  AlipayPartnerConfig.h
//  Test_payment
//
//  Created by forp on 15/12/1.
//  Copyright © 2015年 forp. All rights reserved.
//

#ifndef AlipayPartnerConfig_h
#define AlipayPartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define Alipay_PartnerID @"2088221870912204"
//收款支付宝账号
#define Alipay_SellerID @"13669363456@163.com"
//商户私钥，自助生成
#define Alipay_PartnerPrivKey @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBALfBUVDHrXN8o2M0TjtLcdMAilBFLrtcIdX8Zn3rNZLM//gc4l4Rbm1hGyoBw7xM5D6R9Bg7nRV3wEvJ6doH41ebDfZpjR17y0YfrXeMxk8Z6xivJwKzS4MmVF9rzxjPjJ/638Ge8j1tAG1Dz++GPEnG/sYOMH8UVv/JUheSytFfAgMBAAECgYEAhRZEuMcGP0CkbbNyfcuUswgPJTgWMqj18LAP4185vAsx0RfKc+sYGaxdKj2A8J6YKSE4s1xp1ySWZ83jy4AvDQY2v2nhOhsQWyrB0L+X+T+yRkHleHhq7tSLNVqNdNwHGE6sIA6Dca5MkmzZhi9SMERLIL97j2bZipeA5XUBNbECQQDx/G6GpW4WBMYfv3fR0veoNCLfBASCjpyO8Ai48bc/Zil9ArnuVknp5vApwgHYZCW1dlTO2kNArk9Ol3zBmhLtAkEAwmWVIQWhBzTIGkPzJTpKr3MJbBpDuMsZnXm1JeZ0s5Ao3HtSCff4oxzvvt/+Q7DQnsbheroBb7Rf1SgFAGvv+wJBAKhmq+Q4LCxWlipx7MiwsHj2D250NU9GP92ZXfiW/pe4WRcOVqZulnGYrXnh8bbNuxBVkR+C9VqF89sVwVRaDOECQCpSa1ExJImpGBd/y6PDORdReC+s2CmXLhB2utVxgt7E9+BoiMfa0KrSVe+8XGLoT8MBkX1imYV0Q5joiY458ZkCQQCeR8KwGi1EUqJSLBphFxZmYWrem6IXge10yYMBMnEMcBwUf6jboPpaTQToWdqepEyBKsUMmsQ+Szt8ziyduwKE"
//支付宝公钥
#define AlipayPubKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC3wVFQx61zfKNjNE47S3HTAIpQRS67XCHV/GZ96zWSzP/4HOJeEW5tYRsqAcO8TOQ+kfQYO50Vd8BLyenaB+NXmw32aY0de8tGH613jMZPGesYrycCs0uDJlRfa88Yz4yf+t/BnvI9bQBtQ8/vhjxJxv7GDjB/FFb/yVIXksrRXwIDAQAB"
//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define Alipay_MD5_KEY @"s9o89qidzzm7tm2o8l37m6f1qb87rlst"

//回调地址
#define Alipay_NotifyURL @"payAction!createzhifubaoAffordReply.do"

#endif /* AlipayPartnerConfig_h */
