//
//  hotCell.m
//  Food
//
//  Created by dcw on 14-4-18.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "hotCell.h"
#import "WebImageView.h"
#import "PackageViewController.h"
#import "FoodView.h"

@implementation hotCell

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
    _recommendImage = [[WebImageView alloc] initWithFrame:CGRectZero];
    _recommendImage.backgroundColor = [UIColor clearColor];
    _recommendImage.frame = CGRectMake(5, 5, 70, 60);
    [self.contentView addSubview:_recommendImage];
    
    _foodLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _foodLable.frame = CGRectMake(90, 5, ScreenWidth-70, 30);
    _foodLable.backgroundColor = [UIColor clearColor];
    _foodLable.numberOfLines = 3;
    _foodLable.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_foodLable];
    
    
    
    //App价格
    _priceLableApp = [[RTLabel alloc] initWithFrame:CGRectZero];
    _priceLableApp.frame = CGRectMake(90, 30, 70, 18);
    _priceLableApp.backgroundColor = [UIColor clearColor];
    _priceLableApp.textColor = [UIColor grayColor];
    _priceLableApp.font = [UIFont systemFontOfSize:10.0];
    [self.contentView addSubview:_priceLableApp];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(80, 36, 60, 1)];
    lineView.backgroundColor=[UIColor grayColor];
    [self.contentView addSubview:lineView];
    
    _priceLable = [[RTLabel alloc] initWithFrame:CGRectZero];
    _priceLable.frame = CGRectMake(90, 50, 80, 20);
    _priceLable.backgroundColor = [UIColor clearColor];
    _priceLable.textColor = [UIColor redColor];
    _priceLable.font = [UIFont systemFontOfSize:10.0];
    [self.contentView addSubview:_priceLable];
    
    _plusBut = [[UIButton alloc] initWithFrame:CGRectZero];
    _plusBut.backgroundColor = [UIColor clearColor];
    [_plusBut setBackgroundImage:[UIImage imageNamed:@"Order_plus.png"] forState:UIControlStateNormal];
    [_plusBut addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    _plusBut.frame = CGRectMake(ScreenWidth-30, 40, 28, 28);
    [self.contentView addSubview:_plusBut];
    
    _countBut = [[UIButton alloc] initWithFrame:CGRectZero];
    _countBut.backgroundColor = [UIColor clearColor];
    [_countBut setBackgroundImage:[UIImage imageNamed:@"Order_Num.png"] forState:UIControlStateNormal];
    _countBut.frame = CGRectMake(ScreenWidth-27*2, 43, 23, 23);
    [self.contentView addSubview:_countBut];
    
    _tfcount = [[UITextField alloc] initWithFrame:CGRectZero];
    _tfcount.frame = CGRectMake(0, 0, 23, 23);
    _tfcount.textColor = [UIColor blackColor];
    _tfcount.font = [UIFont systemFontOfSize:11.0];
    _tfcount.backgroundColor = [UIColor clearColor];
    _tfcount.keyboardType=UIKeyboardTypeNumberPad;
    _tfcount.textAlignment = NSTextAlignmentCenter;
    _tfcount.delegate=self;
    [_countBut addSubview:_tfcount];
    
    _minusBut = [[UIButton alloc] initWithFrame:CGRectZero];
    _minusBut.backgroundColor = [UIColor clearColor];
    [_minusBut setBackgroundImage:[UIImage imageNamed:@"Order_minus.png"] forState:UIControlStateNormal];
    [_minusBut addTarget:self action:@selector(minusClick) forControlEvents:UIControlEventTouchUpInside];
    _minusBut.frame = CGRectMake(ScreenWidth-28*3, 40, 28, 28);
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
        _tfcount.text = count;
        
        _foodLable.text = [info objectForKey:@"des"];
        NSString *priceStr = [NSString stringWithFormat:@"￥%@元/%@",[info objectForKey:@"price"],@"套"];
        _priceLable.text = priceStr;
        _priceLableApp.text = priceStr;
        _numberLable.text = [info objectForKey:@"pitcode"];
        [_recommendImage setImage:[UIImage imageNamed:@"defaultFood.png"]];
        [self setImagegrpStr:info];
//         [NSThread detachNewThreadSelector:@selector(setImage:) toTarget:self withObject:info];
        
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
        _tfcount.text = count;
        _foodLable.text = [info objectForKey:@"pdes"];
        NSString *priceStr = [NSString stringWithFormat:@"￥%@元/%@",[info objectForKey:@"price"],[info objectForKey:@"unit"]];
        _priceLable.text = priceStr;
        _priceLableApp.text = priceStr;
        _numberLable.text = [info objectForKey:@"pitcode"];
        [_recommendImage setImage:[UIImage imageNamed:@"defaultFood.png"]];
        [self setSmallImage:info];
//        [NSThread detachNewThreadSelector:@selector(setSmallImage:) toTarget:self withObject:info];
//        [_recommendImage setImageURL:[NSURL URLWithString:[info objectForKey:@"smallUrl"]]];
        
        //初始化点击图片的按钮
        _butImage = [UIButton buttonWithType:UIButtonTypeCustom];
        _butImage.backgroundColor = [UIColor clearColor];
        _butImage.frame = CGRectMake(5, 5, 70, 60);
        [self.contentView addSubview:_butImage];
        [_butImage addTarget:self action:@selector(FoodClick) forControlEvents:UIControlEventTouchUpInside];
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
        _dicInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    if (dic){
        [self showInfo:dic];
    }
}

//点击套餐图片
-(void)packageClick{
    PackageViewController *pack = [[PackageViewController alloc] init];
//    pack.dicInfo = self.dicInfo;
    [pack setDicInfo:self.dicInfo];
    [self.viewController.navigationController pushViewController:pack animated:YES];
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
    //刷新菜單和热门菜品
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBookTableNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHotTableNotification" object:nil];
    
}

-(void)minusFood:(NSMutableDictionary *)foodInfo{
    DataProvider *dp = [DataProvider sharedInstance];
    NSMutableArray *ary = [dp orderedFood];
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
    //刷新菜單和热门菜品
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



//缓存文件处理
-(void)setSmallImage:(NSDictionary *)info
{
    if([DataProvider imageCache:[info objectForKey:@"smallUrl"]])
    {
        [_recommendImage setImage:[UIImage imageWithData:[DataProvider imageCache:[info objectForKey:@"smallUrl"]]]];
    }
    else
    {
        [_recommendImage setImageURL:[NSURL URLWithString:[info objectForKey:@"smallUrl"]]];
    }
    
}

-(void)setImagegrpStr:(NSDictionary *)info
{
    if([DataProvider imageCache:[info objectForKey:@"grpStr"]])
    {
        [_recommendImage setImage:[UIImage imageWithData:[DataProvider imageCache:[info objectForKey:@"grpStr"]]]];
    }
    else
    {
        [_recommendImage setImageURL:[NSURL URLWithString:[info objectForKey:@"grpStr"]]];
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tfcount resignFirstResponder];
    [self changeFood:self.dicInfo byCount:_tfcount.text];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

@end
