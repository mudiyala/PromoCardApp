//
//  PromoCardTests.m
//  PromoCardTests
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "AppDelegate.h"
#import "PromotionDetailViewController.h"
#import "PromotionViewController.h"
#import "CoreDataHelper.h"
#import "PromotionManager.h"
#import "ThemeManager.h"



@interface PromoCardTests : XCTestCase

@end

@implementation PromoCardTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

-(void)testAppdelegateClassExists{

    AppDelegate *apppDelegate = [[UIApplication sharedApplication] delegate];
    
    XCTAssertNotNil(apppDelegate, @"AppDelegate class exists");
}

-(void)testPromotionViewControllerClassExists{
    
    PromotionViewController *promotionViewController = [[PromotionViewController alloc] init];
    
    XCTAssertNotNil(promotionViewController, @"PromotionViewController class exists");
}

-(void)testPromotionDetailViewControllerClassExists{
    
    PromotionDetailViewController *promotionDetailViewController = [[PromotionDetailViewController alloc] init];
    
    XCTAssertNotNil(promotionDetailViewController, @"PromotionDetailViewController class exists");
}

-(void)testCoreDataHelperClassExists{
    
    CoreDataHelper *coreDataHelper = [CoreDataHelper sharedInstance];
    
    XCTAssertNotNil(coreDataHelper, @"CoreDataHelper class exists ");
}

-(void)testPromotionManagerClassExists{
    
    PromotionManager *promotionManager = [PromotionManager sharedInstance];
    
    XCTAssertNotNil(promotionManager, @"PromotionManager class exists");
}

-(void)testPromoCardSettingsPlistExists{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PromoCardSettings" ofType:@"plist"];
    
    XCTAssertNotNil(path, @"PromoCardSettings plist exists");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
