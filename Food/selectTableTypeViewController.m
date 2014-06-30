//
//  selectTableTypeViewController.m
//  Food
//
//  Created by sundaoran on 14-5-15.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "selectTableTypeViewController.h"
#import "queneSuccessView.h"

@interface selectTableTypeViewController ()

@end

@implementation selectTableTypeViewController
{
    UIScrollView              *_backGround;
    CGFloat                     VIEWHRIGHT;
    CVLocalizationSetting       *langSetting;
    NSDictionary               *_storeDict;
    NSMutableArray              *_dataArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//设置门店数据
-(void)setStoreDict:(NSDictionary *)storeDict
{
    _storeDict=storeDict;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    langSetting=[CVLocalizationSetting sharedInstance];
    self.view.backgroundColor=[UIColor whiteColor];
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Select the table type"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIScrollView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    _backGround.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backGround];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refushTable) name:@"refushTable" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAlertView) name:@"showAlertView" object:nil];
    [self refushTable];
    
}


//成功叫号提示框
-(void)showAlertView
{
    bs_dispatch_sync_on_main_thread(^{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"叫号成功\n是否返回菜单界面" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alert show];
    
    });
}
//可叫号门店台位列别数据请求
-(void)refushTable
{
    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(findPaxByFirm) toTarget:self withObject:nil];
}

//获取可叫号门店数据处理
-(void)findPaxByFirm
{
    @autoreleasepool
    {
        DataProvider *dp=[DataProvider sharedInstance];
        NSDictionary *dict=[dp findPaxByFirm:_storeDict];
        if([[dict objectForKey:@"Result"]boolValue])
        {
            for (int i=0; i<[_backGround.subviews count]; i++)
            {
                [((UIView *)[_backGround.subviews objectAtIndex:i]) removeFromSuperview];
            }
            _dataArray=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"Message"]];
            [SVProgressHUD dismiss];
            if([_dataArray count]==0)
            {
                bs_dispatch_sync_on_main_thread(^{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:@"该门店暂无可叫号台位" delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
                    [alert show];
                });
                
            }
            else
            {
                for (int i=0; i<[_dataArray count]; i++)
                {
                    NSDictionary *dictMessage=[_dataArray objectAtIndex:i];
                    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame=CGRectMake(i%2*((ScreenWidth-15)/2+5)+5, i/2*((ScreenWidth-15)/2+5)+15, (ScreenWidth-15)/2, (ScreenWidth-15)/2);
                    switch (i%4) {
                        case 0:
                        {
                            [button setBackgroundImage:[UIImage imageNamed:@"Public_tablered.png"] forState:UIControlStateNormal];
                        }
                            break;
                        case 1:
                        {
                            [button setBackgroundImage:[UIImage imageNamed:@"Public_tableyellow.png"] forState:UIControlStateNormal];
                        }
                            break;
                        case 2:
                        {
                            [button setBackgroundImage:[UIImage imageNamed:@"Public_tablegreen.png"] forState:UIControlStateNormal];
                        }
                            break;
                        case 3:
                        {
                            [button setBackgroundImage:[UIImage imageNamed:@"Public_tableblue.png"] forState:UIControlStateNormal];
                        }
                            break;
                            
                        default:
                            break;
                    }
                    [_backGround addSubview:button];
                   
//                   台位适合人数，上线+3
                    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height*0.3)];
                    [lblName setText:[NSString stringWithFormat:@"%c  %@~%d %@",'A'+i,[dictMessage objectForKey:@"pax"], [[dictMessage objectForKey:@"pax"]intValue]+3,[langSetting localizedString:@"people"]]];
                    lblName.textAlignment=NSTextAlignmentCenter;
                    lblName.backgroundColor=[UIColor clearColor];
                    lblName.font=[UIFont systemFontOfSize:17];
                    lblName.textColor=[UIColor whiteColor];
                    [button addSubview:lblName];
                    
//                    台位名称
                    UILabel  *lbltableNum=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
                    [lbltableNum setText:[NSString stringWithFormat:@"%@", [dictMessage objectForKey:@"pax"]]];
                    lbltableNum.textAlignment=NSTextAlignmentCenter;
                    lbltableNum.backgroundColor=[UIColor clearColor];
                    lbltableNum.font=[UIFont systemFontOfSize:70];
                    lbltableNum.textColor=[UIColor whiteColor];
                    [button addSubview:lbltableNum];
                    
//                    当前叫至多少号
                    UILabel  *lblNow=[[UILabel alloc]initWithFrame:CGRectMake(0, button.frame.size.height-button.frame.size.height*0.3, button.frame.size.width, button.frame.size.height*0.3)];
                    [lblNow setText:[NSString stringWithFormat:[NSString stringWithFormat:@"%@",[langSetting localizedString:@"The current has called to %@"]],[dictMessage objectForKey:@"callingno"]]];
                    lblNow.textAlignment=NSTextAlignmentCenter;
                    lblNow.backgroundColor=[UIColor clearColor];
                    lblNow.font=[UIFont systemFontOfSize:13];
                    lblNow.textColor=[UIColor whiteColor];
                    
//                    button.tag=[[dictMessage objectForKey:@"pax"]intValue];
                    button.tag=i;
                    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [button addSubview:lblNow];
                    
                    [_backGround setContentSize:CGSizeMake(ScreenWidth, button.frame.origin.y+button.frame.size.height+VIEWHRIGHT+20)];
                    
                }

            }
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
        
    }
}

//叫号请求发送
-(void)buttonClick:(UIButton *)button
{
    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(addlineNo:) toTarget:self withObject:[_dataArray objectAtIndex:button.tag]];
    
}

//发送叫号信息
-(void)addlineNo:(NSDictionary *)dict
{
    
//    数据上传需要手机号码和用户id，如果不存在则不能叫号
    if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]boolValue ] ||![[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]boolValue ])
    {
        //@"请先绑定手机号码"
        [SVProgressHUD showErrorWithStatus:@"请先绑定手机号码\n并提交个人信息"];//[langSetting localizedString:@"Please first binding mobile phone number"]
    }
    else
    {
        DataProvider *dp=[DataProvider sharedInstance];
        NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
        [Info setObject:[_storeDict objectForKey:@"firmid"] forKey:@"firmid"];
        [Info setObject:[dict objectForKey:@"pax"] forKey:@"pax"];
        [Info setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"userId"];
        [Info setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"] forKey:@"mobtel"];
        NSMutableDictionary *dictValue=[[NSMutableDictionary alloc]initWithDictionary:[dp addlineNo:Info]];
        if([[dictValue objectForKey:@"Result"]boolValue])
        {
            [SVProgressHUD dismiss];
            NSMutableDictionary *info=[[NSMutableDictionary alloc]initWithDictionary:[[dictValue objectForKey:@"Message"]firstObject]];
            
            [info setObject:[dict objectForKey:@"pax"] forKey:@"pax"];
            queneSuccessView *success=[[queneSuccessView alloc]initWithInfo:info];
            [success show];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dictValue objectForKey:@"Message"]];
        }
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(1==buttonIndex)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
         [[NSNotificationCenter defaultCenter]postNotificationName:@"refushTable" object:nil];
//        [self refushTable];
    }
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
