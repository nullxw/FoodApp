//
//  hotTableView.h
//  Food
//
//  Created by dcw on 14-4-18.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hotTableView : UITableView<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *hotArray;
}

- (id)initWithFrame:(CGRect)frame info:(NSArray *)dicInfo;

@end
