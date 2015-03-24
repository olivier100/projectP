//
//  MyPromosListTableViewController.m
//  WinPromos
//
//  Created by olivier on 2015-03-16.
//  Copyright (c) 2015 IronHack. All rights reserved.
//

#import "MyPromosListTableViewController.h"
#import "PromoItem.h"
#import "AddPromoViewController.h"
#import "PromoGameViewController.h"
#import <Parse/Parse.h>
#import "ListPropertyCellTableViewCell.h"
@interface MyPromosListTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *promoItems;
@property int noOfPromosLabel;
@property int promoSummaryTotalValue;


@end

@implementation MyPromosListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self parseLogin];
    
    self.promoItems = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadInitialData];
    [self getPromoIdFromPromoWinnerTable];
}

-(void)viewDidAppear:(BOOL)animated{
//    [self getPromoIdFromPromoWinnerTable];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        return 40;
    } else {
        return 85;
    }
    
    
}

-(void)parseLogin{
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}


-(void)loadInitialData{
    
    //OLIV - LOAD DATA FROM PARSE
    
    //Create the PromoQuery linked to the Promo table in parse
    PFQuery *promoQuery = [PFQuery queryWithClassName:@"Promo"];

    //Add the column making the connection to the Advertiser table
    [promoQuery includeKey:@"advertiserID"];
    
    PFObject *promoWinner = [PFObject objectWithClassName:@"PromoWinner"];
    [promoQuery whereKeyDoesNotExist:@"promoID"];
    
    
    //Parse method to download the tables
    [promoQuery findObjectsInBackgroundWithBlock:^(NSArray *promoTableFromParse, NSError *error) {
        
        //Verify if there is no error
        if (!error) {
            
            //FOR THE SUMMARY CELL
            //Count number of promos in the array
            self.noOfPromosLabel = promoTableFromParse.count;
            
            //Sum the total promo value amount
            double sum = 0;
            for (NSNumber * n in [promoTableFromParse valueForKey:@"promoValueAmount"]) {
                sum += [n doubleValue];
            }
            self.promoSummaryTotalValue = sum ;

            
            //only used to return each image in the objectAtIndex
            int i = 0;
            
            //Convert every row from the Parse table into an Objective C object
            for (PFObject *promo in promoTableFromParse) {
                
                //Initialise promo object
                PromoItem *promoItem = [[PromoItem alloc]init];
                
                //fill the properties of the promo object
                
                //Retailer specific properties
                promoItem.promoRetailerName = [[promo valueForKey:@"advertiserID"]valueForKey:@"advertiserName"];
                promoItem.promoRetailerType = [[promo valueForKey:@"advertiserID"]valueForKey:@"advertiserType"];
                promoItem.promoRetailerURL = [[promo valueForKey:@"advertiserID"]valueForKey:@"advertiserURL"];
                promoItem.promoRetailerTelephone = [[promo valueForKey:@"advertiserID"]valueForKey:@"advertiserTelephone"];
                
                //Promo specific properties
                promoItem.promoSummary = [promo valueForKey:@"promoSummary"];
                promoItem.promoDescription = [promo valueForKey:@"promoDescription"];
                promoItem.promoValueAmount = [[promo valueForKey:@"promoValueAmount"] integerValue];    //??? how to cast?
                promoItem.promoValidUntil = [promo valueForKey:@"promoValidUntil"]; //??? how to cast?
                promoItem.promoObjectId = [promo valueForKey:@"objectId"];
                promoItem.promoType = [promo objectForKey:@"promoType"];
                promoItem.promoStatus = [promo objectForKey:@"promoStatus"];
            
                
                //method to load the Retailer Logo
                PFFile *promoRetailerLogo = [[[promoTableFromParse objectAtIndex:i] valueForKey:@"advertiserID"]valueForKey:@"advertiserLogo"];
                [promoRetailerLogo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    promoItem.promoRetailerLogo = [UIImage imageWithData:data];
                  
                }];
                
                //method to load the Promo Image
                PFFile *promoImage = [[promoTableFromParse objectAtIndex:i] objectForKey:@"promoImage"];
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


-(void)getPromoIdFromPromoWinnerTable{
    
    int x =1;
    
    if (x ==1)
    {
    //OTHER ATTEMPT - 1 - Returns the Promos from the current user - but the promoID are from the PromoWinner table
        PFQuery *query = [PFQuery queryWithClassName:@"Promo"];
        //    [query whereKey:@"objectId" matchesKey:@"promoID" inQuery:query];
        
        PFQuery *innerQuery = [PFQuery queryWithClassName:@"PromoWinner"];
        [innerQuery whereKey:@"user" equalTo:[PFUser currentUser]];
        [innerQuery findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
            
            for (PFObject *promo in comments) {
                NSLog(@"Result from innerQuery promoID = %@", [comments valueForKey:@"promoID"]);
                NSLog(@"Result from innerQuery ObjectId = %@", [comments valueForKey:@"objectId"]);
                NSLog(@"Result from innerQuery ObjectId = %@", [comments valueForKey:@"promoSummary"]);
                
            }
        }];
        
    } else if (x ==2)
    
    {
    //OTHER ATTEMPT - 2 - Does not return the NSLogs
        PFQuery *innerQuery = [PFQuery queryWithClassName:@"PromoWinner"];
        [innerQuery whereKey:@"user" equalTo:[PFUser currentUser]];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Promo"];
        [query whereKey:@"objectId" matchesKey:@"promoID" inQuery:innerQuery];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
            
            for (PFObject *promo in comments) {
                NSLog(@"Result from innerQuery promoID = %@", [comments valueForKey:@"promoID"]);
                NSLog(@"Result from innerQuery ObjectId = %@", [comments valueForKey:@"objectId"]);
                NSLog(@"Result from innerQuery ObjectId = %@", [comments valueForKey:@"promoSummary"]);
            }
        }];
        
    } else if (x==3)
    
    {
    //OTHER ATTEMPT - 3 - Gives "[Error]: bad type for $inQuery (Code: 102, Version: 1.6.5)"
        PFQuery *innerQuery = [PFQuery queryWithClassName:@"PromoWinner"];
        [innerQuery whereKey:@"user" equalTo:[PFUser currentUser]];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Promo"];
        [query whereKey:@"objectId" matchesQuery:innerQuery];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
            
            for (PFObject *promo in comments) {
                NSLog(@"Result from innerQuery promoID = %@", [comments valueForKey:@"promoID"]);
                NSLog(@"Result from innerQuery ObjectId = %@", [comments valueForKey:@"objectId"]);
                NSLog(@"Result from innerQuery ObjectId = %@", [comments valueForKey:@"promoSummary"]);
                
                
            }
        }];
        
    } else if (x==4)
        
    {
        
        //OTHER ATTEMPT - 4 - Block in a Block -> returns error
        
        PFQuery *innerQuery = [PFQuery queryWithClassName:@"PromoWinner"];
        [innerQuery whereKey:@"user" equalTo:[PFUser currentUser]];
        [innerQuery findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
            
            PFQuery *query = [PFQuery queryWithClassName:@"Promo"];
            [query whereKey:@"objectId" matchesKey:@"promoID" inQuery:query];
            [query findObjectsInBackgroundWithBlock:^(NSArray *comments2, NSError *error) {
                
                for (PFObject *promo in comments2) {
                    NSLog(@"Result from innerQuery promoID = %@", [comments2 valueForKey:@"promoID"]);
                    NSLog(@"Result from innerQuery ObjectId = %@", [comments2 valueForKey:@"objectId"]);
                    NSLog(@"Result from innerQuery ObjectId = %@", [comments2 valueForKey:@"promoSummary"]);
                    
                }
            }];
            
        }];
        
    }
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
    return [self.promoItems count] +1;
}


//-(IBAction)unwindToList:(UIStoryboardSegue *)segue{
//    
//    AddPromoViewController *source = [segue sourceViewController];
//    PromoItem *promoItem = source.promoItem;
//    
//    if (promoItem != nil) {
//        [self.promoItems addObject:promoItem];
//        [self.tableView reloadData];
//    };
//}


//  UNCOMMENT THIS TO GO BACK TO DETAIL CELLS FORMAT
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//   
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPropertyCell" forIndexPath:indexPath];
//    
//    //DETAIL CELL - Configure the cell...
//    PromoItem *promoItem = [self.promoItems objectAtIndex:indexPath.row];
//    cell.textLabel.text = promoItem.promoRetailerName;
//    cell.detailTextLabel.text = promoItem.promoSummary;
//    [cell.imageView setFrame:CGRectMake(0, 0, 10, 10)];
//    cell.imageView.image = promoItem.promoImage;
//
//    return cell;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        ListPropertyCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PromosSummaryPropertyCell" forIndexPath:indexPath];
        NSLog(@"no of promos = %lu", self.noOfPromosLabel);
        cell.noOfPromosLabel.text = [NSString stringWithFormat:@"%lu", self.noOfPromosLabel];
        cell.promoSummaryTotalValue.text = [NSString stringWithFormat:@"%lu", self.promoSummaryTotalValue];

        return cell;
        
    } else {
        
        ListPropertyCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPropertyCell" forIndexPath:indexPath];
        
        // CUSTOM CELL - Configure the cell
        PromoItem *promoItem = [self.promoItems objectAtIndex:indexPath.row - 1];
        cell.retailerNameLabel.text = promoItem.promoRetailerName;
        cell.promoSummaryLabel.text = promoItem.promoSummary;
        cell.promoImageLabel.image = promoItem.promoImage;
        cell.promoValueAmountLabel.text = [NSString stringWithFormat:@"%lu", promoItem.promoValueAmount];
        cell.noOfPromosLabel.text = [NSString stringWithFormat:@"%lu", self.noOfPromosLabel];
        
        return cell;
    }
}

#pragma mark - Table View Delegate


//A WAY TO DO A SEGUE BY CODE
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"ho");
//    
//    if (indexPath.row != 0) {
//        PromoGameViewController *promoVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PromoDetailsViewController"];
//    
//        promoVC.promoItem = self.promoItems[indexPath.row -1];
//    
//        [self.navigationController pushViewController:promoVC animated:YES];
//    }
//}



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
    
    NSLog(@"%@", sender);
    
            PromoGameViewController *promoDetailViewController = [segue destinationViewController];
        
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            PromoItem *promoItem = [[PromoItem alloc]init];
            promoItem = self.promoItems[indexPath.row -1] ;
            promoDetailViewController.promoItem = promoItem;
 
}



@end
