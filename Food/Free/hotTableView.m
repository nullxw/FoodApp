//
//  hotTableView.m
//  Food
//
//  Created by dcw on 14-4-18.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import "hotTableView.h"
#import "hotCell.h"

@implementation hotTableView

- (id)initWithFrame:(CGRect)frame info:(NSArray *)ary
{
    self = [super initWithFrame:frame];
    if (self) {
        hotArray = [NSMutableArray arrayWithArray:ary];
        [self _init];
    }
    return self;
}

-(void)_init{
    self.delegate = self;
    self.dataSource = self;
    self.backgroundColor = [UIColor clearColor];
    self.allowsSelection = NO;
    //刷新的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"reloadHotTableNotification" object:nil];
}

//刷新table
-(void)reloadTable{
    [self reloadData];
}

#pragma mark -  UITableView Delegate & Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"hotResultCell";
    hotCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[hotCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.dicInfo = [hotArray objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [hotArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
