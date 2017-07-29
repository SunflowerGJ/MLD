//
//  QLRegisterFinisheInfoVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/11.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLRegisterFinisheInfoVC.h"
#import "QLKinderSelectedVC.h"
#import "QLMainViewController.h"
@interface QLRegisterFinisheInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{

    __weak IBOutlet UIButton *_btnApply;
    __weak IBOutlet UIView *_viewOne;
    __weak IBOutlet UIView *_viewTwo;
    __weak IBOutlet UIView *_viewThree;
    
    __weak IBOutlet UITextField *_tfParentName;
    __weak IBOutlet UITextField *_tfChindName;
    __weak IBOutlet UITextField *_tfSchoolClassInfo;
    __weak IBOutlet UIImageView *_imgLogo;
    
    __weak IBOutlet UISegmentedControl *_menuSegment;
    NSString *_strImageID;
    QLKinderDataModel *_schoolModel;
    QLClassDataModel *_classModel;
    __weak IBOutlet NSLayoutConstraint *_layoutChildNameHeight;
    __weak IBOutlet NSLayoutConstraint *_layoutChildTop;
}

@end

@implementation QLRegisterFinisheInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (IBAction)menuValueChanged:(id)sender {
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    if (segment.selectedSegmentIndex==0) {//家长
        _tfParentName.placeholder = @"请输入家长姓名";
        _layoutChildNameHeight.constant = 44;
        _layoutChildTop.constant = 10;
    }else{//老师
        _layoutChildNameHeight.constant = 0;
        _layoutChildTop.constant = 0;
        _tfParentName.placeholder = @"请输入老师姓名";
    }
    [_imgLogo setCornerRadius:_imgLogo.frame.size.width/2];
    
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    [self setTitle:@"完成资料"];
    [_btnApply setCornerRadius:10];
    [_viewOne setBorder:.5 borderColor:QLDividerColor];
    [_viewTwo setBorder:.5 borderColor:QLDividerColor];
    [_viewThree setBorder:.5 borderColor:QLDividerColor];
    [QLNotificationCenter addObserver:self selector:@selector(selectedSchoolAndClass:) name:SelectedSchoolAndClass object:nil];
}
- (void)selectedSchoolAndClass:(NSNotification *)notification {
    QLLog(@"nn %@",notification.object);
   NSDictionary *dic = notification.object;
    _schoolModel = dic[@"school"];
    _classModel = dic[@"class"];
    _tfSchoolClassInfo.text = [NSString stringWithFormat:@"%@  %@",_schoolModel.school_name,_classModel.grade_name];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//selected class data
- (IBAction)btnSelectedClass:(id)sender {
    QLKinderSelectedVC *kinderVC = [[QLKinderSelectedVC alloc]init];
    [kinderVC setBlockSelectedSchool:^(QLKinderDataModel *model,QLClassDataModel *classModel){
        QLLog(@"school：%@，class %@",model.school_name,classModel.grade_name);
    }];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:kinderVC animated:YES];
}

#pragma mark - btn
- (IBAction)btnUploadLogo:(id)sender {
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
        UIImagePickerController *  imagePicker1 = [[UIImagePickerController alloc] init];
        imagePicker1.delegate = self;
        imagePicker1.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
            imagePicker1.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        imagePicker1.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker1.allowsEditing=NO;
        if([[[UIDevice
              currentDevice] systemVersion] floatValue]>=8.0) {
            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:imagePicker1 animated:YES completion:nil];
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
    _imgLogo.image = saveImage;
    [self upLoadImage:[saveImage scaleMinSideToSize:500]];
}
- (void)upLoadImage:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image,fileUpload_interface];
    [QLHttpTool postPerWithBaseUrl:imageURL Parameters:@{@"basePath":@"user"} FormData:data FileExtension:@".jpg" MimeType:@"image/jpg"  whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"image response : %@", responseObject);
        _strImageID = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
    } whenFailure:^{
    }];
    
}

- (IBAction)btnApply:(id)sender {
    if ([_strImageID isEmptyString]||_strImageID.length<=0) {
        [QLHUDTool showAlertMessage:@"请选择图片"];
        return ;
    }
    if ([_tfParentName.text isEmptyString]) {
        [QLHUDTool showAlertMessage:@"请输入家长姓名"];
        return;
    }
    if ([_tfChindName.text isEmptyString]) {
        [QLHUDTool showAlertMessage:@"请输入孩子姓名"];
        return ;
    }
    if ([_tfSchoolClassInfo.text isEmptyString]) {
        [QLHUDTool showAlertMessage:@"请选择所在学校及班级"];
        return ;
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,register_interface];
    NSString *userTel = [NSString getValidStringWithObject:_userTel];
    NSString *parentName = [NSString getValidStringWithObject:_tfParentName.text];
    NSString *childName = [NSString getValidStringWithObject:_tfChindName.text];
    NSString *schoolId = [NSString getValidStringWithObject:[NSString stringWithFormat:@"%ld",_classModel.school_id]];
    NSString *classId = [NSString getValidStringWithObject:[NSString stringWithFormat:@"%ld",_classModel.grade_id]];
    NSData *dataPwd = [[NSString stringWithFormat:@"%@",_userPwd] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:@{@"user_tel":userTel,@"user_password":[dataPwd md5String],@"user_name":parentName,@"child_name":childName,@"school_id":schoolId,@"grade_id":classId,@"user_photo":[NSString getValidStringWithObject:_strImageID]}];
    if (_menuSegment.selectedSegmentIndex==1) {
        QLLog(@"家长");
    }else{
        QLLog(@"老师");
    }
    
    [QLHttpTool registerWithBaseUrl:strUrl Parameters:dic whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"regiater response : %@",responseObject);
        [QLHUDTool showAlertMessage:@"注册成功"];
        [self login];
    } whenFailure:^{
        
    }];

}
- (void)login{
    [QLUserTool loginWithUser:_userTel pwd:_userPwd whenSuccess:^{
        QLMainViewController *homeViewController = [QLMainViewController new];
        [self.navigationController pushViewController:homeViewController animated:YES];
        [self removeFromParentViewController];
    } whenFailure:^{
        
    }];

}
@end
