//
//  PromoItem.h
//  WinPromos
//
//  Created by olivier on 2015-03-16.
//  Copyright (c) 2015 IronHack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromoItem : NSObject

@property NSString *promoSummary;
@property NSString *promoDescription;

@property BOOL promoCompleted;
@property (readonly) NSDate *promoCreationDate;

@end
