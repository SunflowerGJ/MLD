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
#import "ELCImagePickerController.h"
#import "QLAdmissionPublishVC.h"
#import "MKJCollectionViewCell.h"
#import "MKJItemModel.h"
#import "MKJCollectionViewFlowLayout.h"
static NSString *indentify = @"MKJCollectionViewCell";

@interface QLAdmissionHome ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ELCImagePickerControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,MKJCollectionViewFlowLayoutDelegate>{
    
    QLAdmisiionSlideVC *slideVC;
    NSString *_strTime;
    NSMutableArray *_datas;
    __weak IBOutlet UICollectionView *_collectionView;
}

@end

@implementation QLAdmissionHome

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataRequest];
    [self loadDefaultSetting];
    [self addsubviews];
}
- (void)loadDefaultSetting {
  
    self.leftBtn.hidden = NO;
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
    
    [QLHttpTool postWithBaseUrl:strBaseUrl Parameters:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *array = [NSMutableArray new];
        array = [QLAdmissionHomeDataModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        array = responseObject[@"data"];
        self.dataSource = [[NSMutableArray alloc] initWithArray:array];
                           
    } whenFailure:^{
        
    }];
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

#pragma mark - new picture test
- (void)addsubviews {
    MKJCollectionViewFlowLayout *flow = [[MKJCollectionViewFlowLayout alloc] init];
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.itemSize = CGSizeMake(QLScreenWidth / 1.8, QLScreenWidth-50);
    flow.minimumLineSpacing = 20;
    flow.minimumInteritemSpacing = 20;
    flow.needAlpha = YES;
    flow.delegate = self;
    CGFloat oneX =QLScreenWidth / 4;
    flow.sectionInset = UIEdgeInsetsMake(0, oneX, 0, oneX);
    
    //TODO:这里设置frame
    [_collectionView setCollectionViewLayout:flow];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [_collectionView registerNib:[UINib nibWithNibName:indentify bundle:nil] forCellWithReuseIdentifier:indentify];
    
    [self datas];
}

#pragma makr - collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MKJItemModel *model = _datas[indexPath.item];
    MKJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentify forIndexPath:indexPath];
    cell.heroImageVIew.image = [UIImage imageNamed:model.imageName];
    
    //在这里设置网络图片，
    [cell.heroImageVIew sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
    
    cell.titleLabel.text = model.titleName;
    
    return cell;
}

// 点击item的时候
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGPoint pInUnderView = [self.view convertPoint:collectionView.center toView:collectionView];
    
    // 获取中间的indexpath
    NSIndexPath *indexpathNew = [collectionView indexPathForItemAtPoint:pInUnderView];
    
    if (indexPath.row == indexpathNew.row)
    {
        NSLog(@"点击了同一个 %ld",indexPath.row);
        return;
    }
    else
    {
        [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
}

#pragma CustomLayout的代理方法
- (void)collectioViewScrollToIndex:(NSInteger)index
{
    //do something you want to
}


- (NSMutableArray*)datas {
    
    if (!_datas) {
        
        _datas = [NSMutableArray array];
        
        {
            MKJItemModel *model = [[MKJItemModel alloc]init];
            
            model.imageName = @"0";
            model.imageURL = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1501736483332&di=76df714cbfee8413baf7331adde346df&imgtype=0&src=http%3A%2F%2Fimg.qqzhi.com%2Fupload%2Fimg_4_2981529949D3712932919_23.jpg";
            model.titleName = @"2017-06-06";
            
            [_datas addObject:model];
        }
        
        {
            MKJItemModel *model = [[MKJItemModel alloc]init];
            
            model.imageName = @"1";
            model.imageURL = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1501736483823&di=ac97884151d1e94d86eaa293b45f862e&imgtype=0&src=http%3A%2F%2Fimg2.a0bi.com%2Fupload%2Fqz%2F20150715%2F313479192953-1379.jpg";
            model.titleName = @"2017-06-07";
            
            [_datas addObject:model];
        }
        
        {
            MKJItemModel *model = [[MKJItemModel alloc]init];
            
            model.imageName = @"2";
            model.imageURL = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1501736483823&di=8bfd7b2e5b5dc76d9af3e255cc165a1c&imgtype=0&src=http%3A%2F%2Fjf258.com%2Fuploads%2F2015-05-16%2F140143280.jpg";
            model.titleName = @"2017-06-08";
            
            [_datas addObject:model];
        }
        
        {
            MKJItemModel *model = [[MKJItemModel alloc]init];
            
            model.imageName = @"3";
            model.imageURL = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1501736522923&di=ae9c993a5c9a4584b7ffe4206a751b35&imgtype=0&src=http%3A%2F%2Fwww.liaoswy.com%2Fqqimg%2Fbd33885800.jpg";
            model.titleName = @"2017-06-09";
            
            [_datas addObject:model];
        }
        
        {
            MKJItemModel *model = [[MKJItemModel alloc]init];
            
            model.imageName = @"4";
            model.imageURL = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1501736522923&di=9cd8343b9af3549152a40b0ab29b9217&imgtype=0&src=http%3A%2F%2Fm.qqzhi.com%2Fupload%2Fimg_2_990630281D4221516853_23.jpg";
            model.titleName = @"2017-06-10";
            
            [_datas addObject:model];
        }
    }
    
    return _datas;
}


@end
