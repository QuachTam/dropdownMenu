//
//  DropDownMenuModel.h
//  ViewBasicInfo
//
//  Created by Quach Ngoc Tam on 2/17/14.
//  Copyright (c) 2014 QsoftVietNam. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DropDownMenuEntity;
@interface DropDownMenuModel : NSObject
@property (nonatomic, strong) NSMutableArray *arrayMenu;
@property (strong, nonatomic) DropDownMenuEntity *downMenuEntity;
@end
