//
//  MyWinsDetailsViewController.m
//  WinPromos
//
//  Created by olivier on 2015-03-20.
//  Copyright (c) 2015 IronHack. All rights reserved.
//

#import "MyWinsDetailsViewController.h"
#import <Parse/Parse.h>

@interface MyWinsDetailsViewController ()


//Properties specific to the PROMO
@property (weak, nonatomic) IBOutlet UILabel *promoSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *promoRetailerLogoUIImageView;
@property (weak, nonatomic) IBOutlet UILabel *promoValideUntilLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoValueAmountLabel;

//Properties specific to the RETAILER
@property (weak, nonatomic) IBOutlet UILabel *promoRetailerName;
@property (weak, nonatomic) IBOutlet UILabel *promoRetailerURLLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoRetailerTelephoneLabel;

//Retailer button to delete a promoItem from the Win screen
- (IBAction)deleteWinPromoButton:(id)sender;

@end

@implementation MyWinsDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.promoRetailerName.text = self.promoItemWin.promoRetailerName;
    self.promoRetailerURLLabel.text = (NSString*)self.promoItemWin.promoRetailerURL;
    self.promoRetailerTelephoneLabel.text = self.promoItemWin.promoRetailerTelephone;
    
    self.promoSummaryLabel.text = self.promoItemWin.promoSummary;
    self.promoDescriptionLabel.text = self.promoItemWin.promoDescription;
    self.promoRetailerLogoUIImageView.image = self.promoItemWin.promoImage;
    self.promoValideUntilLabel.text = [NSString stringWithFormat:@"%@",self.promoItemWin.promoValidUntil];
    self.promoValueAmountLabel.text = [NSString stringWithFormat:@"%lu",self.promoItemWin.promoValueAmount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)deleteWinPromoButton:(id)sender {
    
    
    // Create a query to retrieve the Parse promo object property "objectId"
    PFQuery *promoQuery = [PFQuery queryWithClassName:@"PromoWinner"];
    [promoQuery whereKey:@"objectId" equalTo:self.promoItemWin.promoObjectId];
    
    NSLog(@"objectID = %@",self.promoItemWin.promoObjectId);
    NSLog(@"promoQuery = %@",promoQuery.description);

    
    //Once the ObjectId has been retrieved, update the Parse promoWinner table within the block below
    [promoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
      
        //PARSE - save the collected in the PromoWinner parse table to the right user line
        PFObject *promoItem = [objects firstObject];
        BOOL collected = true;
        promoItem[@"promoCollected"] = [NSNumber numberWithBool:collected];
        
        [promoItem saveEventually];

        
    }];
    
}
@end
