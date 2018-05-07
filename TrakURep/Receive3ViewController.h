//
//  Receive3ViewController.h
//  TrakURep
//
//  Created by MAC on 16/10/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Receive3ViewController : UIViewController{
    NSTimer     *myidleTimer;
}


-(void)resetIdleTimer;


- (IBAction)btn_Tap_Action:(id)sender;
@property (strong,nonatomic) NSString *strDt, *strName, *strLot,*_strNumber;
@property (strong, nonatomic) IBOutlet UITableView *tbl_Receive;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Titlr;
@property (strong, nonatomic) IBOutlet UIView *view_Final;
@property (strong, nonatomic) IBOutlet UIView *vieW_Confirmation;
- (IBAction)btn_Yes_Action:(id)sender;
- (IBAction)btn_No_Action:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_Tap;
@property (strong, nonatomic) IBOutlet UITextField *txt_mg;
@property (weak, nonatomic) IBOutlet UITextField *numberOfSamples;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Med_Name;
 
@end
