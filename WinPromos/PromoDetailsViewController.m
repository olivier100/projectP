//
//  PromoDetailsViewController.m
//  WinPromos
//
//  Created by olivier on 2015-03-16.
//  Copyright (c) 2015 IronHack. All rights reserved.
//

#import "PromoDetailsViewController.h"
#import <WebKit/WebKit.h>

@interface PromoDetailsViewController () <WKScriptMessageHandler> //TRIAL

@property (weak, nonatomic) IBOutlet UILabel *promoSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *promoRetailerLogoUIImageView;
@property (weak, nonatomic) IBOutlet UILabel *promoValideUntilLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoValueAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *promoRetailerName;
@property (weak, nonatomic) IBOutlet UILabel *promoRetailerURLLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoRetailerTelephoneLabel;

//FOR WebView
@property (weak, nonatomic) IBOutlet UIWebView *gameUIWebView;

//FOR WKWebView
@property(strong,nonatomic) WKWebView *gameWKwebView;

@end

@implementation PromoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.promoRetailerName.text = self.promoItem.promoRetailerName;
    self.promoRetailerURLLabel.text = (NSString*)self.promoItem.promoRetailerURL;
    self.promoRetailerTelephoneLabel.text = self.promoItem.promoRetailerTelephone;

    self.promoSummaryLabel.text = self.promoItem.promoSummary;
    self.promoDescriptionLabel.text = self.promoItem.promoDescription;
    self.promoRetailerLogoUIImageView.image = self.promoItem.promoImage;
//    self.promoValideUntilLabel.text = self.promoItem.promoValidUntil;   //??? how to cast?
//    self.promoValueAmountLabel.text = (NSString*)self.promoItem.promoValueAmount; //??? how to cast?

//    OPTION 1 - WEBVIEW - implementing WebView
//    NSURL *url = [NSURL URLWithString:@"http://www.netsolitaire.com/"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [_gameUIWebView loadRequest:request];
//    
//    OPTION 1 - WEBVIEW - Load internal game using webview
//    NSString *gamePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"CrappyBird-master"];
//    NSURL *url = [NSURL fileURLWithPath:gamePath];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [_gameUIWebView loadRequest:request];
    
    //OPTION 2 - WKWEBVIEW - Implement WkWebView and load internal game
    NSString *gamePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"CrappyBird-master"];
    NSURL *url = [NSURL fileURLWithPath:gamePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _gameWKwebView = [[WKWebView alloc] initWithFrame:self.view.frame];
    [_gameWKwebView loadRequest:request];
    
    _gameWKwebView.frame = CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height/2);
    [self.view addSubview:_gameWKwebView];
    
    
}


//  TRIAL - TRYING TO PASS DATA FROM THE GAME TO XCODE
//  Since ViewController is a WKScriptMessageHandler, as declared in the ViewController interface, it must implement the userContentController:didReceiveScriptMessage method. This is the method that is triggered each time 'interOp' is sent a message from the JavaScript code.
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary *sentData = (NSDictionary*)message.body;
    long aCount = [sentData[@"count"] integerValue];
    aCount++;
    [_gameWKwebView evaluateJavaScript:[NSString stringWithFormat:@"storeAndShow(%ld)", aCount] completionHandler:nil];
}




-(void)viewDidAppear:(BOOL)animated{
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

@end
