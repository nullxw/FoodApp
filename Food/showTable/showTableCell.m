//
//  showTableCell.m
//  Food
//
//  Created by sundaoran on 14-4-2.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//


#import "showTableCell.h"
#import "selectTableViewController.h"

@implementation showTableCell
{
    CVLocalizationSetting *langSetting;
    StoreMessage *_stroe;
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
    _stroe=storeMessage;
    CGFloat fontSize=12.0;
    
    CGFloat height=0;
    
//    台位类型
    UILabel *lbltableTyp=[[UILabel alloc]initWithFrame:CGRectMake(5, 0,self.contentView.frame.size.width/2-5 , 25)];
    lbltableTyp.text=[langSetting localizedString:@"Table type"];
    lbltableTyp.textAlignment=NSTextAlignmentCenter;
    lbltableTyp.textColor=[UIColor whiteColor];
    lbltableTyp.font=[UIFont systemFontOfSize:fontSize];
    lbltableTyp.backgroundColor=selfbackgroundColor;
    [self.contentView addSubview:lbltableTyp];
    
//    空闲台位
    UILabel *lbltableHave=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/2, 0,self.contentView.frame.size.width/2 , 25)];
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
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0, i*25+25, view.frame.size.width/2, 25)];
        lbl.backgroundColor=[UIColor clearColor];
        lbl.textAlignment=NSTextAlignmentCenter;
        lbl.font=[UIFont systemFontOfSize:fontSize];
        [view addSubview:lbl];
        
        UILabel *lblNum=[[UILabel alloc]initWithFrame:CGRectMake(view.frame.size.width/2-5,i*25+25 , view.frame.size.width/2-5, 25)];
        lblNum.backgroundColor=[UIColor clearColor];
        lblNum.textAlignment=NSTextAlignmentCenter;
        lblNum.font=[UIFont systemFontOfSize:fontSize];
        lblNum.textColor=[UIColor redColor];
        [view addSubview:lblNum];
        
        UIImageView *lineImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Public_shopLine.png"]];
        lineImage.frame=CGRectMake(0, i*25+50, view.frame.size.width, 1);
        [view addSubview:lineImage];
        //判断是否有包间
        if([storeMessage.storeRoomArray count]>0 && i==index-1)
        {
            lbl.text=[langSetting localizedString:@"rooms"];
            lblNum.text=[NSString stringWithFormat:@"%d",[storeMessage.storeRoomArray count]];
        }
        else
        {
            
            
            NSString *index=@"";
            if([[[storeMessage.storeTableArray objectAtIndex:i]objectForKey:@"mustselfood"]isEqualToString:@"Y"])
            {
                index=@"(必点菜)";
            }
            NSMutableAttributedString *tableName=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@人桌 %@", [[storeMessage.storeTableArray objectAtIndex:i]objectForKey:@"tablePax"],index]];
            NSString *name=[NSString stringWithFormat:@"%@",tableName];
            NSRange range=[name rangeOfString:index];
            [tableName addAttribute:NSForegroundColorAttributeName value:selfbackgroundColor range:range];
            [tableName addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
            lbl.attributedText=tableName;

            lblNum.text=[[storeMessage.storeTableArray objectAtIndex:i]objectForKey:@"tableNum"];
            
        }
        
        height=lineImage.frame.origin.y;
    }
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor whiteColor]];
    nextButton.frame=CGRectMake(180, height+5, 100, 30);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
    nextButton.layer.cornerRadius=5.0;
    nextButton.tag=104;
    [nextButton  addTarget:self action:@selector(changeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *netlbl=[[UILabel alloc]init];
    netlbl.frame=CGRectMake(0, 0, nextButton.frame.size.width, nextButton.frame.size.height);
    [netlbl setText:[langSetting localizedString:@"Next step"]];
    netlbl.textAlignment=NSTextAlignmentCenter;
    netlbl.backgroundColor=[UIColor clearColor];
    netlbl.font=[UIFont systemFontOfSize:13];
    [netlbl setTextColor:[UIColor whiteColor]];
    [nextButton addSubview:netlbl];
    

    [self.contentView addSubview:view];
    [self.contentView addSubview:nextButton];
}

-(void)changeButtonClick
{
    
    //此处传的不是字典，是storeMessage对象
    //将选择的门店信息复制给单利
    
    DataProvider *dp =  [DataProvider sharedInstance];
    dp.storeMessage=_stroe;
    
    //    将是被开始结束时间赋值给单利
    if([dp.selectCanCi isEqualToString:@"午餐"])
    {
        dp.StartTime=_stroe.lunchstart;
        dp.EndTime=_stroe.lunchendtime;
    }
    else
    {
        dp.StartTime=_stroe.dinnerstart;
        dp.EndTime=_stroe.dinnerendtime;
    }
    
    NSLog(@"%@",dp.selectTime);
    if([DataProvider compareNowTime:[NSString stringWithFormat:@"%@ %@",dp.selectTime,dp.EndTime]])
    {
            selectTableViewController *selectTable=[[selectTableViewController alloc]initWithMessageDict:_stroe];
            [self.viewController.navigationController pushViewController:selectTable animated:YES];
    }
    else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"Prompt"] message:@"您选择的门店\n最晚可预点时间早于当前时间\n请选择其他门店\n或重新选择餐次" delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
            [alert show];
        });
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
