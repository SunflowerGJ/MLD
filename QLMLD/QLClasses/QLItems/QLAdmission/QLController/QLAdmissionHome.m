//
//  QLAdmissionHome.m
//  QLMLD
//
//  Created by 英英 on 2017/7/2.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLAdmissionHome.h"
#import "QLShareVC.h"
#import "QLAdmissionDetailVC.h"
#import "QLAdmisiionSlideVC.h"
#import "QLAdmissionHomeDataModel.h"
#import "MyCollectionView.h"
#import "ELCImagePickerController.h"
#import "QLAdmissionPublishVC.h"

@interface QLAdmissionHome ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ELCImagePickerControllerDelegate>{
    
    QLAdmisiionSlideVC *slideVC;
    NSString *_strTime;
    __weak IBOutlet UIView *_viewCollection;
}

@end

@implementation QLAdmissionHome

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataRequest];
    [self loadDefaultSetting];
    
}
- (void)loadDefaultSetting {
    _viewICarousel.delegate = self;
    _viewICarousel.dataSource = self;
    _viewICarousel.type = iCarouselTypeCoverFlow;
    
    self.leftBtn.frame = CGRectMake(0, 28, 50, 30);
    [self.leftBtn setImage:[UIImage imageNamed:@"moreTime_icon"]  forState:UIControlStateNormal];
    
    self.rightBtn.hidden = NO;
    self.rightBtn.frame = CGRectMake(QLScreenWidth-40, 28, 30, 30);
    [self.rightBtn setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(self.rightBtn.frame.origin.x-5, 28, .5, 30)];
    line.backgroundColor = [UIColor whiteColor];
    [self.titleView addSubview:line];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeSystem];
    share.frame = CGRectMake(self.rightBtn.frame.origin.x-40, 28, 30, 30);
    share.tintColor = [UIColor whiteColor];
    share.backgroundColor = [UIColor clearColor];
    [share setImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
    [self.titleView addSubview:share];
    [share addTarget:self action:@selector(clickShare) forControlEvents:UIControlEventTouchUpInside];
}
- (void)clickBack{
    QLLog(@"more");
    slideVC = [[QLAdmisiionSlideVC alloc]initWithNibName:@"QLAdmisiionSlideVC" bundle:[NSBundle mainBundle]];
    slideVC.view.frame = self.view.frame;
    [slideVC setBlockSelectedDate:^(NSString *date){
        _strTime = date;
        
    }];
    [self.view addSubview:slideVC.view];
    [slideVC startAnimation];
}
- (void)clickRight{
    QLLog(@"拍照");
    UIActionSheet *sheetSelect = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheetSelect showInView:self.view];
}
- (void)clickShare{
    QLLog(@"分享");
    QLShareVC *shareVC = [[QLShareVC alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:shareVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - data request 
- (void)dataRequest {
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,admissionHomeData_interface];
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateTime = [formatter stringFromDate:date];
    QLLog(@"date: %@",dateTime);
    
    NSDictionary *dic = @{@"create_time":dateTime};
    
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = [NSMutableArray new];
//        array = [QLClassHomeDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        array = responseObject[@"data"];
        self.dataSource = [[NSMutableArray alloc] initWithArray:array];
                           
    } whenFailure:^{
        
    }];
}
#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 30;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    UIView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",index]]];
    
    UIView *viewTip = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height-40, view.frame.size.width, 40)];
    viewTip.backgroundColor = [UIColor yellowColor];
    [carousel addSubview:viewTip];
    
    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height-40, view.frame.size.width, 30)];
    [view addSubview:lblTime];
    lblTime.text = [NSString stringWithFormat:@"%ld time",index];
    lblTime.textColor = [UIColor redColor];
    
    view.frame = CGRectMake(_viewICarousel.frame.origin.x, _viewICarousel.frame.origin.y, _viewICarousel.frame.size.width, _viewICarousel.frame.size.height);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(detail)];
    [view addGestureRecognizer:tap];
    
    return view;
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
    return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    return 30;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return QLScreenWidth-50;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = _viewICarousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * _viewICarousel.itemWidth);
}
- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return YES;
}
#pragma mark - 
- (void)detail {
    QLAdmissionDetailVC *detailVC = [[QLAdmissionDetailVC alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0)//拍照
    {
        UIImagePickerController *  imagePicker1 = [[UIImagePickerController alloc] init];
        imagePicker1.delegate = self;
        imagePicker1.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker1.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        imagePicker1.allowsEditing=NO;
        if([[[UIDevice
              currentDevice] systemVersion] floatValue]>=8.0) {
            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:imagePicker1 animated:YES completion:nil];
    }
    else if(buttonIndex==1)//相册
    {
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        
        elcPicker.maximumImagesCount = 9; //Set the maximum number of images to select to 100
        elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
        elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
        elcPicker.mediaTypes = @[(NSString *)kUTTypeImage]; //Supports image and movie types
        elcPicker.imagePickerDelegate = self;
        
        [self presentViewController:elcPicker animated:YES completion:nil];
    }
}

-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData =  UIImageJPEGRepresentation(image, 0.6f);
    UIImage *saveImage = [UIImage imageWithData:imageData];
    
    QLAdmissionPublishVC *uploadImage = [[QLAdmissionPublishVC alloc]init];
    uploadImage.muArrayImages = [NSMutableArray arrayWithObjects:saveImage, nil];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:uploadImage animated:YES];
}
#pragma mark - ELCImagePickerController delegate
-(void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    QLLog(@"选择了%zd张图片－images:%@",info.count,info);
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [images addObject:image];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    
    QLAdmissionPublishVC *uploadImage = [[QLAdmissionPublishVC alloc]init];
    uploadImage.muArrayImages = images;
    [[QLHttpTool getCurrentVC].navigationController pushViewController:uploadImage animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
