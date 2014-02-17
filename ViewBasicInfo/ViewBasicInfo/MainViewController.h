//
//  MainViewController.h
//  ViewBasicInfo
//
//  Created by Quach Ngoc Tam on 2/13/14.
//  Copyright (c) 2014 QsoftVietNam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownMenuViewController.h"
@interface MainViewController : UIViewController<DropDownMenuViewControllerDelegate>{
    DropDownMenuViewController *drop;
}

@end
