//
//  EditAddressViewController.m
//  TrakURep
//
//  Created by Darshit Vadodaria on 22/02/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import "EditAddressViewController.h"
#import "common.h"
#import "MBProgressHUD.h"

@interface EditAddressViewController ()

@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    stateID = @"";
    stateName =  @"";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return arrStates.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StatesCell"];
        cell.textLabel.text=[[arrStates objectAtIndex:indexPath.row] valueForKey:@"name"];
        return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    stateID = [[arrStates objectAtIndex:indexPath.row] valueForKey:@"stateid"];
    self.state.text =[[arrStates objectAtIndex:indexPath.row] valueForKey:@"name"];
    _tbl_States.hidden=TRUE;
}


- (IBAction)btn_States_Action:(id)sender {
    
    if(self.view.frame.origin.y<0)
        self.view.frame=CGRectMake( self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [_state resignFirstResponder];
    [_city resignFirstResponder];
    [_zipCode resignFirstResponder];
    [_addr1 resignFirstResponder];
    [_addr2 resignFirstResponder];
    
    if(arrStates.count==0)
    {
        arrStates=[[NSMutableArray alloc]init];
        [self WebResponse:nil WebserviceName:kStatesUrl];
    }
    else{
        _tbl_States.hidden=FALSE;
    }
}

- (IBAction)savePressed:(id)sender {
    NSString *add1 = [_addr1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *add2 = [_addr2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *zipCode = [_zipCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *city = [_city.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if(add1.length>0  && zipCode.length>0 && city.length>0 && stateID.length>0 )
    {
        
        if([self validateAlphabets:city])
        {
            ISUPdate = TRUE;
            
            NSMutableDictionary *dict = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDetails"] mutableCopy];
            [dict setObject:add1 forKey:@"address_1"];
            [dict setObject:add2 forKey:@"address_2"];
            [dict setObject:zipCode forKey:@"zipcode"];
            [dict setObject:city forKey:@"city"];
            [dict setObject:stateID forKey:@"state"];
            [dict setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
            [self WebResponse:dict WebserviceName:kEditProfile];
        }
        else{
            UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Error!" message:@"Please enter only alphabets in city field." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* CancelButton = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action) {
                                               
                                           }];
            
            [popup addAction:CancelButton];
            [self presentViewController:popup animated:YES completion:nil];
        }
        
    }
    else{
        UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Error!" message:@"Please Enter required fields." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* CancelButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           
                                       }];
        [popup addAction:CancelButton];
        [self presentViewController:popup animated:YES completion:nil];
    }
    
    
}

-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
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
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"data: %@",[[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
         
         if (data.length > 0 && connectionError == nil)
         {
             NSLog(@"%@",[[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             
             if (dicYourResponse) {
                 if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
                 {
                     if([WebserviceName isEqualToString:@"statelist"])
                     {
                         arrStates = [dicYourResponse valueForKey:@"data"];
                         [_tbl_States reloadData];
                         _tbl_States.hidden=false;
                     }
                     else{
                         if(ISUPdate) {
                             ISUPdate =FALSE;
                             NSMutableDictionary *dictParams=[[NSMutableDictionary alloc] init];
                             [dictParams setObject:[[dicYourResponse valueForKey:@"data"] valueForKey:@"userid"] forKey:@"userid"];
                             [self WebResponse:dictParams WebserviceName:kGetProfileUrl];
                         } else {
                             [[NSUserDefaults standardUserDefaults] setObject:[dicYourResponse valueForKey:@"data"] forKey:@"UserDetails"];
                             [[self navigationController] popToRootViewControllerAnimated:YES];
                         }
                     }
                     
                 }
             }
             
         }
         
     }];
}

-(BOOL) validateAlphabets: (NSString *)alpha
{
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    NSString *output = [alpha stringByTrimmingCharactersInSet:[myCharSet invertedSet]];
    BOOL isValid = [alpha isEqualToString:output];
    return isValid;
}

@end
