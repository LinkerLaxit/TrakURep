//
//  SignUpSelectionViewController.h
//  TrakURep
//
//  Created by OSX on 05/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpSelectionViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *viewRep;
@property (strong, nonatomic) IBOutlet UIView *viewclinic;
@property (strong, nonatomic) IBOutlet UIView *viewQue;
- (IBAction)btn_clinic_Action:(id)sender;
- (IBAction)btn_Rep_Action:(id)sender;
- (IBAction)button_Question_Action:(id)sender;
@end
