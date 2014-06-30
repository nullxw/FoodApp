//
//  navigationBarView.m
//  Food
//
//  Created by sundaoran on 14-3-31.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "navigationBarView.h"


@implementation navigationBarView
{
    CGFloat  VIEWHEIGHT ;
    CVLocalizationSetting *langSetting;
}

@synthesize delegate=_delegate;

@synthesize isChange=_isChange;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)rightTitle

{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        langSetting =[CVLocalizationSetting sharedInstance];
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
        if([DataProvider sharedInstance].isClearColor)
        {
            imageView.backgroundColor=[UIColor clearColor];
        }
        else
        {
            imageView.backgroundColor=selfbackgroundColor;
        }
        imageView.userInteractionEnabled=YES;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0)
        {
            VIEWHEIGHT=64;
        }
        else
        {
            VIEWHEIGHT=44;
        }
        imageView.frame=CGRectMake(0,0, frame.size.width, VIEWHEIGHT);
        [self addSubview:imageView];
        
        if(rightTitle!=nil)
        {
            UILabel *lbltitle=[[UILabel alloc]initWithFrame:CGRectMake(0,VIEWHEIGHT-44, self.frame.size.width-20, 44)];
            lbltitle.text=rightTitle;
            lbltitle.backgroundColor=[UIColor clearColor];
            lbltitle.textColor=[UIColor whiteColor];
            lbltitle.textAlignment=NSTextAlignmentRight;
            [imageView addSubview:lbltitle];
        }
        
        UIImageView *image=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Public_back.png"]];
        image.frame=CGRectMake(0,7 , 30, 30);
        
        UILabel *lblBack=[[UILabel alloc]initWithFrame:CGRectMake(30,0, 44, 44)];
        lblBack.text=[langSetting localizedString:@"Back"];
        lblBack.backgroundColor=[UIColor clearColor];
        lblBack.textColor=[UIColor whiteColor];
        lblBack.textAlignment=NSTextAlignmentRight;
        
        UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
        //74
        backButton.frame=CGRectMake(10,VIEWHEIGHT-44 , 94, 44);
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        [backButton addSubview:image];
        [backButton addSubview:lblBack];
        
        [imageView addSubview:backButton];
        
    }
    return self;
}

-(void)back
{
    [DataProvider sharedInstance].isClearColor=NO;
    [_delegate navigationBarViewbackClick];
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
