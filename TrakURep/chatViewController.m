//
//  chatViewController.m
//  TrakURep
//
//  Created by osx on 15/09/17.
//  Copyright © 2017 OSX. All rights reserved.
//

#import "chatViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "MBProgressHUD.h"
#import "common.h"
#import "NSBubbleData.h"
#import "ContentView.h"
#import "ChatTableViewCellXIB.h"
#import "UIImageView+WebCache.h"
@interface iMessage: NSObject

-(id) initIMessageWithName:(NSString *)name
                   message:(NSString *)message
                      time:(NSString *)time
                      type:(NSString *)type;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userMessage;
@property (strong, nonatomic) NSString *userTime;
@property (strong, nonatomic) NSString *messageType;

@end

@implementation iMessage

-(id) initIMessageWithName:(NSString *)name
                   message:(NSString *)message
                      time:(NSString *)time
                      type:(NSString *)type
{
    self = [super init];
    if(self)
    {
        self.userName = name;
        self.userMessage = message;
        self.userTime = time;
        self.messageType = type;
    }
    
    return self;
}

@end

@interface chatViewController ()
{

    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;
    NSMutableArray *bubbleData;
    int textY;
    NSString *strLimt ;
    BOOL isSendClicked;
    UIRefreshControl *refreshControl;

}
@property (weak, nonatomic) IBOutlet ContentView *contentView;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatTextViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@property (strong,nonatomic) ChatTableViewCellXIB *chatCell;


@property (strong,nonatomic) ContentView *handler;
@end

@implementation chatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle: [[NSUserDefaults standardUserDefaults] valueForKey:@"FriendName"]];
    
    strLimt = @"0";
    
   
    [_img_UserProfile sd_setImageWithURL:[[NSUserDefaults standardUserDefaults] valueForKey:@"FImage"] placeholderImage:[UIImage imageNamed:@"ProfileIcon"]];
    _img_UserProfile.layer.cornerRadius = _img_UserProfile.frame.size.width/2;
    _img_UserProfile.layer.borderWidth = 1.0;
    _img_UserProfile.layer.borderColor = [[UIColor colorWithRed:52 green:152 blue:219 alpha:1.0] CGColor];
    _img_UserProfile.clipsToBounds = YES;

    
    _lbl_topName.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"FriendName"];
    // Do any additional setup after loading the view.
    bubbleData=[[NSMutableArray alloc] init];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dictHist setObject:strLimt forKey:@"limit"];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"FriendID"] forKey:@"toid"];
    [self WebResponse:dictHist WebserviceName:kGetchat];
    
    UINib *nib = [UINib nibWithNibName:@"ChatSendCell" bundle:nil];
    
    [[self tbl_Chats] registerNib:nib forCellReuseIdentifier:@"chatSend"];
    
    nib = [UINib nibWithNibName:@"ChatReceiveCell" bundle:nil];
    
    [[self tbl_Chats] registerNib:nib forCellReuseIdentifier:@"chatReceive"];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 10, *)) {
        _tbl_Chats.refreshControl = refreshControl;
    }
    else
    {
        [_tbl_Chats  addSubview:refreshControl];
    }
    
    //Instantiating custom view that adjusts itself to keyboard show/hide
  /*  self.handler = [[ContentView alloc] initWithTextView:self.chatTextView ChatTextViewHeightConstraint:self.chatTextViewHeightConstraint contentView:self.contentView ContentViewHeightConstraint:self.contentViewHeightConstraint andContentViewBottomConstraint:self.contentViewBottomConstraint];
    
    //Setting the minimum and maximum number of lines for the textview vertical expansion
    [self.handler updateMinimumNumberOfLines:1 andMaximumNumberOfLine:3];*/
}
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshTable {
    //TODO: refresh your data'
    isSendClicked=false;
    strLimt = [NSString stringWithFormat:@"%d",[strLimt intValue]+500];
    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dictHist setObject:strLimt forKey:@"limit"];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"FriendID"] forKey:@"toid"];
    [self WebResponse:dictHist WebserviceName:kGetchat];
    
}

#pragma mark - table view delegate and data source methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bubbleData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    iMessage *message = [bubbleData objectAtIndex:indexPath.row];
    
    if([message.messageType isEqualToString:@"self"])
    {
        /*Uncomment second line and comment first to use XIB instead of code*/
        //chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        _chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatSend"];
        
        _chatCell.chatMessageLabel.text =message.userMessage;
        
        _chatCell.chatNameLabel.text = @"";

        _chatCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _chatCell.chatTimeLabel.text = message.userTime;
        
       // _chatCell.chatUserImage.image = [UIImage imageNamed:@"defaultUser"];
        
        /*Comment this line is you are using XIB*/
        //_chatCell.authorType = iMessageBubbleTableViewCellAuthorTypeSender;
    }
    else
    {
        /*Uncomment second line and comment first to use XIB instead of code*/
       // chatCell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        _chatCell = (ChatTableViewCellXIB *)[tableView dequeueReusableCellWithIdentifier:@"chatReceive"];
        
        _chatCell.chatMessageLabel.text = message.userMessage;
       
        _chatCell.chatNameLabel.text = @"";
        
        _chatCell.chatTimeLabel.text = message.userTime;
        
        _chatCell.chatUserImage.image = [UIImage imageNamed:@"defaultUser"];
        _chatCell.selectionStyle = UITableViewCellSelectionStyleNone;

        /*Comment this line is you are using XIB*/
       // _chatCell.authorType = iMessageBubbleTableViewCellAuthorTypeReceiver;
    }
    
    return _chatCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    iMessage *message = [bubbleData objectAtIndex:indexPath.row];
    
    CGSize size;
    
    CGSize Namesize;
    CGSize Timesize;
    CGSize Messagesize;
    
   // NSArray *fontArray = [[NSArray alloc] init];
    
    //Get the chal cell font settings. This is to correctly find out the height of each of the cell according to the text written in those cells which change according to their fonts and sizes.
    //If you want to keep the same font sizes for both sender and receiver cells then remove this code and manually enter the font name with size in Namesize, Messagesize and Timesize.
  /*  if([message.messageType isEqualToString:@"self"])
    {
        fontArray = chatCellSettings.getSenderBubbleFontWithSize;
    }
    else
    {
        fontArray = chatCellSettings.getReceiverBubbleFontWithSize;
    }
   */
    //Find the required cell height
    UIFont *boldFontName = [UIFont systemFontOfSize:12];
    Namesize = [@"Name" boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:boldFontName}
                                     context:nil].size;
    
    
    
    Messagesize = [message.userMessage boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:boldFontName}
                                                    context:nil].size;
    
    
    Timesize = [@"Time" boundingRectWithSize:CGSizeMake(220.0f, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:boldFontName}
                                     context:nil].size;
   
    
    size.height = Messagesize.height + Namesize.height + Timesize.height + 48.0f;
    
    return size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;{
    return  (bubbleData.count > 0) ? 56.0 : 1.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    CGFloat height = (bubbleData.count > 0) ? 56.0 : 1.0;
    
    UIView *viewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, height)];
    viewFooter.backgroundColor = [UIColor clearColor];
    return viewFooter;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Webservice Call
-(void)WebResponse:(NSDictionary *)Params WebserviceName:(NSString *)WebserviceName
{
    NSString *stringUrl = [HostName stringByAppendingString:WebserviceName];
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
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
         NSLog(@"chatdata: %@", [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8]);

         if (data.length > 0 && connectionError == nil)
         {
             
             NSDictionary *dicYourResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             NSLog(@"%@",dicYourResponse);
             if(![[dicYourResponse valueForKey:@"status"] isEqualToString:@"0"])
             {
              
                 [self updateTableView:[dicYourResponse valueForKey:@"data"]];

             }
         }
         
         if(refreshControl.isRefreshing)
         {
             [refreshControl endRefreshing];
         }
     }];
   
    
}
- (IBAction)btn_Back_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:false];
}

- (IBAction)btn_Send_Action:(id)sender
{
    isSendClicked=true;
    [textField resignFirstResponder];
    //self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);


    if(textField.text.length>0 && ![textField.text isEqualToString:@" "])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
        [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
        [dictHist setObject:textField.text forKey:@"message"];
        [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"FriendID"] forKey:@"fid"];
        [self WebResponse:dictHist WebserviceName:kSendMessage];
        
        
        //[bubbleData addObject:textField.text];
        //[_tbl_Chats reloadData];
        
        
            textField.text = @"";
            isSendClicked=false;
    }
    else
    {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Alert!" message:@"Message cannot be empty." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (IBAction)receiveMessage:(id)sender
{
    if([self.chatTextView.text length]!=0)
    {
//        iMessage *receiveMessage;
//
//        receiveMessage = [[iMessage alloc] initIMessageWithName:@"Prateek Grover" message:self.chatTextView.text time:@"23:14" type:@"other"];
//
//        [self updateTableView:receiveMessage];
    }
}

-(void) updateTableView:(NSArray *)msgArray
{
    [textField setText:@""];
    [self.handler textViewDidChange:self.chatTextView];
    if(msgArray.count>0)
    {
        [bubbleData removeAllObjects];
    }
    for (int i= 0; i<msgArray.count; i++) {
        iMessage *sendMessage;
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        dict = [msgArray objectAtIndex:i];
        NSString *type = @"";
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"]);
        if([[dict valueForKey:@"fid"] intValue] == [[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] intValue])
        {
            type = @"self";
        }
        else
        {
            type = @"someone";
        }
        sendMessage = [[iMessage alloc] initIMessageWithName:[dict valueForKey:@"fname"] message:[dict valueForKey:@"message"] time:[dict valueForKey:@"time"] type:type];
        [bubbleData addObject:sendMessage];

    }
  
    [_tbl_Chats reloadData];
//    [self.tbl_Chats beginUpdates];
//
//    NSIndexPath *row1 = [NSIndexPath indexPathForRow:bubbleData.count inSection:0];
//
//    [bubbleData insertObject:msg atIndex:bubbleData.count];
//
//    [self.tbl_Chats insertRowsAtIndexPaths:[NSArray arrayWithObjects:row1, nil] withRowAnimation:UITableViewRowAnimationBottom];
//
//    [self.tbl_Chats endUpdates];
    
    //Always scroll the chat table when the user sends the message
    if([self.tbl_Chats numberOfRowsInSection:0]!=0)
    {
        NSIndexPath* ip = [NSIndexPath indexPathForRow:[self.tbl_Chats numberOfRowsInSection:0]-1 inSection:0];
        [self.tbl_Chats scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:UITableViewRowAnimationLeft];
    }
}


- (IBAction)btn_loadMore_Action:(id)sender
{
    isSendClicked=false;
    strLimt = [NSString stringWithFormat:@"%d",[strLimt intValue]+500];
    NSMutableDictionary *dictHist=[[NSMutableDictionary alloc] init];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserId"] forKey:@"userid"];
    [dictHist setObject:strLimt forKey:@"limit"];
    [dictHist setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"FriendID"] forKey:@"toid"];
    [self WebResponse:dictHist WebserviceName:kGetchat];
}


#pragma  mark - text feild delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textY = textField.frame.origin.y;
//    if(self.view.frame.origin.x >=0)
//       self.view.frame = CGRectMake(self.view.frame.origin.x, -245, self.view.frame.size.width, self.view.frame.size.height);
    
    
//    textField.frame= CGRectMake(textField.frame.origin.x, textField.frame.origin.y-180, textField.frame.size.width, textField.frame.size.height);
//    _img_TextBack.frame = CGRectMake(_img_TextBack.frame.origin.x, _img_TextBack.frame.origin.y-180, _img_TextBack.frame.size.width, _img_TextBack.frame.size.height);
//    _btn_Send.frame = CGRectMake(_btn_Send.frame.origin.x, _btn_Send.frame.origin.y-180, _btn_Send.frame.size.width, _btn_Send.frame.size.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
       // self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
//    if(textField.frame.origin.y < textY)
//    {
//        textField.frame= CGRectMake(textField.frame.origin.x, textField.frame.origin.y+130, textField.frame.size.width, textField.frame.size.height);
//        _img_TextBack.frame = CGRectMake(_img_TextBack.frame.origin.x, _img_TextBack.frame.origin.y+130, _img_TextBack.frame.size.width, _img_TextBack.frame.size.height);
//        _btn_Send.frame = CGRectMake(_btn_Send.frame.origin.x, _btn_Send.frame.origin.y+130, _btn_Send.frame.size.width, _btn_Send.frame.size.height);
//
//    }
    return true;
}
@end
