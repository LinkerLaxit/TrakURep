//
//  Receive2ViewController.m
//  TrakURep
//
//  Created by MAC on 16/10/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "Receive2ViewController.h"
#import "Receive3ViewController.h"
@interface Receive2ViewController ()
{
    NSString* selectedDrugsName;
    
}
@end

@implementation Receive2ViewController


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"selectedName"] != nil){
        [_buttonName setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedName"] forState:UIControlStateNormal];
        selectedDrugsName = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectedName"];
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"selectedName"];
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification*)nf {
    CGSize keyboardSize = [[[nf userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    int height = MIN(keyboardSize.height,keyboardSize.width);
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, height, 0)];
    }];
}

- (void)keyboardWillHide:(NSNotification*)nf {
    [UIView animateWithDuration:0.3 animations:^{
        [_scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _view_mg.layer.borderWidth = 0.5;
    _view_mg.layer.borderColor= [UIColor lightGrayColor].CGColor;
    
    _view_Date.layer.borderWidth = 0.5;
    _view_Date.layer.borderColor= [UIColor lightGrayColor].CGColor;
    
    _view_LNum.layer.borderWidth = 0.5;
    _view_LNum.layer.borderColor= [UIColor lightGrayColor].CGColor;
    
    _view_Name.layer.borderWidth = 0.5;
    _view_Name.layer.borderColor= [UIColor lightGrayColor].CGColor;
    
    
    datePicker=[[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    
    [self.dateInput setInputView:datePicker];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.dateInput setInputAccessoryView:toolBar];

    
    UIToolbar *toolBar2=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *doneBtn2=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(nothing)];
    UIBarButtonItem *space2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar2 setItems:[NSArray arrayWithObjects:space2,doneBtn2, nil]];
    [_txt_mg setInputAccessoryView:toolBar2];

    [_txt_LotNumber setInputAccessoryView:toolBar2];
    _txt_mg.autocorrectionType = UITextAutocorrectionTypeNo;
    _txt_LotNumber.autocorrectionType = UITextAutocorrectionTypeNo;
    
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



-(void)nothing{
    [_txt_mg resignFirstResponder];
    [_txt_LotNumber resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textfeild delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _dt_Picker.hidden = true;
}

- (IBAction)btn_Receive_Action:(id)sender {

    if(_dateInput.text.length>0 && selectedDrugsName.length>0 && _txt_LotNumber.text.length>0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:_dateInput.text forKey:@"date"];
        [[NSUserDefaults standardUserDefaults] setValue:_txt_LotNumber.text forKey:@"lot"];
        [[NSUserDefaults standardUserDefaults] setValue:selectedDrugsName forKey:@"name"];
        [[NSUserDefaults standardUserDefaults] setValue:_txt_mg.text forKey:@"mg"];

        [self performSegueWithIdentifier:@"showReceiving3" sender:self];
    }
    else
    {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please enter all of the input fields." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (IBAction)dt_Selection:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    _txt_Date.text = [dateFormatter stringFromDate:_dt_Picker.date];
}
- (IBAction)btn_Close_action:(id)sender {
    _btn_Receive.hidden=false;
    _dt_Picker.hidden = true;
    _btn_close.hidden = true;
}


- (void) ShowSelectedDate{
    int ti = [datePicker.date timeIntervalSinceDate: [[NSDate alloc] init]];
    if(ti < 30*24*60*60){
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Make sure your expiration date is more than 30 days away." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _dateInput.text = [dateFormatter stringFromDate:datePicker.date];
    }
    [_dateInput resignFirstResponder];
}

- (IBAction)open_Date_Picker:(id)sender {
    _btn_Receive.hidden =true;
    _btn_close.hidden = false;
    [_txt_mg resignFirstResponder];
    [_txt_LotNumber resignFirstResponder];
}

- (IBAction)btn_Back_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}
@end
