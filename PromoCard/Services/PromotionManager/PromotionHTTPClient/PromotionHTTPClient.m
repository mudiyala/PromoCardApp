//
//  PromotionHTTPClient.m
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import "PromotionHTTPClient.h"
#import "Constants.h"

@implementation PromotionHTTPClient

+(PromotionHTTPClient *)sharedPromotionHTTPClient
{
    static PromotionHTTPClient *_sharedPromotionHTTPClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PromoCardSettings" ofType:@"plist"];
        NSAssert(path != nil,@"Could not find PromoCardSettings.plist");
        
        NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSAssert(settings != nil,@"Could not load PromoCardSettings.plist");
        
        NSString *baseURLString = settings[@"PromotionBaseURL"];
        _sharedPromotionHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURLString]];
        
    });
    return _sharedPromotionHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
        

        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void)fetchPromotionData:(NSDictionary *)params success:(void (^)(NSDictionary *response))onSuccess failure:(void (^)(NSError* error))onFailure
{
    NSString *urlString = [NSString stringWithFormat:@"promotions.json"];
    
    [self GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         onSuccess((NSDictionary *)responseObject);
     }
      failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         onFailure(error);
     }];
}

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = dict[aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

@end

