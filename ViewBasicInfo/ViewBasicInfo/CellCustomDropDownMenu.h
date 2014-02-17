//
//  CellCustomDropDownMenu.h
//  ViewBasicInfo
//
//  Created by Quach Ngoc Tam on 2/13/14.
//  Copyright (c) 2014 QsoftVietNam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellCustomDropDownMenu : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lableLeft;
@property (weak, nonatomic) IBOutlet UILabel *lableRight;

- (void)setSeparatorLableRight:(int)separatorRight;
- (void)setSeparatorLableLeft:(int)separatorLeft;
- (void)setHiddenLableRight:(BOOL)isHidden;
- (void)setValueLabeRight:(NSString*)value;
- (void)setValueLableLeft:(NSString*)value;
@end
