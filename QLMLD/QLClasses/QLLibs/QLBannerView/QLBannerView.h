//
//  QLBannerView.h
//  Demo_QLBannerView
//
//  Created by Shrek on 3/14/15.
//  Copyright © 2016 Shreker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QLBannerViewItem <NSObject>

- (NSURL *)url;
- (UIImage *)image;

@end

@interface QLBannerView : UIView

@property (nonatomic, copy) NSArray<QLBannerViewItem> *images; /**< NOTE: The priority of the url and image is: image > url **/
@property (nonatomic, strong) UIImage *placeHolderImage;

@property (nonatomic, assign) CGFloat timeInterval; // animation tag. Default is 2s;

@end
