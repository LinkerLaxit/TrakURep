//
//  Receive3ViewController.m
//  TrakURep
//
//  Created by MAC on 16/10/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "Receive3ViewController.h"
#import "common.h"
#import "MBProgressHUD.h"
#import "SampleConfirmViewController.h"

@interface Receive3ViewController ()

@end

@implementation Receive3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lbl_Med_Name.text =  [[NSUserDefaults standardUserDefaults] valueForKey:@"name"];
    _txt_mg.text = [[[NSUserDefaults standardUserDefaults] valueForKey:@"mg"] stringByAppendingString:@" mg"];
    
    [_numberOfSamples setText:[[NSUserDefaults standardUserDefaults] valueForKey:@"number"]];

    
    [self resetIdleTimer];
}


-(void)sendEvent:(UIEvent *)event
{
    [self sendEvent:event];
    
    if (!myidleTimer)
    {
        [self resetIdleTimer];
    }
    
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0)
    {
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan)
        {
            [self resetIdleTimer];
        }
        
    }
}


//as labeled...reset the timer
-(void)resetIdleTimer
{
    if (myidleTimer)
    {
        [myidleTimer invalidate];
    }
    //convert the wait period into minutes rather than seconds
    int timeout =  3*60;
    myidleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
    
}
//if the timer reaches the limit as defined in kApplicationTimeoutInMinutes, post this notification
-(void)idleTimerExceeded
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}




//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
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

- (IBAction)btn_Tap_Action:(id)sender {
    NSArray *arrViews=self.navigationController.viewControllers;
    for(UIViewController *sample in arrViews)
    {
        if([sample isKindOfClass:[SampleConfirmViewController class]])
        {
             [self.navigationController popToViewController:sample animated:YES];
            break;
        }
    }
   
}
- (IBAction)btn_Yes_Action:(id)sender {
    
//    _view_Final.hidden=false;
//    _btn_Tap.hidden=false;
//    _vieW_Confirmation.hidden = true;
    
    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
    
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"name"] forKey:@"name"];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"number"] integerValue] == 0) {
        [dictHist setObject:@"1" forKey:@"amount"];
    }
    else 
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"number"] forKey:@"amount"];
    
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"date"] forKey:@"exp_date"];
    [dictHist setObject:@"" forKey:@"clinic_name"];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"lot"] forKey:@"alotid"];
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"sampleReceivedFromUserKey"] isEqualToString:@"clinic"])
        [dictHist setObject:@"" forKey:@"rep_id"];
    else
        [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"rep_id"] forKey:@"rep_id"];

    [self WebResponse:dictHist WebserviceName:kSaveSamples];
    
}

- (IBAction)btn_No_Action:(id)sender {
    _view_Final.hidden=true;
    _btn_Tap.hidden=true;
    _vieW_Confirmation.hidden = false;
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Webservice Call
-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
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
    
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         if (data.length > 0 && connectionError == nil)
         {
             NSLog(@"%@",[[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             
             if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {
                 [[NSUserDefaults standardUserDefaults] setValue:[[dicYourResponse valueForKey:@"data"] valueForKey:@"receive_count"] forKey:@"RCount"];
                 [[NSUserDefaults standardUserDefaults] setValue:[[dicYourResponse valueForKey:@"data"] valueForKey:@"dispence_count"] forKey:@"DCount"];
                 [[NSUserDefaults standardUserDefaults] setValue:[[dicYourResponse valueForKey:@"data"] valueForKey:@"invent_count"] forKey:@"ICount"];
                 
                 _view_Final.hidden=false;
                 _btn_Tap.hidden=false;
                 if([[Params valueForKey:@"amount"] intValue] == 1 || [[Params valueForKey:@"amount"] length] == 0)
                     _lbl_Titlr.text = @"One Sample Received";
                 else
                     _lbl_Titlr.text = [[Params valueForKey:@"amount"] stringByAppendingString:@" Samples Received"];
                 [[self navigationController] popToRootViewControllerAnimated:YES];
             } else {
                 NSString* errorMessage = [dicYourResponse valueForKey:@"message"];
                 [self showAlert:errorMessage];
             }
             
         }
         
     }];
    
    
}

-(void)showAlert:(NSString*)message {
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
    NSUInteger a ;
    a= [[[NSUserDefaults standardUserDefaults] valueForKey:@"number"] integerValue];
    if(a==0)
    {
        a=1;
    }
    return a;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HistoryCell"];
    cell.imageView.image=[UIImage imageNamed:@"SampleIcon2"];
    cell.textLabel.text = [@"Lot #" stringByAppendingString:[[NSUserDefaults standardUserDefaults] valueForKey:@"lot"]];
    cell.detailTextLabel.text = [@"Expiration Date: " stringByAppendingString:[[NSUserDefaults standardUserDefaults] valueForKey:@"date"]];
   
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [cell.detailTextLabel setNumberOfLines:0];
    return cell;
}


@end
