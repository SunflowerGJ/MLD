//
//  QLClassUploadImageVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/22.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLClassUploadImageVC.h"
#import "QLKinderSelectedVC.h"
#import "QLClassSelectedVC.h"
#import "ELCImagePickerController.h"

@interface QLClassUploadImageVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ELCImagePickerControllerDelegate>{

    __weak IBOutlet UITextView *_textViewDescription;

    __weak IBOutlet NSLayoutConstraint *_layoutImageViewHeight;
    __weak IBOutlet UIView *_viewImageBg;
    NSString *_strSchoolID;
    NSMutableArray *_currentImageArray;
    UIButton *_btnAddImage;
}

@end

@implementation QLClassUploadImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"上传图片";
    self.rightBtn.hidden = NO;
    self.rightBtn.frame = CGRectMake(QLScreenWidth-40, 28, 45, 30);
    [self.rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    
    UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnImage setFrame:CGRectMake(15 , 15, 60, 60)];
    [btnImage addTarget:self action:@selector(btnAddNewImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnImage setImage:[UIImage imageNamed:@"ic_img_add"] forState:UIControlStateNormal];
    [_viewImageBg addSubview:btnImage];
    _btnAddImage = btnImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
////选择学校
//- (IBAction)selectedSchool:(id)sender {
//    QLKinderSelectedVC *schoolVC = [[QLKinderSelectedVC alloc]init];
//    schoolVC.fromClassCircle = YES;
//    [schoolVC setBlockSchool:^(QLKinderDataModel *model){
//        _strSchoolID = [NSString stringWithFormat:@"%ld",model.school_id];
//    }];
//    [[QLHttpTool getCurrentVC].navigationController pushViewController:schoolVC animated:YES];
//}
////选择班级
//- (IBAction)selectedClass:(id)sender {
//    QLClassSelectedVC *classVC = [[QLClassSelectedVC alloc]init
//                                  ];
//    classVC.schoolId = _strSchoolID;
//    [[QLHttpTool getCurrentVC].navigationController pushViewController:classVC animated:YES];
//}
#pragma mark - btn
//发布
- (void)clickRight {
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,nil];
    NSDictionary *dic = @{};
    [QLHttpTool postWithBaseUrl:strUrl Parameters:dic whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } whenFailure:^{
        
    }];
}
- (void)btnAddNewImageAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    
    [actionSheet showInView:self.view];

}
#pragma mark - UIActionSheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            QLLog(@"拍照");
            self.editing = NO;
            
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
            break;
        case 1:{
            QLLog(@"相册选取");
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            
            elcPicker.maximumImagesCount = 9-_arrayImages.count; //Set the maximum number of images to select to 100
            elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
            elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
            elcPicker.imagePickerDelegate = self;
            elcPicker.mediaTypes = @[ALAssetTypePhoto];
            
            [self presentViewController:elcPicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
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
    
    [self addImagesToShow:images];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
-(void)addImagesToShow:(NSArray *)arrImageViews;{
    if (!_arrayImages) {
        _arrayImages = [NSMutableArray arrayWithCapacity:9];
    }
    if (arrImageViews && arrImageViews.count>0) {
        [_arrayImages addObjectsFromArray:arrImageViews];
    }
    __block UIButton *safeBtnAddImage = _btnAddImage;
    [_viewImageBg.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == safeBtnAddImage) {
            ;
        }else{
            [obj removeFromSuperview];
        }
    }];
    
    NSInteger count = _arrayImages.count;
    
    CGFloat fMargin = 5;
    CGFloat fWidthBtn = 70;
    for (NSInteger i=0; i<count; i++) {
        CGFloat fXPointStart = i%3*(fWidthBtn+fMargin*2);
        CGFloat fYPointStart = fMargin;
        UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnImage setFrame:CGRectMake(fXPointStart, fYPointStart, fWidthBtn, fWidthBtn)];
        [btnImage addTarget:self action:@selector(btnScanImagesAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnImage setImage:_arrayImages[i] forState:UIControlStateNormal];
        btnImage.tag = 100+i;
        
        UIButton *btnClean = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClean setBackgroundImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        btnClean.frame = CGRectMake(btnImage.frame.size.width-10, btnImage.frame.origin.y-10, 20, 20);
        [btnImage addSubview:btnClean];
        [btnClean addTarget:self action:@selector(deletImage:) forControlEvents:UIControlEventTouchUpInside];
        [btnClean setCornerRadius:10];
        btnClean.tag = 200+i;
        [_viewImageBg addSubview:btnImage];
        
    }
    CGRect rectView = _viewImageBg.frame;
    if (count <3) {
        CGFloat fXPointStart = count%3*(fWidthBtn+fMargin*2);
        CGFloat fYPointStart = fMargin;
        [_btnAddImage setHidden:NO];
        [_btnAddImage setFrame:CGRectMake(fXPointStart, fYPointStart, fWidthBtn, fWidthBtn)];
        rectView.size.height =CGRectGetMaxY(_btnAddImage.frame)+10;
        [_viewImageBg setFrame:rectView];
    }else{
        [_btnAddImage setHidden:YES];
        rectView.size.height = (fWidthBtn+fMargin)*1+fMargin;
        [_viewImageBg setFrame:rectView];
    }

}
@end
