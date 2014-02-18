//
//  DropDownMenuEntity.h
//  ViewBasicInfo
//
//  Created by Quach Ngoc Tam on 2/17/14.
//  Copyright (c) 2014 QsoftVietNam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DropDownMenuEntity : NSObject

@property (retain, nonatomic) NSMutableArray *arrayItemsLeft;
@property (retain, nonatomic) NSMutableArray *arrayItemsRight;
@property (nonatomic, readwrite) int heithForRow;
@property (nonatomic, readwrite) int separatorLeft;
@property (nonatomic, readwrite) int percent;
@property (nonatomic, readwrite) int widthDropdownMenu;
@property (nonatomic, readwrite) int separaterTop;
@property (nonatomic, readwrite) BOOL isCheckMark;
@property (nonatomic, readwrite) BOOL isCenter;
@property (nonatomic, readwrite) BOOL isOpen;
@property (nonatomic, retain) NSString *type;

@end
