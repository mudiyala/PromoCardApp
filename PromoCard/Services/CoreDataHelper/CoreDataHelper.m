//
//  CoreDataHelper.m
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import "CoreDataHelper.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"


@implementation CoreDataHelper
#pragma mark - SETUP

#pragma mark - FILES

- (NSString*)storeFilename
{
    self.databaseName = [NSString stringWithFormat:@"PromoCard.sqlite"];
    
    return self.databaseName;
}

- (NSString *)storesFolderName
{
    return @"Stores";
}

#pragma mark - PATHS

- (NSString *)applicationDocumentsDirectory
{
    DDLogDebug(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSURL *)applicationStoresDirectory
{
    DDLogDebug(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    
    NSURL *storesDirectory = [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]]
                              URLByAppendingPathComponent:[self storesFolderName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSLog(@"url %@",[storesDirectory path]);
    
    if (![fileManager fileExistsAtPath:[storesDirectory path]])
    {
        NSError *error = nil;
        
        if ([fileManager createDirectoryAtURL:storesDirectory withIntermediateDirectories:YES attributes:nil error:&error])
        {
            DDLogDebug(@"Successfully created Stores directory %@",[storesDirectory path]);
        }
        else
        {
            DDLogDebug(@"FAILED to create Stores directory: %@ %@", [storesDirectory path],error);
        }
    }
    return storesDirectory;
}

- (NSURL *)storeURL
{
    DDLogDebug(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    return [[self applicationStoresDirectory] URLByAppendingPathComponent:[self storeFilename]];
}

/**
 * init
 *
 * The easiest way to achieve background save is to use two contexts in a parent and child hierarchy.
 * The background context, referred to as the _parentContext, will be configured to use a private queue
 * by setting its concurrency type to NSPrivateQueueConcurrencyType. The foreground context that underpins
 * the user interface is referred to as _context. It is already configured to use the main queue, because
 * its concurrency type is NSMainQueueConcurrencyType.
 *
 * Both contexts exist in memory, so intercommunication between them is very fast.
 *
 * A child context has no persistent store. Instead, a parent context acts as the persistent store for its
 * child context. When a child context is saved, changes go to its parent. For those changes to be persisted,
 * a save must then be performed on the parent context, too. As the parent context runs on a private queue,
 * the save will not impact the user interface.
 *
 * When the context hierarchy is configured, at least one context will be configured on a private queue.
 * Private queue context configuration must be performed using blocks. Use performBlockAndWait when
 * configuring a context on a private queue so that it is ready before it is needed. The _context
 * configuration can be performed outside of a block because it already runs on the main queue.
 *
 */
- (id)init
{
    DDLogDebug(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    
    _parentContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [_parentContext performBlockAndWait:^{
        [_parentContext setPersistentStoreCoordinator:_coordinator];
        [_parentContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    }];
    
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setParentContext:_parentContext];
    [_context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextDidSavePrivateQueueContext:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:_parentContext];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextDidSaveMainQueueContext:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:_context];
    
    return self;
}

- (void)contextDidSavePrivateQueueContext:(NSNotification *)notification
{
    @synchronized(self) {
        [self.context performBlock:^{
            [self.context mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

- (void)contextDidSaveMainQueueContext:(NSNotification *)notification
{
    @synchronized(self) {
        [self.parentContext performBlock:^{
            [self.parentContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

- (void)loadStore
{
    DDLogDebug(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    // Don’t load store if it's already loaded
    if (_store)
    {
        return;
    }
    
    // Enable lightweight migration
    NSDictionary *options =
    @{
      NSMigratePersistentStoresAutomaticallyOption:@YES
      ,NSInferMappingModelAutomaticallyOption:@YES
      ,NSSQLiteAnalyzeOption:@YES
      ,NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}
      };
    
    NSError *error = nil;
    
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeURL] options:options error:&error];
    if (!_store)
    {
        DDLogDebug(@"Failed to add store. Error: %@", error);
        abort();
    }
    else
    {
        DDLogDebug(@"Successfully added store: %@", _store);
    }
}

- (void)setupCoreData
{
    DDLogDebug(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    [self loadStore];
}

#pragma mark - SAVING

- (void)saveContext
{
    DDLogDebug(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    if ([_context hasChanges])
    {
        NSError *error = nil;
        if ([_context save:&error])
        {
            DDLogDebug(@"_context SAVED changes to persistent store");
        }
        else
        {
            DDLogDebug(@"Failed to save _context: %@", error);
        }
    }
    else
    {
        DDLogDebug(@"SKIPPED _context save, there are no changes!");
    }
}

/**
 * - (void)backgroundSaveContext
 *
 * This method will save the child context to the parent context and then the parent context
 * to the persistent store. The save to the parent context will be fast because it is
 * performed within memory.
 *
 * It does not matter if the save from the parent context to the persistent store takes a
 * while because it occurs asynchronously on a private queue.
 */
- (void)backgroundSaveContext
{
    DDLogDebug(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    
    // First, save the child context in the foreground (fast, all in memory)
    [self saveContext];
    
    // Then, save the parent context.
    [_parentContext performBlock:^
     {
         if ([_parentContext hasChanges])
         {
             NSError *error = nil;
             if ([_parentContext save:&error])
             {
                 DDLogDebug(@"_parentContext SAVED changes to persistent store");
             }
             else
             {
                 DDLogDebug(@"_parentContext FAILED to save: %@", error);
                 [self showValidationError:error];
             }
         }
         else
         {
             DDLogDebug(@"_parentContext SKIPPED saving as there are no changes");
         }
     }];
}

#pragma mark - VALIDATION ERROR HANDLING

- (void)showValidationError:(NSError *)anError
{
    if (anError && [anError.domain isEqualToString:@"NSCocoaErrorDomain"])
    {
        NSArray *errors = nil;  // holds all errors
        NSString *message = kEmptyString; // the error message text of the alert
        
        // Populate array with error(s)
        if (anError.code == NSValidationMultipleErrorsError)
        {
            errors = anError.userInfo[NSDetailedErrorsKey];
        }
        else
        {
            errors = @[anError];
        }
        // Display the error(s)
        if (errors && errors.count > 0)
        {
            // Build error message text based on errors
            for (NSError *error in errors)
            {
                NSString *entity =
                [[error.userInfo[@"NSValidationErrorObject"] entity] name];
                
                NSString *property =
                error.userInfo[@"NSValidationErrorKey"];
                
                switch (error.code)
                {
                    case NSValidationRelationshipDeniedDeleteError:
                        message = [message stringByAppendingFormat:
                                   @"%@ delete was denied because there are associated %@\n(Error Code %li)\n\n", entity, property, (long) error.code];
                        break;
                    case NSValidationRelationshipLacksMinimumCountError:
                        message = [message stringByAppendingFormat:
                                   @"the '%@' relationship count is too small (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationRelationshipExceedsMaximumCountError:
                        message = [message stringByAppendingFormat:
                                   @"the '%@' relationship count is too large (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationMissingMandatoryPropertyError:
                        message = [message stringByAppendingFormat:
                                   @"the '%@' property is missing (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationNumberTooSmallError:
                        message = [message stringByAppendingFormat:
                                   @"the '%@' number is too small (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationNumberTooLargeError:
                        message = [message stringByAppendingFormat:
                                   @"the '%@' number is too large (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationDateTooSoonError:
                        message = [message stringByAppendingFormat:
                                   @"the '%@' date is too soon (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationDateTooLateError:
                        message = [message stringByAppendingFormat:
                                   @"the '%@' date is too late (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationInvalidDateError:
                        message = [message stringByAppendingFormat:
                                   @"the '%@' date is invalid (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationStringTooLongError:
                        message = [message stringByAppendingFormat:
                                   @"the '%@' text is too long (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationStringTooShortError:
                        message = [message stringByAppendingFormat:
                                   @"the '%@' text is too short (Code %li).", property, (long) error.code];
                        break;
                    case NSValidationStringPatternMatchingError:
                        message = [message stringByAppendingFormat:
                                   @"the '%@' text doesn't match the specified pattern (Code %li).", property, (long) error.code];
                        break;
                    case NSManagedObjectValidationError:
                        message = [message stringByAppendingFormat:
                                   @"generated validation error (Code %li)", (long) error.code];
                        break;
                        
                    default:
                        message = [message stringByAppendingFormat:
                                   @"Unhandled error code %li in showValidationError method", (long) error.code];
                        break;
                }
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Validation Error"
                                                                message:[NSString stringWithFormat:@"%@Please double-tap the home button and close this application by swiping the application screenshot upwards", message]
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}

static CoreDataHelper *_sharedInstance = nil;

+ (CoreDataHelper*)sharedInstance
{
    @synchronized(self)
    {
        DDLogDebug(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
        
        if (_sharedInstance == nil)
        {
            [CoreDataHelper setSharedInstance:[[CoreDataHelper alloc] init]];
        }
        
        return _sharedInstance;
    }
}

+ (void)setSharedInstance:(CoreDataHelper *)instance
{
    @synchronized(self)
    {
        _sharedInstance = instance;
        [_sharedInstance setupCoreData];
    }
}

@end
