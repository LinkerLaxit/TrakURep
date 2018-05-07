//
//  InventDetailViewController.m
//  TrakURep
//
//  Created by MAC on 12/10/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "InventDetailViewController.h"
#import "common.h"
#import "MBProgressHUD.h"
@interface InventDetailViewController ()
{
    IBOutlet UIButton *btn_Dispense;
    NSString *expDate;
    IBOutlet UITextField *txt_Number;
    IBOutlet UIView *view_Dispense;
    NSMutableDictionary *dictS;
    IBOutlet UIView *view_Bottom;
}
@property (strong, nonatomic) IBOutlet UILabel *lbl_Title;
@property (strong, nonatomic) IBOutlet UILabel *lbl_ExpDate;
- (IBAction)btn_Dispense_Action:(id)sender;
@end

@implementation InventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrDispense = [[NSMutableArray alloc] init];
    dictS=[[NSUserDefaults standardUserDefaults] valueForKey:@"InventDetail"];
    _lbl_Title.text = [dictS valueForKey:@"name"];
   
    arrSamples=[[NSMutableArray alloc] init];
    [arrSamples addObjectsFromArray:[dictS valueForKey:@"sample_ids"]];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"exp_date"
                                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    arrSamples = [[arrSamples sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    [self sortSamplesByExpDate];
    
    expDate = [[dictS valueForKey:@"exp_date"] stringByAppendingString:@" days until first expiration."];
   
    _lbl_ExpDate.text = expDate;
    if(_fromSampleTab)
    {
        btn_Dispense.hidden = false;
        view_Dispense.hidden =false;
        _tbl_InventDetails.frame = CGRectMake(_tbl_InventDetails.frame.origin.x, _tbl_InventDetails.frame.origin.y, _tbl_InventDetails.frame.size.width, _tbl_InventDetails.frame.size.height);
        _lbl_ExpDate.hidden = true;
    }
    else
    {
        _tbl_InventDetails.frame = CGRectMake(_tbl_InventDetails.frame.origin.x, _tbl_InventDetails.frame.origin.y, _tbl_InventDetails.frame.size.width, view_Bottom.frame.origin.y-120);
    }
    
    _lbl_ExpDate.frame = CGRectMake(_lbl_ExpDate.frame.origin.x,_tbl_InventDetails.frame.origin.y+_tbl_InventDetails.frame.size.height+10, _lbl_ExpDate.frame.size.width, _lbl_ExpDate.frame.size.height);
    
    if (_fromSampleTab == false)
    [btn_Dispense removeFromSuperview];
   
    
    for(id item in [InventDetailViewController samplesForDespense]) {
        if([item[@"ParentSampleId"] isEqualToString:dictS[@"ParentSampleId"]]) {
            arrDispense = [item[@"sample_ids"] mutableCopy];
        }
    }
}

-(void)sortSamplesByExpDate {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy";
    
    [arrSamples sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *d1 = [df dateFromString: [obj1 valueForKey:@"exp_date"]];
        NSDate *d2 = [df dateFromString: [obj2 valueForKey:@"exp_date"]];
        return [d1 compare: d2];
    }];
}

#pragma mark - table view delegate and data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrSamples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }

    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"MM/dd/yyyy"];

    NSDate *dtServer = [formatter dateFromString:[[arrSamples objectAtIndex:indexPath.row] valueForKey:@"exp_date"]];

    id now = [NSDate date];
    id nowDateWithoutTime = [formatter dateFromString:[formatter stringFromDate:now]];
    NSInteger days = [self numberOffDaysFrom:nowDateWithoutTime toDate:dtServer];
   
    NSLog(@"days : %lu", days);
    if (days > 90) {
        cell.imageView.image=[UIImage imageNamed:@"SampleIcon2"];
    } else if (days > 30) {
        cell.imageView.image=[UIImage imageNamed:@"SampleIcon3"];
    } else if (days >= 0) {
        cell.imageView.image=[UIImage imageNamed:@"SampleIcon4"];
    } else {
        cell.imageView.image=[UIImage imageNamed:@"expiredPill"];
    }

    if (_fromSampleTab)
    {

        UIButton *btnPlus =[UIButton buttonWithType:UIButtonTypeCustom];
        btnPlus.frame = CGRectMake(_tbl_InventDetails.frame.size.width-40, 10, 25, 25);
        btnPlus.backgroundColor = [UIColor whiteColor];
        [btnPlus setBackgroundImage:[UIImage imageNamed:@"RoundTick"] forState:UIControlStateSelected];
        [btnPlus setBackgroundImage:[UIImage imageNamed:@"SmallPlus"] forState:UIControlStateNormal];
        btnPlus.tag = indexPath.row;
        [btnPlus addTarget:self action:@selector(btnPlusAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview: btnPlus];
        
        id sample = arrSamples[indexPath.row];
        [btnPlus setSelected:NO];
        NSString* sampleID = sample[@"id"];
        if ([self sampleAddedInDespenseWith:sampleID]){
            [btnPlus setSelected:YES];

        }
        else{
            [btnPlus setSelected:NO];
        }
    }
    else
    {
        //formatter.dateFormat = @"yyyy-MM-dd";
        NSString* expDateStr = [formatter stringFromDate:dtServer];
        id dateStr = expDateStr == nil ? @"" : [NSString stringWithFormat:@"Exp Date: %@", expDateStr];
        NSString* labelString = [NSString stringWithFormat:@"%@", dateStr];
        cell.detailTextLabel.text =  labelString;
        [cell.detailTextLabel setNumberOfLines:0];
        [cell.detailTextLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
    cell.textLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];

    //NSString* lotNum = [[NSUserDefaults standardUserDefaults] valueForKey:@"selected_alotno"];
    cell.textLabel.text =    [NSString stringWithFormat:@"Lot #%@", [[arrSamples objectAtIndex:indexPath.row] valueForKey:@"alotid"]];
    
    cell.preservesSuperviewLayoutMargins = false;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (IBAction)btn_History_Action:(id)sender {
}

- (IBAction)btn_message_Action:(id)sender {
}

- (IBAction)btn_Inventory_action:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"FromSample"];

    [self.navigationController popViewControllerAnimated:false];
}

- (IBAction)btn_Sample_Action:(id)sender {
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (IBAction)btn_Profile_action:(id)sender {
}

- (IBAction)btn_Back_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:false];
}


-(void)btnPlusAction:(id)sender
{
   
    UIButton *btnplus = sender;
    NSUInteger tag = btnplus.tag;

    
    if(btnplus.isSelected)
    {
        //btnplus.selected = FALSE;
        [btnplus setSelected:NO];
        if(arrDispense.count>0)
            [arrDispense removeObject:[arrSamples objectAtIndex: tag]];
    }
    else
    {
        //btnplus.selected = TRUE;
        [btnplus setSelected:YES];
        [arrDispense addObject:[arrSamples objectAtIndex: tag]];
    }
    
    [self addRemoveItemsInDespense];

}

- (IBAction)btn_Dispense_Action:(id)sender {
    
//    NSString* parentId = [dictS valueForKey:@"ParentSampleId"];
//    NSMutableArray* samples = [InventDetailViewController samplesForDespense];
//
//    __block BOOL sampleExistInList = NO;
//    __block NSUInteger index = -1;
//    [samples enumerateObjectsUsingBlock:^(id  _Nonnull sample, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([sample[@"ParentSampleId"] isEqualToString:parentId]) {
//            sampleExistInList = YES;
//            index = idx;
//        }
//    }];
//
//    if (sampleExistInList)
//        [samples removeObjectAtIndex:index];

    if(arrDispense.count>0 )//&& txt_Number.text.length>0
    {
//        NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
//        [dictHist setObject:parentId forKey:@"ParentSampleId"];
//        [dictHist setObject:arrDispense forKey:@"sample_ids"];
//
//        [samples addObject:dictHist];

        [self showAlertAddMoreSamples];
    }
    
}

+ (NSMutableArray *)samplesForDespense
{
    static NSMutableArray *params;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        params = [[NSMutableArray alloc] init];
    });
    return params;
}

-(void)removeParamsItems {
    id arr = [InventDetailViewController samplesForDespense];
    [arr removeAllObjects];
}

-(BOOL)sampleAddedInDespenseWith:(NSString*)Id {
    for(id item in arrDispense) {
        if ([item[@"id"] isEqualToString:Id]) {
            return true;
        }
    }
    return false;
}

-(void)addRemoveItemsInDespense {
    NSString* parentId = [dictS valueForKey:@"ParentSampleId"];
    
    NSMutableArray* samples = [InventDetailViewController samplesForDespense];
    
    __block BOOL sampleExistInList = NO;
    __block NSUInteger index = -1;
    [samples enumerateObjectsUsingBlock:^(id  _Nonnull sample, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([sample[@"ParentSampleId"] isEqualToString:parentId]) {
            sampleExistInList = YES;
            index = idx;
        }
    }];
    
    if (sampleExistInList)
        [samples removeObjectAtIndex:index];
    
    if(arrDispense.count>0 )//&& txt_Number.text.length>0
    {
        NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
        [dictHist setObject:parentId forKey:@"ParentSampleId"];
        [dictHist setObject:arrDispense forKey:@"sample_ids"];
        
        [samples addObject:dictHist];
    }
}

#pragma mark - Webservice call
-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    //   stringUrl = [stringUrl stringByAddingPercentEncodingWithAllowedCharacters:URLHostAllowedCharacterSet];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    if(Params)
    {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:Params options:0 error:nil]; //[post dataUsingEncoding:NSASCIIStringEncoding];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"] forHTTPHeaderField:@"AuthToken"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
    }
    // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSURLRequest *requestURL = [[NSURLRequest alloc] init];
    requestURL = request.copy;
    
    
    // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@",dicYourResponse);
             [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"FromSample"];
             [self removeParamsItems];
             
             if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {
                 [[NSUserDefaults standardUserDefaults] setValue:[[dicYourResponse valueForKey:@"data"] valueForKey:@"receive_count"] forKey:@"RCount"];
                 [[NSUserDefaults standardUserDefaults] setValue:[[dicYourResponse valueForKey:@"data"] valueForKey:@"dispence_count"] forKey:@"DCount"];
                 [[NSUserDefaults standardUserDefaults] setValue:[[dicYourResponse valueForKey:@"data"] valueForKey:@"invent_count"] forKey:@"ICount"];
                 [[NSUserDefaults standardUserDefaults] setValue:[[dicYourResponse valueForKey:@"data"] valueForKey:@"unique_dispense_id"] forKey:@"Last_Dispesed_UniqueID"];
             }
             
             [[self navigationController] popToRootViewControllerAnimated:YES];
         }
     }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}


-(void)showAlertAddMoreSamples {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you have more samples to pull from inventory?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionYES = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction* actionNO = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        NSString* userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"];
        id params = @{@"userid":userId, @"samples": [InventDetailViewController samplesForDespense]};
        [self WebResponse:params WebserviceName:kDispenseSample];
    }];

    [alert addAction:actionNO];
    [alert addAction:actionYES];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(NSInteger)numberOffDaysFrom:(NSDate*)start toDate:(NSDate*)end {
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:start
                                                          toDate:end
                                                         options:0];
    return [components day];
}


@end
