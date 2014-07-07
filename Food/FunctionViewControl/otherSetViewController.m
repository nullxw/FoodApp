//
//  otherSetViewController.m
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "otherSetViewController.h"
#import "LoginViewController.h"

@interface otherSetViewController ()

@end

@implementation otherSetViewController
{
    UIView *_backGround;
    CGFloat    VIEWHRIGHT;
    
    UITableView         *_tableView;
    CVLocalizationSetting *langSetting;
    UILabel *lbl;
    NSString *app_Version;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    langSetting=[CVLocalizationSetting sharedInstance];
	// Do any additional setup after loading the view.
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
    
    navigationBarView *nvc=[[navigationBarView alloc]initWithFrame:CGRectMake(0, 0, SUPERVIEWWIDTH, VIEWHRIGHT) andTitle:[langSetting localizedString:@"Other Settings"]];
    nvc.delegate=self;
    [self.view addSubview:nvc];
    
    _backGround=[[UIView alloc]init];
    _backGround.frame=CGRectMake(0,VIEWHRIGHT, SUPERVIEWWIDTH, SUPERVIEWHEIGHT);
    _backGround.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_backGround];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 10,SUPERVIEWWIDTH, 40*5) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.bounces=NO;
    [_backGround addSubview:_tableView];
    
   
   
    
}


#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
    cell.detailTextLabel.text=@"";
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text=[langSetting localizedString:@"Change the binding phone"];
            break;
        case 1:
            cell.textLabel.text=[langSetting localizedString:@"Check the binding phone"];
            break;
        case 2:
            cell.textLabel.text=[langSetting localizedString:@"Forget the binding phone"];
            break;
        case 3:
        {
            cell.textLabel.text=@"清除缓存";
            lbl=[[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-100, 0, 100,cell.contentView.frame.size.height)];
            NSString *localPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"] ;
            lbl.text=[NSString stringWithFormat:@"%.2fM", [self fileSizeForDir:localPath]];
            lbl.textAlignment=NSTextAlignmentCenter;
            lbl.font=[UIFont systemFontOfSize:14];
            lbl.textColor=selfbackgroundColor;
            [cell.contentView addSubview:lbl];
        }
            break;
        case 4:
        {
            cell.textLabel.text=@"检查更新";
           UILabel *lbl_Version=[[UILabel alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-100, 0, 100,cell.contentView.frame.size.height)];
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            lbl_Version.text=[NSString stringWithFormat:@"v%@", app_Version];
            lbl_Version.textAlignment=NSTextAlignmentCenter;
            lbl_Version.font=[UIFont systemFontOfSize:14];
            lbl_Version.textColor=selfbackgroundColor;
            [cell.contentView addSubview:lbl_Version];
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.row==0)
    {
        LoginViewController *login=[[LoginViewController alloc]init];
        login.isChange=YES;//修改账号
        [DataProvider sharedInstance].isClearColor=YES;//导航条为透明
        [self.navigationController pushViewController:login animated:YES];
    }
    else if(indexPath.row==1)
    {
        NSString    *userPhone;
        NSString    *userName;
        NSString    *userId;
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"])
        {
            userName=[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
        }
        else
        {
            userName=[langSetting localizedString:@"Temporarily no data"];
        }
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"] boolValue])
        {
            userPhone=[[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"];
        }
        else
        {
            userPhone=[langSetting localizedString:@"Temporarily no data"];
        }
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userId"])
        {
            userId=[[NSUserDefaults standardUserDefaults]objectForKey:@"userId"];
        }
        else
        {
            userId=[langSetting localizedString:@"Temporarily no data"];
        }
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"The binding information"] message:[NSString stringWithFormat:@"用户ID:%@\n%@:%@\n%@:%@",userId,[langSetting localizedString:@"User name"],userName,[langSetting localizedString:@"Phone number"],userPhone] delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil ];
            [alert show];
        });
        
    }
    else if (indexPath.row==2)
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[langSetting localizedString:@"Prompt"] message:[langSetting localizedString:@"Determine the cancellation of the current user information"] delegate:self cancelButtonTitle:[langSetting localizedString:@"cancel"] otherButtonTitles:[langSetting localizedString:@"OK"],nil];
            [alert show];
            
        });
    }
    else if (indexPath.row==3)
    {
        [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(cancleCache) toTarget:self withObject:nil];
        
    }
    else if (indexPath.row==4)
    {
        [self checkUpdata:app_Version];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前版本为最新版本" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}


//查询是否需要升级
-(void)checkUpdata:(NSString *)version
{
    [[DataProvider sharedInstance]isTypUpdateWebService:version andXml:@"123"];
}

//清除缓存
-(void)cancleCache
{
    NSString *localPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"] ;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:localPath error:nil];
    for (NSString *str in fileArray)
    {
        NSString *filePath = [localPath stringByAppendingPathComponent:str];
        [fileManager removeItemAtPath:filePath error:nil];
    }
    [SVProgressHUD showSuccessWithStatus:@"完成"];
    lbl.text=[NSString stringWithFormat:@"0.00M"];
}

//计算缓存大小
-(float)fileSizeForDir:(NSString*)path//计算文件夹下文件的总大小
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float size =0;
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size+= fileAttributeDic.fileSize/ 1024.0/1024.0;
        }
        else
        {
            [self fileSizeForDir:fullPath];
        }
    }
    return size;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"userPhone"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"userId"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        if(![[NSUserDefaults standardUserDefaults]objectForKey:@"userName"] && ![[NSUserDefaults standardUserDefaults]objectForKey:@"userPhone"])
        {
            [SVProgressHUD showSuccessWithStatus:[langSetting localizedString:@"Logout success"]];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[langSetting localizedString:@"Logout failed"]];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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

@end
