//
//  DropDownMenuEntity.m
//  ViewBasicInfo
//
//  Created by Quach Ngoc Tam on 2/17/14.
//  Copyright (c) 2014 QsoftVietNam. All rights reserved.
//

#import "DropDownMenuEntity.h"

@implementation DropDownMenuEntity

- (id)init
{
    self = [super init];
    if (self) {
        self.isCheckMark = NO;
        self.isCenter = NO;
        self.isOpen = NO;
        self.heithForRow = 44;
        self.separatorLeft = 5;
        self.separaterTop  = 8;
        self.widthDropdownMenu = 167;
        self.percent = 50;
        self.arrayItemsRight = nil;
    }
    return self;
}

@end
