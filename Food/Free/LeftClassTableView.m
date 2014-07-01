//
//  LeftClassTableView.m
//  BookSystem-iPhone
//
//  Created by dcw on 14-1-14.
//  Copyright (c) 2014年 Stan Wu. All rights reserved.
//

#import "LeftClassTableView.h"
#import "DataProvider.h"

@implementation LeftClassTableView

- (id)initWithFrame:(CGRect)frame info:(NSArray *)ary
{
    self = [super initWithFrame:frame];
    if (self) {
        classArray = [NSMutableArray arrayWithArray:ary];
        [self _init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"reloadLeftTable" object:nil];
    }
    return self;
}

//刷新table通知方法
-(void)reloadTable{
    [self reloadData];
}

//初始化
-(void)_init{
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark -  UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"typeResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text=@"";
    cell.textLabel.text = [[classArray objectAtIndex:indexPath.row] objectForKey:@"des"];
    cell.textLabel.font=[UIFont systemFontOfSize:13];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [classArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str = [[classArray objectAtIndex:indexPath.row] objectForKey:@"des"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeTypeNotification" object:str];
}

@end
