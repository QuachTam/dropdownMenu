//
//  CellCustomDropDownMenu.m
//  ViewBasicInfo
//
//  Created by Quach Ngoc Tam on 2/13/14.
//  Copyright (c) 2014 QsoftVietNam. All rights reserved.
//

#import "CellCustomDropDownMenu.h"

@implementation CellCustomDropDownMenu

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSeparatorLableLeft:(int)separatorLeft{
    CGRect frameLeft = self.lableLeft.frame;
    frameLeft.origin.x = separatorLeft;
    self.lableLeft.frame = frameLeft;
}

- (void)setSeparatorLableRight:(int)separatorRight{
    CGRect frameRight = self.lableRight.frame;
    frameRight.origin.x = separatorRight;
    self.lableRight.frame = frameRight;
}

- (void)setHiddenLableRight:(BOOL)isHidden{
    [self.lableRight setHidden:isHidden];
}

- (void)setValueLabeRight:(NSString*)value{
    self.lableRight.text = value;
    self.accessibilityLabel = value;
}

- (void)setValueLableLeft:(NSString*)value{
    self.lableLeft.text = value;
    self.accessibilityLabel = value;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
