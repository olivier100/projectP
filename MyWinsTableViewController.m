//
//  MyWinsTableViewController.m
//  WinPromos
//
//  Created by olivier on 2015-03-20.
//  Copyright (c) 2015 IronHack. All rights reserved.
//

#import "MyWinsTableViewController.h"
#import <Parse/Parse.h>
#import "PromoItem.h"
#import "MyWinsDetailsViewController.h"

@interface MyWinsTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *promoItems;

@end

@implementation MyWinsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.promoItems = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}


-(void)loadInitialData{

    //PARSE GET - LOAD DATA FROM PARSE
    
    //Create the PromoQuery linked to the PromoWinner table in parse
    PFQuery *myWinsQuery = [PFQuery queryWithClassName:@"PromoWinner"];
    
    //exclude items with "true" in the promoCollected field
    BOOL collected = true;
    [myWinsQuery whereKey:@"promoCollected" notEqualTo:[NSNumber numberWithBool:collected]];
    
    //We need to get the Retailer Name which is two tables away
    //To do this we say, go to "Promo" table using "promoID" and then go to "Advertisers" table using "advertiserID"
    //We can now retrieve the Retailer name using this path -> "PromoWinner" -> "Promo" -> "Advertisers"
    [myWinsQuery includeKey:@"promoID.advertiserID"];
    
    //Parse method to download the tables
    //It says, execute the following with the objects from this query
    [myWinsQuery findObjectsInBackgroundWithBlock:^(NSArray *promoWinnerTableFromParse, NSError *error) {
        
        //Verify if there is no error
        if (!error) {
            
            //only used to return each image in the objectAtIndex
            int i = 0;
            
            //Convert every row from the Parse table into an Objective C object
            for (PFObject *promo in promoWinnerTableFromParse) {
                
                //Initialise promo object
                PromoItem *promoItem = [[PromoItem alloc]init];
                
                //fill the Retailer related properties of the promo object
                promoItem.promoRetailerName = [[[promo valueForKey:@"promoID"]valueForKey:@"advertiserID"]valueForKey:@"advertiserName"];

                //fill the promoItem related properties of the promo object
                promoItem.promoSummary = [[promo valueForKey:@"promoID"]valueForKey:@"promoSummary"];
                promoItem.promoDescription = [[promo valueForKey:@"promoID"]valueForKey:@"promoDescription"];
                promoItem.promoValueAmount = [[[promo  valueForKey:@"promoID"]valueForKey:@"promoValueAmount"] integerValue];
                promoItem.promoValidUntil = [[promo valueForKey:@"promoID"]valueForKey:@"promoValidUntil"];
                promoItem.promoObjectId = [promo valueForKey:@"objectId"];
                
                //method to load the image
                PFFile *promoImage = [[[promoWinnerTableFromParse objectAtIndex:i] valueForKey:@"promoID"] objectForKey:@"promoImage"];
                [promoImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                promoItem.promoImage = [UIImage imageWithData:data];
                
                //reload the data in the tableview
                [self.tableView reloadData];
                }];
                
                //add each object to the array
                [self.promoItems addObject:promoItem];
                [self.tableView reloadData];
                i++;
                
            }
            
        } else {
            NSLog(@"Error");
        }
        
    }];
}


-(void)viewDidAppear:(BOOL)animated{
    [self.promoItems removeAllObjects];
    [self loadInitialData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.promoItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPropertyCell" forIndexPath:indexPath];
    
    // Configure the cell...
    PromoItem *promoItem = [self.promoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = promoItem.promoRetailerName;
    cell.detailTextLabel.text = promoItem.promoSummary;
    [cell.imageView setFrame:CGRectMake(0, 0, 10, 10)];
    cell.imageView.image = promoItem.promoImage;
 
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
        MyWinsDetailsViewController *MyWinsDetailViewController = [segue destinationViewController];
 
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PromoItem *promoItem = [[PromoItem alloc]init];
        promoItem = self.promoItems[indexPath.row];
        MyWinsDetailViewController.promoItemWin = promoItem;
    
}


@end
