//
//  showTableCell.m
//  Food
//
//  Created by sundaoran on 14-4-2.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//


#import "showTableCell.h"


@implementation showTableCell
{
    CVLocalizationSetting *langSetting;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        langSetting=[CVLocalizationSetting sharedInstance];
        
    }
    return self;
}
-(void)setMessageByDict:(StoreMessage *)storeMessage
{
    CGFloat fontSize=12.0;
    
//    门店名称
    UILabel *lblstoreName=[[UILabel alloc]initWithFrame:CGRectMake(10, 0,self.contentView.frame.size.width-10 , 25)];
    lblstoreName.text=storeMessage.storeFirmdes;
    lblstoreName.textAlignment=NSTextAlignmentLeft;
    lblstoreName.textColor=[UIColor blackColor];
    lblstoreName.font=[UIFont systemFontOfSize:fontSize];
    [self.contentView addSubview:lblstoreName];
    
    
//    台位类型
    UILabel *lbltableTyp=[[UILabel alloc]initWithFrame:CGRectMake(10, 25,self.contentView.frame.size.width/2-10 , 25)];
    lbltableTyp.text=[langSetting localizedString:@"Table type"];
    lbltableTyp.textAlignment=NSTextAlignmentCenter;
    lbltableTyp.textColor=[UIColor whiteColor];
    lbltableTyp.font=[UIFont systemFontOfSize:fontSize];
    lbltableTyp.backgroundColor=selfbackgroundColor;
    [self.contentView addSubview:lbltableTyp];
    
//    空闲台位
    UILabel *lbltableHave=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/2, 25,self.contentView.frame.size.width/2 , 25)];
    lbltableHave.text=[langSetting localizedString:@"The free table"];
    lbltableHave.textColor=[UIColor whiteColor];
    lbltableHave.font=[UIFont systemFontOfSize:fontSize];
    lbltableHave.textAlignment=NSTextAlignmentCenter;
    lbltableHave.backgroundColor=selfbackgroundColor;
    [self.contentView addSubview:lbltableHave];
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, 0, self.contentView.frame.size.width-10, self.contentView.frame.size.height)];
    view.backgroundColor=[UIColor clearColor];
    int index=0;
    if([storeMessage.storeRoomArray count]>0)
    {
        index=[storeMessage.storeTableArray count]+1;
    }
    else
    {
        index=[storeMessage.storeTableArray count];
    }
    for (int i=0; i<index; i++)
    {
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, i*25+50, view.frame.size.width/2, 25)];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.font=[UIFont systemFontOfSize:fontSize];
        [view addSubview:lbl];
        
        UILabel *lblNum=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2,i*25+50 , view.frame.size.width/2, 25)];
        lblNum.backgroundColor=[UIColor clearColor];
        lblNum.textAlignment=NSTextAlignmentCenter;
        lblNum.font=[UIFont systemFontOfSize:fontSize];
        lblNum.textColor=[UIColor redColor];
        [view addSubview:lblNum];
        
        UIImageView *lineImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Public_shopLine.png"]];
        lineImage.frame=CGRectMake(0, i*25+75, view.frame.size.width, 1);
        [view addSubview:lineImage];
        //判断是否有包间
        if([storeMessage.storeRoomArray count]>0 && i==index-1)
        {
            lbl.text=[langSetting localizedString:@"rooms"];
            lblNum.text=[NSString stringWithFormat:@"%d",[storeMessage.storeRoomArray count]];
        }
        else
        {
            lbl.text=[NSString stringWithFormat:[langSetting localizedString:@"Table for %@"],[[storeMessage.storeTableArray objectAtIndex:i]objectForKey:@"tablePax"]];
            lblNum.text=[[storeMessage.storeTableArray objectAtIndex:i]objectForKey:@"tableNum"];
        }

    }
    [self.contentView addSubview:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
