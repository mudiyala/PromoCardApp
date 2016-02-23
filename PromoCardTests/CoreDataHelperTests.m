//
//  CoreDataHelperTests.m
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CoreDataHelperTests.h"
#import "CoreDataHelper.h"
#import "TestHelpers.h"
#import "OCMockObject.h"
#import "OCMockRecorder.h"
#import "Promotion.h"


@implementation CoreDataHelperTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

+ (CoreDataHelper*)setupCoreDataHelperForTesting
{
    CoreDataHelper* coreDataHelper = [CoreDataHelper new];
    
    id mockPartialForCoreDataHelper = [OCMockObject partialMockForObject:coreDataHelper];
    [[[mockPartialForCoreDataHelper stub] andReturn:@"UnitTestStores"] storesFolderName];
    
    [[[mockPartialForCoreDataHelper stub] andReturn:@"TestDatabase.sqlite"] storeFilename];
    
    // Clear UnitTesting Database
    [TestHelpers clearTempDataBases:mockPartialForCoreDataHelper];
    
    [CoreDataHelper setSharedInstance:mockPartialForCoreDataHelper];
    
    return coreDataHelper;
}

- (void)testCreateCoreDataHelper
{
    CoreDataHelper* coreDataHelper = [CoreDataHelperTests setupCoreDataHelperForTesting];
    [coreDataHelper setupCoreData];
}

- (void)testSaveWithCoreDataHelper
{
    CoreDataHelper* coreDataHelper = [CoreDataHelperTests setupCoreDataHelperForTesting];
    
    [TestHelpers saveDataBase:coreDataHelper];
}

- (void)testInsertingEntities
{
    CoreDataHelper* coreDataHelper = [CoreDataHelperTests setupCoreDataHelperForTesting];
    
    NSArray *newItemNames = @[@"Summer", @"Winter", @"Fall", @"Autumn", @"Spring"];
    
    for (NSString *newItemName in newItemNames)
    {
        Promotion *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Promotion"
                                                                   inManagedObjectContext:coreDataHelper.context];
        newItem.title = newItemName;
        NSLog(@"Inserted New Managed Object for '%@'", newItem.title);
    }
    
    [TestHelpers saveDataBase:coreDataHelper];
}


@end
