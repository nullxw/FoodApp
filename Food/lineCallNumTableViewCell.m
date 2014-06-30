//
//  lineCallNumTableViewCell.m
//  Food
//
//  Created by sundaoran on 14-5-15.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "lineCallNumTableViewCell.h"

@implementation lineCallNumTableViewCell
{
    NSDictionary    *_storeDict;
    CVLocalizationSetting *langSetting;
    
    UILabel *lblstoreName;
    UILabel *lbllineNum;
}

//叫号成功后刷新当前界面设置门的店数据
-(void)setInfoDict:(NSDictionary *)dict
{
    _storeDict=[[NSDictionary alloc]initWithDictionary:dict];
    lblstoreName.text=[dict objectForKey:@"firmdes"];
    NSString *subStr=[NSString stringWithFormat:[langSetting localizedString:@"Total number of table %@"],[dict objectForKey:@"num"]];
    int lengthAfter = [[[subStr componentsSeparatedByString:[dict objectForKey:@"num"]]firstObject]length];
    int lengthBefor=[[[subStr componentsSeparatedByString:[dict objectForKey:@"num"]]lastObject]length];
    NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:subStr];
    [str addAttribute:NSForegroundColorAttributeName value:selfbackgroundColor range:NSMakeRange(lengthAfter,[str length]-lengthAfter-lengthBefor)];
    lbllineNum.attributedText=str;

    
}

//初始化cell包含门店数据
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andStoreMessage:(NSDictionary   *)dict
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        langSetting =[CVLocalizationSetting sharedInstance];
        _storeDict=[[NSDictionary alloc]initWithDictionary:dict];
        CGFloat fontSize=12.0;
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 70)];
        view.backgroundColor=[UIColor clearColor];
        
        lblstoreName=[[UILabel alloc]init];
        lblstoreName.frame=CGRectMake(20, 0,  view.frame.size.width/2-20, view.frame.size.height);
        lblstoreName.textAlignment=NSTextAlignmentLeft;
        lblstoreName.text=[dict objectForKey:@"firmdes"];
        lblstoreName.font=[UIFont systemFontOfSize:fontSize+4];
        lblstoreName.numberOfLines=2;
        lblstoreName.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:lblstoreName];
        
        
        lbllineNum=[[UILabel alloc]init];
        lbllineNum.frame=CGRectMake(lblstoreName.frame.origin.x+lblstoreName.frame.size.width, 5,  view.frame.size.width/2-20, 30);
        lbllineNum.textAlignment=NSTextAlignmentCenter;
        NSString *subStr=[NSString stringWithFormat:[langSetting localizedString:@"Total number of table %@"],[dict objectForKey:@"num"]];
        int lengthAfter = [[[subStr componentsSeparatedByString:[dict objectForKey:@"num"]]firstObject]length];
        int lengthBefor=[[[subStr componentsSeparatedByString:[dict objectForKey:@"num"]]lastObject]length];
        NSMutableAttributedString *str=[[NSMutableAttributedString alloc]initWithString:subStr];
        [str addAttribute:NSForegroundColorAttributeName value:selfbackgroundColor range:NSMakeRange(lengthAfter,[str length]-lengthAfter-lengthBefor)];
        lbllineNum.attributedText=str;
        lbllineNum.font=[UIFont systemFontOfSize:fontSize];
        lbllineNum.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:lbllineNum];
        
        UIButton  *btnSelect=[UIButton buttonWithType:UIButtonTypeCustom];
        btnSelect.frame=CGRectMake(lblstoreName.frame.origin.x+lblstoreName.frame.size.width+10, lbllineNum.frame.size.height, view.frame.size.width/2-40, 30);
        btnSelect.backgroundColor=selfbackgroundColor;
        [btnSelect addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [btnSelect setTitle:[langSetting localizedString:@"Take number"] forState:UIControlStateNormal];
        btnSelect.layer.cornerRadius=5;
        btnSelect.titleLabel.font=[UIFont systemFontOfSize:fontSize+2];
        
        [self.contentView addSubview:btnSelect];
        
    }
    return self;
}
-(void)buttonClick
{
    selectTableTypeViewController *select=[[selectTableTypeViewController alloc]init];
    [select setStoreDict:_storeDict];
//    获取当前cell的父视图的viewController
    [self.viewController.navigationController pushViewController:select animated:YES];
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
