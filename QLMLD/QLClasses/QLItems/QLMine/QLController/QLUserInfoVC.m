//
//  QLUserInfoVC.m
//  QLMLD
//
//  Created by syy on 2017/7/12.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLUserInfoVC.h"
#import "QLAlterPwdVC.h"
#import "QLAppDelegate.h"
@interface QLUserInfoVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    __weak IBOutlet UIImageView *_imageHead;
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
    [_imageHead setCornerRadius:20];
    NSString *tele = [QLUserTool sharedUserTool].userModel.user_tel;
    NSString *name = [QLUserTool sharedUserTool].userModel.user_name;
    NSString *strHeadUrl = [QLUserTool sharedUserTool].userModel.user_photo;
    _lblName.text = name;
    _lblAccount.text = tele;
    [_imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image,strHeadUrl]]  placeholderImage:nil];
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
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确认退出登录?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        [[QLUserTool sharedUserTool] logout];
    }
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
    NSData *data = UIImageJPEGRepresentation(image, 1);
    [QLHUDTool showLoading];
    __weak typeof(self) weakSelf = self;
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString_Image,fileUpload_interface];
    [QLHttpTool postPerWithBaseUrl:strBaseUrl Parameters:@{@"basePath":@"user"} FormData:data FileExtension:@".jpg" MimeType:@"image/jpg"  whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"image response : %@", responseObject);
         NSString * imageID = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
        _imageHead.image = image;
        [weakSelf updateData:imageID];
    } whenFailure:^{
    }];

}
- (void)updateData:(NSString *)url{
    NSString *imageURL = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,alterHeadImage_interface];
    NSDictionary *dic = @{@"userPhoto":url};
    [QLHttpTool postWithBaseUrl:imageURL Parameters:dic whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        QLLog(@"修改头像：%@",responseObject);
    } whenFailure:^{
        
    }];
}
@end
