//
//  VipCheckSelectViewController.m
//  Food
//
//  Created by sundaoran on 14-4-25.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "VipCheckSelectViewController.h"



@implementation VipCheckSelectViewController
{
    Checkselect         _checkType;
    NSString            *_title;
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    UITableView         *_tableView;
    NSMutableArray      *_dataButtonArray;
    NSInteger           buttonflag;//点击button事件的标志
    UITableView         *_rechargeTable;//充值/消费记录tableView
    NSMutableArray      *_dataArray;//充值/消费记录
    NSMutableArray      *_JuanDataArray;//电子劵数据
    
    NSDictionary        *_result;
    
    UILabel             *_lblDate;//选择时间lbl
    UILabel             *_lblDateNow;//选择结束日期
    
    CVLocalizationSetting *langSetting;
    
    UIView              *vPicker;
    UIPickerView        *_pickViewTime;
    
    NSMutableArray      *_dataYear;
    NSMutableArray      *_dataMoon;
    NSMutableArray      *_dataDay;
    
    
    NSInteger           selectYear;
    NSInteger           selectMoon;
    NSInteger           selectDay;
    
    NSString            *NowMoon;  //当前月份
    NSString            *NowDay;    //当前日
    NSString            *NowYear;   //当前年份
    
    NSString            *NowDate;
    NSString            *goalDate;
    
    BOOL                isNowDate;//判断选择结束时间还是开始时间
    
    
    
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//初始化方法，添加会员卡数据字典
-(id)initWithCheckSelectType:(Checkselect)checkType andTitleName:(NSString *)title andsetResult:(NSDictionary *)result
{
    self=[super init];
    if(self)
    {
        _checkType=checkType;
        _title=title;
        _result=result;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    langSetting=[CVLocalizationSetting sharedInstance];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
	// Do any additional setup after loading the view.
    
    VipMessageClass *vipMessage=[DataProvider sharedInstance].selectVip;
    
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:_title];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT-VIEWHRIGHT);
    [self.view addSubview:_backGround];
    
    
    UIImageView *imageViewtitle=[[UIImageView alloc]init];
    imageViewtitle.frame=CGRectMake(20, 20, 40, 40);
    
    UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(imageViewtitle.frame.origin.x+imageViewtitle.frame.size.width+10, imageViewtitle.frame.origin.y+5, 80, 30)];
    
    lblTitle.textColor=[UIColor blackColor];
    
    UILabel *lblMessage=[[UILabel alloc]initWithFrame:CGRectMake(lblTitle.frame.origin.x+lblTitle.frame.size.width+10, lblTitle.frame.origin.y, ScreenWidth-lblTitle.frame.origin.x-lblTitle.frame.size.width-20, 30)];
    lblMessage.textColor=selfbackgroundColor;
    
    UIWebView  *webResult=[[UIWebView alloc]init];
    webResult.scrollView.bounces=NO;
    webResult.layer.backgroundColor=selfborderColor.CGColor;
    webResult.layer.borderWidth=0.5;
    webResult.layer.cornerRadius=5;
    
    
    CGFloat   height=imageViewtitle.frame.origin.y+imageViewtitle.frame.size.height;
    
    if(_checkType==CheckselectApply)//适用门店
    {
        webResult.frame=CGRectMake(5, 10, ScreenWidth-10, _backGround.frame.size.height-20);
        [webResult loadHTMLString:[_result objectForKey:@"STORE"] baseURL:nil];
        [_backGround addSubview:webResult];
    }
    else if (_checkType ==CheckselectMoney)//余额
    {
        lblTitle.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Balance"]];
        lblMessage.text=vipMessage.cardzAmt;
        [imageViewtitle setImage:[UIImage imageNamed:@"Public_balance.png"]];
        [_backGround addSubview:lblTitle];
        [_backGround addSubview:lblMessage];
        [_backGround addSubview:imageViewtitle];
        
        webResult.frame=CGRectMake(5, height+10, ScreenWidth-10, _backGround.frame.size.height-height-20);
        [webResult loadHTMLString:[_result objectForKey:@"chgrules"] baseURL:nil];
        [_backGround addSubview:webResult];
    }
    else if (_checkType ==CheckselectSpecial)//会员专享
    {
        
    }
    else if (_checkType ==CheckselectIntegral) //积分
    {
        lblTitle.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Integral"]];
        lblMessage.text=vipMessage.cardttlFen;
        [imageViewtitle setImage:[UIImage imageNamed:@"Public_integral.png"]];
        [_backGround addSubview:lblTitle];
        [_backGround addSubview:lblMessage];
        [_backGround addSubview:imageViewtitle];
        webResult.frame=CGRectMake(5, height+10, ScreenWidth-10, _backGround.frame.size.height-height-20);
        [webResult loadHTMLString:[_result objectForKey:@"jifenrules"] baseURL:nil];
        [_backGround addSubview:webResult];
    }
    else if (_checkType ==CheckselectCoupon) //电子卷
    {
        
         [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(queryVoucher) toTarget:self withObject:nil];
        UIView *Viewbutton=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _backGround.frame.size.width, 40)];
        Viewbutton.backgroundColor=[UIColor clearColor];
        [_backGround addSubview:Viewbutton];
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,Viewbutton.frame.size.height, _backGround.frame.size.width, _backGround.frame.size.height-Viewbutton.frame.size.height-10) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.allowsSelection=NO;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        
        
        _dataButtonArray=[[NSMutableArray alloc]init];
        for (int i=0; i<4; i++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(i*(Viewbutton.frame.size.width/4), 0,(Viewbutton.frame.size.width/4),Viewbutton.frame.size.height);
            button.tag=i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            switch (i) {
                case 0:
                {
                    [button setBackgroundImage:[UIImage imageNamed:@"Public_btnline.png"] forState:UIControlStateNormal];
                    [button setTitle:[langSetting localizedString:@"Unused"] forState:UIControlStateNormal];
                    [button setTitleColor:selfbackgroundColor forState:UIControlStateNormal];
                    buttonflag=0;
                }
                    break;
                case 1:
                {
                    [button setBackgroundImage:[UIImage imageNamed:@"Public_btnnoline.png"] forState:UIControlStateNormal];
                    [button setTitle:[langSetting localizedString:@"Used"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                    break;
                case 2:
                {
                    [button setBackgroundImage:[UIImage imageNamed:@"Public_btnnoline.png"] forState:UIControlStateNormal];
                    [button setTitle:[langSetting localizedString:@"Expired"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                    break;
                case 3:
                {
                    [button setBackgroundImage:[UIImage imageNamed:@"Public_btnnoline.png"] forState:UIControlStateNormal];
                    [button setTitle:[langSetting localizedString:@"Inactive"] forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
                    break;
                    
                default:
                    break;
            }
            [_dataButtonArray addObject:button];
            [Viewbutton addSubview:button];
            
        }
        
        [_backGround addSubview:_tableView];
    }
    else if (_checkType ==CheckselectSale) //消费记录
    {
        _rechargeTable=[[UITableView alloc]initWithFrame:CGRectMake(5,5, _backGround.frame.size.width-10, _backGround.frame.size.height-15) style:UITableViewStylePlain];
        _rechargeTable.delegate=self;
        _rechargeTable.dataSource=self;
        _rechargeTable.layer.borderColor=selfborderColor.CGColor;
        _rechargeTable.layer.borderWidth=0.5;
        _rechargeTable.layer.cornerRadius=2;
        _rechargeTable.allowsSelection=NO;
        [_backGround addSubview:_rechargeTable];
        
        [self initArray];
        
    }
    else if (_checkType ==CheckselectRechange) //充值记录
    {
        _rechargeTable=[[UITableView alloc]initWithFrame:CGRectMake(5,5, _backGround.frame.size.width-10, _backGround.frame.size.height-15) style:UITableViewStylePlain];
        _rechargeTable.delegate=self;
        _rechargeTable.dataSource=self;
        _rechargeTable.layer.borderColor=selfborderColor.CGColor;
        _rechargeTable.layer.borderWidth=0.5;
        _rechargeTable.layer.cornerRadius=2;
        _rechargeTable.allowsSelection=NO;
        [_backGround addSubview:_rechargeTable];
        
        [self initArray];
        
        
    }
    else if (_checkType ==CheckselectExplane)//会员卡说明
    {
        webResult.frame=CGRectMake(5, 10, ScreenWidth-10, _backGround.frame.size.height-20);
        [webResult loadHTMLString:[_result objectForKey:@"cardexplan"] baseURL:nil];
        [_backGround addSubview:webResult];
    }
    else if (_checkType==CheckselectAgreement)//用户协议
    {
        [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(getUserAgreement) toTarget:self withObject:nil];
    }
    else
    {
        
    }
}

//会员卡优惠劵信息获取
-(void)queryVoucher
{
    @autoreleasepool
    {
        DataProvider *dp=[DataProvider sharedInstance];
        //    获取选择会员卡单利
        VipMessageClass *vipMessage=[DataProvider sharedInstance].selectVip;
        NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
        [Info setObject:vipMessage.cardId forKey:@"cardId"];
        NSDictionary *dict=[dp queryVoucher:Info];
        NSMutableArray *noUseCard=[[NSMutableArray alloc]init];//未使用劵
        NSMutableArray *useCard=[[NSMutableArray alloc]init];//已经使用
        NSMutableArray *timeOutCard=[[NSMutableArray alloc]init];//已经过期
        NSMutableArray *inactiveCard=[[NSMutableArray alloc]init];//未激活
        _JuanDataArray=[[NSMutableArray alloc]init];
        
        if([[dict objectForKey:@"Result"]boolValue])
        {
            [SVProgressHUD dismiss];
            NSLog(@"%@",[dict objectForKey:@"Message"]);
            NSArray *array=[[NSArray alloc]initWithArray:[dict objectForKey:@"Message"]];
            for (int i=0; i<[array count]; i++)
            {
                NSDictionary *dict=[[NSDictionary alloc]initWithDictionary:[array objectAtIndex:i]];
                if([[dict objectForKey:@"sta"]isEqualToString:@"N"])
                {
                    [noUseCard addObject:dict];
                }
                else if ([[dict objectForKey:@"sta"]isEqualToString:@""])
                {
                    [useCard addObject:dict];
                }
                else if ([[dict objectForKey:@"sta"]isEqualToString:@""])
                {
                    [timeOutCard addObject:dict];
                }
                else if([[dict objectForKey:@"sta"]isEqualToString:@""])
                {
                    [inactiveCard addObject:dict];
                }
                else
                {
                    NSLog(@"无此状态");
                }
            }
            [_JuanDataArray addObject:noUseCard];
            [_JuanDataArray addObject:useCard];
            [_JuanDataArray addObject:timeOutCard];
            [_JuanDataArray addObject:inactiveCard];
            [_tableView reloadData];
            if([noUseCard count]==0 && [useCard count]==0 && [timeOutCard count]==0 && [inactiveCard count]==0)
            {
                bs_dispatch_sync_on_main_thread(^{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"Temporarily no data"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
                    [alert show];
                });
                
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Failed to get information"]];
        }
        
    }
}


//获取用户协议
-(void)getUserAgreement
{
    @autoreleasepool {
        DataProvider *dp=[DataProvider sharedInstance];
        NSDictionary *dict=[dp getUserAgreement:UserAgreementId];
        if([[dict objectForKey:@"Result"]boolValue])
        {
            NSLog(@"%@",[[dict objectForKey:@"Message"]objectForKey:@"title"]);
            NSLog(@"%@",[[dict objectForKey:@"Message"]objectForKey:@"wcontent"]);
            bs_dispatch_sync_on_main_thread(^{
                UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, _backGround.frame.size.width, _backGround.frame.size.height)];
                webView.scrollView.bounces=NO;
                [webView loadHTMLString:[[dict objectForKey:@"Message"]objectForKey:@"wcontent"] baseURL:nil];
                [_backGround addSubview:webView];
                [SVProgressHUD dismiss];
            });
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Failed to get information"]];
        }
        
    }
}

//电子卷界面button点击事件
-(void)buttonClick:(UIButton *)button
{
    buttonflag=button.tag;
    for (UIButton *btn in _dataButtonArray)
    {
        if(btn.tag==button.tag)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"Public_btnline.png"] forState:UIControlStateNormal];
            [button setTitleColor:selfbackgroundColor forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"Public_btnnoline.png"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    [_tableView reloadData];
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


#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView==_rechargeTable)
    {
        return 1;
    }
    else
    {
        return [[_JuanDataArray objectAtIndex:buttonflag] count];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_rechargeTable)
    {
        return [_dataArray count];
    }
    else
    {
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==_rechargeTable)
    {
        static  NSString *cellName1=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName1];
        if(!cell)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName1];
        }
        for (UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
        
        UILabel *lblStoreName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0,ScreenWidth*0.4+10 ,40)];
        lblStoreName.font=[UIFont systemFontOfSize:14];
        lblStoreName.numberOfLines=2;
        lblStoreName.backgroundColor=[UIColor clearColor];
        [cell.contentView addSubview:lblStoreName];
        
        UILabel *lblDate=[[UILabel alloc]initWithFrame:CGRectMake(lblStoreName.frame.size.width+lblStoreName.frame.origin.x, 0,ScreenWidth*0.3 ,40)];
        lblDate.backgroundColor=[UIColor clearColor];
        lblDate.font=[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lblDate];
        
        UILabel *lblMoney=[[UILabel alloc]initWithFrame:CGRectMake(lblDate.frame.origin.x+lblDate.frame.size.width, 0,ScreenWidth*0.2 ,40)];
        lblMoney.textAlignment=NSTextAlignmentRight;
        lblMoney.backgroundColor=[UIColor clearColor];
        lblMoney.font=[UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lblMoney];
        
        lblStoreName.text=[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"firmdes" ];
        lblDate.text=[[[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"tim"]componentsSeparatedByString:@" "]firstObject];
        
        if(_checkType==CheckselectRechange)
        {
            
            lblMoney.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"operater"]floatValue]];
        }
        else
        {
            lblMoney.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"balaamt"]floatValue]];
        }
        
        return cell;
    }
    else
    {
        static  NSString *cellName2=@"cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName2];
        if(!cell)
        {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName2];
        }
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView==_rechargeTable)
    {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 62)];
        view.backgroundColor=[UIColor clearColor];
        //        开始日期
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 0, ScreenWidth-80, 30);
        button.backgroundColor=kgrayColor;
        [button addTarget:self action:@selector(buttonClickDate) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        UILabel *lblDateLeft=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 70, 30)];
        lblDateLeft.text=[NSString stringWithFormat:@"%@:",@"开始日期"];//[langSetting localizedString:@"Query the date"]
        lblDateLeft.backgroundColor=[UIColor clearColor];
        lblDateLeft.textAlignment=NSTextAlignmentLeft;
        lblDateLeft.font=[UIFont systemFontOfSize:14];
        [button addSubview:lblDateLeft];
        
        _lblDate=[[UILabel alloc]initWithFrame:CGRectMake(lblDateLeft.frame.size.width, 0,button.frame.size.width-lblDateLeft.frame.size.width, 30)];
        
        _lblDate.text=[NSString stringWithFormat:@"%@",goalDate];
        _lblDate.backgroundColor=[UIColor clearColor];
        _lblDate.textAlignment=NSTextAlignmentLeft;
        _lblDate.font=[UIFont systemFontOfSize:12];
        [button addSubview:_lblDate];
        
        //        结束日期
        UIButton *buttonNow=[UIButton buttonWithType:UIButtonTypeCustom];
        buttonNow.frame=CGRectMake(0, 32, ScreenWidth-80, 30);
        buttonNow.backgroundColor=kgrayColor;
        [buttonNow addTarget:self action:@selector(buttonClickDateNow) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lblDateLeftNow=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 70, 30)];
        lblDateLeftNow.text=[NSString stringWithFormat:@"%@:",@"结束日期"];//[langSetting localizedString:@"Query the date"]
        lblDateLeftNow.backgroundColor=[UIColor clearColor];
        lblDateLeftNow.textAlignment=NSTextAlignmentLeft;
        lblDateLeftNow.font=[UIFont systemFontOfSize:14];
        [buttonNow addSubview:lblDateLeftNow];
        
        _lblDateNow=[[UILabel alloc]initWithFrame:CGRectMake(lblDateLeftNow.frame.size.width, 0,button.frame.size.width-lblDateLeft.frame.size.width, 30)];
        
        _lblDateNow.text=[NSString stringWithFormat:@"%@",NowDate];
        _lblDateNow.backgroundColor=[UIColor clearColor];
        _lblDateNow.textAlignment=NSTextAlignmentLeft;
        _lblDateNow.font=[UIFont systemFontOfSize:12];
        [buttonNow addSubview:_lblDateNow];
        [view addSubview:buttonNow];
        
        UIButton *btnquery=[UIButton buttonWithType:UIButtonTypeCustom];
        btnquery.frame=CGRectMake(_lblDate.frame.size.width+_lblDate.frame.origin.x, 0, 70, 62);
        [btnquery setTitle:[langSetting localizedString:@"query"] forState:UIControlStateNormal];
        btnquery.backgroundColor=selfbackgroundColor;
        [btnquery setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnquery addTarget:self action:@selector(btnquery) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btnquery];
        
        return view;
    }
    else
    {
        NSArray *array=[[NSArray alloc]initWithArray:[_JuanDataArray objectAtIndex:buttonflag]];
        NSDictionary *infoDict=[[NSDictionary alloc]initWithDictionary:[array objectAtIndex:section]];
        UIView  *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)];
        view.backgroundColor=[UIColor whiteColor];
        UIImageView *imagebackground=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,ScreenWidth-20, 110)];
        
        UILabel *lblMoney=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, imagebackground.frame.size.width*0.3, imagebackground.frame.size.height)];
        lblMoney.text=[NSString stringWithFormat:[langSetting localizedString:@"%@Money"],[infoDict objectForKey:@"saildiscamt"]];
        lblMoney.textAlignment=NSTextAlignmentCenter;
        lblMoney.font=[UIFont systemFontOfSize:40];
        [imagebackground addSubview:lblMoney];
        
        
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(lblMoney.frame.size.width, 10, imagebackground.frame.size.width*0.7, 30)];
        lblName.text=[NSString stringWithFormat:@"%@",[infoDict objectForKey:@"typdes"]];
        lblName.textAlignment=NSTextAlignmentLeft;
        lblName.font=[UIFont systemFontOfSize:15];
        [imagebackground addSubview:lblName];
        
        
        UILabel *lblNum=[[UILabel alloc]initWithFrame:CGRectMake(lblName.frame.origin.x, lblName.frame.origin.y+lblName.frame.size.height, imagebackground.frame.size.width*0.7, 30)];
        
        //        现金劵号码
        lblNum.text=[NSString stringWithFormat:@"%@:%@",[langSetting localizedString:@"Cash coupon number"],[infoDict objectForKey:@"id"]];
        lblNum.textAlignment=NSTextAlignmentLeft;
        lblNum.font=[UIFont systemFontOfSize:15];
        [imagebackground addSubview:lblNum];
        
        
        //        过期时间
        UILabel *lblTime=[[UILabel alloc]initWithFrame:CGRectMake(lblName.frame.origin.x, lblNum.frame.origin.y+lblNum.frame.size.height, imagebackground.frame.size.width*0.7, 30)];
        lblTime.text=[NSString stringWithFormat:@"%@:%@",[langSetting localizedString:@"Expiration time"], [[[infoDict objectForKey:@"edate"]componentsSeparatedByString:@" "]firstObject]];
        lblTime.textAlignment=NSTextAlignmentLeft;
        lblTime.font=[UIFont systemFontOfSize:15];
        [imagebackground addSubview:lblTime];
        
        
        
        switch (buttonflag)
        {
            case 0:
            {
                [imagebackground setImage:[UIImage imageNamed:@"card_vipCoupon.png"]];
                lblMoney.textColor=selfbackgroundColor;
                lblName.textColor=selfbackgroundColor;
                lblNum.textColor=selfbackgroundColor;
                lblTime.textColor=selfbackgroundColor;
            }
                break;
            case 1:
            {
                [imagebackground setImage:[UIImage imageNamed:@"card_vipCouponuse.png"]];
                lblMoney.textColor=selfbackgroundColor;
                lblName.textColor=selfbackgroundColor;
                lblNum.textColor=selfbackgroundColor;
                lblTime.textColor=selfbackgroundColor;
            }
                break;
            case 2:
            {
                [imagebackground setImage:[UIImage imageNamed:@"card_vipCouponcantuse.png"]];
                lblMoney.textColor=[UIColor grayColor];
                lblName.textColor=[UIColor grayColor];
                lblNum.textColor=[UIColor grayColor];
                lblTime.textColor=[UIColor grayColor];
            }
                break;
            case 3:
            {
                [imagebackground setImage:[UIImage imageNamed:@"card_vipCouponcantuse.png"]];
                lblMoney.textColor=[UIColor grayColor];
                lblName.textColor=[UIColor grayColor];
                lblNum.textColor=[UIColor grayColor];
                lblTime.textColor=[UIColor grayColor];
            }
                break;
                
            default:
                break;
        }
        [view addSubview:imagebackground];
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView==_rechargeTable)
    {
        return 62;
    }
    else
    {
        return 120;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark  pickView
//显示PickView
-(void)showPickView{
    
    if(!vPicker)
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
    
    _pickViewTime= [[UIPickerView alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _pickViewTime.frame = CGRectMake(0, vPicker.frame.size.height-216, ScreenWidth, 218) ;
    }else{
        _pickViewTime.frame = CGRectMake(0, vPicker.frame.size.height-216, ScreenWidth, 218) ;
    }
    _pickViewTime.showsSelectionIndicator = YES;
    _pickViewTime.delegate = self;
    _pickViewTime.dataSource = self;
    _pickViewTime.backgroundColor = [UIColor whiteColor];
    
    
    
    [vPicker addSubview:_pickViewTime];
    
    vPicker.frame = CGRectMake(0, vPicker.frame.size.height, vPicker.frame.size.width, vPicker.frame.size.height);
    [self.view addSubview:vPicker];
    
    [UIView animateWithDuration:.3f animations:^{
        vPicker.frame = CGRectMake(0, 0, vPicker.frame.size.width, vPicker.frame.size.height);
    }];
    }
    else
    {
        NSLog(@"存在");
    }
}

//取消日期选择
- (void)cancelClicked{
    [UIView animateWithDuration:.3f animations:^{
        vPicker.frame = CGRectMake(0, vPicker.frame.size.height, vPicker.frame.size.width, vPicker.frame.size.height);
    }completion:^(BOOL finished) {
        [vPicker removeFromSuperview];
        vPicker = nil;
    }];
}


//确定选择的日期
- (void)confirmClicked{
    [UIView animateWithDuration:.3f animations:^{
        vPicker.frame = CGRectMake(0, vPicker.frame.size.height, vPicker.frame.size.width, vPicker.frame.size.height);
    }completion:^(BOOL finished) {
        [vPicker removeFromSuperview];
        vPicker = nil;
    }];
    
    NSString *strMoon;
    if(selectMoon>0 &&selectMoon<9)
    {
        strMoon=[NSString stringWithFormat:@"0%d",selectMoon];
    }
    else
    {
        strMoon=[NSString stringWithFormat:@"%d",selectMoon];
    }
    NSString *strDay;
    if(selectDay>0 &&selectDay<9)
    {
        strDay=[NSString stringWithFormat:@"0%d",selectDay];
    }
    else
    {
        strDay=[NSString stringWithFormat:@"%d",selectDay];
    }
    if(isNowDate)
    {
        //        选择结束时间
        NowDate=[NSString stringWithFormat:@"%d-%@-%@",selectYear,strMoon,strDay];
        _lblDateNow.text=[NSString stringWithFormat:@"%@",NowDate];
    }
    else
    {
        //    选择的开始时间
        goalDate=[NSString stringWithFormat:@"%d-%@-%@",selectYear,strMoon,strDay];
        _lblDate.text=[NSString stringWithFormat:@"%@",goalDate];
    }
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(component==0)
    {
        selectYear =[[_dataYear objectAtIndex:row]integerValue];
        [_pickViewTime reloadAllComponents];
    }
    else if(component==1)
    {
        selectMoon=[[_dataMoon objectAtIndex:row]integerValue];
        [_pickViewTime reloadAllComponents];
    }
    else
    {
        selectDay=[[_dataDay objectAtIndex:row]integerValue];
    }
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if(component==0)
    {
        return [_dataYear count];
    }
    else if (component==1)
    {
        _dataMoon=[[NSMutableArray alloc]init];
        NSInteger   MoonNum=12;
        if([NowYear integerValue]==selectYear)
        {
            MoonNum=[NowMoon integerValue];
        }
        for(int i=1;i<=MoonNum;i++)
        {
            [_dataMoon addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        return [_dataMoon count];
    }
    else
    {
        //判断平年闰年
        BOOL rainYear=NO;
        if(selectYear%4==0 ||(selectYear%100==0 &&selectYear%400==0))
        {
            rainYear=YES;
        }
        else
        {
            rainYear=NO;
        }
        
        int MoonDay;
        selectMoon=[[_dataMoon objectAtIndex:[pickerView selectedRowInComponent:1]]integerValue];
        if(selectMoon==1||selectMoon==3||selectMoon==5||selectMoon==7||selectMoon==8||selectMoon==10||selectMoon==12)
        {
            MoonDay=31;
        }
        else if(selectMoon==4||selectMoon==6||selectMoon==9||selectMoon==11)
        {
            MoonDay=30;
        }
        else
        {
            if(rainYear)
            {
                MoonDay=29;
            }
            else
            {
                MoonDay=28;
            }
        }
        _dataDay=[[NSMutableArray alloc]init];
        NSInteger   dayNum=MoonDay;
        if([NowMoon integerValue]==selectMoon && [NowYear integerValue]==selectYear)
        {
            dayNum=[NowDay integerValue];//当前月份，日期从当前日期开始，否则，从1号开始
        }
        for(int i=1;i<=dayNum;i++)
        {
            [_dataDay addObject:[NSString stringWithFormat:@"%d",i]];
        }
        return [_dataDay count];
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if(component==0)
    {
        selectYear=[[_dataYear objectAtIndex:row] integerValue];
        return [_dataYear objectAtIndex:row];
    }
    else if (component==1)
    {
        selectMoon=[[_dataMoon objectAtIndex:row]integerValue];
        return [_dataMoon objectAtIndex:row];
    }
    else
    {
        selectDay=[[_dataDay objectAtIndex:row] integerValue];
        return [_dataDay objectAtIndex:row];
    }
}


//获取当前的系统日期
-(NSString *)nowTime
{
    NSString *nowtime=@"2014-04-01";
    NSDate *datenow = [NSDate date];//现在时间,您可以输出来看下是什么格式
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    NSInteger interval = [zone secondsFromGMTForDate:datenow]+60*24;
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy"];
    //用[NSDate date]可以获取系统当前时间
    NSString *yy = [dateFormatter stringFromDate:localeDate];
    [dateFormatter setDateFormat:@"MM"];
    //用[NSDate date]可以获取系统当前时间
    NSString *MM = [dateFormatter stringFromDate:localeDate];
    [dateFormatter setDateFormat:@"dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *dd = [dateFormatter stringFromDate:localeDate];
    nowtime=[NSString stringWithFormat:@"%@-%@-%@",yy,MM,dd];
    
    return nowtime;
}


//初始化可选择的日期数组（包括年，月，日）
-(void)initArray
{
    
    NSDate *datenow = [NSDate date];//现在时间,您可以输出来看下是什么格式
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    NSInteger interval = [zone secondsFromGMTForDate:datenow]+60*24;
    NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy"];
    //用[NSDate date]可以获取系统当前时间
    NSString *yy = [dateFormatter stringFromDate:localeDate];
    NowYear=yy;
    [dateFormatter setDateFormat:@"MM"];
    //用[NSDate date]可以获取系统当前时间
    NSString *MM = [dateFormatter stringFromDate:localeDate];
    NowMoon=MM;
    [dateFormatter setDateFormat:@"dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *dd = [dateFormatter stringFromDate:localeDate];
    NowDay=dd;
    
    NowDate=[self nowTime];
    goalDate=NowDate;
    
    _dataMoon=[[NSMutableArray alloc]init];
    _dataDay=[[NSMutableArray alloc]init];
    _dataYear=[[NSMutableArray alloc]init];
    
    for(int i=[yy integerValue]-2;i<=[yy integerValue];i++)
    {
        [_dataYear addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for(int i=1;i<=12;i++)
    {
        [_dataMoon addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for(int i=1;i<=[dd integerValue];i++)
    {
        [_dataDay addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
}

//选择查询的日期时间段
-(void)buttonClickDate
{
    isNowDate=NO;
    [self showPickView];
}

//选择结束日期
-(void)buttonClickDateNow
{
    isNowDate=YES;
    [self showPickView];
    
}

//查询记录点击事件
-(void)btnquery
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'"];

    NSDate *goal=[dateFormatter dateFromString:goalDate];
    NSDate *Now=[dateFormatter dateFromString:NowDate];
    NSLog(@"%d",[Now compare:goal]);
    if([Now compare:goal]<0)//开始时间早于结束时间
    {
        [SVProgressHUD showErrorWithStatus:@"结束日期不可早于开始日期"];
    }
    else
    {
        if(_checkType==CheckselectRechange)
        {
            //        查询充值记录
            [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(queryChargeRecord) toTarget:self withObject:nil];
        }
        else
        {
            //        查询消费记录
            [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(queryConsumeRecord) toTarget:self withObject:nil];
            
        }
    }
}

//充值记录数据处理
-(void)queryChargeRecord
{
    @autoreleasepool
    {
        
        DataProvider *dp=[DataProvider sharedInstance];
        VipMessageClass *vipMessage=[DataProvider sharedInstance].selectVip;
        NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
        [Info setObject:vipMessage.cardId forKey:@"cardId"];
        [Info setObject:NowDate forKey:@"endDate"];
        [Info setObject:goalDate forKey:@"startDate"];
        NSDictionary *dict=[dp queryChargeRecord:Info];
        if([[dict objectForKey:@"Result"]boolValue])
        {
            [SVProgressHUD dismiss];
            _dataArray=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"Message"]];
            [_rechargeTable reloadData];
            [SVProgressHUD dismiss];
            if([_dataArray count]==0)
            {
                bs_dispatch_sync_on_main_thread(^{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[NSString stringWithFormat:@"%@~%@\n%@",goalDate,NowDate,[langSetting localizedString:@"No prepaid phone records time period"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
                    [alert show];
                });
                
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
    }
}

//消费数据返回结果处理
-(void)queryConsumeRecord
{
    @autoreleasepool
    {
        _dataArray=[[NSMutableArray alloc]init];
        DataProvider *dp=[DataProvider sharedInstance];
        VipMessageClass *vipMessage=[DataProvider sharedInstance].selectVip;
        NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
        [Info setObject:vipMessage.cardId forKey:@"cardId"];
        [Info setObject:NowDate forKey:@"endDate"];
        [Info setObject:goalDate forKey:@"startDate"];
        NSDictionary *dict=[dp queryConsumeRecord:Info];
        if([[dict objectForKey:@"Result"]boolValue])
        {
            _dataArray=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"Message"]];
            [_rechargeTable reloadData];
            [SVProgressHUD dismiss];
            if([_dataArray count]==0)
            {
                bs_dispatch_sync_on_main_thread(^{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:
                                        [NSString stringWithFormat:@"%@~%@\n%@",goalDate,NowDate,[langSetting localizedString:@"No record of consumption period"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
                    [alert show];
 
                });
                
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
    }
}

#pragma mark showDateViewDelegate

#pragma mark webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
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
