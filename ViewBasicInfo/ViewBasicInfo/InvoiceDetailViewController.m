//
//  InvoiceDetailViewController.m
//  Customer
//
//  Created by Trinh Huy Cuong  on 1/14/14.
//  Copyright (c) 2014 El Nino. All rights reserved.
//

#import "InvoiceDetailViewController.h"
#import "DropDownMenu.h"
#import "PDFViewController.h"
#import "TitleControl.h"
#import "InvoiceDetailService.h"
#import "InvoiceModel.h"
#import "CustomerModel.h"
#import "Invoice.h"
#import "CustomHeaderObject.h"
#import "DISSectionHeaderModel.h"
#import "CustomHeaderView.h"
#import "DropDownControl.h"
#import "InvoiceDetailInformationCell.h"
#import "InvoiceDetailNoteCell.h"
#import "InvoiceDetailMoreDetailCell.h"
#import "UserSession.h"
#import "CustomerEntity.h"
#import "PDFService.h"
#import "SendEmailEntity.h"

@interface InvoiceDetailViewController (){
    NSMutableDictionary *headerItems;
    NSArray *cells;
    
    InvoiceDetailMoreDetailCell *detailMoreDetailCell;
    InvoiceDetailInformationCell *detailInformationCell;
    InvoiceDetailNoteCell *detailNoteCell;
    
}
@property DropDownMenu *drop;

@end

@implementation InvoiceDetailViewController
@synthesize email;

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
    [self initNavigationBar];
//    
//    NSLog(@"WebID of customer: %@", self.invoiceDetailService.customerModel.customerEntity.webId);
//    NSLog(@"invoice detail: %@", self.invoiceDetailService.invoiceModel.invoice.detailList);
    
    headerItems = [NSMutableDictionary dictionary];
    detailMoreDetailCell = [[InvoiceDetailMoreDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    detailInformationCell = [[InvoiceDetailInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    detailNoteCell = [[InvoiceDetailNoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    InvoiceModel *invoice = self.invoiceDetailService.invoiceModel;
    
    detailInformationCell.values = @{@"Bill to:":   invoice.invoice.billToCustomer,
                                     @"Opened:":    [Lib convertToLocalTimezone:invoice.invoice.openedDate withUTCFormat:UTC_TIME_FORMAT andLocalFormat:LOCAL_DATE_FORMAT] ? [Lib convertToLocalTimezone:invoice.invoice.openedDate withUTCFormat:UTC_TIME_FORMAT andLocalFormat:LOCAL_DATE_FORMAT] : @"<null>",
                                     @"Closed:":    [Lib convertToLocalTimezone:invoice.invoice.closedDate withUTCFormat:UTC_TIME_FORMAT andLocalFormat:LOCAL_DATE_FORMAT] ? [Lib convertToLocalTimezone:invoice.invoice.closedDate withUTCFormat:UTC_TIME_FORMAT andLocalFormat:LOCAL_DATE_FORMAT] : @"<null>",
                                     @"Due date:":  [Lib convertToLocalTimezone:invoice.invoice.dueDate withUTCFormat:UTC_TIME_FORMAT andLocalFormat:LOCAL_DATE_FORMAT] ? [Lib convertToLocalTimezone:invoice.invoice.dueDate withUTCFormat:UTC_TIME_FORMAT andLocalFormat:LOCAL_DATE_FORMAT] : @"<null>",
                                     @"Ship to:" :  invoice.invoice.shipToCustomer,
                                     @"Address:" :  invoice.invoice.shipToAddress};
    
    [detailInformationCell loadData];
    
    detailNoteCell.notes = invoice.invoice.notes;
    [detailNoteCell loadData];

    detailMoreDetailCell.strData = invoice.invoice.detailList;
    detailMoreDetailCell.invoice = invoice.invoice;
    [detailMoreDetailCell loadData];
    
    cells = @[detailInformationCell, detailNoteCell, detailMoreDetailCell];
    
    [self getPdfWithInvoiceId:[self.invoiceDetailService.invoiceModel.invoice.clientId description] success:^(NSData *dataPdf) {
        dataPdfScan = dataPdf;
    } fail:^(NSString *error) {
        
    }];
    
    [self loadRequest:[self.invoiceDetailService.invoiceModel.invoice.clientId description] Path:GET_PDF_INVOICE_PATH];
    subjectStr = [NSString stringWithFormat:@"Invoice %@",self.invoiceDetailService.invoiceModel.invoice.invoiceNumber];
    namePdfFromServerStr = [NSString stringWithFormat:@"Invoice_%@_Scan", self.invoiceDetailService.invoiceModel.invoice.invoiceNumber];
    namePdfScanViewDetailStr = [NSString stringWithFormat:@"Invoice_%@", self.invoiceDetailService.invoiceModel.invoice.invoiceNumber];
}

- (void)initNavigationBar {
    [self initDropMenu];
    [self setRightButtonItem];
    [self initViewCommon];
    
    UIBarButtonItem *item = [Lib barButtonItemFromImage:@"bt_back"];
    UIButton *backButto = (UIButton *)item.customView;
    [backButto addTarget:self.navigationController
                  action:@selector(popViewControllerAnimated:)
        forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = @[item];
    
    UILabel *label = (UILabel*)[Lib navigationTitleViewFromString:[NSString stringWithFormat:@"Invoice %@", self.invoiceDetailService.invoiceModel.invoice.invoiceNumber]];
    [self.navigationItem setTitleView:label];
}

- (void)initViewCommon {
    tbView.backgroundColor = [UIColor clearColor];
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    
    // setup background of content view
    UIImage *bgColor = [UIImage imageNamed:@"bg_screen"];
    [bgColor resizableImageWithCapInsets:UIEdgeInsetsMake(0, 150, 0, 150)];
    UIImageView *imageBackground = [[UIImageView alloc] init];
    imageBackground.image = bgColor;
    imageBackground.frame = self.view.bounds;
    imageBackground.autoresizingMask = self.view.autoresizingMask;
    [self.view insertSubview:imageBackground atIndex:0];
}


#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CustomHeaderView *headerObject = (CustomHeaderView*)[headerItems objectForKey:@(section)];
    
    if (headerObject.model.isOpening) {
        return 1;
    }

    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section ? 30 : 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [[cells objectAtIndex:indexPath.section] getCellHeight];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomHeaderView *headerView = [headerItems objectForKey:@(section)];
    if (!headerView) {
        CustomHeaderObject *customHeader = [[CustomHeaderObject alloc] init];
        DISSectionHeaderModel *headerModel = [[DISSectionHeaderModel alloc] init];
        headerModel.headerNameString = (!section) ? @"INVOICE INFORMATION" : (section == 1) ? @"INVOICE NOTE" : @"DETAIL";
        customHeader.headerModel = headerModel;
        customHeader.isOpen = YES;
        
        headerView = [[CustomHeaderView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        headerView.titleRightControl.rightButton.hidden = YES;
        
        headerView.openHeaderBlock = ^(CustomHeaderView *sender) {
            [self openSection:section withCustomerHeaderView:sender];
        };
        headerView.closeHeaderBlock = ^(CustomHeaderView *sender) {
            [self closeSection:section withCustomerHeaderView:sender];
        };
        [headerView setModel:headerModel];

        [headerItems setObject:headerView forKey:@(section)];
    }
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = cells[indexPath.section];
    
    NSLog(@"Cell class: %@", cell.class);
    
    return cell;
}

#pragma mark Excute open close tableview section
- (void)openSection:(NSInteger )section withCustomerHeaderView:(CustomHeaderView*)headerView {
    headerView.model.isOpening = YES;
    [tbView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)closeSection:(NSInteger )section withCustomerHeaderView:(CustomHeaderView*)headerView {
    headerView.model.isOpening = NO;
    [tbView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark DropDown Menu
// init drop down menu
- (void)setRightButtonItem{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
    [rightButton setImage:[UIImage imageNamed:@"bt_more_action.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(actionDropDown) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barRightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    
    UIButton *pdfButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 31)];
    [pdfButton setImage:[UIImage imageNamed:@"bt_pdf.png"] forState:UIControlStateNormal];
    [pdfButton addTarget:self action:@selector(viewPDFViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *pdfButtonItem = [[UIBarButtonItem alloc] initWithCustomView:pdfButton];

    self.navigationItem.rightBarButtonItems = @[barRightButtonItem, pdfButtonItem];
}

- (void)initDropMenu{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    NSInteger width = UIDeviceOrientationIsLandscape(deviceOrientation) ? self.view.frame.size.height : self.view.frame.size.width;
    
    self.drop = [[DropDownMenu alloc] initWithNibName:@"DropDownMenu" bundle:nil];
    [self.drop setItemsArray:@[@"Print", @"Question", @"Send Email"]];
    [self.drop.view setFrame:CGRectMake(width - 167 - 5, -122, 167, 122)];
    self.drop.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:self.drop.view];
    
    __weak __typeof(&*self)weak = self;
    self.drop.didSelectRowIndexPath = ^void(NSIndexPath *indexPath){
        [weak didSelectIndexPath:indexPath];
    };
}

- (void)actionDropDown{
    [self.drop dropDownMenu];
}

- (void)viewPDFViewController{
    PDFViewController *pdf = [[PDFViewController alloc] initWithNibName:@"PDFViewController" bundle:nil];
    pdf.getPdfPath = GET_PDF_INVOICE_PATH;
    pdf.invoiceNumber = self.invoiceDetailService.invoiceModel.invoice.invoiceNumber;
    [pdf Id:[self.invoiceDetailService.invoiceModel.invoice.clientId description]];
    pdf.email = email;
    [self.navigationController pushViewController:pdf animated:YES];
}

- (void)didSelectIndexPath:(NSIndexPath*)indexPath{
    switch (indexPath.row) {
        case 0:{
            [self printItem:dataPdfServer];
        }
            break;
        case 1:
            [self actionSendEmail:@[email] namePdfFromServer:namePdfFromServerStr namePdfScanDetail:namePdfScanViewDetailStr subject:subjectStr];
            break;
        case 2:
            [self actionSendEmail:nil namePdfFromServer:namePdfFromServerStr namePdfScanDetail:namePdfScanViewDetailStr subject:subjectStr];
            break;
        default:
            break;
    }
}
// end drop down menu


- (void)actionSendEmail:(NSArray*)emails namePdfFromServer:(NSString*)nameServer namePdfScanDetail:(NSString*)nameDetail subject:(NSString*)subject{
    if (dataPdfServer && dataPdfScan) {
        sendEmail = [[SendEmailEntity alloc] init];
        sendEmail.pdfFromServer = dataPdfServer;
        sendEmail.pdfScanViewDetail = dataPdfScan; // is true if view pdf
        sendEmail.superView = self;
        sendEmail.namePdfScanDetail = nameDetail;
        sendEmail.namePdfServer = nameServer;
        [sendEmail sendEmailWithRecipients:emails subject:subject];
    }else{
        [Lib showAlert:@"Warning" withMessage:@"Loading data"];
    }
}



-(void)printItem:(NSData*)dataPrint{
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    if(printController && [UIPrintInteractionController canPrintData:dataPrint]) {
        printController.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        //        printInfo.jobName = [path lastPathComponent];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printController.printInfo = printInfo;
        printController.showsPageRange = YES;
        printController.printingItem = dataPrint;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            }
        };
        [printController presentAnimated:YES completionHandler:completionHandler];
    }else{
        [Lib showAlert:@"Error" withMessage:@"Service unavailable"];
    }
}

- (void)loadRequest:(NSString*)ID Path:(NSString*)path{
    PDFService *service = [[PDFService alloc] init];
    [service loadRequest:ID Path:path success:^(NSData *dataPDF) {
        dataPdfServer = dataPDF;
    } fail:^(NSString *error) {
        [Lib showAlert:@"Error" withMessage:@"Service unavailable"];
        NSLog(@"error load pdf: %@", error);
    }];
}


- (void)getPdfWithInvoiceId:(NSString*)Id success:(void (^)(NSData *dataPdf))success fail:(void (^)(NSString *error))fail{
    PDFService *service = [[PDFService alloc] init];
    [service getPdfWithInvoiceId:Id success:^(NSData *dataPDF) {
        success(dataPDF);
    } fail:^(NSString *error) {
        [Lib showAlert:@"Error" withMessage:@"Service unavailable"];
        fail(error);
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
