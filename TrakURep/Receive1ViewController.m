//
//  Receive1ViewController.m
//  TrakURep
//
//  Created by MAC on 16/10/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "Receive1ViewController.h"
#import "Receive3ViewController.h"

@interface Receive1ViewController ()

@end

@implementation Receive1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"number"];
    
    [self resetIdleTimer];

}


//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_Continue_Action:(id)sender {
    
    if(_segment_cntrl.selectedSegmentIndex == 0)
    {
        [self performSegueWithIdentifier:@"showReceiving2" sender:self];
    }
    else
    {
        NSString* number = [_txt_Numbers.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(number.length>0 && number.intValue>0)
        {
            [[NSUserDefaults standardUserDefaults] setValue:_txt_Numbers.text forKey:@"number"];

            [self performSegueWithIdentifier:@"showReceiving2" sender:self];
        }
        else
        {
            UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please enter number of samples." preferredStyle:UIAlertControllerStyleAlert];
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



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)slider_Value_Changed:(id)sender {
    if(_segment_cntrl.selectedSegmentIndex==0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"number"];

        _view_numbers.hidden = true;
    }
    else
    {
        _view_numbers.hidden=false;
    }
    
}


@end
