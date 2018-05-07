//
//  UIViewController+VerifyIdentityViewController.h
//  TrakURep
//
//  Created by Aidan Curtis on 1/11/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifyIdentityViewController:UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
- (IBAction)yesSelected:(id)sender;
- (IBAction)noSelected:(id)sender;

@end
