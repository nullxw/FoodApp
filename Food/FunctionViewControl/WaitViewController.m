//
//  WaitViewController.m
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "WaitViewController.h"
#import "LookequipotentialViewController.h"

@interface WaitViewController ()

@end

@implementation WaitViewController
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    CVLocalizationSetting   *langSetting;
    
    UITableView         *_tableView;
    NSMutableArray      *_dataArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    langSetting =[CVLocalizationSetting sharedInstance];
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"My equipotential"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT- VIEWHRIGHT);
    _backGround.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backGround];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, _backGround.frame.size.width, _backGround.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
     [_backGround addSubview:_tableView];
    
    [self refushMyWaitList];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refushMyWaitList) name:@"refushMyWaitList" object:nil];
    
}


-(void)refushMyWaitList
{
    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(findMyWait) toTarget:self withObject:nil];
}

-(void)findMyWait
{
    @autoreleasepool
    {
        if(![[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"]boolValue ])
        {
                //请先绑定手机号码
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Please first binding mobile phone number"]];
        }
        else
        {
            DataProvider *dp=[DataProvider sharedInstance];
            NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
            NSString  *phone=[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"];
            [Info setObject:phone forKey:@"Phone"];
            NSDictionary *dict=[dp findMyWait:Info];
            if([[dict objectForKey:@"Result"]boolValue])
            {
                _dataArray=[[NSMutableArray alloc]initWithArray:[dict objectForKey:@"Message"]];
                [_tableView reloadData];
                
                [SVProgressHUD dismiss];
                if([_dataArray count]==0)
                {
                    //暂无等位记录
                    bs_dispatch_sync_on_main_thread(^{
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"No equipotential record"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
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
}

#pragma mark  uitableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.textLabel.text=@"";
    cell.detailTextLabel.text=@"";
    NSDictionary *dict=[[NSDictionary alloc]initWithDictionary:[_dataArray objectAtIndex:indexPath.row]];
    cell.textLabel.text=[dict objectForKey:@"firmdes"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@:%@",[langSetting localizedString:@"Your allelic number"],[dict objectForKey:@"getNo"]];
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LookequipotentialViewController *quipoten=[[LookequipotentialViewController alloc]init];
    [quipoten setInfo:[_dataArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:quipoten animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(void)navigationBarViewbackClick
{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
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

@end
