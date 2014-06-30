//
//  showDateView.h
//  Food
//
//  Created by sundaoran on 14-5-4.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol showDateViewDelegate <NSObject>

-(void)getselectDate:(NSString *)date;

@end

@interface showDateView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    __weak id<showDateViewDelegate>_delegate;
}

@property(nonatomic,weak)__weak id<showDateViewDelegate>delegate;
-(id)initWithDateArray:(NSMutableArray *)array;

- (void)show;
@end
