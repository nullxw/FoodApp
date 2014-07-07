//
//  FavorableCell.m
//  Food
//
//  Created by dcw on 14-5-4.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "FavorableCell.h"
#import "WebImageView.h"

@implementation FavorableCell
@synthesize imgTop;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _init];
    }
    return self;
}

//初始化
-(void)_init{
    UIView *v = [[UIView alloc] init];
    v.frame = CGRectMake(5, 3, ScreenWidth-10, 80);
    v.backgroundColor = [UIColor whiteColor];
//    [v.layer setCornerRadius:10.0];
//    [v.layer setMasksToBounds:YES];
//    v.clipsToBounds = YES;
    [self addSubview:v];
    
    imgTop = [[WebImageView alloc] init];
    imgTop.frame = CGRectMake(0, 0, 100, 80);
    [imgTop setImage:[UIImage imageNamed:@"yhxxx.png"]];

    imgTop.backgroundColor = [UIColor clearColor];
    [v addSubview:imgTop];
    
    lblName = [[UILabel alloc] init];
    lblName.frame = CGRectMake(110, 5, ScreenWidth-130, 80);
    lblName.font = [UIFont systemFontOfSize:18.0f];
    lblName.backgroundColor = [UIColor clearColor];
    lblName.numberOfLines = 3;
    lblName.textColor = [UIColor redColor];
    [v addSubview:lblName];
    
}

- (void)setDicInfo:(NSDictionary *)dic{
    
    if (_dicInfo!=dic){
        _dicInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
    }
    if (dic){
        [self showInfo:dic];
    }
}

- (void)showInfo:(NSDictionary *)info{
    [self setImagewurl:info];
//     [NSThread detachNewThreadSelector:@selector(setImage:) toTarget:self withObject:info];
    lblName.text = [info objectForKey:@"title"];
}

-(void)setImagewurl:(NSDictionary *)info
{
    if([DataProvider imageCache:[info objectForKey:@"wurl"]])
    {
        [imgTop setImage:[UIImage imageWithData:[DataProvider imageCache:[info objectForKey:@"wurl"]]]];
    }
    else
    {
        [imgTop setImageURL:[NSURL URLWithString:[info objectForKey:@"wurl"]] andImageBoundName:@"yhxxx.png"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
