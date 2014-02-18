//
//  MainViewController.m
//  ViewBasicInfo
//
//  Created by Quach Ngoc Tam on 2/13/14.
//  Copyright (c) 2014 QsoftVietNam. All rights reserved.
//

#import "MainViewController.h"
#import "DropDownMenuViewController.h"
#import "DropDownMenuModel.h"
#import "DropDownMenuEntity.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initModel];
    [self setRightButtonItem];
    UIView *viewxxx = [[UIView alloc] initWithFrame:self.view.frame];
    [viewxxx setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:viewxxx];
}


#pragma Start DropDown menu

- (void)setRightButtonItem{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    rightButton.tag = 0;
    [rightButton setImage:[UIImage imageNamed:@"bt_more_action.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(actionDrop:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barRightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIButton *pdfButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 31)];
    pdfButton.tag = 1;
    [pdfButton setImage:[UIImage imageNamed:@"bt_pdf.png"] forState:UIControlStateNormal];
    [pdfButton addTarget:self action:@selector(actionDrop:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *pdfButtonItem = [[UIBarButtonItem alloc] initWithCustomView:pdfButton];
    
    self.navigationItem.rightBarButtonItems = @[barRightButtonItem, pdfButtonItem];
}

- (void)initDropDownLeft:(DropDownMenuEntity*)menuEntity{
    if (!drop) {
        drop = [[DropDownMenuViewController alloc] initWithNibName:@"DropDownMenuViewController" bundle:nil];
        drop.superView = self;
        drop.delegate = self;
        drop.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self.view addSubview:drop.view];
    }
    [drop.view bringSubviewToFront:self.view];
    [drop setValue:menuEntity];
}

- (void)didSelectIndexPath:(NSIndexPath*)indexPath{
    NSLog(@"indexPath: %@", indexPath);
}

- (void)actionDrop:(id)sender{
    UIButton *buttonTemp  = sender;
    DropDownMenuEntity *menuEntity = [menuModel.arrayMenu objectAtIndex:[buttonTemp tag]];
    [self initDropDownLeft:menuEntity];
}

- (void)didSelectOpen:(DropDownMenuEntity*)menuEntity{
    [self resetStatusMenu:menuEntity];
}
- (void)didSelectClose:(DropDownMenuEntity*)menuEntity{
    [self resetStatusMenu:menuEntity];
}

- (void)resetStatusMenu:(DropDownMenuEntity*)menuEntity{
    NSMutableArray *array = menuModel.arrayMenu;
    for (DropDownMenuEntity *entity in array) {
        if ([entity.type isEqualToString:menuEntity.type]) {
            entity.isOpen = menuEntity.isOpen;
        }else{
            entity.isOpen = NO;
        }
    }
}

- (void)initModel{
    NSArray *arrayLableLeft = @[@"menu 1", @"menu 2", @"menu 3", @"menu 4", @"menu 5", @"menu 6", @"menu 7", @"menu 8", @"menu 9"];
    NSArray *arrayLableRight = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    menuModel = [[DropDownMenuModel alloc] init];
        
    DropDownMenuEntity *dropEntity = [[DropDownMenuEntity alloc] init];
    dropEntity.arrayItemsLeft = [NSMutableArray arrayWithArray:arrayLableLeft];
    dropEntity.arrayItemsRight = [NSMutableArray arrayWithArray:arrayLableRight];
    dropEntity.type = @"0";
    [menuModel.arrayMenu addObject:dropEntity];
    
    NSArray *arrayLableLeft1 = @[@"menu 1", @"menu 2", @"menu 3"];
    DropDownMenuEntity *dropEntity1 = [[DropDownMenuEntity alloc] init];
    dropEntity1.arrayItemsLeft = [NSMutableArray arrayWithArray:arrayLableLeft1];
    dropEntity1.isCheckMark = YES;
    dropEntity1.isCenter = YES;
    dropEntity1.type = @"1";
    [menuModel.arrayMenu addObject:dropEntity1];
}
#pragma End DropDown menu

@end
