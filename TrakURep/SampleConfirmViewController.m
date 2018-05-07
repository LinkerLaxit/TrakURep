//
//  SampleConfirmViewController.m
//  TrakURep
//
//  Created by MAC on 16/10/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "SampleConfirmViewController.h"
#import "common.h"
#import "MBProgressHUD.h"
#import "Receive1ViewController.h"

@interface SampleConfirmViewController (){
    NSTimer* timer;
}
@property (strong, nonatomic) IBOutlet UIView *view_Confirm;

@end

@implementation SampleConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _view_Confirm.layer.borderWidth = 0.5;
    _view_Confirm.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    _view_Id.layer.borderWidth = 0.5;
    _view_Id.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(nothing)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [_txt_ID setInputAccessoryView:toolBar];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString* uniqueID = [[NSUserDefaults standardUserDefaults] valueForKey:@"Last_Dispesed_UniqueID"];
    if (uniqueID) {
        _dispensedUniqIDLabel.text = [NSString stringWithFormat:@"Unique Identification Number \n%@", uniqueID];
        [_uinView setHidden:NO];
        [_uinCloseBtn setHidden:NO];
    } else {
        _dispensedUniqIDLabel.text = @"";
        [_uinView setHidden:YES];
        [_uinCloseBtn setHidden:YES];
    }
    
    _lblSampleWidth.constant = (UIScreen.mainScreen.bounds.size.width == 320.0) ? 132.0 : 153.0 ;
    [self.view layoutIfNeeded];
                                
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Last_Dispesed_UniqueID"];
}
-(void)nothing{
    [_txt_ID resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btn_closeUINView_action:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"TrakURep" message:@"Do you want to clear Unique Identification number?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_uinView setHidden:YES];
        [_uinCloseBtn setHidden:YES];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"Last_Dispesed_UniqueID"];

    }];
    
    UIAlertAction *actionNO = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];

    [alert addAction:actionNO];
    [alert addAction:actionYes];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)btn_Continue_Action:(id)sender {
    [_txt_ID resignFirstResponder];
    if(_segment_cntrl.selectedSegmentIndex == 0)
    {
        [self verifyClinicID];
    } else {
        id ID = [_txt_ID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if([ID length] > 0) {
            if(_radioBtnRepID.isSelected) { //For Rep User
                [[NSUserDefaults standardUserDefaults] setValue:@"Rep" forKey:@"sampleReceivedFromUserKey"];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
                [dict setObject:ID forKey:@"rep_id"];
                [self WebResponse:dict WebserviceName:kCheckRepID];
                
            } else { //For Clinic User
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueclinicid"] isEqualToString:ID]) {
                    id vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Receive1ViewController"];
                    [[NSUserDefaults standardUserDefaults] setValue:@"clinic" forKey:@"sampleReceivedFromUserKey"];
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    [self showErrorAlert:@"Your Clinic ID is incorrect."];
                }
            }
        } else {
            NSString* message = _radioBtnRepID.isSelected ? @"Please enter Representative ID." : @"Please enter Clinic ID.";
            [self showErrorAlert: message];
        }

    }
    
}


- (void)showErrorAlert:(NSString*)message {
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Error!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                }];
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)Slider_Value_changed:(id)sender {
    UISegmentedControl *sldr = sender;
    if(sldr.selectedSegmentIndex == 0 )
    {
        _view_Id.hidden = true;
    }
    else
    {
        _view_Id.hidden = false;
    }
}
    
- (IBAction)btn_Inventory_Action:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"FromSample"];

    [self performSegueWithIdentifier:@"ShowInventory" sender:self];
}

- (IBAction)btn_Sample_Action:(id)sender {

}

-(IBAction)radioBtnClicked:(UIButton*)sender {
    [_radioBtnRepID setSelected:NO];
    [_radioBtnClinicID setSelected:NO];
    [sender setSelected:YES];
}

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
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"repdata: %@", [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);
         if (data.length > 0 && connectionError == nil)
         {
             
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];

             if([[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {
                 UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Alert!" message:[dicYourResponse valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* yesButton = [UIAlertAction
                                             actionWithTitle:@"OK"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                             }];
                 
                 [alert addAction:yesButton];
                 
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }
             else
             {
                 //_txt_ID.text = @"";
                 [self setTimerForRemoveRepIdFromTextfield];
                 
               

                 [[NSUserDefaults standardUserDefaults] setValue:[dicYourResponse valueForKey:@"name"] forKey:@"verifyname"];
                 [[NSUserDefaults standardUserDefaults] setValue:[dicYourResponse valueForKey:@"message"] forKey:@"message"];
                 [[NSUserDefaults standardUserDefaults] setValue:[dicYourResponse valueForKey:@"image"] forKey:@"verifyimage"];
                 [[NSUserDefaults standardUserDefaults] setValue:[Params valueForKey:@"rep_id"] forKey:@"rep_id"];
                 UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                          bundle: nil];
                 
                 UIViewController *controller = (Receive1ViewController*)[mainStoryboard
                                                                    instantiateViewControllerWithIdentifier: @"VerifyIdentityViewController"];
                 
                 [[self navigationController] showViewController:controller sender:nil];
                 
             }
         }
         else{
             UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Error!" message:[connectionError description] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction* yesButton = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             //Handle your yes please button action here
                                         }];
             
             
             [alert addAction:yesButton];
             
             [self presentViewController:alert animated:YES completion:nil];
             
         }
     }];
    
}


-(IBAction)txtRepIDDidChagneText:(id)sender {
    [self setTimerForRemoveRepIdFromTextfield];
}

-(void)setTimerForRemoveRepIdFromTextfield {
    if(timer)
        [timer invalidate];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:300 repeats:NO block:^(NSTimer * _Nonnull timer) {
        _txt_ID.text = @"";
        [timer invalidate];
    }];
}

-(void)verifyClinicID {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Verify Your Clinic ID" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"Enter your Clinic ID here"];
    }];
    
    UIAlertAction *verifyAction = [UIAlertAction actionWithTitle:@"Verify" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = alert.textFields.firstObject;
        NSString *enteredClinicID = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSString *userClinicID = [[NSUserDefaults standardUserDefaults] valueForKey:@"uniqueclinicid"];
        if([enteredClinicID isEqualToString:userClinicID]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"Yes" forKey:@"FromSample"];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                     bundle: nil];
            Receive1ViewController *controller = (Receive1ViewController*)[mainStoryboard
                                                                           instantiateViewControllerWithIdentifier: @"InventoryViewController"];
            [[self navigationController] showViewController:controller sender:nil];

        } else {
            [self showErrorAlert:@"You have entered wrong Clinic ID"];
        }
        

    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:verifyAction];
    [self presentViewController:alert animated:YES completion:nil];
}



@end
