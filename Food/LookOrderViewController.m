//
//  LookOrderViewController.m
//  Food
//
//  Created by sundaoran on 14-6-5.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "LookOrderViewController.h"
#import "PackageViewController.h"

@interface LookOrderViewController ()

@end

@implementation LookOrderViewController
{
    
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    
    CVLocalizationSetting *langSetting;
    
    NSMutableArray *_dataArray;
    UITableView     *_tableView;
    
    CGFloat         _price;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

-(id)initWithInfo:(NSMutableArray *)InfoArray
{
    self=[super init];
    if(self)
    {
        _dataArray =[[NSMutableArray alloc]initWithArray:InfoArray];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:@"预订详情"];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    _backGround.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backGround];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-VIEWHRIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_backGround addSubview:_tableView];
    
    _price=0;
    for (NSDictionary *dict in _dataArray)
    {
       _price += [[dict objectForKey:@"price"]floatValue];
    }
}



#pragma mark --UItableViewDelegate
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
    static NSString *cellname=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellname];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellname];
    }
    if(![[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"ispackage"]boolValue])//判断是否为套餐
    {
//        套餐菜品点击后可查看套餐详情
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
//        非套餐菜品不可点击
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
//    加载数据
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSDictionary *dict=[_dataArray objectAtIndex:indexPath.row];
    if(dict)
    {
        //        菜品名称
        UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 130, cell.contentView.frame.size.height)];
        lblName.text=[dict objectForKey:@"pdes"];
        lblName.textAlignment=NSTextAlignmentLeft;
        lblName.font=[UIFont systemFontOfSize:15];
        lblName.textColor=[UIColor grayColor];
        lblName.backgroundColor=[UIColor clearColor];
        lblName.numberOfLines=2;
        lblName.lineBreakMode=NSLineBreakByWordWrapping;
        [cell.contentView addSubview:lblName];
        
        
        //        菜品数量
        UILabel *lblCount=[[UILabel alloc]initWithFrame:CGRectMake(150, 0, 50,  cell.contentView.frame.size.height)];
        lblCount.text=[dict objectForKey:@"foodnum"];
        lblCount.textAlignment=NSTextAlignmentRight;
        lblCount.font=[UIFont systemFontOfSize:17];
        lblCount.textColor=[UIColor grayColor];
        lblCount.backgroundColor=[UIColor clearColor];
        lblCount.numberOfLines=0;
        lblCount.lineBreakMode=NSLineBreakByWordWrapping;
        [cell.contentView addSubview:lblCount];
        
        
        //菜品价格（总价格）
        UILabel *lblPrice=[[UILabel alloc]initWithFrame:CGRectMake(220, 0, 90,  cell.contentView.frame.size.height)];
        lblPrice.text=[NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"price"]floatValue]];
        lblPrice.textAlignment=NSTextAlignmentCenter;
        lblPrice.font=[UIFont systemFontOfSize:17];
        lblPrice.textColor=[UIColor grayColor];
        lblPrice.backgroundColor=[UIColor clearColor];
        lblPrice.numberOfLines=0;
        lblPrice.lineBreakMode=NSLineBreakByWordWrapping;
        [cell.contentView addSubview:lblPrice];
    
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    tableview头部视图，显示账单金额
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    view.backgroundColor=kgrayColor;
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height/2)];
    lbl.text=[NSString stringWithFormat:@"当前菜品总金额：%.2f元",_price];
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.font=[UIFont systemFontOfSize:17];
    lbl.textColor=selfbackgroundColor;
    lbl.numberOfLines=0;
    lbl.lineBreakMode=NSLineBreakByWordWrapping;
    [view addSubview:lbl];
    
    
    UILabel *lblName=[[UILabel alloc]initWithFrame:CGRectMake(20, lbl.frame.size.height, 90, view.frame.size.height/2)];
    lblName.text=[NSString stringWithFormat:@"菜品名称"];
    lblName.textAlignment=NSTextAlignmentLeft;
    lblName.font=[UIFont systemFontOfSize:17];
    lblName.textColor=[UIColor grayColor];
    lblName.backgroundColor=[UIColor clearColor];
    lblName.numberOfLines=0;
    lblName.lineBreakMode=NSLineBreakByWordWrapping;
    [view addSubview:lblName];
    
    
    
    UILabel *lblCount=[[UILabel alloc]initWithFrame:CGRectMake(150, lbl.frame.size.height, 70, view.frame.size.height/2)];
    lblCount.text=[NSString stringWithFormat:@"菜品数量"];
    lblCount.textAlignment=NSTextAlignmentLeft;
    lblCount.font=[UIFont systemFontOfSize:17];
    lblCount.textColor=[UIColor grayColor];
    lblCount.backgroundColor=[UIColor clearColor];
    lblCount.numberOfLines=0;
    lblCount.lineBreakMode=NSLineBreakByWordWrapping;
    [view addSubview:lblCount];
    
    
    UILabel *lblPrice=[[UILabel alloc]initWithFrame:CGRectMake(240, lbl.frame.size.height, 70, view.frame.size.height/2)];
    lblPrice.text=[NSString stringWithFormat:@"菜品金额"];
    lblPrice.textAlignment=NSTextAlignmentLeft;
    lblPrice.font=[UIFont systemFontOfSize:17];
    lblPrice.textColor=[UIColor grayColor];
    lblPrice.backgroundColor=[UIColor clearColor];
    lblPrice.numberOfLines=0;
    lblPrice.lineBreakMode=NSLineBreakByWordWrapping;
    [view addSubview:lblPrice];

    
    
    return view;
}

//只有套餐才为可点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(![[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"ispackage"]boolValue])//判断是否为套餐
    {
        PackageViewController *pack=[[PackageViewController alloc]init];
        [pack setDictInfoByLookorder:[_dataArray objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:pack animated:YES];
    }
}
#pragma marknavigationBarViewDelegate
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
