//
//  DropDownMenuViewController.h
//  ViewBasicInfo
//
//  Created by Quach Ngoc Tam on 2/13/14.
//  Copyright (c) 2014 QsoftVietNam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownMenuViewControllerDelegate;

@interface DropDownMenuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    NSIndexPath *lastIndexPath;
}
@property (weak, nonatomic) id<DropDownMenuViewControllerDelegate> delegate;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIViewController *superView;

@property (retain, nonatomic) NSMutableArray *arrayItemsLeft;
@property (retain, nonatomic) NSMutableArray *arrayItemsRight;
@property (nonatomic, readwrite) int heithForRow;
@property (nonatomic, readwrite) int separatorLeft;
@property (nonatomic, readwrite) BOOL isCheckMark;
@property (nonatomic, readwrite) BOOL isCenter;

- (void)dropDownMenu;

@end


@protocol DropDownMenuViewControllerDelegate <NSObject>
@optional
- (void)didSelectIndexPath:(NSIndexPath*)indexPath;
@end