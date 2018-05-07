//
//  SignUpSelectionViewController.m
//  TrakURep
//
//  Created by OSX on 05/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "SignUpSelectionViewController.h"
#import "SignUpFormViewController.h"
@interface SignUpSelectionViewController ()

@end

@implementation SignUpSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _viewQue.layer.borderColor=[UIColor whiteColor].CGColor;
    _viewRep.layer.borderColor=[UIColor whiteColor].CGColor;
    _viewclinic.layer.borderColor=[UIColor whiteColor].CGColor;

    _viewQue.layer.cornerRadius=2.0;
    _viewRep.layer.cornerRadius=2.0;
    _viewclinic.layer.cornerRadius=2.0;


    
//    UIApplication *app = [UIApplication sharedApplication];
//    CGFloat statusBarHeight = app.statusBarFrame.size.height;
//    
//    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
//    statusBarView.backgroundColor  =  [UIColor colorWithRed:0.1412 green:0.4706 blue:0.6588 alpha:1];
//    [self.view addSubview:statusBarView];
}
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn_Back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_clinic_Action:(id)sender {
   // [[NSUserDefaults standardUserDefaults] setValue:@"Clinic" forKey:@"UserType"];
}

- (IBAction)btn_Rep_Action:(id)sender {
   // [[NSUserDefaults standardUserDefaults] setValue:@"Rep" forKey:@"UserType"];

}

- (IBAction)button_Question_Action:(id)sender {
    
  /*  UIAlertController *popup=[UIAlertController alertControllerWithTitle:@"Alert!" message:@"It will Open TrakURep Website once we have the link." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* CancelButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                   }];
    
    
    [popup addAction:CancelButton];
    [self presentViewController:popup animated:YES completion:nil];*/
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.trakurep.com/"]]; // http://linkerlogic.com/
}
@end
