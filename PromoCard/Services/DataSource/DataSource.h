//
//  DataSource.h
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Promotion;
@class PromotionPath;

@protocol DataSourceDelegate <NSObject>

-(void)didFinishWithSuccess:(BOOL)success;

@end

@interface DataSource : NSObject

@property(nonatomic, retain) id <DataSourceDelegate> delegate;
+ (DataSource*)sharedInstance;

+ (void)setSharedInstance:(DataSource *)instance;

- (void)fetchPromotionFeed;

-(NSFetchedResultsController*)fetchResultsViewController;

-(NSArray *)checkForPromotionDataInDB;

@end
