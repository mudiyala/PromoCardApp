//
//  TestHelpers.m
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import "TestHelpers.h"
#import "CoreDataHelper.h"


@implementation TestHelpers

/*
 Helper method to remove sql database files used for unit testing
 */
+ (void)clearTempDataBases:(CoreDataHelper *)cdh
{
    NSError *error;
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    NSURL *applicationStoresDirectory = [cdh applicationStoresDirectory];
    NSString* persistentStoreFileString = [[applicationStoresDirectory path] stringByAppendingPathComponent:[cdh storeFilename]];
    
    BOOL result = [[applicationStoresDirectory path] hasSuffix:@"UnitTestStores"];
    
    //
    //Check to make sure we are operating against the TestDatabase.sqlite database in the
    //UnitTestStores directory
    //
    
    if(result == NO)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[applicationStoresDirectory path] userInfo:nil];
    }
    
    result = [persistentStoreFileString hasSuffix:@"TestDatabase.sqlite"];
    if(result == NO)
    {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:persistentStoreFileString userInfo:nil];
    }
    
    if([fileManager fileExistsAtPath:persistentStoreFileString])
    {
        NSLog(@"[clearTempDataBases] Removing %@",persistentStoreFileString);
        [fileManager removeItemAtPath:persistentStoreFileString error:&error];
    }
    
    persistentStoreFileString = [[applicationStoresDirectory path] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-shm",cdh.storeFilename]];
    if([fileManager fileExistsAtPath:persistentStoreFileString])
        [fileManager removeItemAtPath:persistentStoreFileString error:&error];
    
    persistentStoreFileString = [[applicationStoresDirectory path] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-wal",cdh.storeFilename]];
    if([fileManager fileExistsAtPath:persistentStoreFileString])
        [fileManager removeItemAtPath:persistentStoreFileString error:&error];
}

/*
 * This helper saves synchronously - if we were to do it async then the unit tests that
 * need saving would not work as expected.
 */
+ (void)saveDataBase:(CoreDataHelper *)cdh
{
    [cdh saveContext];
    
    if ([cdh.parentContext hasChanges])
    {
        NSError *error = nil;
        if ([cdh.parentContext save:&error])
        {
            NSLog(@"_parentContext SAVED changes to persistent store");
        }
        else
        {
            NSLog(@"_parentContext FAILED to save: %@", error);
        }
    }
    else
    {
        NSLog(@"_parentContext SKIPPED saving as there are no changes");
    }
}

@end