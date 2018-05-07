//
//  HistDetailViewController.h
//  TrakURep
//
//  Created by OSX on 12/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistDetailViewController : UIViewController
{
    NSMutableArray *arrSamples;
}
@property (strong, nonatomic) IBOutlet UILabel *lbl_Title;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *viewDispenseDate;

@property (strong, nonatomic) IBOutlet UITableView *tbl_Samples;
@property (strong, nonatomic) IBOutlet UIView *view_Bottom_Rep;
@property (strong, nonatomic) IBOutlet UIView *view_Bottom_Clinic;
@property (strong, nonatomic) IBOutlet UILabel *lbl_1;
@property (strong, nonatomic) IBOutlet UILabel *lbl_2;
@property (strong, nonatomic) IBOutlet UILabel *lbl_3;
@property (strong, nonatomic) IBOutlet UILabel *lbl_4;
@property (weak, nonatomic) IBOutlet UILabel *lblDispenseDate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1Top;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disDateHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disViewTop;


- (IBAction)btn_Back_Action:(id)sender;
- (IBAction)btn_History_action:(id)sender;
- (IBAction)btn_mesages_Action:(id)sender;
- (IBAction)btn_Samples_action:(id)sender;
- (IBAction)btn_inventory_atcion:(id)sender;
- (IBAction)btn_Profile_action:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewRepName;
@property (weak, nonatomic) IBOutlet UIView *viewComName;
@property (weak, nonatomic) IBOutlet UILabel *lblRepName;
@property (weak, nonatomic) IBOutlet UILabel *lblComName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *repViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *comNameViewHeight;

@end
