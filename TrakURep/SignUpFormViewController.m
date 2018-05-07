//
//  SignUpFormViewController.m
//  TrakURep
//
//  Created by OSX on 06/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "SignUpFormViewController.h"
#import "MBProgressHUD.h"
#import "UIImage+fixOrientation.h"

@interface SignUpFormViewController ()

@end

@implementation SignUpFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _view_Form_1.hidden = NO;
    _view_Form_2.hidden = YES;
    
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"Email *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.Email.attributedPlaceholder = str;
    
    NSAttributedString *confirmEmail = [[NSAttributedString alloc] initWithString:@"Confirm Email *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.txt_confirmEmail.attributedPlaceholder = confirmEmail;
    
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Password *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.Password.attributedPlaceholder = str1;
    
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Confirm Password *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.ConfirmPass.attributedPlaceholder = str2;
    
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"Clinic Name *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.ClinicName.attributedPlaceholder = str3;
    
    NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:@"Institution Address 1*" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.addr1.attributedPlaceholder = str4;
    
    NSAttributedString *str5 = [[NSAttributedString alloc] initWithString:@"Institution Address 2" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.addr2.attributedPlaceholder = str5;
    
    NSAttributedString *str6 = [[NSAttributedString alloc] initWithString:@"Zip Code *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.zipCode.attributedPlaceholder = str6;
    
    NSAttributedString *str7 = [[NSAttributedString alloc] initWithString:@"City *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.city.attributedPlaceholder = str7;
    
    NSAttributedString *str8 = [[NSAttributedString alloc] initWithString:@"State *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.state.attributedPlaceholder = str8;
    
    NSAttributedString *str9 = [[NSAttributedString alloc] initWithString:@"Institution Phone Number *" attributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] }];
    self.institutionPhnNumber.attributedPlaceholder = str9;
    
    _tbl_States.layer.cornerRadius = 5;
    _tbl_States.layer.borderWidth = 1.0;
    _tbl_States.layer.borderColor = [UIColor blackColor].CGColor;
    _tbl_States.clipsToBounds = YES;
    
    [self setTermsConditionText];
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tapLabel:)];
    [_lblTermsCondition addGestureRecognizer:gest];
    [_lblTermsCondition setUserInteractionEnabled:YES];

}


-(void)setTermsConditionText {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"By signing in, you are agreeing to our "];
    
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Terms and Conditions"
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSBackgroundColorAttributeName: [UIColor clearColor]}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" and "]];
    
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"Privacy Policy"
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSBackgroundColorAttributeName: [UIColor clearColor]}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@". Please go to our website, "]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"www.trakurep.com"
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSBackgroundColorAttributeName: [UIColor clearColor]}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" to review the documents."]];
    _lblTermsCondition.attributedText = attributedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_Back_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (IBAction)btn_Profile_Pic_Action:(id)sender {
    // UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Photo Library",nil];
    UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Select Picture" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:@"Photo Library"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                       //picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,kUTTypeImage,nil];
                                       
                                       picker.delegate = self;
                                       picker.editing = YES;
                                       picker.allowsEditing = YES;
                                       
                                       picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                       [self presentViewController:picker animated:YES completion:NULL];
                                   }];
    
    
    [popup addAction:CancelButton];
    
    UIAlertAction* TakeButton = [UIAlertAction
                                 actionWithTitle:@"Take Photo"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                                     {
                                         UIImagePickerController* picker = [[UIImagePickerController alloc] init];
                                         picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                         // picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,kUTTypeImage,nil];
                                         
                                         picker.delegate = self;
                                         [self presentViewController:picker animated:YES completion:NULL];
                                     }
                                     else
                                     {
                                         UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Camera Not Available" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
                                         UIAlertAction* CancelButton = [UIAlertAction actionWithTitle:@"OK"                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                         }];
                                         [popup addAction:CancelButton];
                                         
                                         [self presentViewController:popup animated:YES completion:nil];
                                         
                                         
                                         
                                     }
                                     
                                 }];
    
    
    [popup addAction:TakeButton];
    
    UIAlertAction* libraryButton = [UIAlertAction
                                    actionWithTitle:@"Cancel"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
    
    
    [popup addAction:libraryButton];
    
    
    [self presentViewController:popup animated:YES completion:nil];
    
}

#pragma mark - Form Validation methods

-(BOOL)ValidateForm1 {
    
    NSString* email = [_Email.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* confEmail = [_txt_confirmEmail.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* pasword = [_Password.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* confPassword = [_ConfirmPass.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* clinicName = [_ClinicName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if(Pimagedata.length == 0) {
        [self showAlert:@"Please choose a profile picture."];
        return NO;
    }
    
    if((email.length == 0) || ![self IsValidEmail:email])  {
        [self showErrorAlert:@"Please enter a valid email address."];
        return NO;
    }
    
    if(![email isEqualToString:confEmail]) {
        [self showErrorAlert:@"Email and confirm email does not match."];
        return NO;
    }
    
    if((pasword.length == 0) || ![self isValidPassword:pasword]) {
        [self showErrorAlert:@"Your password must include at least 10 characters, one capital letter, one number, and one special character."];
        return NO;
    }
    
    if(![pasword isEqualToString:confPassword]) {
        [self showErrorAlert:@"Password and confirm password does not match."];
        return NO;
    }

    if(clinicName.length == 0) {
        [self showErrorAlert:@"Please enter your clinic name."];
        return NO;
    }
    
    if(!isAgreed) {
        [self showErrorAlert:@"Please accept to the app's Terms of services."];
        return NO;
    }
    
    return YES;
    
}

-(BOOL)validateForm2 {
    
    NSString* address1 = [_addr1.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* city = [_city.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* zipCode = [_zipCode.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* contactNumber = [_institutionPhnNumber.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* state = [_state.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if(address1.length == 0) {
        [self showErrorAlert:@"Please enter your address."];
        return NO;
    }
    
    if(zipCode.length == 0) {
        [self showErrorAlert:@"Please enter zip code."];
        return NO;
    }

    if(city.length == 0) {
        [self showErrorAlert:@"Please enter your city name."];
        return NO;
    }
    
    if(state.length == 0) {
        [self showErrorAlert:@"Please select your state."];
        return NO;
    }
    
    if(contactNumber.length != 10) {
        [self showErrorAlert:@"Institution phone number must be 10 digits."];
        return NO;
    }

    return YES;
    
}

#pragma mark - IBAction Methods

- (IBAction)btn_Continue_action:(id)sender {
    if([self ValidateForm1]) {
        
        NSString* email = [_Email.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:email forKey:@"email"];
        [self WebResponse:dict WebserviceName:kCheckEmail];
        
    }
    
}

- (IBAction)btn_Continue2_action:(id)sender {
    
    if([self validateForm2]) {
        
        NSString* email = [_Email.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* pasword = [_Password.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* clinicName = [_ClinicName.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* address1 = [_addr1.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* address2 = [_addr2.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* city = [_city.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* zipCode = [_zipCode.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString* contactNumber = [_institutionPhnNumber.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

        NSString *baseString= [Pimagedata base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:email forKey:@"email"];
        [dict setObject:pasword forKey:@"password"];
        [dict setObject:clinicName forKey:@"company_name"];
        [dict setObject:address1 forKey:@"address_1"];
        [dict setObject:address2 forKey:@"address_2"];
        [dict setObject:zipCode forKey:@"zipcode"];
        [dict setObject:city forKey:@"city"];
        [dict setObject:contactNumber forKey:@"phone"];
        [dict setValue:stateID forKey:@"state"];
        [dict setObject:@"3" forKey:@"user_type_id"];
        
        if([[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"])
            [dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceToken"] forKey:@"device_id"];
        
        if(baseString)
            [dict setObject:baseString forKey:@"image"];
        
        [self WebResponse:dict WebserviceName:kRegistrationUrl];
        
    }
    
}

- (IBAction)btn_Tick_action:(id)sender {
    UIButton *btn_Tick= (UIButton *)sender;
    if(btn_Tick.isSelected)
    {
        isAgreed =FALSE;
        btn_Tick.selected=FALSE;
    }
    else
    {
        isAgreed=TRUE;
        btn_Tick.selected=TRUE;
    }
}


- (IBAction)btn_States_Action:(id)sender {
    
    if(self.view.frame.origin.y<0)
        self.view.frame=CGRectMake( self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [_state resignFirstResponder];
    [_ClinicName resignFirstResponder];
    [_city resignFirstResponder];
    [_zipCode resignFirstResponder];
    [_addr1 resignFirstResponder];
    [_addr2 resignFirstResponder];
    [_ConfirmPass resignFirstResponder];
    [_Email resignFirstResponder];
    [_institutionPhnNumber resignFirstResponder];
    [_Password resignFirstResponder];
    
    if(arrStates.count==0)
    {
        arrStates=[[NSMutableArray alloc]init];
        [self WebResponse:nil WebserviceName:kStatesUrl];
    }
    else{
        _tbl_States.hidden=false;
    }
}

#pragma mark - image picker delegate


- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo{
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage* img = [image fixOrientation];

    Pimagedata = UIImageJPEGRepresentation(img, 0.3);
    
    
    [_btn_Profile setBackgroundImage:image forState:UIControlStateNormal];
    
    
}
#pragma mark -  email/password validation
-(BOOL)IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL)isValidPassword:(NSString *)passwordString
{
    NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@#$!%*?&])[A-Za-z\\d$#@$!%*?&]{10,}";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [passwordTest evaluateWithObject:passwordString];
}
-(BOOL) validateAlphabets: (NSString *)alpha
{
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    NSString *output = [alpha stringByTrimmingCharactersInSet:[myCharSet invertedSet]];
    
    BOOL isValid = [alpha isEqualToString:output];
    return isValid;
}



#pragma mark - table view delegate and data source methods
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
    _state.text=[[arrStates objectAtIndex:indexPath.row] valueForKey:@"name"];
    _tbl_States.hidden=TRUE;
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
         
         if (data.length > 0 && connectionError == nil)
         {
             
             
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@",dicYourResponse);
             if(dicYourResponse == nil) {
                 [self showErrorAlert: @"Something went wrong!"];
                 
             } else if([[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"]) {
                 [self showErrorAlert: [dicYourResponse valueForKey:@"message"]];
             }
             else
             {
                 if([WebserviceName isEqualToString:@"statelist"]) {
                     arrStates = [dicYourResponse valueForKey:@"data"];
                     [_tbl_States reloadData];
                     _tbl_States.hidden=false;
                 }
                 else if([WebserviceName isEqualToString:@"checksignupemail"]) {
                     
                     _view_Form_1.hidden = YES;
                     _view_Form_2.hidden = NO;
                     
                 }
                 else {
                     [[NSUserDefaults standardUserDefaults] setObject:[[dicYourResponse valueForKey:@"data"] valueForKey:@"userid"] forKey:@"UserId"];
                     [[NSUserDefaults standardUserDefaults] setObject:@"Clinic" forKey:@"UserType"];
                     [[NSUserDefaults standardUserDefaults] setObject:[[dicYourResponse valueForKey:@"data"] valueForKey:@"access_token"] forKey:@"AccssToken"];
                     //[self performSegueWithIdentifier:@"ShowWaitScreen" sender:self];
                     [self.navigationController popToRootViewControllerAnimated:YES];
                     [self showAlert:@"Your account has been created successfully and it may take up to 48 hours for access to be reviewed. Please check your registered email address for access status."];
                     
                 }
                 
             }
         }
         else{
             [self showErrorAlert:[connectionError description]];
         }
     }];
    
}


#pragma mark - Alert Methods

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

-(void)showAlert:(NSString*)message {
    UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"TrakURep" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
    
    
    [popup addAction:CancelButton];
    [self presentViewController:popup animated:YES completion:nil];
}


#pragma mark - Touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(self.view.frame.origin.y<0)
        self.view.frame=CGRectMake( self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    [_state resignFirstResponder];
    [_ClinicName resignFirstResponder];
    [_city resignFirstResponder];
    [_zipCode resignFirstResponder];
    [_addr1 resignFirstResponder];
    [_addr2 resignFirstResponder];
    [_ConfirmPass resignFirstResponder];
    [_Email resignFirstResponder];
    [_institutionPhnNumber resignFirstResponder];
    [_Password resignFirstResponder];
    
}
#pragma mark - textfeild delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //if(self.view.frame.origin.y<0)
    //self.view.frame=CGRectMake( self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [textField resignFirstResponder];
    
    
    
    return TRUE;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.layer.borderWidth = 0.0;
    textField.layer.borderColor = [UIColor clearColor].CGColor;
    if(textField == _institutionPhnNumber || textField == _ClinicName)
    {
        //if(self.view.frame.origin.y>=0)
        //self.view.frame=CGRectMake(self.view.frame.origin.x, -120, self.view.frame.size.width, self.view.frame.size.height);
        
    }
    return true;
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return true;
}



-(void)tapLabel:(UITapGestureRecognizer*)gesture {
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"By signing in, you are agreeing to our Terms and Conditions and Privacy Policy. Please go to our website, www.trakurep.com to review the documents."];
    NSRange termsRange = [text.string rangeOfString:@"Terms and Conditions"];
    NSRange privacyRange = [text.string rangeOfString:@"Privacy Policy"];
    NSRange webRange = [text.string rangeOfString:@"www.trakurep.com"];

    if([self isTappedAtTextInLabel:_lblTermsCondition gesture:gesture textRange:termsRange]) {
        
        NSLog(@"Terms and Conditions");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://admin.trakurep.com/termsconditions_trakurep.pdf"]];
        
    } else if([self isTappedAtTextInLabel:_lblTermsCondition gesture:gesture textRange:privacyRange]) {
        
        NSLog(@"Privacy Policy");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://admin.trakurep.com/privacy_policy.pdf"]];
        
        
    } else if([self isTappedAtTextInLabel:_lblTermsCondition gesture:gesture textRange:webRange]) {
        
        NSLog(@"www.trakurep.com");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.trakurep.com/"]];
        
    } else {
        NSLog(@"Other location tapped");
        
    }
}

-(Boolean)isTappedAtTextInLabel:(UILabel*)lable gesture:(UIGestureRecognizer*)gesture textRange:(NSRange)targetRange {
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc]init];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:lable.attributedText];
    
    [layoutManager addTextContainer:textContainer];
    [textStorage addLayoutManager:layoutManager];
    
    textContainer.lineFragmentPadding = 0.0;
    textContainer.lineBreakMode = lable.lineBreakMode;
    textContainer.maximumNumberOfLines = lable.numberOfLines;
    CGSize labelSize = lable.bounds.size;
    textContainer.size = labelSize;
    
    
    CGPoint locationOfTouchInLabel = [gesture locationInView:lable];
    CGRect textbondingBox = [layoutManager usedRectForTextContainer:textContainer];
    
    CGPoint textContainerOffset = CGPointMake((labelSize.width - textbondingBox.size.width) * 0.5 - textbondingBox.origin.x, (labelSize.height - textbondingBox.size.height) * 0.5 - textbondingBox.origin.y);
    
    CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                     locationOfTouchInLabel.y - textContainerOffset.y);
    NSUInteger indexOfCharacter = [layoutManager characterIndexForPoint:locationOfTouchInTextContainer inTextContainer:textContainer fractionOfDistanceBetweenInsertionPoints:nil];
    
    return NSLocationInRange(indexOfCharacter, targetRange);
}
@end
