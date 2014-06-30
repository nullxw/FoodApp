//
//  queneSuccessView.m
//  Food
//
//  Created by sundaoran on 14-5-22.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "queneSuccessView.h"
#import "AppDelegate.h"

@implementation queneSuccessView
{
    CVLocalizationSetting *langSetting;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        
        langSetting=[CVLocalizationSetting sharedInstance];
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        
        UIView *viewBg = [[UIView alloc] init];
        viewBg.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        viewBg.backgroundColor = kblackColor;
        viewBg.alpha = 0.4;
        [self addSubview:viewBg];
        
        UIView *v = [[UIView alloc] init];
        float padding = 20;
        v.frame = CGRectMake(padding, 100+padding, ScreenWidth-padding*2, 568-250-padding*2);
        v.backgroundColor = [UIColor whiteColor];
        [v.layer setCornerRadius:10.0];
        [v.layer setMasksToBounds:YES];
        v.clipsToBounds = YES;
        [self addSubview:v];
        
        
        UILabel *lblTitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, v.frame.size.width, 30)];
        lblTitle.text=[NSString stringWithFormat:@"%@:",[langSetting localizedString:@"Your line number"]];
        lblTitle.textAlignment=NSTextAlignmentCenter;
        lblTitle.font=[UIFont systemFontOfSize:17];
        lblTitle.textColor=selfbackgroundColor;
        lblTitle.backgroundColor=[UIColor clearColor];
        [v addSubview:lblTitle];
        
        UILabel *lblNum=[[UILabel alloc]initWithFrame:CGRectMake(0, lblTitle.frame.size.height, v.frame.size.width, 40)];
        lblNum.text=[info objectForKey:@"getNo"];
        lblNum.textAlignment=NSTextAlignmentCenter;
        lblNum.font=[UIFont systemFontOfSize:17];
        lblNum.textColor=selfbackgroundColor;
        lblNum.backgroundColor=[UIColor clearColor];
        [v addSubview:lblNum];
        
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(5, lblNum.frame.origin.y+lblNum.frame.size.height, v.frame.size.width-10, v.frame.size.height-(lblNum.frame.origin.y+lblNum.frame.size.height))];
//        lbl.text
        NSString *str =[NSString stringWithFormat:@"%@:%@%@\n%@:%@~%d%@\n%@\n%@\n%@:%@",[langSetting localizedString:@"Before you have"],[info objectForKey:@"count"],[langSetting localizedString:@"tables"],[langSetting localizedString:@"Your choice is"],[info objectForKey:@"pax"],[[info objectForKey:@"pax"]integerValue]+3,[langSetting localizedString:@"people"],[info objectForKey:@"date"],[langSetting localizedString:@"Take number information please go to the APP page under'my allelic'queries in!"],[langSetting localizedString:@"Helpful hints"],[langSetting localizedString:@"No invalid number, according to your delay after 2 table arrangement, please forgive me!"]];

        

        lbl.textAlignment=NSTextAlignmentCenter;
        UIFont *font=[UIFont systemFontOfSize:17];
        lbl.font=font;
        lbl.textColor=[UIColor blackColor];
        lbl.numberOfLines=0;
        lbl.text=str;
        CGSize constraint = CGSizeMake(v.frame.size.width-10, 20000.0f);
        
        CGSize size = [str sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        [lbl setFrame:CGRectMake(5, lblNum.frame.origin.y+lblNum.frame.size.height, size.width, size.height+10)];
          [v addSubview:lbl];
        
        
        UIButton *btncancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btncancel.frame = CGRectMake(20, lbl.frame.origin.y+lbl.frame.size.height+10,v.frame.size.width-40, 30);
        [btncancel setTitle:[langSetting localizedString:@"OK"] forState:UIControlStateNormal];
        [btncancel setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonNomal.png"] forState:UIControlStateNormal];
        [btncancel setBackgroundImage:[UIImage imageNamed:@"Public_nextButtonSelect.png"] forState:UIControlStateHighlighted];
        [btncancel addTarget:self action:@selector(dismissAdditions) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:btncancel];

        
        v.frame = CGRectMake(padding, 100+padding, ScreenWidth-padding*2, lblTitle.frame.size.height+lblNum.frame.size.height+lbl.frame.size.height+btncancel.frame.size.height+30);
        
    }
    return self;
}

- (void)show{
    self.alpha = 0;
    UIWindow *w = (UIWindow *)[(AppDelegate *)[UIApplication sharedApplication].delegate window];
    [w addSubview:self];
    
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismissAdditions{
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showAlertView" object:nil];
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
