//
//  showDateView.m
//  Food
//
//  Created by sundaoran on 14-5-4.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "showDateView.h"
#import "AppDelegate.h"


@implementation showDateView
{
    UITableView     *dateTableView;
    NSArray         *dataArray;
    UIView           *v;
}

@synthesize delegate=_delegate;
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}
-(id)initWithDateArray:(NSMutableArray *)array
{
    self = [super init];
    if (self) {
        // Initialization code
         self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor=[UIColor clearColor];
        
        UIView *viewBg = [[UIView alloc] init];
        viewBg.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        viewBg.backgroundColor = kblackColor;
        viewBg.alpha = 0.5;
        [self addSubview:viewBg];
        
        v = [[UIView alloc] init];
        float padding = 20;
        v.frame = CGRectMake(padding, 100+padding, ScreenWidth-padding*2, ScreenHeight-250-padding*2);
        v.backgroundColor = [UIColor whiteColor];
        [v.layer setCornerRadius:10.0];
        [v.layer setMasksToBounds:YES];
        v.clipsToBounds = YES;
        [self addSubview:v];
        
        dateTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, v.frame.size.width, v.frame.size.height) style:UITableViewStylePlain];
        dateTableView.delegate=self;
        dateTableView.dataSource=self;
        [v addSubview:dateTableView];
        
        dataArray=[[NSMutableArray alloc]initWithArray:array];
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
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, v.frame.size.width, 40)];
    label.text=[dataArray objectAtIndex:indexPath.row];
    label.textAlignment=NSTextAlignmentCenter;
    
    [cell.contentView addSubview:label];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissAdditions];
    [dateTableView deselectRowAtIndexPath:indexPath animated:YES];
    [_delegate getselectDate:[dataArray objectAtIndex:indexPath.row]];
    
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
