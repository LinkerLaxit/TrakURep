//
//  HistoryViewController.m
//  TrakURep
//
//  Created by OSX on 11/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "HistoryViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UserTableViewCell.h"
#import "HistDetailViewController.h"

@interface HistoryViewController ()
{
    UIRefreshControl *refreshControl;
    BOOL isDownload;
    IBOutlet UIView *view_Segment;
    int limit;
}
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tbl_History.rowHeight = UITableViewAutomaticDimension;
    _tbl_History.estimatedRowHeight = 50;
    [_tbl_History setTableFooterView:[[UIView alloc]init] ];
    
    view_Segment.layer.borderWidth = 0.5;
    view_Segment.layer.borderColor= [UIColor lightGrayColor].CGColor;
    
    searchResult=[[NSMutableArray alloc]init];
    arrReceived=[[NSMutableArray alloc] init];
    arrDispensed=[[NSMutableArray alloc]init];
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"])
    {
        view_Segment.hidden = false;
        [_segmnetcontrol setHidden:false];
        _view_Bottom_Rep.hidden=TRUE;
        _view_bottom_clinic.hidden=false;

    }
    else
    {
        view_Segment.hidden = true;
        _view_Bottom_Rep.hidden=false;
        _view_bottom_clinic.hidden=true;
        _tbl_History.frame = CGRectMake(_tbl_History.frame.origin.x, 110, _tbl_History.frame.size.width, _tbl_History.frame.size.height);
    }


    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];


    if (@available(iOS 10, *)) {
        _tbl_History.refreshControl = refreshControl;
    }
    else
    {
        [_tbl_History addSubview:refreshControl];
    }
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dictHist setObject:[NSString stringWithFormat:@"%d",limit] forKey:@"limit"];

    isDownload = false;
    [self WebResponse:dictHist WebserviceName:kGetHistoryUrl];


}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [refreshControl endRefreshing];
}
- (void)refreshTable {
    limit = limit +5;
    //TODO: refresh your data'
    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dictHist setObject:[NSString stringWithFormat:@"%d",limit] forKey:@"limit"];

    isDownload = false;
     [self WebResponse:dictHist WebserviceName:kGetHistoryUrl];
   
}


- (IBAction)Value_Changes_Segment:(id)sender {
    [_tbl_History reloadData];
}

- (IBAction)btn_Samples_Action:(id)sender {
}

- (IBAction)btn_Inventory_Action:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"No" forKey:@"FromSample"];
}

- (IBAction)btn_Download_action:(id)sender
{
    BOOL historyItemsAvailable;
    if(_segmnetcontrol.selectedSegmentIndex==0) {
        historyItemsAvailable = arrDispensed.count > 0;
    } else {
        historyItemsAvailable = arrReceived.count > 0;
    }
    
    if (historyItemsAvailable) {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"" message:@"Do you want to save your history as a CSV and send it to your registered email?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
                                        [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
                                        if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"]){
                                            [dictHist setObject:self.segmnetcontrol.selectedSegmentIndex == 0  ? @"dispensed" : @"received" forKey:@"sample_type"];
                                        }
                                        [dictHist setObject:self.searchBar.text forKey:@"search_sample"];
                                        isDownload = true;
                                        [self WebResponse:dictHist WebserviceName:kDownload];
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
    } else {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"TrakURep" message:@"There are no items found in your history." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* OKAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        [alert addAction:OKAction];
        [self presentViewController:alert animated:YES completion:nil];

    }
}

#pragma mark - table view delegate and data source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int a=0;
    if(_segmnetcontrol.selectedSegmentIndex==0)
    {
        a=(int)arrDispensed.count;
    }
    else if(_segmnetcontrol.selectedSegmentIndex==1)
    {
        a=(int)arrReceived.count;
    }
    if (searchEnabled) {
        a=(int)searchResult.count;
    }
    return a;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UserTableViewCell *cell = (UserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserCell"];
    }
    

    if(_segmnetcontrol.selectedSegmentIndex==0)
    {
        id sampleDic = [arrDispensed objectAtIndex:indexPath.row];
        
        cell.lbl_Name.text=[[sampleDic valueForKey:@"name"] stringByAppendingFormat:@"(%@)",[sampleDic valueForKey:@"amount"]];
        cell.lbl_ExpDate.text = [sampleDic valueForKey:@"exp_date"];
        //cell.lbl_Image.image=[UIImage imageNamed:@"SampleICon"];
        [cell.lbl_Image sd_setImageWithURL:[NSURL URLWithString:[sampleDic valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"SampleICon"]];
        cell.lbl_Image.layer.borderWidth = 0.0;
        cell.lbl_Image.clipsToBounds = NO;
    }
    else
    {
        id sampleDic = [arrReceived objectAtIndex:indexPath.row];
        cell.lbl_Name.text=[[sampleDic valueForKey:@"name"] stringByAppendingFormat:@"(%@)",[sampleDic valueForKey:@"amount"]];
        cell.lbl_ExpDate.text=[sampleDic valueForKey:@"exp_date"];
        [cell.lbl_Image sd_setImageWithURL:[NSURL URLWithString:[sampleDic valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"SampleICon"]];
        
    }
    if(searchEnabled)
    {
        id sampleDic = [searchResult objectAtIndex:indexPath.row];

        cell.lbl_Name.text=[[sampleDic valueForKey:@"name"] stringByAppendingFormat:@"(%@)",[sampleDic valueForKey:@"amount"]];
        cell.lbl_ExpDate.text=[sampleDic valueForKey:@"exp_date"];
        
        [cell.lbl_Image sd_setImageWithURL:[NSURL URLWithString:[sampleDic valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"ProfileIcon"]];
    }
  
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    cell.preservesSuperviewLayoutMargins = false;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    [cell.lbl_Name setNumberOfLines:0];
    
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 45;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    [_searchBar resignFirstResponder];
    if(_segmnetcontrol.selectedSegmentIndex==0)
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"D" forKey:@"key"];

        [[NSUserDefaults standardUserDefaults] setObject:[arrDispensed objectAtIndex:indexPath.row] forKey:@"HistDetail"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"R" forKey:@"key"];
        [[NSUserDefaults standardUserDefaults] setObject:[arrReceived objectAtIndex:indexPath.row] forKey:@"HistDetail"];
    }
    if(searchEnabled)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[searchResult objectAtIndex:indexPath.row] forKey:@"HistDetail"];
    }
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    HistDetailViewController *controller = (HistDetailViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"HistDetailViewController"];
    [[self navigationController] showViewController:controller sender:nil];

}

#pragma mark - Search delegate methods

- (void)filterContentForSearchText:(NSString*)searchText
{
    if(searchText.length>0)
    {

        id arrForSearch = @[];
        if(_segmnetcontrol.selectedSegmentIndex==0)
            arrForSearch = arrDispensed;
        else
            arrForSearch = arrReceived;
        
        
            searchResult = [[NSMutableArray alloc] initWithArray:[arrForSearch filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
                id objName = [object objectForKey:@"name"];
                id objLotNum = [object objectForKey:@"alotno"];
                id lowercaseSearchText = [searchText lowercaseString];
                id uniqueID = _segmnetcontrol.selectedSegmentIndex==0 ? [object valueForKey:@"unique_dispense_id"] : [object valueForKey:@"trans_id"];
//                id samples = [object objectForKey:@"sample_id"];
                if( [[objLotNum lowercaseString] containsString: lowercaseSearchText] || [[objName lowercaseString] containsString:lowercaseSearchText] || [[uniqueID lowercaseString] containsString:lowercaseSearchText]) {
                    return YES;
                } else {
                    
//                    for(id obj in samples) {
//                        id lotNum = [[obj valueForKey:@"alotid"] lowercaseString];
//                        if([lotNum  containsString:lowercaseSearchText]) {
//                            return YES;
//                        }
//                    }
                    
                    return NO;
                }
            }]]];

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
    NSString *search = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (search == nil || [search isEqualToString:@""]) {
        searchEnabled = NO;
        [searchResult removeAllObjects];
        [searchBar setText:@""];
        [_tbl_History reloadData];
    }
    else{
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

-(NSMutableArray*)explodeTransactions:(NSMutableArray*)transactions{
    //return transactions;
    NSMutableArray* returning = [[NSMutableArray alloc] init];
    for (NSDictionary *sample in transactions) {
        NSMutableArray* dateArray = [[NSMutableArray alloc] init];
        NSLog(@"%@",[sample valueForKey:@"sample_id"]);
        for (NSDictionary* single in [sample valueForKey:@"sample_id"]){
            
            if([dateArray containsObject:[single valueForKey:@"updatedate"]]){
                int dateindex = (int)[dateArray indexOfObject:[single valueForKey:@"updatedate"]];
                NSString *amount = [[returning objectAtIndex:dateindex] valueForKey:@"amount"];
                NSString *newnum = [NSString stringWithFormat:@"%li", [amount integerValue]+1];
                [[returning objectAtIndex:dateindex] setValue:newnum forKey:@"amount"];
                NSMutableArray *sampleArray =[[NSMutableArray alloc] initWithArray:[[returning objectAtIndex:dateindex] objectForKey:@"sample_id"]];
                [sampleArray addObject:single];
                [[returning objectAtIndex:dateindex] setValue:sampleArray forKey:@"sample_id"];
            }else{
                [dateArray addObject:[single valueForKey:@"updatedate"]];
                NSMutableDictionary * partition =[[NSMutableDictionary alloc] initWithDictionary:[sample copy]];
                [partition setValue:@"1" forKey:@"amount"];
                [partition setValue:[[NSArray alloc] initWithObjects:single, nil] forKey:@"sample_id"];
                [returning addObject: partition];
            }
        }
    }

    NSLog(@"returning: %@",returning);

    return returning;
}

#pragma mark - Webservice call
-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    NSLog(@"Access Token Here");
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"]);

    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    //   stringUrl = [stringUrl stringByAddingPercentEncodingWithAllowedCharacters:URLHostAllowedCharacterSet];
    
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
         NSLog(@"datastring: %@",[[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);

         [MBProgressHUD hideHUDForView:self.view animated:YES];

         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@",dicYourResponse);
             if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {
                 if(!isDownload)
                 {

                     if([[[dicYourResponse valueForKey:@"data"] valueForKey:@"DISPENSE"] count]>0)
                     {
                         arrDispensed = (NSMutableArray*)[[dicYourResponse valueForKey:@"data"] valueForKey:@"DISPENSE"];
                         //arrDispensed = [[[arrDispensed reverseObjectEnumerator] allObjects] mutableCopy];
                         
                         //arrDispensed = [self explodeTransactions:arrDispensed];
                         //add to array for different dates
                     }
                     
                     
                     if([[[dicYourResponse valueForKey:@"data"] valueForKey:@"RECEIVED"] count]>0)
                     {
                         arrReceived = (NSMutableArray*)[[dicYourResponse valueForKey:@"data"] valueForKey:@"RECEIVED"];
                        // arrReceived = [[[arrReceived reverseObjectEnumerator] allObjects] mutableCopy];
                         
                         //add to array for different dates
                         //arrReceived = [self explodeTransactions:arrReceived];

                     }
                    // [self sortHistoryItem];
                     [_tbl_History reloadData];

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

- (void)sortHistoryItem {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
   
//    NSArray *sortedArray = [arrReceived sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        NSDate *d1 = [df dateFromString: [obj1 valueForKey:@"createdate"]];
//        NSDate *d2 = [df dateFromString: [obj2 valueForKey:@"createdate"]];
//        return [d2 compare: d1];
//    }];
    
    NSSortDescriptor *dateDescr = [[NSSortDescriptor alloc] initWithKey:@"createdate" ascending:YES];
    // String are alphabetized in ascending order
    NSSortDescriptor *nameDescr = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    // Combine the two
    NSArray *sortDescriptors = @[dateDescr,nameDescr];
    // Sort your array
    
     NSArray *sortedArray = [arrReceived sortedArrayUsingDescriptors:sortDescriptors];

    [arrReceived removeAllObjects];
    arrReceived = [NSMutableArray arrayWithArray:sortedArray];
    
//    NSArray *sortedArray2 = [arrDispensed sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        NSDate *d1 = [df dateFromString: [obj1 valueForKey:@"createdate"]];
//        NSDate *d2 = [df dateFromString: [obj2 valueForKey:@"createdate"]];
//        return [d2 compare: d1];
//    }];
    
     NSArray *sortedArray2 = [arrDispensed sortedArrayUsingDescriptors:sortDescriptors];
    
    [arrDispensed removeAllObjects];
    arrDispensed = [NSMutableArray arrayWithArray:sortedArray2];
   
   

}
@end
