//
//  DataSource.m
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import "DataSource.h"
#import "Constants.h"
#import "CoreDataHelper.h"
#import "PromotionManager.h"
#import "Promotion.h"
#import "PromotionPath.h"
#import "PromotionHTTPClient.h"
#import "AppDelegate.h"


@interface DataSource()

@end

@implementation DataSource

NSString *const kPromotionId = @"id";
NSString *const kPromotionTitle = @"title";
NSString *const kPromotionImage = @"image";
NSString *const kPromotionSummary = @"description";
NSString *const kPromotionFooter = @"footer";
NSString *const kPromotionButton = @"button";
NSString *const kPromotionButtonTarget = @"target";
NSString *const kPromotionButtonTitle = @"title";



#pragma mark - SETUP

static DataSource *_sharedInstance = nil;

+ (DataSource*)sharedInstance
{
    @synchronized(self)
    {
        DDLogDebug(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        
        if (_sharedInstance == nil)
        {
            [DataSource setSharedInstance:[[DataSource alloc] init]];
        }
        
        return _sharedInstance;
    }
}

+ (void)setSharedInstance:(DataSource *)instance
{
    @synchronized(self)
    {
        _sharedInstance = instance;
    }
}


- (void)fetchPromotionFeed
{
    
    PromotionManager *client = [PromotionManager sharedInstance];
    [client fetchPromotionDetails:nil success:^(NSDictionary *array) {
        
        CoreDataHelper *coreDataHelper = [CoreDataHelper sharedInstance];
        
        [self processBulkDownloadDataResults:array coreDataHelper:coreDataHelper];
        
        [coreDataHelper backgroundSaveContext];
        
        [self.delegate didFinishWithSuccess:YES];
        
    } failure:^(NSError *error) {
        
        DDLogCError(@"Unable to fetch promotional feed. Error %@",[error localizedFailureReason]);
        [self.delegate didFinishWithSuccess:NO];

    }];
}


- (void)processBulkDownloadDataResults:(NSDictionary*)results coreDataHelper:(CoreDataHelper *)coreDataHelper
{
    if(results == nil)
    {
        return;
    }
    
    // People Results
    [self handleBulkDownloadPeopleResults:results coreDataHelper:coreDataHelper];
    
}

/**
 * handleBulkDownloadPeopleResults
 *
 * Create the CoreData Entities for the "people" array returned in the bulk data results
 */
- (void)handleBulkDownloadPeopleResults:(NSDictionary*)results coreDataHelper:(CoreDataHelper *)coreDataHelper
{
    NSArray *peopleJson = results[@"promotions"];
    
    for(int i = 0; i < [peopleJson count]; i++)
    {
        Promotion *peopleEntity = nil;
        
        NSDictionary* dictionary = peopleJson[i];
        
        NSString* personId = [self objectOrNilForKey:kPromotionTitle fromDictionary:dictionary];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:PromotionEntityName];
        [fetchRequest setIncludesPendingChanges:NO];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@",personId];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setFetchBatchSize:1];
        
        NSArray *fetchResults = [coreDataHelper.context executeFetchRequest:fetchRequest error:nil];
        if([fetchResults count] > 0)
        {
            peopleEntity = fetchResults[0];
        }
        else
        {
            peopleEntity = [NSEntityDescription insertNewObjectForEntityForName:PromotionEntityName inManagedObjectContext:coreDataHelper.context];
        }
        
        peopleEntity.title = [self objectOrNilForKey:kPromotionTitle fromDictionary:dictionary];
        peopleEntity.imageName = [self objectOrNilForKey:kPromotionImage fromDictionary:dictionary];
        peopleEntity.summary = [self objectOrNilForKey:kPromotionSummary fromDictionary:dictionary];
        peopleEntity.footer = [self objectOrNilForKey:kPromotionFooter fromDictionary:dictionary];
        
        id promotionPathsDict = [self objectOrNilForKey:kPromotionButton fromDictionary:dictionary];
        
        for(int i=0; i < [promotionPathsDict count]; i++)
        {
            NSDictionary *dictLocal = promotionPathsDict;
            if([[promotionPathsDict class] isSubclassOfClass:[NSArray class]]){
                
                dictLocal = promotionPathsDict[i];
            }
            
            PromotionPath* promotionButtonEntity = [NSEntityDescription insertNewObjectForEntityForName:PromotionPathEntityName inManagedObjectContext:coreDataHelper.context];
            promotionButtonEntity.title = [self objectOrNilForKey:kPromotionButtonTitle fromDictionary:dictLocal];
            promotionButtonEntity.path = [self objectOrNilForKey:kPromotionButtonTarget fromDictionary:dictLocal];
            
            [peopleEntity setPromotionPath:promotionButtonEntity];
        }
        
        
    }
    
    return;
}
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = dict[aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


//- (Promotion*)getPromotionFromTitle:(NSString*)title
//{
//    CoreDataHelper* coreDataHelper = [CoreDataHelper sharedInstance];
//    
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:PromotionEntityName];
//    [fetchRequest setFetchBatchSize:1];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", title];
//    [fetchRequest setPredicate:predicate];
//    
//    NSError *fetchError = nil;
//    NSArray* results = [coreDataHelper.context executeFetchRequest:fetchRequest error:&fetchError];
//    
//    if([results count] > 0)
//    {
//        return results[0];
//    }
//    else
//    {
//        return nil;
//    }
//}

-(NSFetchedResultsController*)fetchResultsViewController{
    
    CoreDataHelper *coreData = [CoreDataHelper sharedInstance];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:PromotionEntityName inManagedObjectContext:[coreData context]];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kPromotionTitle
                                                                   ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    [fetchRequest setIncludesPendingChanges:NO];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[coreData context] sectionNameKeyPath:nil cacheName:nil];
    
}

// method implementation to check whether promotio entities availability
-(NSArray *)checkForPromotionDataInDB
{
    CoreDataHelper *coreData = [CoreDataHelper sharedInstance];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:PromotionEntityName inManagedObjectContext:[coreData context]];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:kPromotionTitle
                                                                   ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    [fetchRequest setIncludesPendingChanges:NO];

    //    CoreDataHelper *coreData = [CoreDataHelper sharedInstance];
    //    NSEntityDescription *entity = [NSEntityDescription entityForName:PromotionEntityName inManagedObjectContext:coreData.context];
    //    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:PromotionEntityName];
    //    [fetchRequest setEntity:entity];
    //    [fetchRequest setResultType:NSDictionaryResultType];
    //    [fetchRequest setReturnsDistinctResults:YES];
    //
    NSError *error = nil;
    
//    NSArray* results = [coreData.context executeFetchRequest:fetchRequest error:&error];
//    
//    if([results count] > 0)
//    {
//        return results[0];
//    }
//    else
//    {
//        return nil;
//    }
    
    
    return [coreData.context executeFetchRequest:fetchRequest error:&error];
}

@end