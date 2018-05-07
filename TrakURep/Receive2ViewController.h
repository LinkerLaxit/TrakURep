//
//  Receive2ViewController.h
//  TrakURep
//
//  Created by MAC on 16/10/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Receive2ViewController : UIViewController{
    UIDatePicker* datePicker;
    NSTimer     *myidleTimer;
}

-(void)resetIdleTimer;



@property (weak, nonatomic) IBOutlet UIButton *buttonName;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextField *txt_LotNumber;
@property (strong, nonatomic) IBOutlet UITextField *txt_Date;
- (IBAction)btn_Receive_Action:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *txt_mg;
@property (strong, nonatomic) IBOutlet UIView *view_Name;
@property (strong, nonatomic) IBOutlet UIView *view_LNum;
@property (strong, nonatomic) IBOutlet UIView *view_Date;
@property (strong, nonatomic) IBOutlet UIView *view_mg;
@property (strong, nonatomic) IBOutlet UIDatePicker *dt_Picker;
@property (strong, nonatomic) IBOutlet UIButton *btn_Receive;

@property (weak, nonatomic) IBOutlet UITextField *dateInput;


@property (strong, nonatomic) IBOutlet UIButton *btn_close;
- (IBAction)dt_Selection:(id)sender;
- (IBAction)btn_Back_Action:(id)sender;

@end
