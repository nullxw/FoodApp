//
//  VipMainViewController.m
//  Food
//
//  Created by sundaoran on 14-4-23.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "VipMainViewController.h"
#import "VipManageViewController.h"
#import "VipLookMessageViewController.h"
#import "addOtherPassVertryViewController.h"
#import "VipMessageClass.h"
#import "relexPassWordViewController.h"

@interface VipMainViewController ()
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    CVLocalizationSetting *langSetting;
    UITableView         *_tableView;
    NSMutableArray      *_dataArray;
    
    NSString            *_selectDeleteCardNum;
    
    int                 cardCount;
    
    UIButton            *_btnForgetPass;//忘记密码
    UIButton            *_btnRelexPass;//修改密码
    BOOL                isPush;//是否按下设置
}

@end

@implementation VipMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

//获取该用户下绑定的所有会员卡数据
-(void)queryBindCard
{
    @autoreleasepool {
        if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]boolValue ])
        {
            //@"请先绑定手机号码"
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please first binding mobile phone number"]];
        }
        else
        {
            DataProvider *dp=[DataProvider sharedInstance];
            NSDictionary  *dict=[dp queryBindCard:[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]];
            _dataArray=[[NSMutableArray alloc]init];
            if ([[dict objectForKey:@"Result"] boolValue]) {
                [SVProgressHUD dismiss];
                if([[dict objectForKey:@"isNULL"]boolValue])
                {
                    //                [SVProgressHUD showErrorWithStatus:@"暂无绑定会员数据\n请绑定会员卡"];
                    cardCount =0;
                }
                else
                {
                    for (int i=0; i<[[dict objectForKey:@"Message"]count]; i++)
                    {
                        NSDictionary *dicvalue=[[dict objectForKey:@"Message"]objectAtIndex:i];
                        VipMessageClass *message=[[VipMessageClass alloc]init];
                        message.cardNum=[dicvalue objectForKey:@"cardNo"];       //卡号
                        message.cardinvoiceamt=[dicvalue objectForKey:@"invoiceamt"];//
                        message.cardname=[dicvalue objectForKey:@"name"];      //持卡人名字
                        message.cardttlFen=[dicvalue objectForKey:@"ttlFen"];    //卡积分
                        message.cardzAmt=[dicvalue objectForKey:@"zAmt"];      //卡余额
                        message.cardId=[dicvalue objectForKey:@"cardId"];
                        [_dataArray addObject:message];
                    }
                    cardCount =[[dict objectForKey:@"Message"]count];
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Failed to get information"]];
            }
        }
        [_tableView reloadData];
    }
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

    
//    会员卡设置按钮
    UIButton  *btnSetting=[UIButton buttonWithType:UIButtonTypeCustom];
    btnSetting.frame=CGRectMake(_backGround.frame.size.width-40,_backGround.frame.size.height-40, 30, 30);
    [btnSetting addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    [btnSetting setBackgroundImage:[UIImage imageNamed:@"Public_settingPass.png"] forState:UIControlStateNormal];
    [_backGround addSubview:btnSetting];
    
    _btnForgetPass=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnForgetPass.frame=CGRectMake(_backGround.frame.size.width-40,_backGround.frame.size.height-40, 30, 30);
    [_btnForgetPass addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnForgetPass.tag=100001;
    _btnForgetPass.alpha=0.0;
    [_btnForgetPass setBackgroundImage:[UIImage imageNamed:@"Public_forgetPass.png"] forState:UIControlStateNormal];
    
    
    _btnRelexPass=[UIButton buttonWithType:UIButtonTypeCustom];
    _btnRelexPass.frame=CGRectMake(_backGround.frame.size.width-40,_backGround.frame.size.height-40, 30, 30);
    [_btnRelexPass addTarget:self action:@selector(settingClick:) forControlEvents:UIControlEventTouchUpInside];
    _btnRelexPass.tag=100002;
    _btnRelexPass.alpha=0.0;
    [_btnRelexPass setBackgroundImage:[UIImage imageNamed:@"Public_relexPass.png"] forState:UIControlStateNormal];
    
    
//    第一次请求会员卡数据
    [self getBindCardMessage];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getBindCardMessage) name:@"getBindCardMessage" object:nil];
    
}


//获取绑定会员卡请求
-(void)getBindCardMessage
{
    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(queryBindCard) toTarget:self withObject:nil];
}

//右下角设置视图动画简单效果
-(void)setting
{
    if(!isPush)
    {
        [_backGround addSubview:_btnRelexPass];
        [_backGround addSubview:_btnForgetPass];
        _btnRelexPass.alpha=1.0;
        _btnForgetPass.alpha=1.0;
        [UIView animateWithDuration:0.15f animations:^{
            _btnForgetPass.frame=CGRectMake(_backGround.frame.size.width-80,_backGround.frame.size.height-40, 30, 30);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.15f animations:^{
                _btnRelexPass.frame=CGRectMake(_backGround.frame.size.width-40,_backGround.frame.size.height-80, 30, 30);
//                _btnRelexPass.frame=CGRectMake(_backGround.frame.size.width-120,_backGround.frame.size.height-40, 30, 30);
            } completion:^(BOOL finished) {
                isPush=YES;
            }];
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
            _btnRelexPass.frame=CGRectMake(_backGround.frame.size.width-40,_backGround.frame.size.height-40, 30, 30);
            _btnForgetPass.frame=CGRectMake(_backGround.frame.size.width-40,_backGround.frame.size.height-40, 30, 30);
        } completion:^(BOOL finished) {
            [_btnForgetPass removeFromSuperview];
            [_btnRelexPass removeFromSuperview];
            _btnRelexPass.alpha=0.0;
            _btnForgetPass.alpha=0.0;
            isPush=NO;
        }];
    }
}

//设置按键的触发事件
-(void)settingClick:(UIButton *)button
{
    if(cardCount==0)
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:@"你还未添加会员卡" delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles: nil];
            [alert show];
        });
        
    }
    else
    {
        if(button.tag==100001)
        {
            bs_dispatch_sync_on_main_thread(^{
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:@"确定忘记密码，并重新添加会员卡" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:[langSetting localizedString:@"OK"], nil];
                alert.tag=101;
                [alert show];
            });
            
        }
        else if (button.tag==100002)
        {
            //        更换密码
            relexPassWordViewController *relex=[[relexPassWordViewController alloc]init];
            [self.navigationController pushViewController:relex animated:YES];
        }
        else
        {
            NSLog(@"无按键");
        }
    }
}

#pragma mark  --tableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count]+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    if(indexPath.row==[_dataArray count])
    {
        UIButton *btnAddCard=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, cell.frame.size.width-20, 80)];
        [btnAddCard setBackgroundImage:[UIImage imageNamed:@"card_messageNomal.png"] forState:UIControlStateNormal];
        [btnAddCard setBackgroundImage:[UIImage imageNamed:@"card_messageSelect.png"] forState:UIControlStateHighlighted];
        [btnAddCard addTarget:self action:@selector(addVipCard) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnAddCard];
    }
    else
    {
        UIButton *btncheckCard=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, cell.frame.size.width-20, 80)];
        [btncheckCard setBackgroundImage:[UIImage imageNamed:@"vipmessage.png"] forState:UIControlStateNormal];
        btncheckCard.tag=indexPath.section;
        [btncheckCard addTarget:self action:@selector(checkVipMessage:) forControlEvents:UIControlEventTouchUpInside];
        [btncheckCard setTag:indexPath.row];
        CGFloat centerY=btncheckCard.center.y+5;
        NSString *cardNo=((VipMessageClass *)[_dataArray objectAtIndex:indexPath.row]).cardNum;
        int CardNolength=[cardNo length];
        NSMutableArray *numArray=[[NSMutableArray alloc]init];
        for (int i=0; i<CardNolength; i++)
        {
            [numArray addObject:[cardNo substringWithRange:NSMakeRange(i, 1)]];
        }
        for (int i=0; i<[numArray count]; i++)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"num_%d",[[numArray objectAtIndex:i]intValue]]]];
            imageView.frame=CGRectMake(i*22+10, centerY, 20, 20);
            [btncheckCard addSubview:imageView];
        }
        [cell.contentView addSubview:btncheckCard];
        
//        添加长按删除会员卡手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
        [longPress setMinimumPressDuration:1.0];
        [btncheckCard addGestureRecognizer:longPress];
    }
    return cell;
}

//删除会员长按手势的触发事件
-(void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state==UIGestureRecognizerStateEnded)
    {

        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[NSString stringWithFormat:[langSetting localizedString:@"Whether the membership card %@ unbound"],((VipMessageClass *)[_dataArray objectAtIndex:((UIButton *)longPress.view).tag]).cardNum] delegate:self cancelButtonTitle:[langSetting localizedString:@"The next time"] otherButtonTitles:[langSetting localizedString:@"Remove the binding"], nil];
            _selectDeleteCardNum=[NSString stringWithFormat:@"%@",((VipMessageClass *)[_dataArray objectAtIndex:((UIButton *)longPress.view).tag]).cardNum];
            [alert show];
        });
       
        
        
    }
}

//添加会员卡，需要判断第一次或者第二次添加
-(void)addVipCard
{
    if([_dataArray count]==0)
    {
//        第一次添加
        [DataProvider sharedInstance].isFirst=YES;
        VipManageViewController *manage=[[VipManageViewController alloc]init];
        [self.navigationController pushViewController:manage animated:YES];
    }
    else
    {
//        第二次添加
        [DataProvider sharedInstance].isFirst=NO;
        addOtherPassVertryViewController *add=[[ addOtherPassVertryViewController alloc]init];
        [add setVipMessage:[_dataArray firstObject]];
        [self.navigationController pushViewController:add animated:YES];
    }
}

//查看已经添加的会员卡信息
-(void)checkVipMessage:(UIButton *)button
{
    [DataProvider sharedInstance].selectVip=(VipMessageClass *)[_dataArray objectAtIndex:button.tag];
    NSLog(@"%@",[DataProvider sharedInstance].selectVip);
    VipLookMessageViewController  *look=[[VipLookMessageViewController alloc]init];
    [self.navigationController pushViewController:look animated:YES];
}




#pragma mark alertDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==101)
    {
        if(buttonIndex==1)
        {
             [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(forgetPassword) toTarget:self withObject:nil];
        }
    }
    else
    {
        if(buttonIndex==1)
        {
             [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(removeBindCard) toTarget:self withObject:nil];
        }
    }
}

//忘记支付密码
-(void)forgetPassword
{
    @autoreleasepool
    {
        if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]boolValue ])
        {
            //@"请先绑定手机号码"
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please first binding mobile phone number"]];
        }
        else
        {
            DataProvider *dp=[DataProvider sharedInstance];
            NSMutableDictionary *info=[[NSMutableDictionary alloc]init];
            [info setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"] forKey:@"phone"];
            NSDictionary *dict=[dp forgetPassword:info];
            if ([[dict objectForKey:@"Result"] boolValue])
            {
                [SVProgressHUD dismiss];
                bs_dispatch_sync_on_main_thread(^{
                    [self getBindCardMessage];
                });
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[info objectForKey:@"Message"]];
            }
            
        }
    }
}

//移除绑定的会员卡
-(void)removeBindCard
{
    
    DataProvider *dp=[DataProvider sharedInstance];
    NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
    if(cardCount ==0)
    {
        [DataProvider sharedInstance].isFirst=YES;
    }
    else if(cardCount==1)
    {
        [Info setObject:@"true" forKey:@"flag"];
    }
    else
    {
        [Info setObject:@"false" forKey:@"flag"];
    }
//    flag 的值用于确认是否为解除最后一个绑定，如果是不近解除绑定，而且要充值支付密码
    
    [Info setObject:_selectDeleteCardNum forKey:@"cardNum"];
    NSDictionary *dict=[dp removeBindCard:Info];
    if(dict)
    {
        if([[dict objectForKey:@"Result"]boolValue])
        {
            [self getBindCardMessage];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dict objectForKey:@"Message"]];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Failed to get information"]];
    }

}

-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
