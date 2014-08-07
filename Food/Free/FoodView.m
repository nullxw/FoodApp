//
//  FoodView.m
//  Food
//
//  Created by dcw on 14-4-30.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "FoodView.h"
#import "AppDelegate.h"

@implementation FoodView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (FoodView *)FoodViewWithInfo:(NSDictionary *)info{
    FoodView *foodView = [[FoodView alloc] initWithInfo:info];
    return foodView;
}

-(id)initWithInfo:(NSDictionary *)info{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        
        UIView *viewBg = [[UIView alloc] init];
        viewBg.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        viewBg.backgroundColor = kblackColor;
        viewBg.alpha = 0.5;
        [self addSubview:viewBg];
        
        UIView *v = [[UIView alloc] init];
        float padding = 20;
        v.frame = CGRectMake(padding, 100+padding, ScreenWidth-padding*2, ScreenHeight-180-padding*2);
        v.backgroundColor = [UIColor whiteColor];
        [v.layer setCornerRadius:10.0];
        [v.layer setMasksToBounds:YES];
        v.clipsToBounds = YES;
        [self addSubview:v];
        
        webImg = [[WebImageView alloc] init];
        webImg.frame = CGRectMake(15, 15, v.frame.size.width-30, 150);
        [webImg setImage:[UIImage imageNamed:@"defaultPack.png"]];
        [self getImage:[info objectForKey:@"url"]];
//        [NSThread detachNewThreadSelector:@selector(getImage:) toTarget:self withObject:[info objectForKey:@"url"]];
        [v addSubview:webImg];
        
        lblName = [[UILabel alloc] initWithFrame:CGRectZero];
        lblName.frame = CGRectMake(15, v.frame.size.height-80, 170, 30);
        lblName.backgroundColor = [UIColor clearColor];
        lblName.font = [UIFont systemFontOfSize:13.0];
        lblName.numberOfLines = 3;
        [v addSubview:lblName];
        
        lblPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        lblPrice.frame = CGRectMake(140, v.frame.size.height-80, 100, 30);
        lblPrice.backgroundColor = [UIColor clearColor];
        lblPrice.textAlignment = NSTextAlignmentCenter;
        lblPrice.font = [UIFont systemFontOfSize:13.0];
        [v addSubview:lblPrice];
    
        lblInfro = [[UILabel alloc] initWithFrame:CGRectZero];
        lblInfro.frame = CGRectMake(15, v.frame.size.height-60, v.frame.size.width-25, 60);
        lblInfro.backgroundColor = [UIColor clearColor];
        lblInfro.textAlignment = NSTextAlignmentLeft;
        lblInfro.font = [UIFont systemFontOfSize:13.0];
        lblInfro.numberOfLines = 3;
        [v addSubview:lblInfro];
        
        UIButton *btncancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btncancel.frame = self.frame;
        [btncancel setBackgroundColor:[UIColor clearColor]];
        [btncancel addTarget:self action:@selector(dismissAdditions) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btncancel];
        
        //赋值
        NSString *price = [info objectForKey:@"price"];
        NSString *unit = [info objectForKey:@"unit"];
        NSString *PU = [NSString stringWithFormat:@"%@元/%@",price,unit];
        lblName.text = [info objectForKey:@"pdes"];
        lblPrice.text = PU;
        lblInfro.text = [info objectForKey:@"discription"];
    }
    
    
    return self;
}

- (void)show{
    bs_dispatch_sync_on_main_thread(^{
        self.alpha = 0;
        UIWindow *w = (UIWindow *)[(AppDelegate *)[UIApplication sharedApplication].delegate window];
        [w addSubview:self];
        
        [UIView animateWithDuration:.3 animations:^{
            self.alpha = 1;
        }];
    });
    
}

//获取图片路径
-(void)getImage:(NSString *)url
{
    @autoreleasepool {
        url=[NSString stringWithFormat:@"%@%@",[[DataProvider getIpPlist]objectForKey:@"foodPic"],url];
        if([DataProvider imageCache:url])
        {
            [webImg setImage:[UIImage imageWithData:[DataProvider imageCache:url]]];
        }
        else
        {
            [webImg setImageURL:url andImageBoundName:@"defaultPack.png"];
        }
    }
    
    
}

- (void)dismissAdditions{
    bs_dispatch_sync_on_main_thread(^{
        [UIView animateWithDuration:.3 animations:^{
            self.alpha = 0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
            [webImg cancelRequest];
        }];
    });
    
}
@end
