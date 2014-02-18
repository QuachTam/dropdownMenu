//
//  DropDownMenuViewController.m
//  ViewBasicInfo
//
//  Created by Quach Ngoc Tam on 2/13/14.
//  Copyright (c) 2014 QsoftVietNam. All rights reserved.
//

#import "DropDownMenuViewController.h"
#import "CellCustomDropDownMenu.h"
#import "DropDownMenuEntity.h"

@interface DropDownMenuViewController ()

@end

@implementation DropDownMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.accessibilityIdentifier = @"accessibility_DropDownMenuViewController";
        self.tableView.accessibilityIdentifier = @"accessibilityLabel_TableView_DropDownMenuViewController";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.arrayItemsLeft = [[NSMutableArray alloc] init];
    self.arrayItemsRight = [[NSMutableArray alloc] init];
    self.view.layer.cornerRadius = 2.0;
    self.view.layer.masksToBounds = YES;
    self.dropEntity = [[DropDownMenuEntity alloc] init];
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

- (void)setValue:(DropDownMenuEntity*)menuEntity{
    self.dropEntity = menuEntity;
    NSInteger width = [self getWidthView];
    if (menuEntity.isCenter) {
        int pointx = 0;
        pointx = (width*self.dropEntity.percent)/100 - self.dropEntity.widthDropdownMenu/2;
        [self.view setFrame:CGRectMake(pointx, -(self.dropEntity.heithForRow*[menuEntity.arrayItemsLeft count]), self.dropEntity.widthDropdownMenu, (self.dropEntity.heithForRow*[menuEntity.arrayItemsLeft count]+5))];
    }else{
        [self.view setFrame:CGRectMake(width - self.dropEntity.widthDropdownMenu - self.dropEntity.separatorLeft, -(self.dropEntity.heithForRow*[menuEntity.arrayItemsLeft count]), self.dropEntity.widthDropdownMenu, (self.dropEntity.heithForRow*[menuEntity.arrayItemsLeft count]+5))];
    }
    if ([menuEntity.arrayItemsLeft count]>0) {
        [self setArrayItemsLeft:[NSMutableArray arrayWithArray:menuEntity.arrayItemsLeft]];
    }
    if ([menuEntity.arrayItemsRight count]>0 && [menuEntity.arrayItemsRight count]==[menuEntity.arrayItemsLeft count]) {
        [self setArrayItemsRight:[NSMutableArray arrayWithArray:menuEntity.arrayItemsRight]];
    }
    [[self tableView] reloadData];
    if (!self.dropEntity.isOpen) {
        [self actionOpenMenu:self.dropEntity];
    }else{
        [self actionCloseMenu:self.dropEntity];
    }
}

- (void)actionOpenMenu:(DropDownMenuEntity*)menuEntity{
    menuEntity.isOpen = YES;
    if ([self.delegate respondsToSelector:@selector(didSelectOpen:)]) {
        [self.delegate didSelectOpen:menuEntity];
    }
    self.view.frame = CGRectMake(self.view.frame.origin.x, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    [self animation:CGRectMake(self.view.frame.origin.x, self.dropEntity.separaterTop, self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)actionCloseMenu:(DropDownMenuEntity*)menuEntity{
    menuEntity.isOpen = NO;
    if ([self.delegate respondsToSelector:@selector(didSelectClose:)]) {
        [self.delegate didSelectClose:menuEntity];
    }
    [self animation:CGRectMake(self.view.frame.origin.x, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
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
                     }];
}

- (NSInteger)getWidthView{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    NSInteger width = 0;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        width = screenRect.size.height;
    }else{
        width = screenRect.size.width;
    }
    return width;
}

- (void)orientationChanged:(NSNotification *)notification{
    [self shoutLandscape:[self getWidthView]];
}

- (void)shoutLandscape:(float)width{
    CGRect frameSelf = self.view.frame;
    CGRect superFrame  = self.superView.view.frame;
    if (self.dropEntity.isCenter) {
       frameSelf.origin.x = [self caculatorPointX:self.dropEntity.percent];
    }else{
        frameSelf.origin.x = width - self.view.frame.size.width - 5;
    }
    if (self.view.frame.size.height>superFrame.size.height) {
        frameSelf.size.height = superFrame.size.height;
    }else{
        frameSelf.size.height = self.arrayItemsLeft.count*self.dropEntity.heithForRow;
    }
    self.view.frame = frameSelf;
    
    if (!self.dropEntity.isOpen) {
        self.view.frame = CGRectMake(self.view.frame.origin.x, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    }
}

- (int)caculatorPointX:(int)percent{
    float pointx = 0;
    int width = [self getWidthView];
    pointx = (width*percent)/100 - self.view.frame.size.width/2;
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
    return self.dropEntity.heithForRow;
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
        imgView.frame = CGRectMake(0, self.dropEntity.heithForRow-1, self.view.frame.size.width, 1);
        [cell.contentView addSubview:imgView];
    }
    if (self.dropEntity.isCheckMark) {
        [[UITableViewCell appearance] setTintColor:[UIColor whiteColor]];
        NSUInteger row = [indexPath row];
        NSUInteger oldRow = [self.lastIndexPath row];
        cell.accessoryType = (row == oldRow && self.lastIndexPath!=nil)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(didSelectIndexPath:)]) {
        [self.delegate didSelectIndexPath:indexPath];
    }
    if (self.dropEntity.isCheckMark) {
        int newRow = [indexPath row];
        int oldRow = self.lastIndexPath!=nil?[self.lastIndexPath row]:-1;
        if (newRow!=oldRow) {
            
            UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:self.lastIndexPath];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            self.lastIndexPath = indexPath;
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self actionCloseMenu:self.dropEntity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
