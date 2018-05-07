//
//  Receive1ViewController.h
//  TrakURep
//
//  Created by MAC on 16/10/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Receive1ViewController : UIViewController{
    NSTimer     *myidleTimer;
}

-(void)resetIdleTimer;
@property (strong, nonatomic) IBOutlet UITextField *txt_Numbers;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segment_cntrl;
@property (strong, nonatomic) IBOutlet UIView *view_numbers;
- (IBAction)slider_Value_Changed:(id)sender;

@end
