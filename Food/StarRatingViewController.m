//
//  StarRatingViewController.m
//  Food
//
//  Created by sundaoran on 14-7-2.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "StarRatingViewController.h"

@interface StarRatingViewController ()

@end

@implementation StarRatingViewController
{
    UIScrollView              *_backGround;
    CGFloat             VIEWHRIGHT;
    
    CVLocalizationSetting *    langSetting;
    
    NSMutableArray  *_ratingViewArray;
    NSString        *_storeId;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setStoreMessage:(NSString *)storeId
{
        _storeId=storeId;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    langSetting=[CVLocalizationSetting sharedInstance];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
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
    
    _backGround=[[UIScrollView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT-VIEWHRIGHT);
    [self.view addSubview:_backGround];
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:@"顾客点评"];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(getEvalColumn) toTarget:self withObject:nil];
    
}

-(void)getEvalColumn
{
    @autoreleasepool
    {
        DataProvider *dp = [[DataProvider alloc] init];
        NSDictionary *dicCity = [dp getEvalColumn];
        if ([[dicCity objectForKey:@"Result"] boolValue])
        {
            [SVProgressHUD dismiss];
            NSArray *valueArray=[[NSArray alloc]initWithArray:[dicCity objectForKey:@"Message"]];
            [self creatView:valueArray];
        }else{
            [SVProgressHUD showErrorWithStatus:[dicCity objectForKey:@"Message"]];
        }
    }
}


-(void)creatView:(NSArray *)array
{
    
    _ratingViewArray=[[NSMutableArray alloc]init];
    CGFloat height=0.0;
    for (int i=0; i<[array count]+1; i++)
    {
        UILabel *lblLeftTitle=[[UILabel alloc]initWithFrame:CGRectMake(30, i*50+20,60, 50)];
        NSMutableDictionary *dict;
        if(i!=[array count])
        {
            dict=[[NSMutableDictionary alloc]initWithDictionary:[array objectAtIndex:i]];
             lblLeftTitle.text=[NSString stringWithFormat:@"%@:",[dict objectForKey:@"name"]];
        }
        else
        {
            dict=[[NSMutableDictionary alloc]init];
             lblLeftTitle.text=[NSString stringWithFormat:@"总分:"];
        }
        
        lblLeftTitle.textAlignment=NSTextAlignmentLeft;
        lblLeftTitle.font=[UIFont systemFontOfSize:17];
        lblLeftTitle.textColor=[UIColor blackColor];
        lblLeftTitle.backgroundColor=[UIColor clearColor];
        lblLeftTitle.numberOfLines=0;
        lblLeftTitle.lineBreakMode=NSLineBreakByWordWrapping;
        [_backGround addSubview:lblLeftTitle];
        
        
        RatingView *rat=[[RatingView alloc]initWithFrame:CGRectMake(lblLeftTitle.frame.origin.x+lblLeftTitle.frame.size.width, lblLeftTitle.frame.origin.y+10, 220-lblLeftTitle.frame.size.width-60,lblLeftTitle.frame.size.height)];
        [rat setImagesDeselected:@"Public_starNomal.png" partlySelected:nil fullSelected:@"Public_starFull.png" andDelegate:self];
        [rat displayRating:5.0];
        rat.backgroundColor=[UIColor clearColor];
        
        [dict setObject:rat forKey:@"view"];
        [dict setObject:[NSNumber numberWithFloat:5.0] forKey:@"score"];
        
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(rat.frame.origin.x+rat.frame.size.width+10, lblLeftTitle.frame.origin.y, 75, lblLeftTitle.frame.size.height)];
        lbl.text=@"非常满意";
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.font=[UIFont systemFontOfSize:17];
        lbl.textColor=selfbackgroundColor;
        [_backGround addSubview:lbl];
        
         [dict setObject:lbl forKey:@"titleView"];
        
        if(i==[array count])
        {
            [dict setObject:@"总分" forKey:@"name"];
            [dict setObject:@"score" forKey:@"id"];
        }
        [_ratingViewArray addObject:dict];
        [_backGround addSubview:rat];
        
       
        height=rat.frame.origin.y+rat.frame.size.height;
    }
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor whiteColor]];
    nextButton.frame=CGRectMake(10, height+30, SUPERVIEWWIDTH-20, 30);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    nextButton.layer.cornerRadius=5.0;
    nextButton.tag=104;
    [nextButton  addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *netlbl=[[UILabel alloc]init];
    netlbl.frame=CGRectMake(0, 0, nextButton.frame.size.width, nextButton.frame.size.height);
    [netlbl setText:[langSetting localizedString:@"Submit"]];
    netlbl.textAlignment=NSTextAlignmentCenter;
    netlbl.backgroundColor=[UIColor clearColor];
    netlbl.font=[UIFont systemFontOfSize:13];
    [netlbl setTextColor:[UIColor whiteColor]];
    [nextButton addSubview:netlbl];
    [_backGround addSubview:nextButton];
    
    [_backGround setContentSize:CGSizeMake(ScreenWidth, nextButton.frame.origin.y+nextButton.frame.size.height+30)];

}

-(void)nextButtonClick
{
    NSMutableDictionary *info=[[NSMutableDictionary alloc]init];
    NSString *str=@"";
    for(NSMutableDictionary *dict in _ratingViewArray)
    {
        if([[dict objectForKey:@"id"]isEqualToString:@"score"])
        {
           [info setObject:[dict objectForKey:@"score"] forKey:@"score"];
        }
        else
        {
            NSString *value=[NSString stringWithFormat:@"{%@:'%@',%@:'%@',%@:%@}",@"columnId",[dict objectForKey:@"id"],@"columnName",[dict objectForKey:@"name"],@"columnValue",[dict objectForKey:@"score"]];
            if([str isEqualToString:@""])
            {
                str=[str stringByAppendingString:[NSString stringWithFormat:@"%@",value]];
            }
            else
            {
                str=[str stringByAppendingString:[NSString stringWithFormat:@",%@",value]];
            }
        }
    }
    
    [info setObject:_storeId forKey:@"firmId"];
    
    [info setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"] forKey:@"cardId"];
    [info setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"] forKey:@"account"];
    [info setObject:[NSString stringWithFormat:@"[%@]",str] forKey:@"scoredtl"];
    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(saveEvalColumn:) toTarget:self withObject:info];
    
}

-(void)saveEvalColumn:(NSMutableDictionary *)Info
{
    @autoreleasepool
    {
        DataProvider *dp = [[DataProvider alloc] init];
        NSDictionary *dicCity = [dp saveEvaluation:Info];
        if ([[dicCity objectForKey:@"Result"] boolValue])
        {
            [SVProgressHUD dismiss];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"评价成功" message:@"感谢您的支持与参与" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alert.tag=101;
            [alert show];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dicCity objectForKey:@"Message"]];
        }
    }

}

#pragma mark strarRatingDelegate
-(void)ratingChanged:(float)newRating andRatongView:(id)ratingView
{
    for(NSMutableDictionary *dict in _ratingViewArray)
    {
        if ([dict objectForKey:@"view"]==ratingView)
        {
            [dict setObject:[NSNumber numberWithFloat:newRating] forKey:@"score"];
            switch ([[NSNumber numberWithFloat:newRating]intValue]) {
                case 1:
                    ((UILabel *)[dict objectForKey:@"titleView"]).text=@"非常糟糕";
                    ((UILabel *)[dict objectForKey:@"titleView"]).textColor=[UIColor grayColor];
                    break;
                    
                case 2:
                    ((UILabel *)[dict objectForKey:@"titleView"]).text=@"糟糕";
                    ((UILabel *)[dict objectForKey:@"titleView"]).textColor=[UIColor grayColor];
                    break;
                    
                case 3:
                    ((UILabel *)[dict objectForKey:@"titleView"]).text=@"一般";
                    ((UILabel *)[dict objectForKey:@"titleView"]).textColor=[UIColor orangeColor];
                    break;
                    
                case 4:
                    ((UILabel *)[dict objectForKey:@"titleView"]).text=@"满意";
                    ((UILabel *)[dict objectForKey:@"titleView"]).textColor=selfbackgroundColor;
                    break;
                    
                case 5:
                    ((UILabel *)[dict objectForKey:@"titleView"]).text=@"非常满意";
                    ((UILabel *)[dict objectForKey:@"titleView"]).textColor=selfbackgroundColor;
                    break;
                default:
                    break;
            }
        }
    }
    
}

#pragma mark AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]-3)] animated:YES];
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
