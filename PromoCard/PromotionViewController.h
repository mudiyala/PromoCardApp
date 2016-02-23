//
//  PromotionViewController.h
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataSource.h"
#import "Promotion.h"

@class PromotionPath;

@interface PromotionViewController :UIViewController <NSFetchedResultsControllerDelegate,DataSourceDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) NSFetchedResultsController *fetchedResultsViewController;

@end

