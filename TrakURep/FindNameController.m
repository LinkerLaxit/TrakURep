//
//  UIViewController+FindNameController.m
//  TrakURep
//
//  Created by Aidan Curtis on 1/10/18.
//  Copyright © 2018 OSX. All rights reserved.
//

#import "FindNameController.h"
#import "MBProgressHUD.h"
#import "common.h"
#import "InventDetailViewController.h"
#import "SampleConfirmViewController.h"

@implementation FindNameController:UIViewController

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return filteredArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == filteredArr.count - 2 && currentPage < totalPage){
        isSearching = FALSE;
        [self getSampleList];
    }
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
       
        [[[cell.textLabel leftAnchor] constraintEqualToAnchor:cell.leftAnchor constant:8] setActive:YES];
        [[[cell.textLabel rightAnchor] constraintEqualToAnchor:cell.rightAnchor constant:8] setActive:YES];
        [[[cell.textLabel topAnchor] constraintEqualToAnchor:cell.topAnchor constant:8] setActive:YES];
        [[[cell.textLabel bottomAnchor] constraintEqualToAnchor:cell.bottomAnchor constant:8]  setActive:YES];
        [cell.textLabel setNumberOfLines:0];
    }
    NSDictionary *dict = filteredArr[indexPath.row];
    [[cell textLabel] setText:[dict valueForKey:@"drug_name"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
   
    currentPage = 0;
    isSearching = TRUE;
    [self getSampleList];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    isSearching = TRUE;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    isSearching = FALSE;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = filteredArr[indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:[dict valueForKey:@"drug_name"] forKey:@"selectedName"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) viewDidLoad{
//    NSString *string = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]
//                                                           pathForResource:@"drugs_unique" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
//    
//    NSArray* arr = [string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
   
    isSearching = FALSE;
    nameArr = [NSMutableArray new];
    filteredArr = [NSMutableArray new];
    [_tableView reloadData];
    currentPage = 0;
    totalPage = 1;
    [self getSampleList];
}

-(NSArray*)sortItems:(NSArray*)arr {
    return [arr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

-(void)getSampleList{
    currentPage++;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.searchBar.text forKey:@"drug_name"];
    [dict setObject:@"100" forKey:@"limit"];
    [dict setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"page"];
    [self WebResponse:dict WebserviceName:kTradeList];
}

#pragma mark - Webservice call
-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    if(Params)
    {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:Params options:0 error:nil]; //[post dataUsingEncoding:NSASCIIStringEncoding];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
    }
    NSURLRequest *requestURL = [[NSURLRequest alloc] init];
    requestURL = request.copy;
    
    
    // NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (isSearching){
             [nameArr removeAllObjects];
             [filteredArr removeAllObjects];
         }
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"Response =========================== \n%@",dicYourResponse);
             if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {
                 
                 totalPage = [[dicYourResponse valueForKey:@"total_page"]intValue];
                 NSArray *arr  = [dicYourResponse valueForKey:@"data"];
                 [nameArr addObjectsFromArray:arr];
                 [filteredArr addObjectsFromArray: arr];
                
             }
         }
         [_tableView reloadData];
     }];
    
    
    
}

@end
