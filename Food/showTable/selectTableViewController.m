//
//  selectTableViewController.m
//  Food
//
//  Created by sundaoran on 14-4-2.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "selectTableViewController.h"
#import "MakeSureTableViewController.h"
#import "WebImageView.h"


@interface selectTableViewController ()

@end

@implementation selectTableViewController
{
    CGFloat             VIEWSELFHEIGHT;
    CGFloat             ButtonHeight;
    WebImageView         *_imageView;
    UILabel             *_lblpeopleNum;
    
    NSMutableArray      *_dataButton;
    UIPickerView        *_pickView;
    UIView              *vPicker;
    
    NSMutableArray      *_dataArray;
    
    StoreMessage        *_indexStoreMessage;
    
    BOOL                isSelectTabel;//是否已经选择台位
    CVLocalizationSetting *langSetting;
    
    NSString            *roomName;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithMessageDict:(StoreMessage *)storemessage
{

    self =[super init];
    if(self)
    {
        [self creatView:storemessage];
        _indexStoreMessage=storemessage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     langSetting =  [CVLocalizationSetting sharedInstance];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

-(void)creatView:(StoreMessage *)storemessage
{
    _dataArray=[[NSMutableArray alloc]initWithArray:storemessage.storeRoomArray];
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        VIEWSELFHEIGHT=64.0;
    }
    else
    {
        VIEWSELFHEIGHT=44.0;
    }
    ButtonHeight=0.0;
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWSELFHEIGHT) andTitle:nil];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    UIScrollView  *scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, VIEWSELFHEIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT-VIEWSELFHEIGHT)];
    [self.view addSubview:scroll];
    
    
   
    _imageView=[[WebImageView alloc]initWithImage:[UIImage imageNamed:@"Public_default.png"]];
    _imageView.frame=CGRectMake(10, 10, SUPERVIEWWIDTH-20, SUPERVIEWWIDTH-120);
    [scroll addSubview:_imageView];
    [self getImage:storemessage.storeWbigPic];
//     [NSThread detachNewThreadSelector:@selector(getImage:) toTarget:self withObject:storemessage.storeWbigPic];
    
    _dataButton=[[NSMutableArray alloc]init];
    
    int index=0;
    if([storemessage.storeRoomArray count]>0)
    {
        index=[storemessage.storeTableArray count]+1;
    }
    else
    {
        index=[storemessage.storeTableArray count];
    }
    for (int i=0; i<index; i++)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(30+i%2*((scroll.frame.size.width-70)/2+10), 35*(i/2)+_imageView.frame.origin.y+_imageView.frame.size.height+25, (scroll.frame.size.width-70)/2, 30);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_dataButton addObject:button];
        
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(button.frame.size.width*0.3, 0, button.frame.size.width*0.7, button.frame.size.height)];
        lbl.textAlignment=NSTextAlignmentLeft;
        if([storemessage.storeRoomArray count]>0 && i==index-1)
        {
             lbl.text=[langSetting localizedString:@"rooms"];
        }
        else
        {
            button.tag=[[[storemessage.storeTableArray objectAtIndex:i]objectForKey:@"tablePax"]integerValue];
            lbl.text=[NSString stringWithFormat:[langSetting localizedString:@"Table for %@"], [[storemessage.storeTableArray objectAtIndex:i]objectForKey:@"tablePax"]];
        }
        [button addSubview:lbl];
        
        UIImageView *imageView=[[UIImageView alloc]init];
        
        if((![storemessage.storeRoomArray count] && [[[storemessage.storeTableArray objectAtIndex:i]objectForKey:@"tableNum"]integerValue]<=0)||(i!=index-1&&[storemessage.storeRoomArray count] && [[[storemessage.storeTableArray objectAtIndex:i]objectForKey:@"tableNum"]integerValue]<=0))
        {
            [imageView setImage:[UIImage imageNamed:@"Public_sexcant.png"]];
            button.userInteractionEnabled=NO;
        }
        else
        {
            [imageView setImage:[UIImage imageNamed:@"Public_sexNomal.png"]];
            button.userInteractionEnabled=YES;
        }
        imageView.frame=CGRectMake(0, 3, button.frame.size.width*0.2, button.frame.size.height-6);
        [button addSubview:imageView];
        ButtonHeight=button.frame.origin.y+50;
        [scroll addSubview:button];
    }
    
    
    _lblpeopleNum=[[UILabel alloc]initWithFrame:CGRectMake(30,ButtonHeight, SUPERVIEWWIDTH-60, 25)];
    _lblpeopleNum.text=[NSString stringWithFormat:@"%@",[langSetting localizedString:@"Suitable for   people"]];
    _lblpeopleNum.textAlignment=NSTextAlignmentLeft;
    _lblpeopleNum.font=[UIFont systemFontOfSize:12];
    _lblpeopleNum.textColor=[UIColor grayColor];
    [scroll addSubview:_lblpeopleNum];
    
    
//    下一步
    UIButton  *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(30, _lblpeopleNum.frame.origin.y+35, SUPERVIEWWIDTH-60, 30);
    [nextButton setTitle:[langSetting localizedString:@"Next step"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
     [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(jumpNetView) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:nextButton];
    [scroll setContentSize:CGSizeMake(SUPERVIEWWIDTH, nextButton.frame.origin.y+50)];
}

//获取图片路径
-(void)getImage:(NSString *)url
{
    @autoreleasepool {
        url=[NSString stringWithFormat:@"%@%@",[[DataProvider getIpPlist]objectForKey:@"storesPicURL"],url];
        if([DataProvider imageCache:url])
        {
            [_imageView setImage:[UIImage imageWithData:[DataProvider imageCache:url]]];
        }
        else
        {
            [_imageView setImageURL:[NSURL URLWithString:url] andImageBoundName:@"Public_default.png"];
        }
    }
    
    
}


//显示PickView
-(void)showPickView{
    
    
    if(!vPicker)//避免重复创建pickView
    {
    vPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    UIImage *root_image;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        toolbar.frame = CGRectMake(0, vPicker.frame.size.height-218-42, ScreenWidth, 44);
        root_image = [UIImage imageNamed:@"Order_bgPick.png"];
    }else{
        toolbar.frame = CGRectMake(0, vPicker.frame.size.height-218-44-18, ScreenWidth, 44);
        root_image = [UIImage imageNamed:@"Order_bgPick2.png"];
    }
    
    
    if ([toolbar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
        [toolbar setBackgroundImage:root_image forToolbarPosition:0 barMetrics:0];         //仅5.0以上版本适用
    }else{
        toolbar.barStyle = UIToolbarPositionTop;
    }
    
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [vPicker addSubview:toolbar];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn sizeToFit];
    btn.frame = CGRectMake(0, 0, 60, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:[langSetting localizedString:@"cancel"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.center = CGPointMake(10+btn.frame.size.width/2, 22);
    [toolbar addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn sizeToFit];
    btn.frame = CGRectMake(0, 0, 60, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setTitle:[langSetting localizedString:@"OK"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(confirmClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.center = CGPointMake(ScreenWidth-10-btn.frame.size.width/2, 22);
    [toolbar addSubview:btn];
    
    UIPickerView *pickView = [[UIPickerView alloc] init];
    pickView.tag=10000;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        pickView.frame = CGRectMake(0, vPicker.frame.size.height-218, ScreenWidth, 218) ;
    }else{
        pickView.frame = CGRectMake(0, vPicker.frame.size.height-218-18, ScreenWidth, 218) ;
    }
    pickView.showsSelectionIndicator = YES;
    pickView.delegate = self;
    pickView.dataSource = self;
    pickView.backgroundColor = [UIColor whiteColor];
    
    [vPicker addSubview:pickView];
    
    vPicker.frame = CGRectMake(0, vPicker.frame.size.height, vPicker.frame.size.width, vPicker.frame.size.height);
    [self.view addSubview:vPicker];
    
    [UIView animateWithDuration:.3f animations:^{
        vPicker.frame = CGRectMake(0, 0, vPicker.frame.size.width, vPicker.frame.size.height);
    }];
    }
    else
    {
        NSLog(@"存在pickView");
    }
}

- (void)cancelClicked{
    [UIView animateWithDuration:.3f animations:^{
        vPicker.frame = CGRectMake(0, ScreenHeight, vPicker.frame.size.width, vPicker.frame.size.height);
    }completion:^(BOOL finished) {
        [vPicker removeFromSuperview];
        vPicker = nil;
        
    }];
}

- (void)confirmClicked{
    [UIView animateWithDuration:.3f animations:^{
        vPicker.frame = CGRectMake(0, ScreenHeight, vPicker.frame.size.width, vPicker.frame.size.height);
    }completion:^(BOOL finished) {
        [vPicker removeFromSuperview];
        vPicker = nil;
    }];
}


#pragma mark pickViewDelegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    for (NSObject *view in ((UIButton *)[_dataButton lastObject]).subviews)
    {
        if([view isKindOfClass:[UILabel class]])
        {
            [(UILabel *)view setText:[NSString stringWithFormat:@"%@",[[_dataArray objectAtIndex:row]objectForKey:@"tableName"]]];
        }
    }
    isSelectTabel=YES;
    [DataProvider sharedInstance].isRoom=YES;//选择台位为包间
    [DataProvider sharedInstance].selecttableName=[[_dataArray objectAtIndex:row]objectForKey:@"tableId"];
     _lblpeopleNum.text=[NSString stringWithFormat:[langSetting localizedString:@"Suitable for 1~%@ people"],[[_dataArray objectAtIndex:row]objectForKey:@"tablePax"]];
    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_dataArray count];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *RowView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    RowView.backgroundColor=[UIColor clearColor];
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0,0, ScreenWidth, 40)];
    lbl.text=[NSString stringWithFormat:@"%@:%@%@",[[_dataArray objectAtIndex:row]objectForKey:@"tableName"],[[_dataArray objectAtIndex:row]objectForKey:@"tablePax"],[langSetting localizedString:@"people"]];
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.font=[UIFont systemFontOfSize:15];
    lbl.textColor=[UIColor blackColor];
    [RowView addSubview:lbl];
    
    return RowView;
}

//
-(void)buttonClick:(UIButton *)button
{
    
//_dataButton数组中最后第一个对象为包间的对象
    for (NSObject *view in button.subviews)
    {
        if([view isKindOfClass:[UILabel class]]&& button==[_dataButton lastObject] && [_indexStoreMessage.storeRoomArray count]>0)
        {
            [self showPickView];
        }
        else
        {
            for (UIButton *btn in _dataButton)
            {
                if(button==btn)
                {
                    for (NSObject *view in button.subviews)
                    {
                        if([view isKindOfClass:[UIImageView class]])
                        {
                            [(UIImageView *)view setImage:[UIImage imageNamed:@"Public_sexSelect.png"]];
                        }
                    }
                }
                else if(!btn.userInteractionEnabled)
                {
                    for (NSObject *view in btn.subviews)
                    {
                        if([view isKindOfClass:[UIImageView class]])
                        {
                            [(UIImageView *)view setImage:[UIImage imageNamed:@"Public_sexcant.png"]];
                        }
                    }
                }
                else
                {
                    for (NSObject *view in btn.subviews)
                    {
                        if([view isKindOfClass:[UIImageView class]])
                        {
                            [(UIImageView *)view setImage:[UIImage imageNamed:@"Public_sexNomal.png"]];
                        }
                    }
                }
            }
        }
        
    }
    isSelectTabel=YES;
    [DataProvider sharedInstance].isRoom=NO;  //选择台位为大厅
    [DataProvider sharedInstance].selecttableName=[NSString stringWithFormat:@"%d",button.tag];
    _lblpeopleNum.text=[NSString stringWithFormat:[langSetting localizedString:@"Suitable for 1~%@ people"],[NSString stringWithFormat:@"%d",button.tag]];
}
-(void)jumpNetView
{
//    是否已经选择台位判断
    if(isSelectTabel)
    {
//        bs_dispatch_sync_on_main_thread(^{
           [_imageView cancelRequest];
            MakeSureTableViewController *makeSure=[[MakeSureTableViewController alloc]init];
            [self.navigationController pushViewController:makeSure animated:YES];
//        });
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Did not choose the table type"]];
    }
}

-(void)dealloc
{
//    [_imageView cancelRequest];
}
-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
