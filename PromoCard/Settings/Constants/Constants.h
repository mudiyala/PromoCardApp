//
//  Constants.h
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#ifndef PromoCard_Constants_h
#define PromoCard_Constants_h

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "DDASLLogger.h"
#import "DDTTYLogger.h"


#endif

#define kEmptyString @""

#define kPromotionsTitle @"Promotions"
#define kPromotionDetailTitle @"Promotion"



/**
 * Logging
 */
extern const int ddLogLevel;

/**
 * CoreData Entity Names
 */
extern NSString* const PromotionEntityName;
extern NSString* const PromotionPathEntityName;

#endif