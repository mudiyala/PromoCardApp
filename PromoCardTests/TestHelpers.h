//
//  TestHelpers.h
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CoreDataHelper;

@interface TestHelpers : NSObject

+ (void)clearTempDataBases:(CoreDataHelper *)cdh;

+ (void)saveDataBase:(CoreDataHelper *)cdh;

@end