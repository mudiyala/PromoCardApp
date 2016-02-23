//
//  PromotionHTTPClient.h
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface PromotionHTTPClient : AFHTTPSessionManager

+ (PromotionHTTPClient *)sharedPromotionHTTPClient;

- (instancetype)initWithBaseURL:(NSURL *)url;

- (void)fetchPromotionData:(NSDictionary *)params success:(void (^)(NSDictionary *response))onSuccess failure:(void (^)(NSError* error))onFailure;


@end
