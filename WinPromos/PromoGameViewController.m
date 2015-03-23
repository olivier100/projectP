//
//  PromoDetailsViewController.m
//  WinPromos
//
//  Created by olivier on 2015-03-16.
//  Copyright (c) 2015 IronHack. All rights reserved.
//

#import "PromoGameViewController.h"
#import <WebKit/WebKit.h>
#import <Parse/Parse.h>
#import "PromoDetailsViewController.h"

@interface PromoGameViewController () <WKScriptMessageHandler> //TRIAL

//Properties specific to the PROMO
@property (weak, nonatomic) IBOutlet UILabel *promoSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoValideUntilLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoValueAmountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *promoImageUIImageView;

//Properties specific to the RETAILER
@property (weak, nonatomic) IBOutlet UILabel *promoRetailerName;
@property (weak, nonatomic) IBOutlet UILabel *promoRetailerURLLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoRetailerTelephoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *promoRetailerLogoUIImageView;




//Button property to navigate to next page
@property (weak, nonatomic) IBOutlet UIButton *promoDetailsButton;

//FOR WebView
@property (weak, nonatomic) IBOutlet UIWebView *gameUIWebView;

//FOR WKWebView
@property(strong,nonatomic) WKWebView *gameWKwebView;
@property(strong,nonatomic) WKWebView *gameWKwebViewSlotMachine;
@property (weak, nonatomic) IBOutlet UILabel *gameScoreLabel;
@property (strong, nonatomic) NSNumber *gameScore;

@end

@implementation PromoGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.promoRetailerName.text = self.promoItem.promoRetailerName;
    self.promoRetailerURLLabel.text = (NSString*)self.promoItem.promoRetailerURL;
    self.promoRetailerTelephoneLabel.text = self.promoItem.promoRetailerTelephone;
    self.promoRetailerLogoUIImageView.image = self.promoItem.promoRetailerLogo;

    self.promoSummaryLabel.text = self.promoItem.promoSummary;
    self.promoDescriptionLabel.text = self.promoItem.promoDescription;
    self.promoImageUIImageView.image = self.promoItem.promoImage;
    self.promoValideUntilLabel.text = [NSString stringWithFormat:@"%@",self.promoItem.promoValidUntil];
    self.promoValueAmountLabel.text = [NSString stringWithFormat:@"%lu",self.promoItem.promoValueAmount];
    
    
//WKWEBVIEW - GAME
    
    //WKWEBVIEW - Setting the up WkWebKit Configuration and Controller to be able to use the "didReceiveScriptMessage" method

    // (1) Setting the WKWebView
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    WKUserContentController *controller = [[WKUserContentController alloc]init];
    [controller addScriptMessageHandler:self name:@"observeHandler"];
    
    configuration.userContentController = controller;
    _gameWKwebView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    
    // (2) Implement WkWebView and load internal game
    NSString *gamePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"CrappyBird-master"];
    NSURL *url = [NSURL fileURLWithPath:gamePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_gameWKwebView loadRequest:request];

    // (3) paint it on screen
    _gameWKwebView.frame = CGRectMake(0, 175, self.view.frame.size.width, self.view.frame.size.height/1.5);
    [self.view addSubview:_gameWKwebView];
    
//WKWEBVIEW - SLOT MACHINE

    //Setting the WKWebView
    WKWebViewConfiguration *configurationSlotMachine = [[WKWebViewConfiguration alloc]init];
    WKUserContentController *controllerSlotMachine = [[WKUserContentController alloc]init];
    [controllerSlotMachine addScriptMessageHandler:self name:@"observeHandlerSlotMachine"];

    configuration.userContentController = configurationSlotMachine;
    _gameWKwebViewSlotMachine = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configurationSlotMachine];
    
}

// (1) GETTING RESULT FROM THE HTML GAME
// (2) RUN SLOT MACHINE IF GAME SUCCESS
// (3) TELL PARSE THAT THIS USER HAS WON THE PROMO

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    
    // GETTING RESULT FROM THE HTML GAME
    NSLog(@"Received event %@", message.body);
    self.gameScore = message.body;

    // SET MIN SCORE TO SPIN SLOT MACHINE
    int minScoreSuccess = 0;
  
    // LOAD SLOT MACHINE IF GAME SCORE IS >= to minScoreSuccess
    
    if ([self.gameScore integerValue] >=minScoreSuccess )
    {
        [self runSlotMachine];
        NSLog(@"SUCCESS - Running slot machine");
        
    } else {
        
        NSLog(@"Not running slot machine");
    }
     
}

-(void)runSlotMachine{
    
    [self.gameWKwebView removeFromSuperview];
    
    NSString *gamePath =[[NSBundle mainBundle]pathForResource:@"index" ofType:@"html" inDirectory:@"SlotMachine"];
    NSURL *url = [NSURL fileURLWithPath:gamePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    _gameWKwebViewSlotMachine.frame = CGRectMake(0, 175, self.view.frame.size.width, self.view.frame.size.height/1.5);
    [self.view addSubview:_gameWKwebViewSlotMachine];

    [_gameWKwebViewSlotMachine loadRequest:request];
    
    // (2.1) GETTING RESULT FROM SLOT MACHINE
    
    [self parseSaveToPromoWinnerTable];

}

-(void)parseSaveToPromoWinnerTable{
    
    //TELL PARSE THAT THIS USER HAS WON THE PROMO - i.e update the PromoWinner table with Promo and User ids
    
    //Create promoUser object what will contain the unique reference
    PFObject *user = [PFObject objectWithoutDataWithClassName:@"PromoUser" objectId:@"6ZJJ59uRrv"];
    
    // Create a query to retrieve the Parse promo object property "objectId"
    PFQuery *promoQuery = [PFQuery queryWithClassName:@"Promo"];
    [promoQuery whereKey:@"objectId" equalTo:self.promoItem.promoObjectId];
    
    //Once the ObjectId has been retrieved, update the Parse promoWinner table within the block below
    [promoQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        PFObject *promoWinnerTableInParse = [PFObject objectWithClassName:@"PromoWinner"];
        promoWinnerTableInParse[@"score"] = self.gameScore;
        [promoWinnerTableInParse setObject:user forKey:@"userEmail"];
        promoWinnerTableInParse[@"promoID"] = [objects firstObject];
        
        [promoWinnerTableInParse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
                NSLog(@"Result saved to parse");
            } else {
                // There was a problem, check error.description
                NSLog(@"Parse saving FAILURE");
            }
        }];
    }];
    
    
}


-(void)viewDidAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
        
    PromoDetailsViewController *promoDetailsViewController = [segue destinationViewController];
//    PromoItem *promoItem = [[PromoItem alloc]init];
    promoDetailsViewController.promoItem = self.promoItem;
    
}


@end
