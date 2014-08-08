//
//  VipPersonMessageViewController.m
//  Food
//
//  Created by sundaoran on 14-4-21.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "VipPersonMessageViewController.h"
#import "VipAuthorViewController.h"
#import "VipCheckSelectViewController.h"

@interface VipPersonMessageViewController ()
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    UITextField         *_tfuserName;
    UITextField         *_tfIdentifiyNum;
    UITextField         *_tfPhoneNum;
    UILabel             *lblVipType;
    UITableView         *_tableView;
    NSMutableArray      *_indefidyTypedataArray;
    BOOL                isShowTableView;
    BOOL                isAgreeProtocol;//是否同意协议
    BOOL                isSelect;//是否选择了证件类型
    NSMutableDictionary              *_card_message;
    
    CVLocalizationSetting   *langSetting;
}
@end

@implementation VipPersonMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//复制输入的会员卡号码
-(void)setVipCardNum:(NSDictionary *)cardNum
{
    _card_message=[[NSMutableDictionary  alloc]initWithDictionary:cardNum];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    langSetting=[CVLocalizationSetting sharedInstance];
    self.view.backgroundColor=[UIColor whiteColor];
    _indefidyTypedataArray=[[NSMutableArray alloc]initWithObjects:@"身份证",@"军人证",@"学生证",@"护照",@"驾照", nil];
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
    
   
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    [self.view addSubview:_backGround];
    
//    填写会员卡信息
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Fill in the card information"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(110, 137, ScreenWidth-130, 150) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.layer.borderWidth=0.5;
    _tableView.layer.borderColor=selfborderColor.CGColor;
    _tableView.dataSource=self;

    
    UIView *messageView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 40)];
    messageView.backgroundColor=[UIColor whiteColor];
    messageView.layer.borderColor=selfborderColor.CGColor;
    messageView.layer.borderWidth=0.5;
    messageView.layer.cornerRadius=5;
    [_backGround addSubview:messageView];
    
    UIImageView  *imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 20, 20)];
    [imageViewLeft setImage:[UIImage imageNamed:@"Public_card.png"]];
    [messageView addSubview:imageViewLeft];
    
    
//    *会员卡类型
    UILabel  *lblLeft=[[UILabel alloc]init];
    lblLeft.frame=CGRectMake(30, 0,90, 40);
    lblLeft.text=[langSetting localizedString:@"Card type"];
    lblLeft.textAlignment=NSTextAlignmentLeft;
    lblLeft.backgroundColor=[UIColor clearColor];
    lblLeft.font=[UIFont systemFontOfSize:14];
    [lblLeft setTextColor:[UIColor blackColor]];
    [messageView addSubview:lblLeft];
    
    
    
    UILabel  *lblcardType=[[UILabel alloc]init];
    lblcardType.frame=CGRectMake(120, 0,70, 40);
    [lblcardType setText:[DataProvider sharedInstance].cardType];
    lblcardType.textAlignment=NSTextAlignmentLeft;
    lblcardType.backgroundColor=[UIColor clearColor];
    lblcardType.font=[UIFont systemFontOfSize:14];
    [lblcardType setTextColor:[UIColor blackColor]];
    [messageView addSubview:lblcardType];
    
    
    UIView *PersonView=[[UIView alloc]initWithFrame:CGRectMake(10, messageView.frame.origin.y+messageView.frame.size.height+5, ScreenWidth-20, 165)];
    PersonView.backgroundColor=[UIColor whiteColor];
    PersonView.layer.borderColor=selfborderColor.CGColor;
    PersonView.layer.borderWidth=0.5;
    PersonView.layer.cornerRadius=5;
    [_backGround addSubview:PersonView];
    
    for (int i=0; i<4; i++)
    {
        
        UIImageView  *imageViewLeft=[[UIImageView alloc]initWithFrame:CGRectMake(5, i*41+10, 20, 20)];
        [imageViewLeft setImage:[UIImage imageNamed:@"Public_white.png"]];
        [PersonView addSubview:imageViewLeft];
        
        UILabel  *lblLeft=[[UILabel alloc]init];
        lblLeft.frame=CGRectMake(30,i*41,70, 41);
        lblLeft.textAlignment=NSTextAlignmentLeft;
        lblLeft.backgroundColor=[UIColor clearColor];
        lblLeft.font=[UIFont systemFontOfSize:14];
        [lblLeft setTextColor:[UIColor blackColor]];
        
        if(i!=3)
        {
        UIImageView *lineView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Public_cardline.png"]];
        lineView.frame=CGRectMake(0, (i+1)*41, PersonView.frame.size.width, 1);
        [PersonView addSubview:lineView];
        }
        
        [PersonView addSubview:lblLeft];
        switch (i) {
            case 0:
            {
//                *姓    名:
                NSString *subStr=[NSString stringWithFormat:@"*%@:",[langSetting localizedString:@"name"]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:subStr];
                [str addAttribute:NSForegroundColorAttributeName value:selfbackgroundColor range:NSMakeRange(0,1)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(1,[str length]-1)];
                [lblLeft setAttributedText:str];
                _tfuserName =[[UITextField alloc]initWithFrame:CGRectMake(100,(i*41)+5, messageView.frame.size.width-110, 30)];
                _tfuserName.clearButtonMode=UITextFieldViewModeWhileEditing;
                _tfuserName.borderStyle=UITextBorderStyleNone;
                _tfuserName.delegate=self;
                _tfuserName.font=[UIFont systemFontOfSize:14];
//                请输入姓名
                _tfuserName.placeholder=[langSetting localizedString:@"Enter your name"];
                [PersonView addSubview:_tfuserName];
            }
                break;
            case 1:
            {
//              证件类型:
                [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Document type"]]];
                UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(100, i*41, messageView.frame.size.width-110, 40)];
                [button addTarget:self action:@selector(selectCardTyp) forControlEvents:UIControlEventTouchUpInside];
                lblVipType=[[UILabel alloc]init];
                lblVipType.frame=CGRectMake(0,0,110, 41);
                //请选择证件类型
                [lblVipType setText:[langSetting localizedString:@"Select a credentials type"]];
                lblVipType.textAlignment=NSTextAlignmentLeft;
                lblVipType.backgroundColor=[UIColor clearColor];
                lblVipType.font=[UIFont systemFontOfSize:14];
                [lblVipType setTextColor:[UIColor grayColor]];
                
                UIImageView  *imageViewRight=[[UIImageView alloc]initWithFrame:CGRectMake(button.frame.size.width-20,10, 20, 20)];
                [imageViewRight setImage:[UIImage imageNamed:@"Public_down.png"]];
                [button addSubview:imageViewRight];
                
                [button addSubview:lblVipType];
                [PersonView addSubview:button];
            }
                break;
            case 2:
            {
//                证  件  号:
                [lblLeft setText:[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Id Number"]]];
                _tfIdentifiyNum =[[UITextField alloc]initWithFrame:CGRectMake(100, (i*41)+5, messageView.frame.size.width-110, 30)];
                _tfIdentifiyNum.clearButtonMode=UITextFieldViewModeWhileEditing;
                _tfIdentifiyNum.borderStyle=UITextBorderStyleNone;
                _tfIdentifiyNum.delegate=self;
                _tfIdentifiyNum.font=[UIFont systemFontOfSize:14];
//                请输入证件号
                _tfIdentifiyNum.placeholder=[langSetting localizedString:@"Enter the id number"];
                [PersonView addSubview:_tfIdentifiyNum];
            }
                break;
            case 3:
            {
//                *手  机  号：
                NSString *subStr=[NSString stringWithFormat:@"*%@:",[langSetting localizedString:@"phone number"]];
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:subStr];
                [str addAttribute:NSForegroundColorAttributeName value:selfbackgroundColor range:NSMakeRange(0,1)];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(1,[str length]-1)];
                [lblLeft setAttributedText:str];
                _tfPhoneNum =[[UITextField alloc]initWithFrame:CGRectMake(100,(i*41)+5, messageView.frame.size.width-110, 30)];
                _tfPhoneNum.clearButtonMode=UITextFieldViewModeWhileEditing;
                _tfPhoneNum.delegate=self;
                _tfPhoneNum.borderStyle=UITextBorderStyleNone;
                _tfPhoneNum.font=[UIFont systemFontOfSize:14];
                
//                请输入手机号
                _tfPhoneNum.placeholder=[langSetting localizedString:@"Please enter the phone number"];
                _tfPhoneNum.keyboardType=UIKeyboardTypePhonePad;
                [PersonView addSubview:_tfPhoneNum];
            }
                break;
                
            default:
                break;
        }
        
    }

    UIView *Protocolview=[[UIView alloc]initWithFrame:CGRectMake(20, PersonView.frame.origin.y+PersonView.frame.size.height+5, SUPERVIEWWIDTH-170, 20)];
    Protocolview.backgroundColor=[UIColor clearColor];
    [_backGround addSubview:Protocolview];
    
    UIButton *btnAgree=[UIButton buttonWithType:UIButtonTypeCustom];
    btnAgree.frame=CGRectMake(0, 0, 20, 20);
    [btnAgree setBackgroundImage:[UIImage imageNamed:@"Public_agree.png"] forState:UIControlStateNormal];
    [btnAgree addTarget:self action:@selector(agreebutton:) forControlEvents:UIControlEventTouchUpInside];
    isAgreeProtocol=YES;
    [Protocolview addSubview:btnAgree];
    isAgreeProtocol=YES;
    
    UILabel *lblagree=[[UILabel alloc]init];
    lblagree.frame=CGRectMake(20, 0, 30, 20);
    
//    同意
    [lblagree setText:[langSetting localizedString:@"Agree"]];
    lblagree.textAlignment=NSTextAlignmentCenter;
    lblagree.backgroundColor=[UIColor clearColor];
    lblagree.font=[UIFont systemFontOfSize:12];
    [lblagree setTextColor:[UIColor blackColor]];
    [Protocolview addSubview:lblagree];
    
    UIButton *btnUserProtocol=[UIButton buttonWithType:UIButtonTypeCustom];
    btnUserProtocol.frame=CGRectMake(50, 0, 80, 20);
    
//    《同意协议》
    [btnUserProtocol setTitle:[NSString stringWithFormat:@"《%@》",[langSetting localizedString:@"User agreement"]] forState:UIControlStateNormal];
    btnUserProtocol.titleLabel.font=[UIFont systemFontOfSize:12];
    [btnUserProtocol addTarget:self action:@selector(selectorProtocol) forControlEvents:UIControlEventTouchUpInside];
    [btnUserProtocol setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [Protocolview addSubview:btnUserProtocol];
    
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor whiteColor]];
    nextButton.frame=CGRectMake(10, Protocolview.frame.origin.y+Protocolview.frame.size.height+15, SUPERVIEWWIDTH-20, 30);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    nextButton.layer.cornerRadius=5.0;
    nextButton.tag=104;
    [nextButton  addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *netlbl=[[UILabel alloc]init];
    netlbl.frame=CGRectMake(0, 0, nextButton.frame.size.width, nextButton.frame.size.height);
    [netlbl setText:[langSetting localizedString:@"Next step"]];
    netlbl.textAlignment=NSTextAlignmentCenter;
    netlbl.backgroundColor=[UIColor clearColor];
    netlbl.font=[UIFont systemFontOfSize:13];
    [netlbl setTextColor:[UIColor whiteColor]];
    [nextButton addSubview:netlbl];
    [_backGround addSubview:nextButton];
    
    
    UIControl *control=[[UIControl alloc]initWithFrame:_backGround.bounds];
    [control addTarget:self action:@selector(controlClick) forControlEvents:UIControlEventTouchUpInside];
    [_backGround addSubview:control];
    [_backGround sendSubviewToBack:control];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}


//触发键盘隐藏的事件
-(void)controlClick
{
    [_tfPhoneNum resignFirstResponder];
    [_tfuserName resignFirstResponder];
    [_tfIdentifiyNum resignFirstResponder];
}

//监测键盘以藏后触发的事件
-(void)keyboardWillHide
{
    [UIView animateWithDuration:0.3f animations:^{
         _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
    
}

//下一步
-(void)changeButtonClick:(UIButton *)button
{
    
    if (!isSelect)
    {
        lblVipType.text=@"";
    }
    if ([_tfIdentifiyNum.text length]==0)
    {
      _tfIdentifiyNum.text=@"";
    }
    if([_tfuserName.text length]==0 ||![[_card_message objectForKey:@"name"]isEqualToString:_tfuserName.text])
    {
//        请填写办理会员卡时登记的姓名
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please fill out the registration name card"]];
    }
    else if ([_tfPhoneNum.text length]==0 || [_tfPhoneNum.text length]!=11 ||![_tfPhoneNum.text isEqualToString:[_card_message objectForKey:@"tele"]])
    {
//        请填写办理会员卡时登记的手机号码
        [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please fill in the card registered mobile phone number"]];
    }
    else if (![_tfPhoneNum.text isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]])
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"登陆绑定的手机号码与会员绑定手机号码不符，不可添加绑定" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        });

    }
    else
    {
        [self controlClick];
        [_card_message setObject:_tfuserName.text forKey:@"name"];
        [_card_message setObject:lblVipType.text forKey:@"credenTyp"];
        [_card_message setObject:_tfIdentifiyNum.text forKey:@"idNo"];
         
        
        NSLog(@"%@",_card_message);


    [DataProvider sharedInstance].authorPhoe=_tfPhoneNum.text;
    VipAuthorViewController *vipcard=[[VipAuthorViewController alloc]init];
    [vipcard setPersonInfo:_card_message];
    [self.navigationController pushViewController:vipcard animated:YES];
    }
}

//查看协议
-(void)selectorProtocol
{
    VipCheckSelectViewController *vipCheck=[[VipCheckSelectViewController alloc]initWithCheckSelectType:CheckselectAgreement andTitleName:[langSetting localizedString:@"User agreement"] andsetResult:nil];
    [self.navigationController pushViewController:vipCheck animated:YES];
}

//是否同归协议
-(void)agreebutton:(UIButton *)button
{
    if(isAgreeProtocol)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"Public_disagree.png"] forState:UIControlStateNormal];
        isAgreeProtocol=NO;
    }
    else
    {
          [button setBackgroundImage:[UIImage imageNamed:@"Public_agree.png"] forState:UIControlStateNormal];
        isAgreeProtocol=YES;
    }
}
//选择证件类型
-(void)selectCardTyp
{
    [self controlClick];
    if(!isShowTableView)
    {
        [_backGround addSubview:_tableView];
        isShowTableView=YES;
    }
    else
    {
        [_tableView removeFromSuperview];
        isShowTableView=NO;
    }
}


//根据点击的textField来判断需要改变视图的位置，防止键盘盖住textField
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGFloat  moverHeight=0.0;
    if(!(ScreenHeight>480.0f || ScreenHeight>568))
    {
    if(textField==_tfuserName)
    {
        moverHeight=0.0f;
    }
    else if (textField==_tfIdentifiyNum)
    {
        moverHeight=70.0f;
    }
    else if (textField==_tfPhoneNum)
    {
        moverHeight=100.0f;
    }
    [UIView animateWithDuration:0.3f animations:^{
        _backGround.frame=CGRectMake(0,VIEWHRIGHT-moverHeight, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    } completion:^(BOOL finished) {
        
    }];
    }
    return YES;
}

#pragma mark  uitableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_indefidyTypedataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text=@"";
    cell.textLabel.text=[_indefidyTypedataArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isSelect=YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    lblVipType.text=[_indefidyTypedataArray objectAtIndex:indexPath.row];
    [_tableView removeFromSuperview];
    isShowTableView=NO;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        if(textField !=_tfPhoneNum)
        {
            if(textField ==_tfIdentifiyNum  && !isSelect)
            {
                [SVProgressHUD showErrorWithStatus:@"请选择证件类型"];
                return NO;
            }
            else
            {
                return YES;
            }
            
        }
        else
        {
            if((textField==_tfPhoneNum && [_tfPhoneNum.text length]<=0 &&[string isEqualToString:@"0"]) || [_tfPhoneNum.text length]>10)
            {
                return NO;
            }
            else
            {
                NSString *validRegEx =@"^[0-9]+(.[0-9]{2})?$";
                
                NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
                
                BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
                
                if (myStringMatchesRegEx)
                    
                    return YES;
                
                else
                    
                    return NO;
            }

        }
    }
    
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
