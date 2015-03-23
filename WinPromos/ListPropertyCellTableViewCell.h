//
//  ListPropertyCellTableViewCell.h
//  WinPromos
//
//  Created by olivier on 2015-03-21.
//  Copyright (c) 2015 IronHack. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListPropertyCellTableViewCell : UITableViewCell
//UI elements
@property (weak, nonatomic) IBOutlet UILabel *retailerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoSummaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *promoImageLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoValueAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *noOfPromosLabel;
@property (weak, nonatomic) IBOutlet UILabel *promoSummaryTotalValue;


@end
