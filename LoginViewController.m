//
//  LoginViewController.m
//  WinPromos
//
//  Created by olivier on 2015-03-24.
//  Copyright (c) 2015 IronHack. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (nonatomic) UIViewController *parseLogInViewController;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)parseLogin{
    
//    if (![PFUser currentUser]) { // No user logged in
//        // Create the log in view controller
//        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
//        [logInViewController setDelegate:self]; // Set ourselves as the delegate
//        
//        // Create the sign up view controller
//        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
//        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
//        
//        // Assign our sign up controller to be displayed from the login controller
//        [logInViewController setSignUpController:signUpViewController];
//        
//        // Present the log in view controller
//        [self presentViewController:logInViewController animated:YES completion:NULL];
//    }
}

-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error{
    
    NSLog(@"Error login %@",error);
    
}

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
    
    NSLog(@"User %@ logged",user);
    
    [self.parseLogInViewController dismissViewControllerAnimated:YES completion:^{
        // Transition to new VC
    }];
    
}

-(void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController{
    
    NSLog(@"User cancelled login");
    
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
