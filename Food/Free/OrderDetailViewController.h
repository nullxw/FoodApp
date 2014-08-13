//
//  OrderDetailViewController.h
//  Food
//
//  Created by dcw on 14-4-21.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController<navigationBarViewDeleGete,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    UITableView *tvOrder;
    NSMutableArray *aryOrder;
    float allPrice;
    UILabel *lblCount,*lblSum;
    UITextView *lblAddition;
    int offSet;
    UIView *viewUp,*viewDown,*viewBottom,*viewUpUp;
    CVLocalizationSetting *langSetting;
    UIButton *butSubmit;
    
    NSDictionary     *_sendTableInfo;
}
@property (nonatomic,strong) NSDictionary *dicInfo;
@property (nonatomic,strong) NSDictionary *sendTableInfo;
@end
