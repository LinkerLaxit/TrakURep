//
//  InventDetailViewController.h
//  TrakURep
//
//  Created by MAC on 12/10/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface InventDetailViewController : UIViewController
{
    NSMutableArray *arrDispense;
    NSMutableArray *arrSamples;
    NSMutableDictionary* paramsSampelsForDispense;

}

@property (strong, nonatomic) IBOutlet UITableView *tbl_InventDetails;
@property  BOOL fromSampleTab;

- (IBAction)btn_History_Action:(id)sender;
- (IBAction)btn_message_Action:(id)sender;
- (IBAction)btn_Inventory_action:(id)sender;
- (IBAction)btn_Sample_Action:(id)sender;
- (IBAction)btn_Profile_action:(id)sender;
- (IBAction)btn_Back_Action:(id)sender;

@end
