//
//  BSBookCell.m
//  BookSystem-iPhone
//
//  Created by dcw on 13-12-4.
//  Copyright (c) 2013年 Stan Wu. All rights reserved.
//

#import "BSBookCell.h"
#import "DataProvider.h"
#import "PackageViewController.h"
#import "WebImageView.h"
#import "FoodView.h"

@implementation BSBookCell
{
    UIView *_lineView;
}
@synthesize delegate,recommendImage,cellImageClick;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

//初始化控件
- (void)_initView{
    //头像
    recommendImage = [[WebImageView alloc] initWithFrame:CGRectZero];
    recommendImage.backgroundColor = [UIColor clearColor];
    recommendImage.frame = CGRectMake(5, 5, 70, 60);
    recommendImage.userInteractionEnabled = YES;
    [self.contentView addSubview:recommendImage];
    
    
    
    //菜名
    _foodLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _foodLable.frame = CGRectMake(80, 5, ScreenWidth-kLeftTableWidth-70, 20);
    _foodLable.backgroundColor = [UIColor clearColor];
    _foodLable.numberOfLines = 3;
    _foodLable.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_foodLable];
    
    
    
    //价格
    _priceLable = [[RTLabel alloc] initWithFrame:CGRectZero];
    _priceLable.frame =  CGRectMake(80, 30, 0, 0);//CGRectMake(80, 50, 70, 18);
    _priceLable.backgroundColor = [UIColor clearColor];
    _priceLable.textColor = [UIColor grayColor];
    _priceLable.font = [UIFont systemFontOfSize:10.0];
    [self.contentView addSubview:_priceLable];
    
    _lineView=[[UIView alloc]initWithFrame:CGRectMake(80, 36, 0, 0)];
    _lineView.backgroundColor=[UIColor grayColor];
    [self.contentView addSubview:_lineView];
    
    //App价格
    _priceLableApp = [[RTLabel alloc] initWithFrame:CGRectZero];
    _priceLableApp.frame = CGRectMake(80, 50, 0, 0);//CGRectMake(80, 30, 70, 18);
    _priceLableApp.backgroundColor = [UIColor clearColor];
    _priceLableApp.textColor = [UIColor redColor];
    _priceLableApp.font = [UIFont systemFontOfSize:10.0];
    [self.contentView addSubview:_priceLableApp];

    
    //加号
    _plusBut = [[UIButton alloc] initWithFrame:CGRectZero];
    _plusBut.backgroundColor = [UIColor clearColor];
    [_plusBut setBackgroundImage:[UIImage imageNamed:@"Order_check_plus.png"] forState:UIControlStateNormal];
    [_plusBut addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    _plusBut.frame = CGRectMake(ScreenWidth-kLeftTableWidth-30, 40, 28, 28);
    [self.contentView addSubview:_plusBut];
    
    //数量
    _countBut = [[UIButton alloc] initWithFrame:CGRectZero];
    _countBut.backgroundColor = [UIColor clearColor];
    [_countBut setBackgroundImage:[UIImage imageNamed:@"Order_Num.png"] forState:UIControlStateNormal];
    _countBut.frame = CGRectMake(ScreenWidth-kLeftTableWidth-27*2, 43, 23, 23);
    [self.contentView addSubview:_countBut];
    
    _counttf = [[UITextField alloc] initWithFrame:CGRectZero];
    _counttf.frame = CGRectMake(0, 0, 23, 23);
    _counttf.textColor = [UIColor blackColor];
    _counttf.font = [UIFont systemFontOfSize:11.0];
    _counttf.backgroundColor = [UIColor clearColor];
    _counttf.keyboardType=UIKeyboardTypeNumberPad;
    _counttf.textAlignment = NSTextAlignmentCenter;
    _counttf.delegate=self;
    [_countBut addSubview:_counttf];
    
    //减号
    _minusBut = [[UIButton alloc] initWithFrame:CGRectZero];
    _minusBut.backgroundColor = [UIColor clearColor];

    [_minusBut setBackgroundImage:[UIImage imageNamed:@"Order_check_minus.png"] forState:UIControlStateNormal];
    [_minusBut addTarget:self action:@selector(minusClick) forControlEvents:UIControlEventTouchUpInside];
    _minusBut.frame = CGRectMake(ScreenWidth-kLeftTableWidth-28*3, 40, 28, 28);
    [self.contentView addSubview:_minusBut];
    
}

//显示信息
- (void)showInfo:(NSDictionary *)info{
    
    if ([[info objectForKey:@"grpStr"] isEqualToString:@"套餐"]) {
        
        //显示已点菜品数量的判断
        DataProvider *db = [DataProvider sharedInstance];
        NSMutableArray *aryOrder = [db orderedFood];
        int countFood = 0;
        for (NSMutableDictionary *dicOrder in aryOrder) {
            if ([[dicOrder objectForKey:@"id"] isEqualToString:[info objectForKey:@"id"]] | [[dicOrder objectForKey:@"pubitem"] isEqualToString:[info objectForKey:@"pubitem"]]) {
                countFood = countFood + [[dicOrder objectForKey:@"total"] intValue];
            }
        }
        if (countFood > 0) {
            _minusBut.hidden = NO;
            _countBut.hidden = NO;
        }else{
            _countBut.hidden = YES;
            _minusBut.hidden = YES;
        }
        
        
        NSString *count = [NSString stringWithFormat:@"%d",countFood];
        _counttf.text = count;
        
        
        _foodLable.text = [info objectForKey:@"des"];
        NSString *priceStr = [NSString stringWithFormat:@"￥%@元/%@",[info objectForKey:@"price3"],@"套"];
        NSString *priceStrApp = [NSString stringWithFormat:@"￥%@元/%@",[info objectForKey:@"price2"],@"套"];
        
//        文字自适配
        UIFont *sizefont=[UIFont fontWithName:@"Arial" size:10.0];
        CGSize size=CGSizeMake(ScreenWidth, 2000);
        CGSize labelSize=[priceStr sizeWithFont:sizefont constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        _priceLable.frame=CGRectMake(80, 30, labelSize.width, labelSize.height);
        _priceLable.font=sizefont;
        _priceLable.text = priceStr;
        
        
        _lineView.frame=CGRectMake(80, 36, labelSize.width, 1);
        if([info objectForKey:@"price3"]==nil || [[info objectForKey:@"price3"]isEqualToString:[info objectForKey:@"price2"]])
        {
            [_lineView removeFromSuperview];
            [_priceLable removeFromSuperview];
        }
    
        
       
        labelSize=[priceStrApp sizeWithFont:sizefont constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        _priceLableApp.frame=CGRectMake(80, 50, labelSize.width, labelSize.height);
        _priceLableApp.font=sizefont;
        _priceLableApp.text=priceStrApp;
        
        
        _numberLable.text = [info objectForKey:@"pitcode"];
        [recommendImage setImage:[UIImage imageNamed:@"defaultFood.png"]];
        [self setImagepicsrc:info];
//          [NSThread detachNewThreadSelector:@selector(setImagepicsrc:) toTarget:self withObject:info];
        

        //初始化点击图片的按钮
        _butImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _butImage.backgroundColor = [UIColor clearColor];
        _butImage.frame = CGRectMake(5, 5, 70, 60);
        [self.contentView addSubview:_butImage];
        [_butImage addTarget:self action:@selector(packageClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        DataProvider *db = [DataProvider sharedInstance];
        NSMutableArray *aryOrder = [db orderedFood];
        int countFood = 0;
        for (NSMutableDictionary *dicOrder in aryOrder) {
            if ([[dicOrder objectForKey:@"id"] isEqualToString:[info objectForKey:@"id"]] | [[dicOrder objectForKey:@"pubitem"] isEqualToString:[info objectForKey:@"pubitem"]]) {
                countFood = countFood + [[dicOrder objectForKey:@"total"] intValue];
            }
        }
        if (countFood > 0) {
            _minusBut.hidden = NO;
            _countBut.hidden = NO;
        }else{
            _countBut.hidden = YES;
            _minusBut.hidden = YES;
        }
        
        
        NSString *count = [NSString stringWithFormat:@"%d",countFood];
        _counttf.text = count;
        _foodLable.text = [info objectForKey:@"pdes"];
        NSString *priceStr = [NSString stringWithFormat:@"￥%@元/%@",[info objectForKey:@"price3"],[info objectForKey:@"unit"]];
        NSString *priceStrApp = [NSString stringWithFormat:@"￥%@元/%@",[info objectForKey:@"price2"],[info objectForKey:@"unit"]];
        //        文字自适配
        UIFont *sizefont=[UIFont fontWithName:@"Arial" size:10.0];
        CGSize size=CGSizeMake(ScreenWidth, 2000);
        CGSize labelSize=[priceStr sizeWithFont:sizefont constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        _priceLable.frame=CGRectMake(80, 30, labelSize.width, labelSize.height);
        _priceLable.font=sizefont;
        _priceLable.text = priceStr;
        
        
        _lineView.frame=CGRectMake(80, 36, labelSize.width, 1);
        if([info objectForKey:@"price3"]==nil || [[info objectForKey:@"price3"]isEqualToString:[info objectForKey:@"price2"]])
        {
            [_lineView removeFromSuperview];
            [_priceLable removeFromSuperview];
        }
        
        
        
        labelSize=[priceStrApp sizeWithFont:sizefont constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
        _priceLableApp.frame=CGRectMake(80, 50, labelSize.width, labelSize.height);
        _priceLableApp.font=sizefont;
        _priceLableApp.text=priceStrApp;

        _numberLable.text = [info objectForKey:@"pitcode"];
        [recommendImage setImage:[UIImage imageNamed:@"defaultFood.png"]];
        [self setSmallImage:info];
//        [NSThread detachNewThreadSelector:@selector(setSmallImage:) toTarget:self withObject:info];

        
        //初始化点击图片的按钮
        _butImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _butImage.backgroundColor = [UIColor clearColor];
        _butImage.frame = CGRectMake(5, 5, 70, 60);
        [self.contentView addSubview:_butImage];
        [_butImage addTarget:self action:@selector(FoodClick) forControlEvents:UIControlEventTouchUpInside];
    }
}


-(void)setSmallImage:(NSDictionary *)info
{
    NSString *url=[NSString stringWithFormat:@"%@%@",[[DataProvider getIpPlist]objectForKey:@"foodPic"],[info objectForKey:@"smallUrl"]];
    
    
    if([DataProvider imageCache:url])
    {
        [recommendImage setImage:[UIImage imageWithData:[DataProvider imageCache:url]]];
    }
    else
    {
         [recommendImage setImageURL:url andImageBoundName:@"defaultFood.png"];
    }

}

-(void)setImagepicsrc:(NSDictionary *)info
{
     NSString *url=[NSString stringWithFormat:@"%@%@",[[DataProvider getIpPlist]objectForKey:@"foodPic"],[info objectForKey:@"picsrc"]];
    if([DataProvider imageCache:url])
    {
        [recommendImage setImage:[UIImage imageWithData:[DataProvider imageCache:url]]];
    }
    else
    {
        [recommendImage setImageURL:[NSURL URLWithString:url] andImageBoundName:@"defaultFood.png"];
    }
}

#pragma mark -- Actions

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDicInfo:(NSDictionary *)dic{

    if (_dicInfo!=dic){
        [_dicInfo release];
        _dicInfo = [[NSMutableDictionary dictionaryWithDictionary:dic] retain];
    }
    if (dic){
        [self showInfo:dic];
    }
}

//点击套餐图片
-(void)packageClick{
    cellImageClick(self.dicInfo);
}
//点击菜品图片
-(void)FoodClick{
    FoodView *foodView = [FoodView FoodViewWithInfo:self.dicInfo];
    [foodView show];
}


//加号事件
-(void)plusClick{
    [self addFood:self.dicInfo byCount:@"1"];
}
//减号事件
-(void)minusClick{
    [self minusFood:self.dicInfo];
}

- (void)addFood:(NSMutableDictionary *)foodInfo byCount:(NSString *)count{
    
    DataProvider *dp = [DataProvider sharedInstance];
    NSMutableArray *ary = [dp orderedFood];
    
    BOOL bFinded = NO;
    for (NSDictionary *food in ary){
        if ([[food objectForKey:@"id"] isEqualToString:[foodInfo objectForKey:@"id"]] |[[food objectForKey:@"pubitem"] isEqualToString:[foodInfo objectForKey:@"pubitem"]]){
            bFinded = YES;
            int total = [[food objectForKey:@"total"] intValue];
            total += [count floatValue];
            
            if (total>0){
                NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:food];
                [mut setObject:[NSString stringWithFormat:@"%d",total] forKey:@"total"];
                [ary replaceObjectAtIndex:[ary indexOfObject:food] withObject:mut];
            }else
                [ary removeObject:food];
            
            [dp saveOrders];
            break;
        }
    }
    
    if (!bFinded && [count floatValue]>0){
        [foodInfo setValue:count forKey:@"total"];
        [ary addObject:foodInfo];
        [dp saveOrders];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBookTableNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHotTableNotification" object:nil];
    
}

-(void)minusFood:(NSMutableDictionary *)foodInfo{
    DataProvider *dp = [DataProvider sharedInstance];
    NSMutableArray *ary = [dp orderedFood];
//    int total2 = 0;
    BOOL bFinded = NO;
    for (NSDictionary *food in ary){
       if ([[food objectForKey:@"id"] isEqualToString:[foodInfo objectForKey:@"id"]] |[[food objectForKey:@"pubitem"] isEqualToString:[foodInfo objectForKey:@"pubitem"]]){
            bFinded = YES;
            int total = [[food objectForKey:@"total"] intValue];
            
            if (total>1){
                NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:food];
                [mut setObject:[NSString stringWithFormat:@"%d",total-1] forKey:@"total"];
                [ary replaceObjectAtIndex:[ary indexOfObject:food] withObject:mut];
            }else
                [ary removeObject:food];
            
            [dp saveOrders];
            break;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBookTableNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHotTableNotification" object:nil];
}


- (void)changeFood:(NSMutableDictionary *)foodInfo byCount:(NSString *)count{
    
    DataProvider *dp = [DataProvider sharedInstance];
    NSMutableArray *ary = [dp orderedFood];
    
    BOOL bFinded = NO;
    for (NSDictionary *food in ary){
        if ([[food objectForKey:@"id"] isEqualToString:[foodInfo objectForKey:@"id"]] |[[food objectForKey:@"pubitem"] isEqualToString:[foodInfo objectForKey:@"pubitem"]]){
            bFinded = YES;
            int total= [count floatValue];
            
            if (total>0){
                NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:food];
                [mut setObject:[NSString stringWithFormat:@"%d",total] forKey:@"total"];
                [ary replaceObjectAtIndex:[ary indexOfObject:food] withObject:mut];
            }else
                [ary removeObject:food];
            
            [dp saveOrders];
            break;
        }
    }
    
    if (!bFinded && [count floatValue]>0){
        [foodInfo setValue:count forKey:@"total"];
        [ary addObject:foodInfo];
        [dp saveOrders];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBookTableNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHotTableNotification" object:nil];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_counttf resignFirstResponder];
    [self changeFood:self.dicInfo byCount:_counttf.text];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)dealloc
{
    [recommendImage release];
    [_foodLable release];
    [_priceLable release];
    [_priceLableApp release];
    [_lineView release];
    [_numberLable release];
    [_amountLable release];
    [_counttf release];
    [super dealloc];
}


@end
