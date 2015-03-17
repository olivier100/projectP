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

@interface MyPromosListTableViewController ()

@property (strong, nonatomic) NSMutableArray *promoItems;


@end

@implementation MyPromosListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.promoItems = [[NSMutableArray alloc] init];
    [self loadInitialData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)loadInitialData{
 
    //ADD ITEMS
    PromoItem *promo1 = [[PromoItem alloc]init];
    promo1.promoSummary = @"Promo 1";
    promo1.promoDescription = @"This is the description for promo 1. You can get this promotion by coming to the location and presenting your WinPromo pomo";
    [self.promoItems addObject:promo1];

    PromoItem *promo2 = [[PromoItem alloc]init];
    promo2.promoSummary = @"Promo 2";
    promo2.promoDescription = @"This is the description for promo 2. You can get this promotion by coming to the location and presenting your WinPromo pomo";
    [self.promoItems addObject:promo2];

    PromoItem *promo3 = [[PromoItem alloc]init];
    promo3.promoDescription = @"This is the description for promo 3. You can get this promotion by coming to the location and presenting your WinPromo pomo";
    promo3.promoSummary = @"Promo 3";
    [self.promoItems addObject:promo3];

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


-(IBAction)unwindToList:(UIStoryboardSegue *)segue{
    
    AddPromoViewController *source = [segue sourceViewController];
    PromoItem *promoItem = source.promoItem;
    
    if (promoItem != nil) {
        [self.promoItems addObject:promoItem];
        [self.tableView reloadData];
    };
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPropertyCell" forIndexPath:indexPath];
    
    // Configure the cell...
    PromoItem *promoItem = [self.promoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = promoItem.promoSummary;
    
    //DISPLAY ITEM COMPLETION STATE
    if (promoItem.promoCompleted) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table View Delegate

//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    PromoItem *tappedPromoItem = [self.promoItems objectAtIndex:indexPath.row];
//    tappedPromoItem.promoCompleted = !tappedPromoItem.promoCompleted;
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
    PromoDetailsViewController *promoDetailViewController = [segue destinationViewController];

    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    PromoItem *promoItem = [[PromoItem alloc]init];
    promoItem = self.promoItems[indexPath.row];
    promoDetailViewController.promoItem = promoItem;
 
}


@end