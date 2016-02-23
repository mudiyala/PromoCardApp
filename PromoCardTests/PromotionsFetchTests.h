//
//  PromotionsFetchTests.h
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

@class PromotionManager;

@interface PromotionsFetchTests : XCTestCase

+ (PromotionManager* )setupPromotionManagerForTesting;

@end