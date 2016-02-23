//
//  PromotionsFetchTests.m
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import "PromotionsFetchTests.h"
#import <XCTest/XCTest.h>
#import "CoreDataHelperTests.h"
#import "CoreDataHelper.h"
#import "TestHelpers.h"
#import "OCMockObject.h"
#import "OCMockRecorder.h"
#import "Promotion.h"
#import "PromotionManager.h"


@implementation PromotionsFetchTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

+ (PromotionManager*)setupPromotionManagerForTesting
{
    PromotionManager *promoManager = [PromotionManager new];
    
    id mockPartialForCoreDataHelper = [OCMockObject partialMockForObject:promoManager];
    [[[mockPartialForCoreDataHelper stub] andReturn:@"path"] storesFolderName];
    
    [[[mockPartialForCoreDataHelper stub] andReturn:@"some json"] storeFilename];
    
    // Clear UnitTesting Database
    [TestHelpers clearTempDataBases:mockPartialForCoreDataHelper];
    
    [PromotionManager setSharedInstance:promoManager];
    
    return promoManager;
}



@end