//
//  BSSearchViewController.h
//  BookSystem-iPhone
//
//  Created by Stan Wu on 12-11-25.
//  Copyright (c) 2012年 Stan Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "BSBookCell.h"
#import "PackageViewController.h"
#import "LeftClassTableView.h"
#import "hotTableView.h"


@interface BSBookViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UISearchBarDelegate,EGORefreshTableHeaderDelegate,BSBookCellDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,navigationBarViewDeleGete>{
    UITableView *tvResult,*tvLeftClass;
    UIButton *btnOrdered,*btnBook;
    
    NSMutableArray *aryResult,*aryAddition;
    NSArray *aryOrdered;
    NSString *strUnitKey,*strPriceKey;
    
    UISearchBar *searchBar;
    UIButton *btnKeyBoard;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    UITapGestureRecognizer *_tapRecognizer;
    UIView *viewHeader;
    UIImageView *imgv;
    
    UIImageView *imgMenu;  //菜单图标
    UIButton *butMenu;     //菜单按钮
    int addPrice;
    float allPrice;
    
    LeftClassTableView *leftClass; //左视图
    UIButton           *butSerachFood;//搜索
    NSMutableArray *classArray;//菜品分类
    UIImageView *imgSeparator;//中间分割线
    
    NSMutableArray *searchByResult;
    NSMutableArray *searchClass;
    NSMutableArray *aryResultNew;
    RTLabel *allPriceLable;
    NSArray *arySoldOut;//沽清
    NSMutableDictionary *dicUnit2;//第二单位
    NSIndexPath *indexp2;
    
    NSMutableArray *aryPack,*aryPackItem,*aryHot;
    UIButton *butAll,*butHot;
    BOOL  boHot,boAll;
    float lx;
    float ly;
    hotTableView *tvHot;
    UILabel *lblTotal,*lblCount;
    CVLocalizationSetting *langSetting;
    NSMutableArray *aryCell;
    
    
    NSDictionary *_sendTableInf;
}
@property (nonatomic,strong) NSMutableArray *aryResult,*aryAddition;
@property (nonatomic,strong) NSString *strUnitKey,*strPriceKey;
@property (nonatomic,strong) NSMutableArray *searchByName;
@property (nonatomic,strong) UITextField *tfInput;
@property (nonatomic,strong) NSMutableDictionary *contactDic;
@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,strong) NSDictionary *dicInfo;
@property (nonatomic,strong) NSDictionary *sendTableInf;
- (void )getFoodList;

@end
