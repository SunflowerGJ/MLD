//
//  QLClassHomeDataModel.h
//  QLMLD
//
//  Created by syy on 2017/7/6.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLClassHomeDataModel : NSObject
//{
//    "create_time" = "2017-07-15 22:39:11";
//    "grade_name" = "XiaoBanNO.11";
//    "photo_1" = "/wg_cms/file/others/IMG_-2027572219.jpg";
//    "photo_2" = "/wg_cms/file/others/IMG_-1647116937.jpg";
//    "photo_3" = "/wg_cms/file/others/09-10-27-image.gif";
//    "photo_4" = "/wg_cms/file/others/IMG_20170606_191456.jpg";
//    "photo_5" = "/wg_cms/file/others/black.png";
//    "photo_6" = "/wg_cms/file/others/IMG_20170605_080702.jpg";
//    "praise_num" = 0;
//    "user_name" = Mike;
//    "user_photo" = "/wg_cms/file/others/IMG_-2027572219.jpg";
//},
@property (strong, nonatomic) NSString *strId;
@property (strong, nonatomic) NSString *grade_name;
@property (strong, nonatomic) NSString *photo_1;
@property (strong, nonatomic) NSString *photo_2;
@property (strong, nonatomic) NSString *photo_3;
@property (strong, nonatomic) NSString *photo_4;
@property (strong, nonatomic) NSString *photo_5;
@property (strong, nonatomic) NSString *photo_6;
@property (strong, nonatomic) NSString *praise_num;
@property (strong, nonatomic) NSString *user_name;
@property (strong, nonatomic) NSString *user_photo;
@property (strong, nonatomic) NSString *createTime;
-(instancetype)initClassDataDictionary:(NSDictionary *)dicData;

@end
