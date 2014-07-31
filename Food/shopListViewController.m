//
//  shopListViewController.m
//  Food
//
//  Created by sundaoran on 14-4-22.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "shopListViewController.h"
#import "shopListTableViewCell.h"


@interface shopListViewController ()
{
    UITableView *_tableView;
    UIView              *_backGround;
    CGFloat             VIEWHRIGHT;
    NSMutableArray      *dataArray;
    CVLocalizationSetting   *langSetting;
}
@end

@implementation shopListViewController

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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellName=@"cell";
    shopListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[shopListTableViewCell alloc]initWithStoreDict:[dataArray objectAtIndex:indexPath.row] andCellStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    return cell;
}

//cell图标点击代理事件
-(void)ClickButonOnTheCell:(NSDictionary *)dict
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
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
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    [self.view addSubview:_backGround];
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Store the query"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, _backGround.frame.size.width, _backGround.frame.size.height-VIEWHRIGHT) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.allowsSelection=NO;
    [self requestStores];

}

//请求门店数据
-(void)requestStores
{
    [SVProgressHUD showProgress:-1 status:[langSetting localizedString:@"load..."] maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(getStore) toTarget:self withObject:nil];
}

//获取门店数据处理获取结果
-(void)getStore
{
    @autoreleasepool {
        DataProvider *dp=[DataProvider sharedInstance];
        dp.storeMessage=nil;
        NSMutableDictionary *dictValue=[[NSMutableDictionary alloc]init];
        
        if([dp.selectCity.selectproviceId isEqualToString:@"0"])
        {
            [dictValue setValue:dp.selectCity.selectprovice forKey:@"area"];
            [dictValue setValue:dp.selectCity.selectproviceId forKey:@"type"];
        }
        else
        {
            [dictValue setValue:dp.selectCity.selectproviceId forKey:@"area"];
        }
        [dictValue setValue:dp.selectTime forKey:@"dat"];
        [dictValue setValue:dp.selectCanCi forKey:@"sft"];
        dp.isShop=YES;
        NSDictionary *dictStore=[[NSDictionary alloc]initWithDictionary:[dp getStoreByArea:dictValue]];
        
        if ([[dictStore objectForKey:@"Result"] boolValue])
        {
            [SVProgressHUD dismiss];
            NSArray *ary = [dictStore objectForKey:@"Message"];
            dataArray=[[NSMutableArray alloc]init];
            for (NSDictionary *dic in ary)
            {
                StoreMessage  *store=[[StoreMessage alloc]init];
                store.storeFirmdes =[dic objectForKey:@"firmdes"];
                store.storeFirmid =[dic objectForKey:@"firmid"];
                store.storeAddr =[dic objectForKey:@"addr"];
                store.storeArea =[dic objectForKey:@"area"];
                store.storeTele =[dic objectForKey:@"tele"];
                store.storeWbigPic =[dic objectForKey:@"wbigpic"];
                store.storeInit =[dic objectForKey:@"init"];
                store.storelongitude=[[[[dic objectForKey:@"position"]componentsSeparatedByString:@","]firstObject]doubleValue ];
               store.storelatitude=[[[[dic objectForKey:@"position"]componentsSeparatedByString:@","]lastObject]doubleValue ];
                store.lunchstart=[dic objectForKey:@"lunchstart"];
                store.lunchendtime=[dic objectForKey:@"lunchendtime"];
                store.dinnerstart=[dic objectForKey:@"dinnerstart"];
                store.dinnerendtime=[dic objectForKey:@"dinnerendtime"];
                if(!store.storelatitude && !store.storelongitude)//没有返回经纬度，默认北京
                {
//                坐标经纬度
                    store.storelongitude=116.404;
                    store.storelatitude=39.915;
                }
                [dataArray addObject:store];
            }
            if([dataArray count]==0)
            {
                bs_dispatch_sync_on_main_thread(^{
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"The city is temporarily unable to store data"] delegate:nil cancelButtonTitle:nil otherButtonTitles:[langSetting localizedString:@"OK"], nil];
                    [alert show];
                });
                
            }
            [_backGround addSubview:_tableView];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dictStore objectForKey:@"Message"]];
        }
    }
    
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
