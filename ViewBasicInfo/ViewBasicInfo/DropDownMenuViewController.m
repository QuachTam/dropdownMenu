//
//  DropDownMenuViewController.m
//  ViewBasicInfo
//
//  Created by Quach Ngoc Tam on 2/13/14.
//  Copyright (c) 2014 QsoftVietNam. All rights reserved.
//

#import "DropDownMenuViewController.h"
#import "CellCustomDropDownMenu.h"

@interface DropDownMenuViewController ()
@property UIButton *buttonDropDown;
@property BOOL isStart;
@end

@implementation DropDownMenuViewController
@synthesize arrayItemsLeft, arrayItemsRight, superView;
@synthesize lastIndexPath, isCheckMark, separatorLeft, isCenter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.accessibilityLabel = @"accessibility_DropDownMenuViewController";
        self.tableView.accessibilityLabel = @"accessibilityLabel_TableView_DropDownMenuViewController";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.buttonDropDown = [[UIButton alloc] init];
    self.buttonDropDown.tag = 0;
    self.isStart = YES;
    self.arrayItemsLeft = [[NSMutableArray alloc] init];
    self.arrayItemsRight = [[NSMutableArray alloc] init];
    self.view.layer.cornerRadius = 2.0;
    self.view.layer.masksToBounds = YES;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)viewDidUnload {
    self.lastIndexPath = nil;
    [super viewDidUnload];
}

- (void)orientationChanged:(NSNotification *)notification{
    [self shoutLandscape:superView.view.frame.size.width];
}

- (void)shoutLandscape:(float)width{
    CGRect frameSelf = self.view.frame;
    if (isCenter) {
       frameSelf.origin.x = [self caculatorPointX:50];
    }else{
        frameSelf.origin.x = superView.view.frame.size.width - self.view.frame.size.width - 5;
    }
    if (self.view.frame.size.height>superView.view.frame.size.height) {
        frameSelf.size.height = superView.view.frame.size.height;
    }else{
        frameSelf.size.height = self.arrayItemsLeft.count*self.heithForRow;
    }
    self.view.frame = frameSelf;
    
    if (self.buttonDropDown.tag==0) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (int)caculatorPointX:(int)percent{
    float pointx = 0;
    int widthSelf = superView.view.frame.size.width;
    pointx = (widthSelf*percent)/100 - self.view.frame.size.width/2;
    return pointx;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayItemsLeft count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.heithForRow;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reusableCellIdentifier = @"CellCustomDropDownMenu";
    CellCustomDropDownMenu *cell = [self.tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
    if (!cell) {
        [[self tableView] registerNib:[UINib nibWithNibName:@"CellCustomDropDownMenu" bundle:nil] forCellReuseIdentifier:reusableCellIdentifier];
        cell = [self.tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
    }
    [cell setValueLableLeft:[self.arrayItemsLeft objectAtIndex:indexPath.row]];
    if ([self.arrayItemsRight count]>0) {
        [cell setHiddenLableRight:NO];
        [cell setValueLabeRight:[self.arrayItemsRight objectAtIndex:indexPath.row]];
    }else{
        [cell setHiddenLableRight:YES];
    }
    if (indexPath.row<self.arrayItemsLeft.count-1) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_dropdown_menu.png"]];
        imgView.frame = CGRectMake(0, self.heithForRow-1, self.view.frame.size.width, 1);
        [cell.contentView addSubview:imgView];
    }
    if (isCheckMark) {
        [[UITableViewCell appearance] setTintColor:[UIColor whiteColor]];
        NSUInteger row = [indexPath row];
        NSUInteger oldRow = [lastIndexPath row];
        cell.accessoryType = (row == oldRow && lastIndexPath!=nil)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didSelectIndexPath:)]) {
        [self.delegate didSelectIndexPath:indexPath];
    }
    if (isCheckMark) {
        int newRow = [indexPath row];
        int oldRow = lastIndexPath!=nil?[lastIndexPath row]:-1;
        if (newRow!=oldRow) {
            
            UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:lastIndexPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            lastIndexPath = indexPath;
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dropDownMenu];
}

- (void)dropDownMenu{
    if (self.isStart) {
        self.isStart = NO;
        if (!self.buttonDropDown.tag) {
            self.buttonDropDown.tag = 1;
        }else{
            self.buttonDropDown.tag = 0;
        }
        
        if (self.buttonDropDown.tag==1) {
            [self animation:CGRectMake(self.view.frame.origin.x, 8, self.view.frame.size.width, self.view.frame.size.height)];
        }else{
            [self animation:CGRectMake(self.view.frame.origin.x, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        }
    }
}

- (void)animation:(CGRect)frameCurrent{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn // See other options
                     animations:^{
                         [self.view setFrame:frameCurrent];
                     }
                     completion:^(BOOL finished) {
                         // Completion Block
                         self.isStart = YES;
                     }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
