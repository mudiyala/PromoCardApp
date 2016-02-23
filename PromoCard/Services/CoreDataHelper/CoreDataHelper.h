//
//  CoreDataHelper.h
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject

@property (nonatomic, readonly) NSManagedObjectContext* parentContext;
@property (nonatomic, readonly) NSManagedObjectContext* context;
@property (nonatomic, readonly) NSManagedObjectModel* model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator* coordinator;
@property (nonatomic, readonly) NSPersistentStore* store;
@property (nonatomic, retain) NSString *databaseName;

- (void)setupCoreData;

- (void)saveContext;

- (void)backgroundSaveContext;

- (NSURL *)storeURL;

- (NSString*)storeFilename;

- (NSURL *)applicationStoresDirectory;

- (NSString *)storesFolderName;

+ (CoreDataHelper*)sharedInstance;

+ (void)setSharedInstance:(CoreDataHelper *)instance;

@end