//
//  listViewController.m
//  Nerdfeed
//
//  Created by lovocas on 13-11-28.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "listViewController.h"
#import "webViewController.h"
#import "channelViewController.h"
#import "BNRFeedStore.h"

@implementation listViewController

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.channel.array count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     //webViewController * wv=[[webViewController alloc]init];
    if(![self splitViewController])
    [self.navigationController pushViewController:self.webView animated:YES];
    
   /* NSString * url=[[self.channel.array objectAtIndex:[indexPath row]]link];
    NSURL * reqUrl=[NSURL URLWithString:url];
    NSURLRequest * req =[NSURLRequest requestWithURL:reqUrl];
   
    //self.webView =wv;
    [self.webView.webview loadRequest:req];
    [[self.webView navigationItem]setTitle:[[self.channel.array objectAtIndex:[indexPath row]]title]];*/
    RSItem * item =[self.channel.array objectAtIndex:[indexPath row]];
     [[BNRFeedStore sharedStore]markItemAsRead:item];
    [[self.tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
    [self.webView listViewController:self handledObject:item];
    
    if([self splitViewController])
    {
        //add the webview into new navigator
        UINavigationController * detail =[[UINavigationController alloc]initWithRootViewController:self.webView];
        [self.splitViewController  setViewControllers:[NSArray arrayWithObjects:[self navigationController],detail,nil]];
        [self.splitViewController setDelegate:self.webView];
       // [self splitViewController]setViewControllers:<#(NSArray *)#>
    }
    //
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return nil;
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"titleCell"];
    if(!cell)
    {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCell"];
        
    }
    RSItem * item = [self.channel.array objectAtIndex:[indexPath row]];
    [cell.textLabel setText:item.title];
    if([[BNRFeedStore sharedStore]hasItembeenRead:item])
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    return  cell;
}

-(void)fetchEntries
{
   /* xmldata =[[NSMutableData alloc]init];
    
    NSURL * url =[NSURL URLWithString:
    @"http://forums.bignerdranch.com/smartfeed.php?"
    @"limit=1_DAY&sort_by=standard&feed_type=RSS2.0&feed_style=COMPACT"];
    NSURLRequest * req=[[NSURLRequest alloc]initWithURL:url];
    conn=[[NSURLConnection alloc]initWithRequest:req delegate:self startImmediately:YES];*/
    //[[BNRFeedStore sharedStore]fetchRSSFeedWithCompletion:
     void(^completeblock)(RSChannel * channel,NSError * error)= ^(RSChannel * channel,NSError * error){
        if (!error) {
            self.channel =channel;
            [self.tableView reloadData];
        } else {
            UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [av show];
        }
    };
    if (rssType) {
        [[BNRFeedStore sharedStore]fetchTopsongs:10 WithCompletion:completeblock];
    }
    else
    {
        self.channel=[[BNRFeedStore sharedStore]fetchRSSFeedWithCompletion:^(RSChannel * object,NSError * error){
            
            int  count =[[self.channel  array ]count];
            int newcoune =[[object array]count];
            self.channel =object;
            int internal =newcoune -count;
            if(internal>0){
            NSMutableArray * rows=[NSMutableArray array];
          
            for (int i=0;i<internal;i++)
            {
                NSIndexPath * row =[NSIndexPath indexPathForRow:i inSection:0];
                [rows addObject:row];
                
            }
            [self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationTop];
            }
        }];
        [self.tableView reloadData];
    }
}
/*-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [xmldata appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * string =[[NSString alloc]initWithData:xmldata encoding:NSUTF8StringEncoding];
    WSLog(@"xmldata is %@",string);
    NSXMLParser * parser =[[NSXMLParser alloc]initWithData:xmldata];
    [parser setDelegate:self];
    [parser parse];
    
    
    xmldata =nil;
    connection =nil;
    [self.tableView reloadData];
    NSLog(@"%@\n %@\n %@\n",self.channel, [self.channel title], [self.channel infoString]);
}
 -(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
 {
 conn =nil;
 xmldata =nil;
 NSString * err =[NSString stringWithFormat:@"fetch errot %@",[error localizedDescription]];
 UIAlertView * av=[[UIAlertView alloc]initWithTitle:@"error" message:err  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
 [av show];
 
 
 }
 */
-(BOOL)shouldAutorotate
{
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        return YES;
    return  NO;
}

/*-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
     NSLog( @"%@,find the element %@",self,elementName);
    if([elementName isEqualToString: @"channel"])
    {
        self.channel =[[RSChannel alloc]init];
        [self.channel setParentDelegate: self];
        [parser setDelegate:self.channel];
    }
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
}*/
-(id)initWithStyle:(UITableViewStyle)style
{
    self =[super initWithStyle:style];
    if(self){
        UIBarButtonItem* right =[[UIBarButtonItem alloc]initWithTitle:@"info" style:UIBarButtonItemStylePlain target:self action:@selector(showInfo:)];
        self.navigationItem.rightBarButtonItem=right;
        //
        UISegmentedControl * seg=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"BNR",@"Apple",nil]];
        [seg setSelectedSegmentIndex:0];
        [seg addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventValueChanged];
        [self.navigationItem setTitleView:seg];
        [self fetchEntries];
    }
    return self;
}
-(void)changeType:(id)sender
{
    rssType =[sender selectedSegmentIndex];
    [self fetchEntries];
}
-(void)showInfo:(id)sender
{
    
    UINavigationController * detail= [[self.splitViewController viewControllers]objectAtIndex:1];
    UIBarButtonItem * button = [[[detail topViewController]navigationItem]leftBarButtonItem];
    
    channelViewController * channel =[[channelViewController alloc]init];
  
    if([self splitViewController]){
        UINavigationController * detail =[[UINavigationController alloc]initWithRootViewController:channel];
        [self.splitViewController  setViewControllers:[NSArray arrayWithObjects:[self navigationController],detail,nil]];
        [self.splitViewController setDelegate:channel];
        [channel.navigationItem setLeftBarButtonItem:button];
    }
    else
        [self.navigationController pushViewController:channel animated:YES];
    [channel listViewController:self handledObject:self.channel];
}


@end
