//
//  PromoItem.h
//  WinPromos
//
//  Created by olivier on 2015-03-16.
//  Copyright (c) 2015 IronHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PromoItem : NSObject

@property NSString *promoRetailerName;
@property NSString *promoRetailerType;
@property UIImage *promoRetailerLogo;
@property NSURL *promoRetailerURL;
@property NSString *promoRetailerTelephone;

@property NSString *promoSummary;
@property NSString *promoDescription;
@property NSInteger *promoValueAmount;
@property NSDate *promoValidUntil;
@property UIImage *promoImage;
@property NSMutableArray *promoLocations;
@property NSString *promoType;
@property NSString *promoStatus;

@property NSString *promoObjectId; //to contain the unique reference created from Parse


@property BOOL promoCompleted;
@property (readonly) NSDate *promoCreationDate;

@end
