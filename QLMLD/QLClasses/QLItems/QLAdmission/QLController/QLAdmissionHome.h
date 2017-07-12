//
//  QLAdmissionHome.h
//  QLMLD
//
//  Created by 英英 on 2017/7/2.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLViewController.h"
#import "iCarousel.h"

@interface QLAdmissionHome : QLViewController<iCarouselDataSource,iCarouselDelegate>
@property (weak, nonatomic) IBOutlet iCarousel *viewICarousel;

@end
