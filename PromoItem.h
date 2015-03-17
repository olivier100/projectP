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

@property NSString *promoRetailer;
@property NSString *promoRetailerType;
@property UIImage *promoRetailerLogo;
@property NSMutableArray *promoLocations;
@property NSURL *promoRetailerURL;
@property NSString *promoRetailerTelephone;

@property NSString *promoSummary;
@property NSString *promoDescription;
@property NSNumber *promoValue;
@property NSDate *promoValidUntil;



@property BOOL promoCompleted;
@property (readonly) NSDate *promoCreationDate;

@end
