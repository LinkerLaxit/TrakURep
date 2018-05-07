//
//  HistDetailViewController.m
//  TrakURep
//
//  Created by OSX on 12/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "HistDetailViewController.h"
#import "SampleTableCell.h"
#import "MBProgressHUD.h"
#import "common.h"

@interface HistDetailViewController ()

@end

@implementation HistDetailViewController


-(NSString*)convertDate:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date  = [dateFormatter dateFromString:dateString];
    // Convert to new Date Format
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *newDate = [dateFormatter stringFromDate:date];
    return newDate;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setTitle:@"Details"];
    
    [_tbl_Samples setTableFooterView:[[UIView alloc]init]];
    [_tbl_Samples setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"HistDetail"]);
    NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults] valueForKey:@"HistDetail"];
  
    _lbl_Title.text=[dict valueForKey:@"name"];
    arrSamples=[[NSMutableArray alloc] init];
   
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"])
    {
        [self fetchHistoryDetail];
//        [arrSamples addObjectsFromArray:[dict valueForKey:@"sample_id"]];
        //[self sortSamplesByDateCreated];
        NSString *newDate = [self convertDate:[dict valueForKey:@"createdate"]];
        
        _lblRepName.text = [dict valueForKey:@"company_name"];
        _lblComName.text=  [NSString stringWithFormat:@"Transaction ID : %@",[dict valueForKey:@"trans_id"]]; //transcationid
        
        _lbl_1.text =  [NSString stringWithFormat:@"Lot #%@", [dict valueForKey:@"alotno"]];
        _lbl_2.text = [NSString stringWithFormat:@"Transaction Date: %@", newDate];
        _viewRepName.hidden = NO;
        _lblRepName.hidden = NO;
        _viewDispenseDate.hidden = YES;
        _disViewTop.constant = 0.0;
        _disDateHeight.constant = 0.0;
        [self.view layoutIfNeeded];

    }
    else
    {
        [self fetchHistoryDetail];

        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"key"] isEqualToString:@"D"]) {
            _lbl_1.text=[@"Unique Identification #: " stringByAppendingString:[dict valueForKey:@"unique_dispense_id"]];
            _lbl_2.text = [NSString stringWithFormat:@"Samples Dispensed: %@",[dict valueForKey:@"amount"]];
            _viewDispenseDate.hidden = FALSE;
            _disViewTop.constant = 4.0;
            _disDateHeight.constant = 45.0;
            _view1.hidden = FALSE;
            _view1Top.constant = 4.0;
            _view1Height.constant = 45.0;
            
           
            [self.view layoutIfNeeded];
            if (arrSamples.count > 0){
                id sample = [arrSamples objectAtIndex:0];
                _lblDispenseDate.text = [self createdDateStringFromSample:sample];
            }
            else{
                _lblDispenseDate.text = @"";
            }
            
        }
        else {
            _lbl_1.text=[@"Transaction ID: " stringByAppendingString:[dict valueForKey:@"trans_id"]];
            _lbl_2.text = [NSString stringWithFormat:@"Samples Received: %@", [dict valueForKey:@"amount"]];
            [_view3 removeFromSuperview];
            _viewDispenseDate.hidden = YES;
            _disViewTop.constant = 0.0;
            _disDateHeight.constant = 0.0;
            _view1.hidden = TRUE;
            _view1Top.constant = 0.0;
            _view1Height.constant = 0.0;
            [self.view layoutIfNeeded];
        }

        _view_Bottom_Rep.hidden=true;
         _view_Bottom_Clinic.hidden=false;
        _comNameViewHeight.constant = 45.0;
        _repViewHeight.constant = 45.0;
        _viewRepName.hidden = false;
        _viewComName.hidden = false;
        
        NSString *repName = [[dict valueForKey:@"rep_name"] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if([repName isEqualToString:@""]) {
            _repViewHeight.constant = 0;
        }
        _lblRepName.text = [dict valueForKey:@"rep_name"];
        _lblComName.text = [dict valueForKey:@"company_name"];
    }
    
}

-(void)sortSamplesByDateCreated {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd/yyyy";
    
     [arrSamples sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
         NSDate *d1 = [df dateFromString: [obj1 valueForKey:@"exp_date"]];
         NSDate *d2 = [df dateFromString: [obj2 valueForKey:@"exp_date"]];
         return [d1 compare: d2];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_Back_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:FALSE];
}

- (IBAction)btn_History_action:(id)sender {
    [self.navigationController popViewControllerAnimated:FALSE];
}

- (IBAction)btn_mesages_Action:(id)sender {
}

- (IBAction)btn_Samples_action:(id)sender {
}

- (IBAction)btn_inventory_atcion:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"FromSample"];

}

- (IBAction)btn_Profile_action:(id)sender {
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"])
    {
        [self performSegueWithIdentifier:@"showRepProfile" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"showClinicProfile" sender:self];
    }
}
- (IBAction)btn_ChatDetail_Action:(id)sender {
    NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults] valueForKey:@"HistDetail"];
    NSString *strUserID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"]];
    NSString *strRepID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"rep_id"]];
    if([strRepID isEqualToString:strUserID]){
        return;
    }
    
    [self verifyClinicIDAndNavigateToChatScreen];
}

-(void)fetchHistoryDetail{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults] valueForKey:@"HistDetail"];
    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dictHist setObject:[dict valueForKey:@"ParentSampleId"] forKey:@"ParentSampleId"];
    [dictHist setObject:[dict valueForKey:@"alotno"] forKey:@"alotno"];
    //if([[[NSUserDefaults standardUserDefaults] valueForKey:@"key"] isEqualToString:@"D"])
        [dictHist setObject:[dict valueForKey:@"unique_dispense_id"] forKey:@"unique_dispense_id"];
    [self WebResponse:dictHist WebserviceName:kGetHistoryDetailUrl];
}



-(void)verifyClinicIDAndNavigateToChatScreen {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Verify Your Clinic ID" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"Enter your Clinic ID here"];
    }];
    
    UIAlertAction *verifyAction = [UIAlertAction actionWithTitle:@"Verify" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = alert.textFields.firstObject;
        NSString *enteredClinicID = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *userClinicID = [[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueclinicid"];
        if([enteredClinicID isEqualToString:userClinicID]) {
           
            NSMutableDictionary *dict=[[NSUserDefaults standardUserDefaults] valueForKey:@"HistDetail"];

            [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"image"] forKey:@"FImage"];
            [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"rep_name"] forKey:@"FriendName"];
            [[NSUserDefaults standardUserDefaults] setValue:[dict valueForKey:@"rep_id"] forKey:@"FriendID"];
            
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"chatViewController"];
            [self.navigationController pushViewController:vc animated:TRUE];
            
        } else {
            [self showErrorAlert:@"You have entered wrong Clinic ID"];
        }
        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:cancelAction];
    [alert addAction:verifyAction];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)showErrorAlert:(NSString*)message {
    UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Error!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
    
    
    [popup addAction:CancelButton];
    [self presentViewController:popup animated:YES completion:nil];
}

#pragma mark - table view delegate and data source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrSamples.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SampleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sampleCell"];
    id sample = [arrSamples objectAtIndex:indexPath.row];
    
    cell.lblLot.text = [@"Lot #"stringByAppendingString:[sample valueForKey:@"alotid"]];
    cell.imgPil.image = [UIImage imageNamed:@"SampleICon"];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"])
        cell.lblTransactionID.text = @"";//[NSString stringWithFormat:@"Transaction ID: %@",[sample objectForKey:@"transaction_id"]];
    else
        cell.lblTransactionID.text = [NSString stringWithFormat:@"Transaction ID: %@",[sample objectForKey:@"transaction_id"]];
    
    cell.lblExpDate.text = [NSString stringWithFormat:@"EXP DATE:  %@", [sample valueForKey:@"exp_date"]];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"]) {
         cell.lblCreatedDate.text = [self createdDateStringFromSample:sample];
    } else {
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"key"] isEqualToString:@"D"]) {
            cell.lblCreatedDate.text = @"";
        } else {
            cell.lblCreatedDate.text = [self createdDateStringFromSample:sample];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

-(NSString*)createdDateStringFromSample:(id)sample {
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"]) {
        return [NSString stringWithFormat:@"Dispensed Date: %@",[self convertDate:[sample valueForKey:@"created"]]];
    } else {
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"key"] isEqualToString:@"D"]) {
            
            return [NSString stringWithFormat:@"Dispensed Date: %@",[self convertDate:[sample valueForKey:@"updatedate"]]];
        } else {
            return [NSString stringWithFormat:@"Received Date: %@",[self convertDate:[sample valueForKey:@"created"]]];
        }
    }
}


#pragma mark - Webservice call
-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    NSLog(@"Access Token Here");
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"]);
    
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
    NSURLRequest *requestURL = [[NSURLRequest alloc] init];
    requestURL = request.copy;
    
    
    // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         NSLog(@"datastring: %@",[[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@",dicYourResponse);
             if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {
                 arrSamples=[[NSMutableArray alloc] init];
                 
                 if([[[NSUserDefaults standardUserDefaults] valueForKey:@"key"] isEqualToString:@"D"]) {
                     if([[[dicYourResponse valueForKey:@"data"] valueForKey:@"DISPENSE"] count]>0){
                         arrSamples = [(NSMutableArray*)[[dicYourResponse valueForKey:@"data"] valueForKey:@"DISPENSE"]valueForKey: @"sample_id"];
                     }
                     if (arrSamples.count > 0){
                         id sample = [arrSamples objectAtIndex:0];
                         _lblDispenseDate.text = [self createdDateStringFromSample:sample];
                     }
                     else{
                         _lblDispenseDate.text = @"";
                     }
                     
                 }
                 else{
                     if([[[dicYourResponse valueForKey:@"data"] valueForKey:@"RECEIVED"] count]>0){
                         arrSamples = [(NSMutableArray*)[[dicYourResponse valueForKey:@"data"] valueForKey:@"RECEIVED"]valueForKey: @"sample_id"];
                     }
                 }
                 //[self sortSamplesByDateCreated];
                 [_tbl_Samples reloadData];
            }
        }
     }];
    
}
@end
