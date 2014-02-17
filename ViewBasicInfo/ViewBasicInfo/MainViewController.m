//
//  MainViewController.m
//  ViewBasicInfo
//
//  Created by Quach Ngoc Tam on 2/13/14.
//  Copyright (c) 2014 QsoftVietNam. All rights reserved.
//

#import "MainViewController.h"
#import "DropDownMenuViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self actionDropDown];
}
#pragma Start DropDown menu
- (void)initDropDown{
    // stype 1:
//    NSArray *arrayLableLeft = @[@"menu 1", @"menu 2", @"menu 3", @"menu 4", @"menu 5", @"menu 6", @"menu 7", @"menu 8", @"menu 9"];
//    NSArray *arrayLableRight = nil;//@[@"1", @"2", @"2563"];
//    [self initDropDownLeft:[NSMutableArray arrayWithArray:arrayLableLeft] arrayDropDownRight:[NSMutableArray arrayWithArray:arrayLableRight] isCheckMark:NO isCenter:NO];

    // stype 2:
//    NSArray *arrayLableLeft = @[@"menu 1", @"menu 2", @"menu 3", @"menu 4", @"menu 5", @"menu 6", @"menu 7", @"menu 8", @"menu 9"];
//    NSArray *arrayLableRight = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
//    [self initDropDownLeft:[NSMutableArray arrayWithArray:arrayLableLeft] arrayDropDownRight:[NSMutableArray arrayWithArray:arrayLableRight] isCheckMark:NO isCenter:NO];

    // stype 3:
    NSArray *arrayLableLeft = @[@"menu 1", @"menu 2", @"menu 3", @"menu 4", @"menu 5", @"menu 6", @"menu 7", @"menu 8", @"menu 9"];
     NSArray *arrayLableRight = nil;
     [self initDropDownLeft:[NSMutableArray arrayWithArray:arrayLableLeft] arrayDropDownRight:[NSMutableArray arrayWithArray:arrayLableRight] isCheckMark:YES isCenter:YES];
}

- (void)initDropDownLeft:(NSMutableArray*)arrayLeft
      arrayDropDownRight:(NSMutableArray*)arrayRight isCheckMark:(BOOL)checkmark isCenter:(BOOL)center{

    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    NSInteger width = UIDeviceOrientationIsLandscape(deviceOrientation) ? self.view.frame.size.height : self.view.frame.size.width;
    int widthDropdownMenu = 167;
    int heightForRow = 44;
    int separatorRight = 5;
    int percent = 50; //50%
    
    drop = [[DropDownMenuViewController alloc] initWithNibName:@"DropDownMenuViewController" bundle:nil];
    drop.superView = self;
    drop.delegate = self;
    drop.isCheckMark = checkmark;
    drop.heithForRow = heightForRow;
    drop.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    if (center) {
        int pointx = 0;
        int widthSelf = self.view.frame.size.width;
        pointx = (widthSelf*percent)/100 - widthDropdownMenu/2;
        
        [drop.view setFrame:CGRectMake(pointx, -(heightForRow*[arrayLeft count]), widthDropdownMenu, (heightForRow*[arrayLeft count]+5))];
        drop.isCenter = YES;
    }else{
        [drop.view setFrame:CGRectMake(width - widthDropdownMenu - separatorRight, -(heightForRow*[arrayLeft count]), widthDropdownMenu, (heightForRow*[arrayLeft count]+5))];
        drop.isCenter = NO;
    }
    if ([arrayLeft count]>0) {
       [drop setArrayItemsLeft:[NSMutableArray arrayWithArray:arrayLeft]];
    }
    if ([arrayRight count]>0 && [arrayRight count]==[arrayLeft count]) {
       [drop setArrayItemsRight:[NSMutableArray arrayWithArray:arrayRight]];
    }
    
    [self.view addSubview:drop.view];    
}

- (void)actionDropDown{
    [drop dropDownMenu];
}

- (void)didSelectIndexPath:(NSIndexPath*)indexPath{
    NSLog(@"indexPath: %@", indexPath);
}

#pragma End DropDown menu

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initDropDown];
    
    [[[UIAlertView alloc] initWithTitle:@"Confirmation"
                                message:NSLocalizedString(@"BOOK_PURCHASE", @"Message")
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
