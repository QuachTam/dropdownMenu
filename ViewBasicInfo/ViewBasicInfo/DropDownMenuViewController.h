//
//  DropDownMenuViewController.h
//  ViewBasicInfo
//
//  Created by Quach Ngoc Tam on 2/13/14.
//  Copyright (c) 2014 QsoftVietNam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownMenuViewControllerDelegate;
@class DropDownMenuEntity;
@interface DropDownMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) id<DropDownMenuViewControllerDelegate> delegate;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIViewController *superView;
@property (nonatomic, retain) DropDownMenuEntity *dropEntity;

@property (retain, nonatomic) NSMutableArray *arrayItemsLeft;
@property (retain, nonatomic) NSMutableArray *arrayItemsRight;

- (void)actionOpenMenu:(DropDownMenuEntity*)menuEntity;
- (void)actionCloseMenu:(DropDownMenuEntity*)menuEntity;
- (void)setValue:(DropDownMenuEntity*)menuEntity;
@end


@protocol DropDownMenuViewControllerDelegate <NSObject>
@optional
- (void)didSelectIndexPath:(NSIndexPath*)indexPath;
- (void)didSelectOpen:(DropDownMenuEntity*)menuEntity;
- (void)didSelectClose:(DropDownMenuEntity*)menuEntity;
@end