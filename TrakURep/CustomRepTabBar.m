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

#import "CustomRepTabBar.h"


@interface CustomRepTabBar () {
    ESTabBarController *tabBarController;
}
@end

@implementation CustomRepTabBar


#pragma mark - UIViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Instance creation.
    tabBarController = [[ESTabBarController alloc] initWithTabIconNames:@[@"HistoryIcon", @"Messages", @"ProfileIcon"]];
    
    
    
    
    
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
    
    [tabBarController setViewController: [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavRepHistoryViewController"]
                                atIndex:0];
    
   [tabBarController setViewController: [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavActualMessagesViewController"]
                                atIndex:1];
    
    [tabBarController setViewController: [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NavRepProfileViewController"]
                                atIndex:2];
    
    
    
    // Colors.
    
    tabBarController.selectedColor = [UIColor colorWithHexString:@"#FFFFFF"];
    tabBarController.buttonsBackgroundColor = [UIColor colorWithHexString:@"#34495E"];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [tabBarController setSelectedIndex:2 animated:YES];
    [tabBarController.tabBarController.tabBar.items[1] setBadgeValue:@"15"];
}
@end

