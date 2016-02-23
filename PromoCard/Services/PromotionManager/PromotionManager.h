//
//  PromotionManager.h
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromotionManager : NSObject

+ (PromotionManager*)sharedInstance;

+ (void)setSharedInstance:(PromotionManager *)instance;

-(void)fetchPromotionDetails:(NSDictionary*)params success:(void (^)(NSDictionary  *array))onSuccess failure:(void (^)(NSError* error))onFailure;

@end

