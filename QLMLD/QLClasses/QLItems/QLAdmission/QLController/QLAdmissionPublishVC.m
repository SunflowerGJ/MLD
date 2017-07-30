//
//  QLAdmissionPublishVC.m
//  QLMLD
//
//  Created by syy on 2017/7/25.
//  Copyright © 2017年 Shreker. All rights reserved.
//  成长印记 发布

#import "QLAdmissionPublishVC.h"
#import "MWPhotoBrowser.h"
#import "ELCImagePickerController.h"
#import "QLAdmissionDetailVC.h"
@interface QLAdmissionPublishVC ()<MWPhotoBrowserDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ELCImagePickerControllerDelegate>{
    __weak IBOutlet UITextView *_textViewDescription;
    __weak IBOutlet NSLayoutConstraint *_layoutImageViewHeight;
    __weak IBOutlet UIView *_viewImageBg;
    UIButton *_btnAdd;
    NSInteger uploadIndex;
    NSMutableDictionary *_dicImgsSave;
}

@end

@implementation QLAdmissionPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
    [self uploadImages:self.muArrayImages];
    uploadIndex = 0;
    _dicImgsSave = [NSMutableDictionary new];
}

- (void)loadDefaultSetting {
    self.title = @"成长印记";
    self.rightBtn.hidden = NO;
    self.rightBtn.frame = CGRectMake(QLScreenWidth-60, 28, 45, 30);
    [self.rightBtn setTitle:@"发布" forState:UIControlStateNormal];
    
    if (!_btnAdd) {
        CGFloat fMargin = 20;
        CGFloat fYPoint = 40;
        CGFloat fWidthBtn = (QLScreenWidth-20-30)/4;
        CGFloat fHeightBtn = fWidthBtn*1.25;

        UIButton * btnNew = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnNew setFrame:CGRectMake(fMargin, fYPoint, fWidthBtn, fHeightBtn)];
        [btnNew setBackgroundImage:[UIImage imageNamed:@"ic_img_add"] forState:UIControlStateNormal];
        [btnNew addTarget:self action:@selector(showAddImagesAlert) forControlEvents:UIControlEventTouchUpInside];
        [_viewImageBg addSubview:btnNew];
        _btnAdd = btnNew;
    }
}

- (void)clickRight {
    if (_textViewDescription.text.length<=0) {
        [QLHUDTool showAlertMessage:@"请输入图片描述"];
        return ;
    }
    if (_muArrayImages<=0) {
        [QLHUDTool showAlertMessage:@"请选择图片"];
        return ;
    }
//    [self upLoadImageToServer:_muArrayImages];
    [self postData];

}
- (void)showAddImagesAlert{
    UIActionSheet *sheetSelect = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheetSelect showInView:self.view];
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
        
        elcPicker.maximumImagesCount = 9-_muArrayImages.count; //Set the maximum number of images to select to 100
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
    [_muArrayImages addObject:saveImage];
    [self uploadImages:_muArrayImages];
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [_muArrayImages addObjectsFromArray:images];
    [self uploadImages:_muArrayImages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - MWPhotoBroswer delegate
-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return _muArrayImages.count;
}
-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    MWPhoto *photo;
    if ([_muArrayImages[index] isKindOfClass:[NSDictionary class]]) {
        NSString *strURL = [NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image,_muArrayImages[index][@"name"]];
        photo = [MWPhoto photoWithURL:[NSURL URLWithString:strURL]];
    }else if([_muArrayImages[index] isKindOfClass:[UIImage class]]){
        photo = [MWPhoto photoWithImage:_muArrayImages[index]];
    }else{
        return nil;
    }
    
    return photo;
}

#pragma mark - data Request
- (void)dataPublish {
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,admissionPublish_interface];
    NSString *theme = [NSString getValidStringWithObject:nil];
    NSString *photo = [NSString getValidStringWithObject:nil];
    NSString *isTeacher = @"1";
    NSDictionary *dicParam = @{@"sign_theme":theme,@"sign_photo":photo,@"is_teacher":isTeacher};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dicParam whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } whenFailure:^{
        
    }];
}
- (void)uploadImages:(NSArray *)images{
    [_viewImageBg.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == _btnAdd) {
            ;
        }else{
            [obj removeFromSuperview];
        }
    }];
    
    NSInteger count = images.count;
    
    CGFloat fMargin = 10;
    CGFloat fWidthBtn = (QLScreenWidth-20-30)/4;
    CGFloat fHeightBtn = fWidthBtn*1.25;
    for (NSInteger i=0; i<count; i++) {
        CGFloat fXPointStart = i%4*(fWidthBtn+fMargin);
        CGFloat fYPointStart = 10+i/4*(fHeightBtn+fMargin);
        UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnImage setFrame:CGRectMake(fXPointStart, fYPointStart, fWidthBtn, fHeightBtn)];
        [btnImage addTarget:self action:@selector(btnScanImagesAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([images[i] isKindOfClass:[NSDictionary class]]) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image,images[i][@"name"]]];
            [btnImage sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_selectPicture_normal"]];
        }else{
            [btnImage setImage:images[i] forState:UIControlStateNormal];
        }
        
        btnImage.tag = 100+i;
        [_viewImageBg addSubview:btnImage];
        
        UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnDelete setFrame:CGRectMake(CGRectGetMaxX(btnImage.frame)-20, CGRectGetMinY(btnImage.frame)-15, 30, 30)];
        [btnDelete setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
        [btnDelete addTarget:self action:@selector(btnDemoveImageAction:) forControlEvents:UIControlEventTouchUpInside];
        btnDelete.tag = 200+i;
        [_viewImageBg addSubview:btnDelete];
    }
    
    CGRect rectView = _viewImageBg.frame;
    if (count <9) {
        CGFloat fXPointStart = count%4*(fWidthBtn+fMargin);
        CGFloat fYPointStart = 10+count/4*(fHeightBtn+fMargin);
        [_btnAdd setHidden:NO];
        [_btnAdd setFrame:CGRectMake(fXPointStart, fYPointStart, fWidthBtn, fHeightBtn)];
        rectView.size.height =CGRectGetMaxY(_btnAdd.frame)+10;
        [_viewImageBg setFrame:rectView];
    }else{
        [_btnAdd setHidden:YES];
        rectView.size.height = (fHeightBtn+fMargin)*1+fMargin;
        [_viewImageBg setFrame:rectView];
    }
    _layoutImageViewHeight.constant = _viewImageBg.frame.size.height;
}

- (void)btnDemoveImageAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag - 200;
    id image = _muArrayImages[tag];
    [_muArrayImages removeObject:image];
    [self uploadImages:_muArrayImages];
}
//浏览图片
-(void)btnScanImagesAction:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag-100;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
}


- (void)upLoadImageToServer:(NSArray *)image{
    NSData *data = UIImageJPEGRepresentation(image[uploadIndex], 1);
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image,fileUpload_interface];
    [QLHUDTool showLoading];
    __weak typeof (self)weakSelf = self;
    [QLHttpTool postPerWithBaseUrl:imageURL Parameters:@{@"basePath":@"other"} FormData:data FileExtension:@".jpg" MimeType:@"image/jpg"  whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"image response : %@", responseObject);
        NSString *url = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
         [_dicImgsSave setObject:url forKey:[NSString stringWithFormat:@"%ld",uploadIndex]];
        if (url&&url.length>0&&uploadIndex<image.count-1) {
            uploadIndex++;
            [weakSelf upLoadImageToServer:image];
        }else{
            [QLHUDTool showAlertMessage:@"图片上传成功！"];
            [weakSelf postData];
        }
    } whenFailure:^{
    }];
}
- (void)postData{
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,admissionPublish_interface];
    NSString *schoolId = [NSString getValidStringWithObject:[NSString stringWithFormat:@"%ld",[QLUserTool sharedUserTool].userModel.school_id]];
    NSString *gradeId = [NSString getValidStringWithObject:[NSString stringWithFormat:@"%ld",[QLUserTool sharedUserTool].userModel.grade_id]];
    NSString *content = [NSString getValidStringWithObject:_textViewDescription.text];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    for (NSInteger i=0; i<_dicImgsSave.allValues.count; i++) {
        [dic setObject:_dicImgsSave.allValues[i] forKey:[NSString stringWithFormat:@"photo_%ld",i]];
    }
    NSString *userType = [NSString getValidStringWithObject:[NSString stringWithFormat:@"%ld",[QLUserTool sharedUserTool].userModel.user_type]];
    [dic setObject:content forKey:@"grade_group_content"];
    [dic setObject:schoolId forKey:@"school_id"];
    [dic setObject:gradeId forKey:@"grade_id"];
    [dic setObject:userType forKey:@"is_teacher"];
    [QLHUDTool showLoading];
    __weak typeof (self) weakSelf = self;
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dic whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [QLHUDTool showAlertMessage:@"发布成功"];
        QLLog(@"发布成功 ：%@",responseObject);
        NSString *signID = [NSString stringWithFormat:@"%@",responseObject[@"GroupSignid"]];
        [weakSelf detailDataRequestWithSignID:signID];
        QLLog(@"dd %@",responseObject);
    } whenFailure:^{
        
    }];
}
//发布主题成功后 请求详情，插入要上传的数据
- (void)detailDataRequestWithSignID:(NSString *)signId{
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,admissionDetail_interface];
//    NSDictionary *dic = @{@"sign_id":[NSString getValidStringWithObject:_signId],@"sign_detial_remark":[NSString getValidStringWithObject:_remark],@"sign_photo":[NSString getValidStringWithObject:_photo]};
    NSDictionary *dic=@{@"sign_id":signId};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dic whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"detail: %@",responseObject);
        //原数据与新上传的拼接 dataSource
    
        QLAdmissionDetailVC *detailVC = [[QLAdmissionDetailVC alloc]init];
        detailVC.imgsArray = _muArrayImages;
        
        [[QLHttpTool getCurrentVC].navigationController pushViewController:detailVC animated:YES];
    } whenFailure:^{
        
    }];
}

@end
