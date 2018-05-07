//
//  CustomTabBar.m
//  TrakURep
//
//  Created by Aidan Curtis on 12/29/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ESTabBarController/ESTabBarController.h>
#import <UIColor-HexString/UIColor+HexString.h>

#import "HistoryViewController.h"
#import "MessagesViewController.h"
#import "SampleConfirmViewController.h"
#import "ProfileRepViewController.h"
#import "InventoryViewController.h"

#import "CustomTabBar.h"



@interface CustomTabBar() {
    ESTabBarController *tabBarController;
}
@end

@implementation CustomTabBar

#pragma mark - UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Instance creation.
   tabBarController = [[ESTabBarController alloc] initWithTabIconNames:@[@"HistoryIcon",
                                                                                              @"Messages",
                                                                                              @"Samples",
                                                                                              @"ProfileIcon",
                                                                                              @"InventoryICon"]];
    
    
    
    

    // Add child view controller.
    
    [self addChildViewController:tabBarController];
    
    [self.view addSubview:tabBarController.view];
    if(self.view.frame.size.height == 812) {
        tabBarController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 32);
    } else {
        tabBarController.view.frame = self.view.bounds;
    }

    [tabBarController didMoveToParentViewController:self];
    
    // View controllers.
    
    [tabBarController setViewController: [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavHistoryViewController"]
                                atIndex:0];
    
    [tabBarController setViewController: [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavMessagesViewController"]
                                atIndex:1];
    
    [tabBarController setViewController: [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavSampleConfirmViewController"]
                                atIndex:2];
    
    [tabBarController setViewController: [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavClinicProfileViewController"]
                                atIndex:3];
    
    [tabBarController setViewController: [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavInventoryViewController"]
                                atIndex:4];
  
    
    // Colors.
    
    tabBarController.selectedColor = [UIColor colorWithHexString:@"#FFFFFF"];
    tabBarController.buttonsBackgroundColor = [UIColor colorWithHexString:@"#34495E"];
    // Actions.

}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [tabBarController setSelectedIndex:3 animated:NO]; //Profile selected by default.
}

@end
