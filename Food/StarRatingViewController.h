//
//  StarRatingViewController.h
//  Food
//
//  Created by sundaoran on 14-7-2.
//  Copyright (c) 2014年 com.choice.food. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingView.h"

@interface StarRatingViewController : UIViewController<RatingViewDelegate,navigationBarViewDeleGete,UIAlertViewDelegate,UITextViewDelegate>


-(void)setStoreMessage:(NSString *)storeId;


@end
