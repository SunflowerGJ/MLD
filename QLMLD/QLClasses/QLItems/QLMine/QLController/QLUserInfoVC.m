//
//  QLUserInfoVC.m
//  QLMLD
//
//  Created by syy on 2017/7/12.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLUserInfoVC.h"
#import "QLAlterPwdVC.h"
@interface QLUserInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    __weak IBOutlet UIButton *_btnImageHead;
    
    __weak IBOutlet UILabel *_lblName;
    
    __weak IBOutlet UILabel *_lblAccount;
    __weak IBOutlet UIButton *_btnLogout;
}

@end

@implementation QLUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"个人信息";
    [_btnLogout setBorder:.5 borderColor:QLDividerColor];
    [_btnImageHead setCornerRadius:20];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//修改密码
- (IBAction)touchToAlterPwd:(id)sender {
    QLAlterPwdVC *alterVC = [[QLAlterPwdVC alloc]init];
    [[QLHttpTool getCurrentVC].navigationController pushViewController:alterVC animated:YES];
}
//退出登录
- (IBAction)btnLogout:(id)sender {
    
}
- (IBAction)uploadHeadImage:(id)sender {
    QLLog(@"更换头像");
    UIActionSheet *sheetSelect = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [sheetSelect showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0)//拍照
    {
        UIImagePickerController *  imagePicker1 = [[UIImagePickerController alloc] init];
        imagePicker1.delegate = self;
        imagePicker1.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePicker1.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        imagePicker1.allowsEditing=YES;
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
        imagePicker1.allowsEditing=YES;
        if([[[UIDevice
              currentDevice] systemVersion] floatValue]>=8.0) {
            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:imagePicker1 animated:YES completion:nil];
    }
}
#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *imageData =  UIImageJPEGRepresentation(image, 0.6f);
    UIImage *saveImage = [UIImage imageWithData:imageData];
    [self upLoadImage:[saveImage scaleMinSideToSize:300]];
}
#pragma mark - 头像处理
- (void)upLoadImage:(UIImage *)image{
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,uploadHeadImage_interface];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    [QLHUDTool showLoading];
    [QLHttpTool postPerWithBaseUrl:imageURL Parameters:nil FormData:data FileExtension:@".jpg" MimeType:@"image/jpg"  whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([responseObject[@"err_code"] isEqualToString:@"ok"]) {
                [QLHUDTool showAlertMessage:@"图片上传成功！"];
                NSString *fileID = [NSString stringWithFormat:@"%@",responseObject[@"fileid"]];
//                [self alterHeadImage:fileID];
            }
        }
    } whenFailure:^{
    }];
}

@end
