//
//  AddPromoViewController.m
//  WinPromos
//
//  Created by olivier on 2015-03-16.
//  Copyright (c) 2015 IronHack. All rights reserved.
//

#import "AddPromoViewController.h"

@interface AddPromoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *promoSummaryTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation AddPromoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if (sender != self.saveButton) return;
    
    if (self.promoSummaryTextField.text.length > 0) {
        
        self.promoItem = [[PromoItem alloc]init];
        self.promoItem.promoSummary = self.promoSummaryTextField.text;
        self.promoItem.promoCompleted = NO;
    }
        
    
}


@end
