//
//  PromotionManager.m
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import "PromotionManager.h"
#import "PromotionHTTPClient.h"
#import "Constants.h"


@implementation PromotionManager


#pragma mark - SETUP

static PromotionManager *_sharedInstance = nil;

+ (PromotionManager*)sharedInstance
{
    @synchronized(self)
    {
        DDLogDebug(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        
        if (_sharedInstance == nil)
        {
            [PromotionManager setSharedInstance:[[PromotionManager alloc] init]];
        }
        
        return _sharedInstance;
    }
}

+ (void)setSharedInstance:(PromotionManager *)instance
{
    @synchronized(self)
    {
        _sharedInstance = instance;
    }
}


-(void)fetchPromotionDetails:(NSDictionary*)params success:(void (^)(NSDictionary  *array))onSuccess failure:(void (^)(NSError* error))onFailure
{
    
    PromotionHTTPClient *client = [PromotionHTTPClient sharedPromotionHTTPClient];
    
    [client fetchPromotionData:params success:^(NSDictionary *responseObject){
        
        
        if(responseObject == nil)
        {
            return;
        }
        
        if (onSuccess) {
            
            onSuccess((NSDictionary *)responseObject);
        }
        
    } failure:^(NSError *error) {
        
        if (onFailure) {
            onFailure(error);
        }
        
    }];
    
}
@end