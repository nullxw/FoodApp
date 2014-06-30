//
//  lineCallNumViewController.m
//  Food
//
//  Created by sundaoran on 14-5-15.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "lineCallNumViewController.h"
#import "lineCallNumTableViewCell.h"

@interface lineCallNumViewController ()

@end

@implementation lineCallNumViewController
{
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    UITableView         *_tableView;
     CVLocalizationSetting   *langSetting;
    NSArray             *_dataArray;//门店数据
}

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
    if([_dataArray count] && _tableView)
    {
        [_tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    langSetting=[CVLocalizationSetting sharedInstance];
    // Do any additional setup after loading the view.
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Line up your turn"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    _backGround.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backGround];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0,_backGround.frame.size.width, _backGround.frame.size.height-VIEWHRIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.allowsSelection=NO;
    _tableView.separatorColor=[UIColor orangeColor];
    [_backGround addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refushTable) name:@"refushTable" object:nil];
    
    [self refushTable];
    
}

//刷新或者首次获取可叫号门店列表
-(void)refushTable
{
    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(getFirmLine) toTarget:self withObject:nil];
}

//可叫号门店数据处理
-(void)getFirmLine
{
    @autoreleasepool
    {
        DataProvider *dp=[DataProvider sharedInstance];
        NSMutableDictionary *Info=[[NSMutableDictionary alloc]init];
        [Info setObject:((changeCity *)dp.selectCity).selectproviceId forKey:@"areaId"];
        NSDictionary *dict=[dp getFirmLine:Info];
        if([[dict objectForKey:@"Result"]boolValue])
        {
            _dataArray=[[NSArray alloc]initWithArray:[dict objectForKey:@"Message"]];
            [_tableView reloadData];
            [SVProgressHUD dismiss];
            if([_dataArray count]==0)
            {
               bs_dispatch_sync_on_main_thread(^{
                  
                   UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"The city is your turn stores"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
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

#pragma mark  tableviewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *cellName=@"cell";
    lineCallNumTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[lineCallNumTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName andStoreMessage:[_dataArray objectAtIndex:indexPath.row]];
    }
    if(cell)
    {
        [cell setInfoDict:[_dataArray objectAtIndex:indexPath.row]];
    }

    return cell;
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
