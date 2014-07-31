//
//  LookequipotentialViewController.m
//  Food
//
//  Created by sundaoran on 14-5-26.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "LookequipotentialViewController.h"

@interface LookequipotentialViewController ()

@end

@implementation LookequipotentialViewController
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    
    CVLocalizationSetting *langSetting;
    
    NSDictionary        *_info;
    NSString            *_id;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setInfo:(NSDictionary *)info
{
    _info=info;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    langSetting=[CVLocalizationSetting sharedInstance];
    // Do any additional setup after loading the view.
    
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        VIEWHRIGHT=64.0;
    }
    else
    {
        VIEWHRIGHT=44.0;
    }
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:TITIEIMAGEVIEW]];
    imageView.frame=self.view.bounds;
    imageView.userInteractionEnabled=YES;
    [self.view addSubview:imageView];
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:@"等位详情"];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    _backGround.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backGround];
    
    
    for (int i=0; i<5; i++)
    {
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(5,i*41+20, _backGround.frame.size.width-10, 40)];
        backView.backgroundColor=[UIColor clearColor];
        UIImageView *imageLine=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Public_cardline.png"]];
        imageLine.frame=CGRectMake(backView.frame.origin.x,backView.frame.size.height, backView.frame.size.width, 1);
        [backView addSubview:imageLine];
        
        UILabel *lblLeft=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 60, backView.frame.size.height)];
        lblLeft.font=[UIFont systemFontOfSize:17];
        lblLeft.textColor=[UIColor blackColor];
        lblLeft.backgroundColor=[UIColor clearColor];
        lblLeft.textAlignment=NSTextAlignmentLeft;
        [backView addSubview:lblLeft];
        
        UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(lblLeft.frame.origin.x+lblLeft.frame.size.width, 0, backView.frame.size.width-(lblLeft.frame.origin.x+lblLeft.frame.size.width), backView.frame.size.height)];
        lblTitle.font=[UIFont systemFontOfSize:17];
        lblTitle.textColor=[UIColor blackColor];
        lblTitle.backgroundColor=[UIColor clearColor];
        lblTitle.textAlignment=NSTextAlignmentCenter;
        [backView addSubview:lblTitle];
        
        
        switch (i) {
            case 0:
            {
               // 你的等位号码
               
                lblTitle.text=[NSString stringWithFormat:@"%@：%@", [langSetting localizedString:@"Your allelic number"],[_info objectForKey:@"getNo"]];
                lblTitle.frame=CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height);
                lblTitle.textColor=selfbackgroundColor;
            }
                break;
            case 1:
            {
                //
                lblTitle.text=[NSString stringWithFormat:@"当前还有 %@ 位客人正在等位",[_info objectForKey:@"count"]];
                lblTitle.frame=CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height);
                lblTitle.textColor=selfbackgroundColor;
            }
                break;
            case 2:
            {
                //店名
                lblLeft.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Stores"]];
                lblTitle.text=[_info objectForKey:@"firmdes"];
                lblTitle.font=[UIFont systemFontOfSize:14];
                lblTitle.numberOfLines=2;
            }
                break;
            case 3:
            {
                //地址
                lblLeft.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Address"]];
                lblTitle.text=[_info objectForKey:@"addr"];
                lblTitle.font=[UIFont systemFontOfSize:14];
                lblTitle.numberOfLines=2;
            }
                break;
            case 4:
            {
                //电话
                lblLeft.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Telephone"]];
                lblTitle.text=[_info objectForKey:@"tele"];
                lblTitle.textAlignment=NSTextAlignmentLeft;
                
                UIButton *buttonPhone=[UIButton buttonWithType:UIButtonTypeCustom];
                [buttonPhone setBackgroundImage:[UIImage imageNamed:@"Public_tele.png"] forState:UIControlStateNormal];
                buttonPhone.titleLabel.text=[_info objectForKey:@"tele"];
                buttonPhone.frame=CGRectMake(backView.frame.size.width-40,5 , 30, 30);
                [buttonPhone addTarget:self action:@selector(buttonClickPhone:) forControlEvents:UIControlEventTouchUpInside];
                [backView addSubview:buttonPhone];
                
            }
                break;

            default:
                break;
        }
        
        [_backGround addSubview:backView];
    }
    
    CGFloat   height= ((UIView *)[[_backGround subviews]lastObject]).frame.origin.y+ ((UIView *)[[_backGround subviews]lastObject]).frame.size.height;
    UIButton *buttonCancle=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCancle setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [buttonCancle setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    buttonCancle.frame=CGRectMake(10, height+30, _backGround.frame.size.width-20, 40);
//    取消等位
    [buttonCancle setTitle:[langSetting localizedString:@"Cancel the allelic"] forState:UIControlStateNormal];
    [buttonCancle addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_backGround addSubview:buttonCancle];
    
    _id=[_info objectForKey:@"id"];
    
}


//点击事件，取消叫号请求
-(void)buttonClick
{
    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(cancelOrder) toTarget:self withObject:nil];
}

//取消叫号结果处理
-(void)cancelOrder
{
    @autoreleasepool
    {
        DataProvider *dp=[DataProvider sharedInstance];
        NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
        [Info setObject:_id forKey:@"orderId"];
        NSDictionary *dict=[dp cancleWait:Info];
        if([[dict objectForKey:@"Result"]boolValue])
        {
            bs_dispatch_sync_on_main_thread(^{
                [SVProgressHUD dismiss];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"等位取消成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            });
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
        
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
//    刷新叫号台位列表通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refushMyWaitList" object:nil];
    [SVProgressHUD dismiss];
}


//电话事件
-(void)buttonClickPhone:(UIButton *)button
{
    [self.view addSubview:[DataProvider callPhoneOrtele:button.titleLabel.text]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
