//
//  TestViewController.m
//  WinPromos
//
//  Created by olivier on 2015-03-24.
//  Copyright (c) 2015 IronHack. All rights reserved.
//

#import "TestViewController.h"
#import "LoginViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (!user is logged)
//    {
    //uiStoryBoard instantiateViewControllerWithIdentifier
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
//    }
    
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
