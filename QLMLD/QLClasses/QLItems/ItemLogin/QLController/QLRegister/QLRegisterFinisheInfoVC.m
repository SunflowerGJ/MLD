//
//  QLRegisterFinisheInfoVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/11.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLRegisterFinisheInfoVC.h"
#import "QLKinderSelectedVC.h"
@interface QLRegisterFinisheInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{

    __weak IBOutlet UIButton *_btnApply;
    __weak IBOutlet UIView *_viewOne;
    __weak IBOutlet UIView *_viewTwo;
    __weak IBOutlet UIView *_viewThree;
    
    __weak IBOutlet UITextField *_tfParentName;
    __weak IBOutlet UITextField *_tfChindName;
    __weak IBOutlet UITextField *_tfSchoolClassInfo;
    NSString *_strImageID;
    NSString *_strSchoolID;
    NSString *_strClassID;
}

@end

@implementation QLRegisterFinisheInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}

/** Load the default UI elements And prepare some datas needed. */
- (void)loadDefaultSetting {
    [self setTitle:@"完成资料"];
    [_btnApply setCornerRadius:10];
    [_viewOne setBorder:.5 borderColor:QLDividerColor];
    [_viewTwo setBorder:.5 borderColor:QLDividerColor];
    [_viewThree setBorder:.5 borderColor:QLDividerColor];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//selected class data
- (IBAction)touchSelectedClass:(id)sender {
    QLKinderSelectedVC *kinderVC = [[QLKinderSelectedVC alloc]init];
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
    [self upLoadImage:[saveImage scaleMinSideToSize:500]];
}
- (void)upLoadImage:(UIImage *)image{
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,fileUpload_interface];
//    [Tools isBlankString:imageID]?nil:@{@"oldFileId":imageID}
    [QLHttpTool postPerWithBaseUrl:imageURL Parameters:@{@"filePath":@"user"} FormData:data FileExtension:@".jpg" MimeType:@"image/jpg"  whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"image response : %@", responseObject);
        //        imageID = [NSString stringWithFormat:@"%@",responseObject[@"fileId"]];
    } whenFailure:^{
    }];
    
}

- (IBAction)btnApply:(id)sender {
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
    NSString *userLogo = [NSString getValidStringWithObject:_strCode];
    NSString *userTel = [NSString getValidStringWithObject:_userTel];
    NSString *userPwd = [NSString getValidStringWithObject:_userPwd];
    NSString *parentName = [NSString getValidStringWithObject:_tfParentName.text];
    NSString *childName = [NSString getValidStringWithObject:_tfChindName.text];
    NSString *schoolId = [NSString getValidStringWithObject:_strSchoolID];
    NSString *classId = [NSString getValidStringWithObject:_strClassID];
    NSDictionary *dic = @{@"user_photo":userLogo,@"user_tel":userTel,@"user_password":userPwd,@"user_name":parentName,@"child_name":childName,@"school_id":schoolId,@"grade_id":classId};
    [QLHttpTool getWithBaseUrl:strUrl Parameters:dic whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"regiater response : %@",responseObject);
    } whenFailure:^{
        
    }];
}

@end
