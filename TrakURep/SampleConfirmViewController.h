//
//  SampleConfirmViewController.h
//  TrakURep
//
//  Created by MAC on 16/10/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleConfirmViewController : UIViewController
- (IBAction)btn_Continue_Action:(id)sender;
- (IBAction)Slider_Value_changed:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *view_Id;
@property (strong, nonatomic) IBOutlet UITextField *txt_ID;
@property (strong, nonatomic) IBOutlet UIView *uinView;
@property (strong, nonatomic) IBOutlet UIButton *uinCloseBtn;
@property (strong, nonatomic) IBOutlet UIButton *radioBtnRepID;
@property (strong, nonatomic) IBOutlet UIButton *radioBtnClinicID;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblSampleWidth;

- (IBAction)btn_Inventory_Action:(id)sender;
- (IBAction)btn_Sample_Action:(id)sender;
- (IBAction)btn_closeUINView_action:(id)sender;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segment_cntrl;

@property (weak, nonatomic) IBOutlet UILabel *dispensedUniqIDLabel;
@end
