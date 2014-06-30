//
//  LookReserveViewController.m
//  Food
//
//  Created by sundaoran on 14-5-20.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "LookReserveViewController.h"
#import "LookOrderViewController.h"

@interface LookReserveViewController ()

@end

@implementation LookReserveViewController
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
-(void)setReserve:(NSDictionary *)Info
{
    _info=Info;
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:@"预定详情"];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    _backGround.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backGround];
    
    
    for (int i=0; i<6; i++)
    {
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(5,i*41+20, _backGround.frame.size.width-10, 40)];
        backView.backgroundColor=[UIColor clearColor];
        UIImageView *imageLine=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Public_cardline.png"]];
        imageLine.frame=CGRectMake(backView.frame.origin.x,backView.frame.size.height, backView.frame.size.width, 1);
        [backView addSubview:imageLine];
        
        UILabel *lblLeft=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, backView.frame.size.height)];
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
                //店名
                lblLeft.text=@"门店名称:";
//                [NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Stores"]];
                lblTitle.text=[_info objectForKey:@"firmdes"];
                lblTitle.font=[UIFont systemFontOfSize:14];
                lblTitle.numberOfLines=2;
            }
                break;
            case 1:
            {
                //日期
                lblLeft.text=@"订餐日期:";
//                [NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Date"]];
                lblTitle.text=[_info objectForKey:@"orderTimes"];
            }
                break;
            case 2:
            {
                //时间
                lblLeft.text=@"就餐时间:";
//                [NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Time"]];
                lblTitle.text=[NSString stringWithFormat:@"%@  %@",[_info objectForKey:@"dat"],[_info objectForKey:@"datmins"]];
            }
                break;
            case 3:
            {
//                台位名称
                lblLeft.text=@"台位类型:";
                NSString *tableType=[[[_info objectForKey:@"tblname"]componentsSeparatedByString:@":"]firstObject ];
                NSString *tableName=[[[_info objectForKey:@"tblname"]componentsSeparatedByString:@":"]lastObject ];
                if([tableType isEqualToString:@"0"] && ![tableName isEqualToString:@"0"] )
                {
                    
                    lblTitle.text=[NSString stringWithFormat:@"%@人台",tableName];
                }
                else if([tableType isEqualToString:@"1"])
                {
                     lblLeft.text=@"台位名称:";
                    lblTitle.text=[NSString stringWithFormat:@"%@",tableName];
                }
                else
                {
                    lblTitle.text=@"暂无台位信息";
                }
            }
                break;
            case 4:
            {
                //地址
                lblLeft.text=@"门店地址:";
//                [NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Address"]];
                lblTitle.text=[_info objectForKey:@"addr"];
                lblTitle.font=[UIFont systemFontOfSize:14];
                lblTitle.numberOfLines=2;
            }
                break;
            case 5:
            {
                //电话
                lblLeft.text=@"门店电话:";
                [NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Telephone"]];
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
            case 6:
            {
                //备注
                lblLeft.text=@"订单备注:";
//                [NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Note"]];
                NSString *remark=[_info objectForKey:@"remark"];
                if([remark isEqualToString:@"null"]||remark==nil ||!remark)
                {
                    lblTitle.text=@"";
                    
                }
                else
                {
                    lblTitle.text=[_info objectForKey:@"remark"];
                    lblTitle.font=[UIFont systemFontOfSize:14];
                    lblTitle.numberOfLines=2;
                }
                lblTitle.textAlignment=NSTextAlignmentLeft;
            }
                break;
                
                
            default:
                break;
        }
        
        [_backGround addSubview:backView];
    }
    
     _id=[_info objectForKey:@"id"];
    CGFloat   height= ((UIView *)[[_backGround subviews]lastObject]).frame.origin.y+ ((UIView *)[[_backGround subviews]lastObject]).frame.size.height;
    
    UIButton *buttonLookOrder=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonLookOrder setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [buttonLookOrder setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    buttonLookOrder.frame=CGRectMake(10, height+30,( _backGround.frame.size.width-30)/2, 40);
    //取消预定
    [buttonLookOrder setTitle:@"菜品详情" forState:UIControlStateNormal];
    [buttonLookOrder addTarget:self action:@selector(buttonClickLookOrder) forControlEvents:UIControlEventTouchUpInside];
    
    [_backGround addSubview:buttonLookOrder];

    UIButton *buttonCancle=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonCancle setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [buttonCancle setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    buttonCancle.frame=CGRectMake(( _backGround.frame.size.width-30)/2+20, height+30, ( _backGround.frame.size.width-30)/2, 40);
    //取消预定
    [buttonCancle setTitle:[langSetting localizedString:@"Cancel the reservation"] forState:UIControlStateNormal];
    [buttonCancle addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];

    [_backGround addSubview:buttonCancle];
    
}

//取消预定请求事件
-(void)buttonClick
{
    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(cancelOrder) toTarget:self withObject:nil];
}
//取消预定处理结果
-(void)cancelOrder
{
    @autoreleasepool
    {
        DataProvider *dp=[DataProvider sharedInstance];
        NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
        [Info setObject:_id forKey:@"orderId"];
        NSDictionary *dict=[dp cancelOrder:Info];
        if([[dict objectForKey:@"Result"]boolValue])
        {
            [SVProgressHUD dismiss];
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"预定取消成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                });

        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
        
        
    }
}


//查看账单详情请求事件
-(void)buttonClickLookOrder
{
    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(LookOrder) toTarget:self withObject:nil];

}

//查看账单详情请求结果处理
-(void)LookOrder
{
    @autoreleasepool
    {
        NSMutableArray *OrderDataArray;
        DataProvider *dp=[DataProvider sharedInstance];
        NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
        [Info setObject:_id forKey:@"orderId"];
        NSDictionary *dict=[dp getOrderDetail:Info];
        if([[dict objectForKey:@"Result"]boolValue])
        {
            [SVProgressHUD dismiss];
            OrderDataArray=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"Message"]];
            if([OrderDataArray count]<=0)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"此订单未点菜" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                LookOrderViewController *look=[[LookOrderViewController alloc]initWithInfo:OrderDataArray];
                [self.navigationController pushViewController:look animated:YES];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
    }

}


//返回到上一界面后刷新上一个界面的视图通知
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refushOrder" object:nil];
}

//电话事件
-(void)buttonClickPhone:(UIButton *)button
{
    [self.view addSubview:[DataProvider callPhoneOrtele:button.titleLabel.text]];
}

-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
