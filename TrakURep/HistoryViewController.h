//
//  HistoryViewController.h
//  TrakURep
//
//  Created by OSX on 11/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "common.h"
@interface HistoryViewController : UIViewController
{
    NSMutableArray *arrDispensed;
    NSMutableArray *arrReceived;
    NSMutableArray *searchResult;
    BOOL searchEnabled;
}
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmnetcontrol;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tbl_History;
@property (strong, nonatomic) IBOutlet UIView *view_Bottom_Rep;
@property (strong, nonatomic) IBOutlet UIView *view_bottom_clinic;
- (IBAction)btn_History_Action:(id)sender;
- (IBAction)btn_Messages_Action:(id)sender;
- (IBAction)btn_Profile_Action:(id)sender;
- (IBAction)Value_Changes_Segment:(id)sender;
- (IBAction)btn_Samples_Action:(id)sender;
- (IBAction)btn_Inventory_Action:(id)sender;
- (IBAction)btn_Download_action:(id)sender;

@end
