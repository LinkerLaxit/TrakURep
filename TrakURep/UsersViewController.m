//
//  UsersViewController.m
//  TrakURep
//
//  Created by MAC on 24/11/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "UsersViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "chatViewController.h"

@interface UsersViewController ()
{
    int limit;
}
@end

@implementation UsersViewController
{
    NSMutableArray *arrUsers;
    NSArray *filtered_arrUsers;
    UIRefreshControl *refreshControl;

}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    filtered_arrUsers = [arrUsers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        if([object isKindOfClass:[NSDictionary class]]){
            return [[object valueForKey:@"name"] hasPrefix:searchText];
        }else{
            NSLog(@"not that class");
            return false;
        }
    }]];
    [_tbl_USer reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"])
    {
        _view_RepBottom.hidden=TRUE;
        _view_ClinicBottom.hidden=false;
    }
    
    arrUsers = [[NSMutableArray alloc] init];
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 10, *)) {
        _tbl_USer.refreshControl = refreshControl;
    }
    else
    {
        [_tbl_USer  addSubview:refreshControl];
    }
    
        NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
        [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Clinic"])
            [dictHist setObject:@"3" forKey:@"user_type_id"];
        else
            [dictHist setObject:@"2" forKey:@"user_type_id"];
        [dictHist setObject:@"" forKey:@"name"];
        [dictHist setObject:[NSString stringWithFormat:@"%d",limit] forKey:@"limit"];
        [self WebResponse:dictHist WebserviceName:kGetUsers];
 
    
}
- (void)refreshTable {
    //TODO: refresh your data'
    limit= limit + 10;
    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Clinic"])
        [dictHist setObject:@"3" forKey:@"user_type_id"];
    else
        [dictHist setObject:@"2" forKey:@"user_type_id"];
    [dictHist setObject:@"" forKey:@"name"];
    [dictHist setObject:[NSString stringWithFormat:@"%d",limit] forKey:@"limit"];
    [self WebResponse:dictHist WebserviceName:kGetUsers];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Webservice Call
-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"]);
    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
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
             if([[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {
                 
             }
             else
             {
                 if([[dicYourResponse valueForKey:@"data"] count]>0)

                 arrUsers = [dicYourResponse valueForKey:@"data"];
                 filtered_arrUsers = [dicYourResponse valueForKey:@"data"];

                 [_tbl_USer reloadData];
             }
         }
         else
         {
             
         }
         if(refreshControl.isRefreshing)
         {
             [refreshControl endRefreshing];
         }
     }];
    
}
#pragma mark - table view delegate and data source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return filtered_arrUsers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell = (UserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UserCell"];
    }
    
    cell.lbl_Name.text = [[filtered_arrUsers objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    if([[filtered_arrUsers objectAtIndex:indexPath.row] valueForKey:@"image"])
    {
        [cell.lbl_Image sd_setImageWithURL:[[filtered_arrUsers objectAtIndex:indexPath.row] valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"ProfileIcon"]];
    }
    
    cell.lbl_Image.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.lbl_Image.layer.cornerRadius = cell.lbl_Image.frame.size.width/2;
    cell.lbl_Image.layer.borderWidth = 1.0;
    cell.lbl_Image.clipsToBounds = YES;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [[NSUserDefaults standardUserDefaults] setValue:[[filtered_arrUsers objectAtIndex:indexPath.row] valueForKey:@"image"] forKey:@"FImage"];
    [[NSUserDefaults standardUserDefaults] setValue:[[filtered_arrUsers objectAtIndex:indexPath.row] valueForKey:@"name"] forKey:@"FriendName"];
    [[NSUserDefaults standardUserDefaults] setValue:[[filtered_arrUsers objectAtIndex:indexPath.row] valueForKey:@"userid"] forKey:@"FriendID"];
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    chatViewController *controller = (chatViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"chatViewController"];
    [[self navigationController] showViewController:controller sender:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTableViewCell *cell = [self.tbl_USer dequeueReusableCellWithIdentifier:@"UserCell"];
    
    return cell.bounds.size.height;
    
    // return 80;
    
}
- (IBAction)btn_Back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}



- (IBAction)btn_HistAction:(id)sender {
    [self performSegueWithIdentifier:@"ShowHist" sender:self];
}

- (IBAction)btn_message_Action:(id)sender {
    [self performSegueWithIdentifier:@"ShowMsg" sender:self];
}

- (IBAction)btn_Samples_Action:(id)sender {
    [self performSegueWithIdentifier:@"ShowSamples" sender:self];
}

- (IBAction)btn_Profile_Action:(id)sender {
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"])
    {
        [self performSegueWithIdentifier:@"ShowProfile" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"ShowProfileClinic" sender:self];
    }

}

- (IBAction)btn_inventory_action:(id)sender {
    [self performSegueWithIdentifier:@"ShowInvent" sender:self];
}
@end
