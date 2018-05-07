//
//  InventoryViewController.m
//  TrakURep
//
//  Created by OSX on 14/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "InventoryViewController.h"
#import "MBProgressHUD.h"
#import "common.h"
#import "InventDetailViewController.h"
#import "SampleConfirmViewController.h"
#import "UserTableViewCell.h"

@interface InventoryViewController ()
{
    UIRefreshControl *refreshControl;
    int limit;
    BOOL isDownload;
}

@property (strong, nonatomic) IBOutlet UILabel *lbl_NumberOfSamples;
@end

@implementation InventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    searchResult=[[NSMutableArray alloc]init];
    arrInventory=[[NSMutableArray alloc]init];
    
    _tbl_History.rowHeight = UITableViewAutomaticDimension;
    _tbl_History.estimatedRowHeight = 45;
    [_tbl_History setTableFooterView:[[UIView alloc] init] ];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 10, *)) {
        _tbl_History.refreshControl = refreshControl;
    }
    else
    {
        [_tbl_History addSubview:refreshControl];
    }
    isDownload = false;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dictHist setObject:[NSString stringWithFormat:@"%d",limit] forKey:@"limit"];
    [self WebResponse:dictHist WebserviceName:kInventoryURL];
  

    int count=0;
    for (int a=0; a<arrInventory.count; a++) {
        count  =  count+[[[arrInventory objectAtIndex:a] valueForKey:@"amount"] intValue];
    }
    if( count >0){
    _lbl_NumberOfSamples.text = [NSString stringWithFormat:@"%d samples in inventory",count];
    _lbl_NumberOfSamples.frame = CGRectMake(_lbl_NumberOfSamples.frame.origin.x, _tbl_History.frame.size.height+_tbl_History.frame.origin.y+20, _lbl_NumberOfSamples.frame.size.width, _lbl_NumberOfSamples.frame.size.height);
    } else {
        _lbl_NumberOfSamples.hidden = TRUE;
    }

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [refreshControl endRefreshing];
}

- (void)refreshTable {
    isDownload = false;
    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dictHist setObject:[NSString stringWithFormat:@"%d",limit] forKey:@"limit"];
    [self WebResponse:dictHist WebserviceName:kInventoryURL];
}


- (IBAction)Value_Changes_Segment:(id)sender {
    [self sortInventoryItems];
    [_tbl_History reloadData];
}


- (IBAction)btn_Inventory_Action:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"FromSample"];
}

- (IBAction)btn_Download_action:(id)sender
{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"" message:@"Do you want to save your inventory as a CSV and send it to your registered email?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
                                    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
                                    [dictHist setObject:self.searchBar.text forKey:@"search_sample"];
                                    switch (self.segmnetcontrol.selectedSegmentIndex) {
                                        case 0:
                                            [dictHist setObject:@"alphabetical" forKey:@"sample_type"];
                                            break;
                                        case 1:
                                            [dictHist setObject:@"expiration" forKey:@"sample_type"];
                                            break;
                                        case 2:
                                            [dictHist setObject:@"stock" forKey:@"sample_type"];
                                            break;
                                        default:
                                            break;
                                    }
                                    isDownload = true;
                                    [self WebResponse:dictHist WebserviceName:kExportInventory];
                                    //Handle your yes please button action here
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - table view delegate and data source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger a=0;
    if(_segmnetcontrol.selectedSegmentIndex==0 || _segmnetcontrol.selectedSegmentIndex==1||_segmnetcontrol.selectedSegmentIndex==2)
    {
        a=arrInventory.count;
    }
    if (searchEnabled)
    {
        a=searchResult.count;
    }
    return a;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sampleCell"];
    //cell.textLabel.text =@"edew";
    
    if(arrInventory.count>0)
    {
        cell.lbl_Name.text=[[arrInventory objectAtIndex:indexPath.row] valueForKey:@"name" ];
        cell.lbl_subDetail.text = [@"" stringByAppendingFormat:@"%@ in stock",[[arrInventory objectAtIndex:indexPath.row] valueForKey:@"amount"]];
    }
    if(searchEnabled)
    {
        cell.lbl_Name.text=[[searchResult objectAtIndex:indexPath.row] valueForKey:@"name"] ;
        cell.lbl_subDetail.text = [@"" stringByAppendingFormat:@"%@ in stock",[[searchResult objectAtIndex:indexPath.row] valueForKey:@"amount"]];
        
    }
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    cell.lbl_Image.image=[UIImage imageNamed:@"SampleICon"];
    
    cell.preservesSuperviewLayoutMargins = false;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [_searchBar resignFirstResponder];
    if(searchEnabled)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[searchResult objectAtIndex:indexPath.row] forKey:@"InventDetail"];
    }
    else
    {
        if(_segmnetcontrol.selectedSegmentIndex==0 || _segmnetcontrol.selectedSegmentIndex==1 ||_segmnetcontrol.selectedSegmentIndex==2 )
        {
            [[NSUserDefaults standardUserDefaults] setObject:[arrInventory objectAtIndex:indexPath.row] forKey:@"InventDetail"];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:[[arrInventory objectAtIndex:indexPath.row] valueForKey:@"alotno"]  forKey:@"selected_alotno"];
    
   
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    InventDetailViewController *controller = (InventDetailViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"InventDetailViewController"];
    controller.fromSampleTab = [self.navigationController.viewControllers.firstObject isKindOfClass: [SampleConfirmViewController class]];
    [[self navigationController] showViewController:controller sender:nil];
}


#pragma mark - Search delegate methods

- (void)filterContentForSearchText:(NSString*)searchText
{
    NSString* text = [[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] lowercaseString];
    if(text.length>0)
    {
        
        searchResult = [[arrInventory filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
            NSString* lotNumber = [[object objectForKey:@"alotno"] lowercaseString];
            NSString* name = [[object objectForKey:@"name"] lowercaseString];
            
            return [lotNumber containsString:text] || [name containsString:text];
        }]] mutableCopy];
        
        
        [_tbl_History reloadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0) {
        searchEnabled = NO;
        [self.tbl_History reloadData];

    }
    else {
        searchEnabled = YES;
        [self filterContentForSearchText:searchBar.text];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if (searchBar.text.length == 0) {
        searchEnabled = NO;
        [self.tbl_History reloadData];
        
    }
    else {
        searchEnabled = YES;
        [self filterContentForSearchText:searchBar.text];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchResult removeAllObjects];
    [searchBar resignFirstResponder];
    [searchBar setText:@""];
    searchEnabled = NO;
    [_tbl_History reloadData];

}

#pragma mark - Touch events
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_searchBar resignFirstResponder];
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
        [request setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"] forHTTPHeaderField:@"AuthToken"];
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
         
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@",dicYourResponse);
             if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {

                 if (!isDownload){
                     arrInventory = [[dicYourResponse valueForKey:@"data"] valueForKey:@"INVENTORY"];
                     [self sortInventoryItems];
                     [_tbl_History reloadData];
                     
                     int count=0;
                     for (int a=0; a<arrInventory.count; a++) {
                         count  =  count+[[[arrInventory objectAtIndex:a] valueForKey:@"amount"] intValue];
                     }
                     if( count >0) {
                         _lbl_NumberOfSamples.text = [NSString stringWithFormat:@"%d samples in inventory",count];
                     } else {
                         _lbl_NumberOfSamples.hidden = TRUE;
                     }
                 }
                
             }
             if(refreshControl.isRefreshing)
             {
                 [refreshControl endRefreshing];
             }
             [_tbl_History reloadData];

         }
     }];
    
    

}
-(void)sortInventoryItems {
    if(_segmnetcontrol.selectedSegmentIndex==0){
        NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
        arrInventory = [[arrInventory sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    }
   else if(_segmnetcontrol.selectedSegmentIndex == 1){
       
       arrInventory = [[arrInventory sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
           NSInteger days1 = [obj1[@"exp_date"] integerValue];
           NSInteger days2 = [obj2[@"exp_date"] integerValue];
           if(days1<days2)
               return NSOrderedAscending;
           else if(days1>days2)
               return  NSOrderedDescending;
           else
               return NSOrderedSame;
       }] mutableCopy] ;
    }
   else  if(_segmnetcontrol.selectedSegmentIndex == 2){
      id arr = [arrInventory sortedArrayUsingComparator: ^(id obj1, id obj2) {
          NSInteger firstCount = [obj1[@"amount"] integerValue];
          NSInteger secondCount = [obj2[@"amount"] integerValue];
          
            if (firstCount == 0 && secondCount == 0){
                return (NSComparisonResult)NSOrderedSame;
            }if (firstCount == 0){
                return (NSComparisonResult)NSOrderedDescending;
            }if (secondCount == 0){
                return (NSComparisonResult)NSOrderedAscending;
            }if (firstCount < secondCount){
                return (NSComparisonResult)NSOrderedDescending;
            }if (firstCount > secondCount){
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        arrInventory = [arr mutableCopy];
    }

}


@end
