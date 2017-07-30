//
//  QLAddAddressVC.m
//  QLMLD
//
//  Created by 英英 on 2017/7/30.
//  Copyright © 2017年 Shreker. All rights reserved.
//

#import "QLAddAddressVC.h"
#import "QLSelectAreaView.h"
@interface QLAddAddressVC ()<QLSelectAreaDelegate>{
    
    __weak IBOutlet UILabel *_lblArea;
    __weak IBOutlet UITextField *_lblUserName;
    __weak IBOutlet UITextField *_lblTele;
    __weak IBOutlet UITextView *_textViewDetailAddress;
    __weak IBOutlet UIImageView *_imgCheck;
    QLSelectAreaView *_selectAreaView;
    BOOL isDefault;
    __weak IBOutlet UIButton *_btnCheck;
    __weak IBOutlet UIButton *_btnSave;
}

@end

@implementation QLAddAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultSetting];
}
- (void)loadDefaultSetting {
    self.title = @"添加地址";
    isDefault = NO;
    [_btnSave setCornerRadius:QLCornerRadius];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)selectArea:(id)sender {
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"QLSelectAreaView" owner:self options:nil];
    _selectAreaView= [nib objectAtIndex:0];
    _selectAreaView.delegate=self;
    _selectAreaView.frame = CGRectMake(0, 0, QLScreenWidth, QLScreenHeight);
    [self.view addSubview:_selectAreaView];
}
- (void)selectArea:(NSString *)province city:(NSString *)city country:(NSString *)country{
    QLLog(@"快看看 == %@,%@,%@",province,city,country);
}
- (IBAction)setDefault:(id)sender {
    isDefault = !isDefault;
    _btnCheck.selected = isDefault;
    
}
- (IBAction)btnSave:(id)sender {
    NSString *strBaseUrl = [NSString stringWithFormat:@"%@%@",QLBaseUrlString,nil];
    NSDictionary *dic = @{};
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:dic whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } whenFailure:^{
        
    }];
}

@end
