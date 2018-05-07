//
//  ClinicProfileViewController.m
//  TrakURep
//
//  Created by OSX on 11/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "ClinicProfileViewController.h"
#import "MBProgressHUD.h"
#import "ViewController.h"
#import "UIImageView+WebCache.h"

@interface ClinicProfileViewController ()

@end

@implementation ClinicProfileViewController

-(void)displayImage{
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserDetails"] count]>0)//&& ![[[NSUserDefaults standardUserDefaults] valueForKey:@"UserDetails"] isEqual:[NSNull null]]
    {
        NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserDetails"];
        //_img_Profile.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dict valueForKey:@"image"]]]];
        [_img_Profile sd_setImageWithURL:[NSURL URLWithString:[dict valueForKey:@"image"]]];
        _img_Profile.layer.cornerRadius=_img_Profile.frame.size.width/2;
        
        _img_Profile.layer.borderWidth=1.0 ;
        _img_Profile.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _img_Profile.layer.cornerRadius=_img_Profile.frame.size.width/2;
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [self displayImage];
    
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    //NSLog(@"wat %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"]);
    
    NSMutableDictionary *dictParams=[[NSMutableDictionary alloc] init];
    [dictParams setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [self WebResponse:dictParams WebserviceName:kGetProfileUrl];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    
    

        NSLog(@"wat %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"]);

    
        NSMutableDictionary *dictParams=[[NSMutableDictionary alloc] init];
        [dictParams setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
        [self WebResponse:dictParams WebserviceName:kGetProfileUrl];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnLogout_Action:(id)sender {
    
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Are you sure you want to logout." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                    NSMutableDictionary *dictParams=[[NSMutableDictionary alloc] init];
                                    [dictParams setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
                                    [self WebResponse:dictParams WebserviceName:kLogout];
                                    [self removeSettingsOnLogout];
                                    
                                    NSArray *arrViews=self.navigationController.viewControllers;
                                    ViewController *view;
                                    if([arrViews containsObject:view])
                                    {
                                        [self.navigationController popToRootViewControllerAnimated:TRUE];
                                    }
                                    else
                                    {
                                        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                                                 bundle: nil];
                                        UINavigationController *controller = (UINavigationController*)[mainStoryboard
                                                                                                       instantiateViewControllerWithIdentifier: @"NavProfile"];
                                        
                                        [[self navigationController] showViewController:controller sender:nil];
                                    }
                                
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                                actionWithTitle:@"No"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];

    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)removeSettingsOnLogout {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserType"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserDetails"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"dispensed"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"received"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Inventory"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UsersMsg"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"AccssToken"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"RCount"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"DCount"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"ICount"];
    [[NSUserDefaults standardUserDefaults] setObject:@"1234" forKey:@"uniqueclinicid"];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)btn_Settings_Action:(id)sender {
}

- (IBAction)btn_Dispensed_Action:(id)sender {
}

- (IBAction)btn_Received_Action:(id)sender {
}

- (IBAction)btn_Inventory_Action:(id)sender {
}





#pragma mark - Bottom Bar buttons Action

- (IBAction)btn_History_Action:(id)sender {
    [self performSegueWithIdentifier:@"ShowHistory" sender:self ];
}

- (IBAction)btn_Messages_action:(id)sender {
    [self performSegueWithIdentifier:@"ShowMessages" sender:self ];

}

- (IBAction)btn_Samples_Action:(id)sender {
    
    [self performSegueWithIdentifier:@"ShowSample" sender:self ];

}

- (IBAction)btn_Bottom_Inventory:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"FromSample"];

}
#pragma Mark - Webservice call
-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    //   stringUrl = [stringUrl stringByAddingPercentEncodingWithAllowedCharacters:URLHostAllowedCharacterSet];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    NSLog(@" token %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"]);
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
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"Response for API - %@ : \n%@",WebserviceName, dicYourResponse);
             if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {
                 
            

                 [_img_Profile sd_setImageWithURL:[NSURL URLWithString:[dicYourResponse valueForKey:@"image"]]];

             
                 _img_Profile.layer.cornerRadius=_img_Profile.frame.size.width/2;

                 _lbl_Clinic_Name.text=[[dicYourResponse valueForKey:@"data"] valueForKey:@"company_name"];
                 _lbl_email.text = [[dicYourResponse valueForKey:@"data"] valueForKey:@"email"];
                 
                 if([[[dicYourResponse valueForKey:@"data"] valueForKey:@"phone"] length]>0)
                 {
                 _lbl_Phone_Number.text=[NSString stringWithFormat:@"(%@)-%@-%@",[[[dicYourResponse valueForKey:@"data"] valueForKey:@"phone"] substringToIndex:3],[[[[dicYourResponse valueForKey:@"data"] valueForKey:@"phone"] substringFromIndex:3] substringToIndex:3],[[[dicYourResponse valueForKey:@"data"] valueForKey:@"phone"] substringFromIndex:6]];//[[dicYourResponse valueForKey:@"data"] valueForKey:@"phone"];
                 }
                 NSString *strAdd= [[dicYourResponse valueForKey:@"data"] valueForKey:@"address_1"];
                 if([[[dicYourResponse valueForKey:@"data"] valueForKey:@"address_2"] length]>0)
                 {
                     strAdd = [strAdd stringByAppendingFormat:@", %@",[[dicYourResponse valueForKey:@"data"] valueForKey:@"address_2"]];
                 }
                 if([[[dicYourResponse valueForKey:@"data"] valueForKey:@"city"] length]>0)
                 {
                     strAdd = [strAdd stringByAppendingFormat:@", %@",[[dicYourResponse valueForKey:@"data"] valueForKey:@"city"]];
                 }
                 if([[[dicYourResponse valueForKey:@"data"] valueForKey:@"statename"] length]>0)
                 {
                     strAdd = [strAdd stringByAppendingFormat:@", %@",[[dicYourResponse valueForKey:@"data"] valueForKey:@"statename"]];
                 }
                 if([[[dicYourResponse valueForKey:@"data"] valueForKey:@"zipcode"] length]>0)
                 {
                     strAdd = [strAdd stringByAppendingFormat:@", %@",[[dicYourResponse valueForKey:@"data"] valueForKey:@"zipcode"]];
                 }
                 _lbl_Address.text=strAdd;
                 
                 
                 [_btn_Green_Action setTitle:[[[dicYourResponse valueForKey:@"data"] valueForKey:@"dispense_count_green"] stringByAppendingString:@" samples over 90 days"] forState:UIControlStateNormal];
                 
                 [_btn_Yellow_Action setTitle:[[[dicYourResponse valueForKey:@"data"] valueForKey:@"dispense_count_yellow"] stringByAppendingString:@" samples between 31 - 90 days"] forState:UIControlStateNormal];
                 
                 [_btn_Red_Action setTitle:[[[dicYourResponse valueForKey:@"data"] valueForKey:@"dispense_count_red"] stringByAppendingString:@" samples under 31 days"] forState:UIControlStateNormal];

                 [[NSUserDefaults standardUserDefaults] setValue:[[dicYourResponse valueForKey:@"data"] valueForKey:@"receive_count"] forKey:@"RCount"];
                 [[NSUserDefaults standardUserDefaults] setValue:[[dicYourResponse valueForKey:@"data"] valueForKey:@"dispence_count"] forKey:@"DCount"];
                 [[NSUserDefaults standardUserDefaults] setValue:[[dicYourResponse valueForKey:@"data"] valueForKey:@"invent_count"] forKey:@"ICount"];

                 [_btn_Received setTitle:[[[dicYourResponse valueForKey:@"data"] valueForKey:@"receive_count"] stringByAppendingString:@" Samples Received"] forState:UIControlStateNormal];
                 [_btn_Dispensed setTitle:[[[dicYourResponse valueForKey:@"data"] valueForKey:@"dispence_count"] stringByAppendingString:@" Samples Dispensed"] forState:UIControlStateNormal];
                 [_btn_inventory setTitle:[[[dicYourResponse valueForKey:@"data"] valueForKey:@"invent_count"] stringByAppendingString:@" Samples In Inventory"] forState:UIControlStateNormal];
                 [[NSUserDefaults standardUserDefaults] setObject:[dicYourResponse valueForKey:@"data"] forKey:@"UserDetails"];
                 
                 [self displayImage];
             }
         }
         else
         {
      
             
         }
         
     }];
    
}


@end
