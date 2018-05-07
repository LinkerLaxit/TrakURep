//
//  UIViewController+VerifyIdentityViewController.m
//  TrakURep
//
//  Created by Aidan Curtis on 1/11/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import "VerifyIdentityViewController.h"
#import "Receive1ViewController.h"
#import "UIImageView+WebCache.h"

@implementation VerifyIdentityViewController:UIViewController


-(void) viewDidLoad{
    [super viewDidLoad];
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"verifyname"] != nil){
        self.name.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"verifyname"];
    }
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"verifyimage"] != nil){
        [_profileImage sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"verifyimage"]]];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NSString *strMessage = [[NSUserDefaults standardUserDefaults]valueForKey:@"message"];
    if(![strMessage isEqualToString:@"sucess"]){
        
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Alert!" message:strMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                    }];
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)yesSelected:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    Receive1ViewController *controller = (Receive1ViewController*)[mainStoryboard
                                                                   instantiateViewControllerWithIdentifier: @"Receive1ViewController"];
    
    [[self navigationController] showViewController:controller sender:nil];
}

- (IBAction)noSelected:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
