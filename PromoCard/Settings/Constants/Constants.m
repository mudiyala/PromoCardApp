//
//  Constants.m
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import "Constants.h"

/**
 * LOG_LEVEL_ALL, LOG_LEVEL_VERBOSE, LOG_LEVEL_DEBUG, LOG_LEVEL_INFO, LOG_LEVEL_WARN, LOG_LEVEL_ERROR
 * will be written out in DEBUG builds
 *
 * Only
 *
 * LOG_LEVEL_INFO, LOG_LEVEL_WARN, LOG_LEVEL_ERROR will be written out in RELEASE builds
 *
 */
#ifdef DEBUG
const int ddLogLevel = LOG_LEVEL_DEBUG;
#else
const int ddLogLevel = LOG_LEVEL_INFO;
#endif

/**
 * CoreData Entity Names
 */
NSString* const PromotionEntityName = @"Promotion";
NSString* const PromotionPathEntityName = @"PromotionPath";


