//
//  MyPromosListTableViewController.h
//  WinPromos
//
//  Created by olivier on 2015-03-16.
//  Copyright (c) 2015 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI.h>

@interface MyPromosListTableViewController : UITableViewController <PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>

-(IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
