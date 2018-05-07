//
//  MessagesViewController.m
//  TrakURep
//
//  Created by osx on 15/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "MessagesViewController.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

@interface MessagesViewController ()<UISearchBarDelegate>
{
    UIRefreshControl *refreshControl;
    int limit;
}
@end

@implementation MessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(![[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Rep"])
    {
        _view_bottom_Rep.hidden=TRUE;
        _view_bottom_clinic.hidden=false;
    }
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 10, *)) {
        _tbl_Messages.refreshControl = refreshControl;
    }
    else
    {
        [_tbl_Messages  addSubview:refreshControl];
    }

}
-(void)viewWillAppear:(BOOL)animated
{
    if(![[NSUserDefaults standardUserDefaults] valueForKey:@"UsersMsg"])
    {
        limit = 0;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //arrUsers = [[NSMutableArray alloc] init];
        NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
        [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
        [dictHist setObject:[NSString stringWithFormat:@"%d",limit] forKey:@"limit"];
        [self WebResponse:dictHist WebserviceName:kGetMainMessageList];
    }
    else
    {
        arrUsers = [[NSUserDefaults standardUserDefaults] valueForKey:@"UsersMsg"];
        [_tbl_Messages reloadData];
    }
    [_tbl_Messages setContentOffset:CGPointMake(0, 0) animated:YES];
}
- (void)refreshTable {
    //TODO: refresh your data'
    limit = limit +5;
    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dictHist setObject:[NSString stringWithFormat:@"%d",limit] forKey:@"limit"];

    [self WebResponse:dictHist WebserviceName:kGetMainMessageList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btn_Plus_Action:(id)sender {
    
    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"UserType"] isEqualToString:@"Clinic"])
       [dictHist setObject:@"3" forKey:@"user_type_id"];
    else
        [dictHist setObject:@"2" forKey:@"user_type_id"];
    [dictHist setObject:@"" forKey:@"name"];
    [self WebResponse:dictHist WebserviceName:kGetUsers];

}

#pragma mark - table view delegate and data source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrUsers.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"message"];
    //MessagesCell *cell =[tableView dequeueReusableCellWithIdentifier:@"message"];;
    MessagesCell *cell = (MessagesCell *)[tableView dequeueReusableCellWithIdentifier:@"message" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MessagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"message"];
    }
   
    cell.lbl_Name.text = [[arrUsers objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.lbl_Message.text = [[arrUsers objectAtIndex:indexPath.row] valueForKey:@"message"];
    cell.lbl.text = [[arrUsers objectAtIndex:indexPath.row] valueForKey:@"beforetime"];
    if([[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"is_read"] isEqualToString:@"Y"] )
    {
        cell.img_BlueDot.hidden=true;
    }
    else
    {
        cell.img_BlueDot.hidden=false;
    }

    if([[arrUsers objectAtIndex:indexPath.row] valueForKey:@"image"])
    {

        [cell.img_profile sd_setImageWithURL:[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"image"] placeholderImage:[UIImage imageNamed:@"ProfileIcon"]];
    }
    
    cell.img_profile.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.img_profile.layer.cornerRadius = cell.img_profile.frame.size.width/2;
    cell.img_profile.layer.borderWidth = 1.0;
    cell.img_profile.clipsToBounds = YES;

    


    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [[NSUserDefaults standardUserDefaults] setValue:[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"image"] forKey:@"FImage"];
    [[NSUserDefaults standardUserDefaults] setValue:[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"name"] forKey:@"FriendName"];
    [[NSUserDefaults standardUserDefaults] setValue:[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"userid"] forKey:@"FriendID"];
    [self performSegueWithIdentifier:@"ShowChat" sender:self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
        NSLog(@"%@", [arrUsers objectAtIndex:indexPath.row]);
        [dictHist setObject:[[arrUsers objectAtIndex:indexPath.row] valueForKey:@"userid"] forKey:@"otherid"];
        [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
        [arrUsers removeObjectAtIndex: indexPath.row];
        [self.tbl_Messages deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self WebResponse: dictHist WebserviceName:kDeleteMessages];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessagesCell *cell =
    [self.tbl_Messages dequeueReusableCellWithIdentifier:@"message"];
    return cell.bounds.size.height;
}

#pragma mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - Webservice Call
-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{

    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    [request setHTTPMethod:@"POST"];
    if(Params)
    {
        NSData *postData = [NSJSONSerialization dataWithJSONObject:Params options:0 error:nil];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"AccssToken"] forHTTPHeaderField:@"AuthToken"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
    }
    NSURLRequest *requestURL = [[NSURLRequest alloc] init];
    requestURL = request.copy;
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"resultoutput: %@", [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);

        if (data.length > 0 && connectionError == nil)
        {
            NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
            {
                if([WebserviceName  isEqual: kDeleteMessages]){
                    NSLog(@"Testing! woo");
                }else{
                    if([[dicYourResponse valueForKey:@"data"]  count]>0)
                        arrUsers = [[NSMutableArray alloc] initWithArray:[dicYourResponse valueForKey:@"data"]];
                    
                    
                
                    id filteredArray = [arrUsers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"is_read != 'Y'"]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (arrUsers.count > 0){
                            NSDictionary *dict = arrUsers[0];
                            int unreadCount= [[dict valueForKey:@"totalUnreads"]intValue];
                            if (unreadCount > 0){
                                [self.tabBarController.tabBar.items[1] setBadgeValue: [NSString stringWithFormat:@"%d",unreadCount]];
                            }
                            else{
                                self.tabBarController.tabBar.items[1].badgeValue = nil;
                            }
                        }
//                        NSString* unreadCount = [filteredArray count] > 0 ? [NSString stringWithFormat:@"%lu", [filteredArray count]] : nil ;
//                        [self.tabBarController.tabBar.items[1] setBadgeValue: unreadCount];
                    });

                    [_tbl_Messages reloadData];
                }
            }
            
        }
        if(refreshControl.isRefreshing)
        {
            [refreshControl endRefreshing];
        }
    }];

    
}

@end
