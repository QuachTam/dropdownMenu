//
//  DropDownMenuModel.m
//  ViewBasicInfo
//
//  Created by Quach Ngoc Tam on 2/17/14.
//  Copyright (c) 2014 QsoftVietNam. All rights reserved.
//

#import "DropDownMenuModel.h"
#import "DropDownMenuEntity.h"

@implementation DropDownMenuModel

- (id)init
{
    self = [super init];
    if (self) {
        self.downMenuEntity = [[DropDownMenuEntity alloc] init];
        self.arrayMenu = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
