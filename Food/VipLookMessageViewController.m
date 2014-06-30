//
//  VipLookMessageViewController.m
//  Food
//
//  Created by sundaoran on 14-4-24.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//
//查看会员卡信息
#import "VipLookMessageViewController.h"
#import "VipMessageClass.h"
#import "VipCheckSelectViewController.h"

@interface VipLookMessageViewController ()
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    CVLocalizationSetting *langSetting;
    UITableView         *_tableView;
    NSMutableArray      *_dataArray;
    BOOL                isShow;//是否展示会员专享说明
    
    UIWebView             *_webVipSpecial;//会员专享lbl
    
    NSString            *_callPhoneOrTele;
    
    NSDictionary        *_resultDict;//规则信息
}

@end

@implementation VipLookMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isShow=NO;//默认不展开显示专享说明
    
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"My Vip cards"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT-VIEWHRIGHT);
    [self.view addSubview:_backGround];

    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, _backGround.frame.size.width, _backGround.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_backGround addSubview:_tableView];
    
     [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(getCardRules) toTarget:self withObject:nil];
   
}

//获取会员卡各种使用规则或者声明信息
-(void)getCardRules
{
    @autoreleasepool
    {
        DataProvider *dp=[DataProvider sharedInstance];
        NSDictionary *dict=[dp getCardResult];
        if([[dict objectForKey:@"Result"]boolValue])
        {
            _resultDict =[[[[dict objectForKey:@"Message"] objectForKey:@"listCard"]objectForKey:@"cardRules"]objectForKey:@"com.choice.webService.domain.CardRules"];
            
            bs_dispatch_sync_on_main_thread(^{
                
                
                // 测试字串
                NSString *str = [_resultDict objectForKey:@"exclusprivle"];
                UIFont *font = [UIFont systemFontOfSize:22];
                //设置一个行高上限
                CGSize size = CGSizeMake(ScreenWidth,ScreenHeight);
                //计算实际frame大小，并将label的frame变成实际大小
                CGSize labelsize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
                _webVipSpecial=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
                _webVipSpecial.scrollView.bounces=YES;
                [_webVipSpecial loadHTMLString:str baseURL:nil];
                _webVipSpecial.frame=CGRectMake(5, 0, labelsize.width-15, labelsize.height);
            });
            
            
        }
        [SVProgressHUD dismiss];
    }
}

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==2 && isShow)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 105;
    }
    else if (section==1 ||section==4)
    {
        return 41*3+5;
    }
    else if (section==2)
    {
        return 45;
    }
    else if (section==3)
    {
        return 41*2+5;
    }
    else if (section==5)
    {
        return 50;
    }
    else
    {
        return 100;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==2 && isShow)
    {
        return _webVipSpecial.frame.size.height;
    }
    else
    {
        return 0;
    }

}


//将所有的会员卡可查看选项添加在section上而不是cell上
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    获取选择会员卡单利
    VipMessageClass *vipMessage=[DataProvider sharedInstance].selectVip;
    //添加会员卡logo
    UIView *headView=[[UIView alloc]init];
    headView.backgroundColor=[UIColor whiteColor];
    if(section==0)
    {
        headView.frame=CGRectMake(0, 0, ScreenWidth, 105);
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"card_logo.png"]];
        imageView.frame=CGRectMake(50, 5, ScreenWidth-100, 100);
        [headView addSubview:imageView];
    }
    
//    会员余额，积分，电子劵
    else if (section==1)
    {
        headView.frame=CGRectMake(0, 0, ScreenWidth, 128);
        UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(5, 5, ScreenWidth-10, 123)];
        view.backgroundColor=[UIColor whiteColor];
        view.layer.borderColor=selfborderColor.CGColor;
        view.layer.borderWidth=0.5;
        view.layer.cornerRadius=5;
        [headView addSubview:view];
        for (int i=0; i<3; i++)
        {
            
            UIButton *btnsection1=[UIButton buttonWithType:UIButtonTypeCustom];
            btnsection1.frame=CGRectMake(0, i*41, view.frame.size.width, 40);
            [btnsection1 addTarget:self action:@selector(buttonClickSection:) forControlEvents:UIControlEventTouchUpInside];
            [btnsection1 setTag:section*100+i ];
            [btnsection1 setBackgroundColor:[UIColor whiteColor]];
            
            
            UIImageView  *imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
            [imageViewLeft setImage:[UIImage imageNamed:@"Public_value.png"]];
            [btnsection1 addSubview:imageViewLeft];
            
           UIImageView *imgJianTou=[[UIImageView alloc] initWithFrame:CGRectMake(btnsection1.frame.size.width-30, 10, 20, 20)];
            [imgJianTou setImage:[UIImage imageNamed:@"Public_arrows.png"]];
            [btnsection1 addSubview:imgJianTou];
            
            UILabel  *lblLeft=[[UILabel alloc]init];
            lblLeft.frame=CGRectMake(imageViewLeft.frame.size.width+imageViewLeft.frame.origin.x+5,0,70, 40);
            lblLeft.textAlignment=NSTextAlignmentLeft;
            lblLeft.backgroundColor=[UIColor clearColor];
            lblLeft.font=[UIFont systemFontOfSize:14];
            [lblLeft setTextColor:[UIColor blackColor]];
            [btnsection1 addSubview:lblLeft];
            
            UILabel  *lbltitle=[[UILabel alloc]init];
            lbltitle.frame=CGRectMake(lblLeft.frame.size.width+lblLeft.frame.origin.x,0,70, 40);
            lbltitle.textAlignment=NSTextAlignmentLeft;
            lbltitle.backgroundColor=[UIColor clearColor];
            lbltitle.font=[UIFont systemFontOfSize:14];
            [lbltitle setTextColor:[UIColor blackColor]];
            [btnsection1 addSubview:lbltitle];
            if(i!=2)
            {
                UIImageView *lineView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Public_cardline.png"]];
                lineView.frame=CGRectMake(0,btnsection1.frame.size.height, btnsection1.frame.size.width, 1);
                [btnsection1 addSubview:lineView];
            }
            switch (i) {
                    
                case 0:
                {
//                    余       额
                    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Balance"]]];
                    [lbltitle setText:vipMessage.cardzAmt];
                }
                    break;
                case 1:
                {
//                    积       分
                    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Integral"]]];
                    [lbltitle setText:vipMessage.cardttlFen];
                }
                    break;
                case 2:
                {
//                    电  子  劵
                    [lblLeft setText:[langSetting localizedString:@"Securities"]];
                }
                    break;
                default:
                    break;
            }
            [view addSubview:btnsection1];
        }
    }
    
    //    会员专享特权
    else if (section==2)
    {
        headView.frame=CGRectMake(0, 0, ScreenWidth, 45);
        UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(5, 5, ScreenWidth-10, 40)];
        view.backgroundColor=[UIColor whiteColor];
        view.layer.borderColor=selfborderColor.CGColor;
        view.layer.borderWidth=0.5;
        view.layer.cornerRadius=5;
        [headView addSubview:view];
        
        UIButton *btnsection2=[UIButton buttonWithType:UIButtonTypeCustom];
        btnsection2.frame=CGRectMake(0, 0, view.frame.size.width, 40);
        [btnsection2 addTarget:self action:@selector(buttonClickSection:) forControlEvents:UIControlEventTouchUpInside];
        [btnsection2 setTag:section*100];
        [btnsection2 setBackgroundColor:[UIColor whiteColor]];
        
        
        UIImageView  *imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
        [imageViewLeft setImage:[UIImage imageNamed:@"Public_specific.png"]];
        [btnsection2 addSubview:imageViewLeft];
        
        UIImageView *imgJianTou=[[UIImageView alloc] initWithFrame:CGRectMake(btnsection2.frame.size.width-30, 10, 20, 20)];
        if (isShow)
        {
           [imgJianTou setImage:[UIImage imageNamed:@"Public_up.png"]];
        }
        else
        {
        [imgJianTou setImage:[UIImage imageNamed:@"Public_down.png"]];
        }
        [imgJianTou setTag:10010];//改变箭头方向，用tag值获取空间
        [btnsection2 addSubview:imgJianTou];
        
        UILabel  *lblLeft=[[UILabel alloc]init];
        lblLeft.frame=CGRectMake(imageViewLeft.frame.size.width+imageViewLeft.frame.origin.x+5,0,90, 40);
        lblLeft.textAlignment=NSTextAlignmentLeft;
//        会员专享特权
        [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Exclusive privilege"]]];
        lblLeft.backgroundColor=[UIColor clearColor];
        lblLeft.font=[UIFont systemFontOfSize:14];
        [lblLeft setTextColor:[UIColor blackColor]];
        [btnsection2 addSubview:lblLeft];
        [view addSubview:btnsection2];
    }
    
    //    会员充值，消费记录
    else if (section==3)
    {
        headView.frame=CGRectMake(0, 0, ScreenWidth, 87);
        UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(5, 5, ScreenWidth-10, 82)];
        view.backgroundColor=[UIColor whiteColor];
        view.layer.borderColor=selfborderColor.CGColor;
        view.layer.borderWidth=0.5;
        view.layer.cornerRadius=5;
        [headView addSubview:view];
        for (int i=0; i<2; i++)
        {
            
            UIButton *btnsection3=[UIButton buttonWithType:UIButtonTypeCustom];
            btnsection3.frame=CGRectMake(0, i*41, view.frame.size.width, 40);
            [btnsection3 addTarget:self action:@selector(buttonClickSection:) forControlEvents:UIControlEventTouchUpInside];
            [btnsection3 setTag:section*100+i ];
            [btnsection3 setBackgroundColor:[UIColor whiteColor]];
            
            
            UIImageView  *imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
            [imageViewLeft setImage:[UIImage imageNamed:@"Public_record.png"]];
            [btnsection3 addSubview:imageViewLeft];
            
            UIImageView *imgJianTou=[[UIImageView alloc] initWithFrame:CGRectMake(btnsection3.frame.size.width-30, 10, 20, 20)];
            [imgJianTou setImage:[UIImage imageNamed:@"Public_arrows.png"]];
            [btnsection3 addSubview:imgJianTou];
            
            UILabel  *lblLeft=[[UILabel alloc]init];
            lblLeft.frame=CGRectMake(imageViewLeft.frame.size.width+imageViewLeft.frame.origin.x+5,0,70, 40);
            lblLeft.textAlignment=NSTextAlignmentLeft;
            lblLeft.backgroundColor=[UIColor clearColor];
            lblLeft.font=[UIFont systemFontOfSize:14];
            [lblLeft setTextColor:[UIColor blackColor]];
            [btnsection3 addSubview:lblLeft];
            if(i!=1)
            {
                UIImageView *lineView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Public_cardline.png"]];
                lineView.frame=CGRectMake(0,btnsection3.frame.size.height, btnsection3.frame.size.width, 1);
                [btnsection3 addSubview:lineView];
            }
            switch (i) {
                case 0:
                {
//                    充值记录
                    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Recharge"]]];
                }
                    break;
                case 1:
                {
//                    消费记录
                    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Expense"]]];
                }
                    break;
                default:
                    break;
            }
            [view addSubview:btnsection3];
        }
        
    }
//    会员卡说明
    else if (section==4)
    {
        headView.frame=CGRectMake(0, 0, ScreenWidth, 128);
        UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(5, 5, ScreenWidth-10, 123)];
        view.backgroundColor=[UIColor whiteColor];
        view.layer.borderColor=selfborderColor.CGColor;
        view.layer.borderWidth=0.5;
        view.layer.cornerRadius=5;
        [headView addSubview:view];
        for (int i=0; i<3; i++)
        {
            
            UIButton *btnsection4=[UIButton buttonWithType:UIButtonTypeCustom];
            btnsection4.frame=CGRectMake(0, i*41, view.frame.size.width, 40);
            [btnsection4 addTarget:self action:@selector(buttonClickSection:) forControlEvents:UIControlEventTouchUpInside];
            [btnsection4 setTag:section*100+i ];
            [btnsection4 setBackgroundColor:[UIColor whiteColor]];
            
            
            UIImageView  *imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
            [btnsection4 addSubview:imageViewLeft];
            
            UIImageView *imgJianTou=[[UIImageView alloc] initWithFrame:CGRectMake(btnsection4.frame.size.width-30, 10, 20, 20)];
            [imgJianTou setImage:[UIImage imageNamed:@"Public_arrows.png"]];
            if(i!=1)
            {
                [btnsection4 addSubview:imgJianTou];
            }
            
            UILabel  *lblLeft=[[UILabel alloc]init];
            lblLeft.frame=CGRectMake(imageViewLeft.frame.size.width+imageViewLeft.frame.origin.x+5,0,120, 40);
            lblLeft.textAlignment=NSTextAlignmentLeft;
            lblLeft.backgroundColor=[UIColor clearColor];
            lblLeft.font=[UIFont systemFontOfSize:14];
            [lblLeft setTextColor:[UIColor blackColor]];
            [btnsection4 addSubview:lblLeft];
            
            if(i!=2)
            {
                UIImageView *lineView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Public_cardline.png"]];
                lineView.frame=CGRectMake(0,btnsection4.frame.size.height, btnsection4.frame.size.width, 1);
                [btnsection4 addSubview:lineView];
            }
            switch (i) {
                case 0:
                {
//                    会员卡说明
                    [imageViewLeft setImage:[UIImage imageNamed:@"Public_explain.png"]];
                    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Card explain"]]];
                }
                    break;
                case 1:
                {
//                    会员卡中心电话
                    [imageViewLeft setImage:[UIImage imageNamed:@"Public_tele.png"]];
                    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Phone card center"]]];
                    UILabel  *lbltitle=[[UILabel alloc]init];
                    lbltitle.frame=CGRectMake(lblLeft.frame.size.width+lblLeft.frame.origin.x,0,90, 40);
                    lbltitle.textAlignment=NSTextAlignmentLeft;
                    lbltitle.backgroundColor=[UIColor clearColor];
                    lbltitle.font=[UIFont systemFontOfSize:14];
                    [lbltitle setTextColor:[UIColor grayColor]];
                    [btnsection4 addSubview:lbltitle];
                    [lbltitle setText:vipMessage.cardtele];
                    _callPhoneOrTele=[NSString stringWithFormat:@"%@",vipMessage.cardtele];
                }
                    break;
                case 2:
                {
                    [imageViewLeft setImage:[UIImage imageNamed:@"Public_value.png"]];
                    
//                    适用门店
                    [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Apply to stores"]]];
                }
                    break;
                default:
                    break;
            }
            [view addSubview:btnsection4];
        }
        
    }
    return headView;
}


//100：余额  101：积分  102：电子卷  200：展示会员专享  300：   301：   302
-(void)buttonClickSection:(UIButton *)button
{
    
    if(button.tag==100)
    {
        //余额
        VipCheckSelectViewController *vipcheck=[[VipCheckSelectViewController alloc]initWithCheckSelectType:CheckselectMoney andTitleName:[langSetting localizedString:@"Balance"] andsetResult:_resultDict];
        
        [self.navigationController pushViewController:vipcheck animated:YES];
        
    }
    else if (button.tag==101)
    {
        //积分
        VipCheckSelectViewController *vipcheck=[[VipCheckSelectViewController alloc]initWithCheckSelectType:CheckselectIntegral andTitleName:[langSetting localizedString:@"Integral"] andsetResult:_resultDict];
        [self.navigationController pushViewController:vipcheck animated:YES];
    }
    else if (button.tag==102)
    {
        //电子卷
        VipCheckSelectViewController *vipcheck=[[VipCheckSelectViewController alloc]initWithCheckSelectType:CheckselectCoupon andTitleName:[langSetting localizedString:@"Securities"] andsetResult:_resultDict];
        [self.navigationController pushViewController:vipcheck animated:YES];
    }
    else if(button.tag==200)
    {
        if(isShow)
        {
            isShow=NO;
        }
        else
        {
            isShow=YES;
        }
        [_tableView reloadData];
    }
    else if (button.tag==300)
    {
        VipCheckSelectViewController *vipcheck=[[VipCheckSelectViewController alloc]initWithCheckSelectType:CheckselectRechange andTitleName:[langSetting localizedString:@"Recharge"] andsetResult:_resultDict];
        [self.navigationController pushViewController:vipcheck animated:YES];
    }
    else if (button.tag==301)
    {
        VipCheckSelectViewController *vipcheck=[[VipCheckSelectViewController alloc]initWithCheckSelectType:CheckselectSale andTitleName:[langSetting localizedString:@"Expense"] andsetResult:_resultDict];
        [self.navigationController pushViewController:vipcheck animated:YES];
    }
    else if (button.tag==400)
    {
        VipCheckSelectViewController *vipcheck=[[VipCheckSelectViewController alloc]initWithCheckSelectType:CheckselectExplane andTitleName:[langSetting localizedString:@"Card explain"] andsetResult:_resultDict];
        [self.navigationController pushViewController:vipcheck animated:YES];
    }
    else if (button.tag==401)
    {
      [self.view addSubview:[DataProvider callPhoneOrtele:_callPhoneOrTele]];
    }
    else if (button.tag==402)
    {
        VipCheckSelectViewController *vipcheck=[[VipCheckSelectViewController alloc]initWithCheckSelectType:CheckselectApply andTitleName:[langSetting localizedString:@"Apply to stores"]   andsetResult:_resultDict];
        [self.navigationController pushViewController:vipcheck animated:YES];
    }
    else
    {
        NSLog(@"无操作");
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    if(indexPath.section==2)
    {
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(5, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height);
        view.backgroundColor=[UIColor clearColor];
        [view addSubview:_webVipSpecial];
        [cell.contentView addSubview:view];
    }
    return cell;
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
