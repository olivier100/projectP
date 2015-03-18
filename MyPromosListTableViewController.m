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
#import "PromoDetailsViewController.h"
#import <Parse/Parse.h>

@interface MyPromosListTableViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *promoDescriptionLabel;

@property (strong, nonatomic) NSMutableArray *promoItems;


@end

@implementation MyPromosListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.promoItems = [[NSMutableArray alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self loadInitialData];
    
}


-(void)loadInitialData{
 
    //ADD ITEMS
//    PromoItem *promo1 = [[PromoItem alloc]init];
//    promo1.promoSummary = @"Promo 1";
//    promo1.promoDescription = @"This is the description for promo 1. You can get this promotion by coming to the location and presenting your WinPromo pomo";
//    promo1.promoRetailerLogo = [UIImage imageNamed:@"image1.png"];
//    [self.promoItems addObject:promo1];
//
//    PromoItem *promo2 = [[PromoItem alloc]init];
//    promo2.promoSummary = @"Promo 2";
//    promo2.promoDescription = @"This is the description for promo 2. You can get this promotion by coming to the location and presenting your WinPromo pomo";
//    promo2.promoRetailerLogo = [UIImage imageNamed:@"image2.jpg"];
//    [self.promoItems addObject:promo2];
//
//    PromoItem *promo3 = [[PromoItem alloc]init];
//    promo3.promoDescription = @"This is the description for promo 3. You can get this promotion by coming to the location and presenting your WinPromo pomo";
//    promo3.promoSummary = @"Promo 3";
//    UIImage *image = [UIImage imageNamed:@"image3.jpg"];
//    promo3.promoRetailerLogo = image;
//    [self.promoItems addObject:promo3];
    

        //OLIV LOAD DATA FROM PARSE
        PFQuery *query = [PFQuery queryWithClassName:@"Promo"];
  
    
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
    
                for (PFObject *arr in objects) {
                    NSLog(@"PromoSummary = %@",[arr valueForKey:@"title"]);
                    NSLog(@"PromoDescription = %@",[arr valueForKey:@"description"]);

                    PromoItem *promoItem = [[PromoItem alloc]init];
                    promoItem.promoSummary = [arr valueForKey:@"title"];
                    promoItem.promoDescription = [arr valueForKey:@"description"];

                    [self.promoItems addObject:promoItem];
                    [self.tableView reloadData];
                    
                }
    
//                PFFile *logo = [[objects objectAtIndex:1] objectForKey:@"picture"];
//                [logo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//    
//                    PromoItem *promo1 = [[PromoItem alloc]init];
//                    promo1.promoSummary = @"Promo1";
//                    promo1.promoRetailerLogo = [UIImage imageWithData:data];
//                    [self.promoItems addObject:promo1];
//                    
//                    //reload the data in the tableview
//                    [self.tableView reloadData];
//                }]; 
    
            } else {
                NSLog(@"Error");
            }
            
        }];
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPropertyCell" forIndexPath:indexPath];
    
    // Configure the cell...
    PromoItem *promoItem = [self.promoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = promoItem.promoSummary;
    cell.detailTextLabel.text = promoItem.promoDescription;
    [cell.imageView setFrame:CGRectMake(0, 0, 10, 10)];
    cell.imageView.image = promoItem.promoRetailerLogo;


//    DISPLAY ITEM COMPLETION STATE
//    if (promoItem.promoCompleted) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    } else {
//        cell.accessoryType = UITableViewCellAccessoryNone;
//    }
    
    return cell;
}

#pragma mark - Table View Delegate


//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
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
    
    PromoDetailsViewController *promoDetailViewController = [segue destinationViewController];

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    PromoItem *promoItem = [[PromoItem alloc]init];
    promoItem = self.promoItems[indexPath.row];
    promoDetailViewController.promoItem = promoItem;
 
}



@end
