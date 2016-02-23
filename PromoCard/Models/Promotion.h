//
//  Promotion.h
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PromotionPath;

@interface Promotion : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSString * footer;
@property (nonatomic, retain) PromotionPath *promotionPath;

@end
