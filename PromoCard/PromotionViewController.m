//
//  PromotionViewController.m
//  PromoCard
//
//  Created by Krishna Mudiyala on 22/02/16.
//  Copyright (c) 2016 Krishna Mudiyala. All rights reserved.
//

#import "PromotionViewController.h"
#import "DataSource.h"
#import "PromotionDetailViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AutoLayoutUtility.h"
#import "Constants.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
@interface PromotionViewController ()

@property(nonatomic, strong) MBProgressHUD *hud;

@property(nonatomic, strong) UITableView *promotionsTableView;

@property (nonatomic) BOOL isBusy;

@end

@implementation PromotionViewController

@synthesize fetchedResultsViewController = _fetchedResultsViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    

   [self initView];
    self.navigationItem.title = NSLocalizedString(@"Promotions", @"Promotions");
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];

    _isBusy = NO;

    UIBarButtonItem* refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadBulkData)];
        refresh.tintColor = [UIColor blackColor];
        
        self.navigationItem.rightBarButtonItems = @[refresh];
        
    [self loadBulkData];
    
    NSError *error;
    
    if(![[self fetchedResultsViewController] performFetch:&error]){
        
        NSLog(@"Error! %@", error);
        abort();
    }
    
}

- (void)loadBulkData
{
    if (!_isBusy) {

        _isBusy = YES;

        DataSource* dataSource = [DataSource sharedInstance];
        
        dataSource.delegate = self;
        if (![[dataSource checkForPromotionDataInDB] count] >0){
            
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
        }
        else{
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
                       ^{
                           [dataSource fetchPromotionFeed];
                           
                       });
    }
    
}

-(void)initView{
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.promotionsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.promotionsTableView.delegate = self;
    self.promotionsTableView.dataSource = self;
    self.promotionsTableView.rowHeight = 80.0f;
    [self.promotionsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"promocell"];
    self.promotionsTableView.backgroundColor = [UIColor clearColor];

    self.promotionsTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.promotionsTableView];
    
    
    NSDictionary *viewsDictionary = @ {
        @"tableview":self.promotionsTableView,
    };
    
    CONSTRAIN_VIEWS(self.view, @"V:|[tableview]|", viewsDictionary);
    
    CONSTRAIN_VIEWS(self.view, @"H:|[tableview]|", viewsDictionary);

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsViewController sections] objectAtIndex:section];
    
    return [secInfo numberOfObjects];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [[self.fetchedResultsViewController sections] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5.0f;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIndentifier = @"promocell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIndentifier forIndexPath:indexPath];
    
    Promotion *promotion = [self.fetchedResultsViewController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = promotion.title;
    
    cell.imageView.image = [UIImage imageNamed:@"placeholderImage"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",promotion.imageName]];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UITableViewCell *updateCell = [tableView cellForRowAtIndexPath:indexPath];
                
                if (updateCell) {
                    updateCell.imageView.image = image;
                }
                [cell layoutSubviews];
                
            });
        }
    });
    
    return cell;
    
}
#pragma mark -
#pragma mark Fetched Results View Controller

-(NSFetchedResultsController*) fetchedResultsViewController {
    
    if(_fetchedResultsViewController){
        
        return _fetchedResultsViewController;
    }
    
    DataSource *dataSource = [DataSource sharedInstance];
    
    _fetchedResultsViewController = [dataSource fetchResultsViewController];
    
    _fetchedResultsViewController.delegate = self;
    
    return _fetchedResultsViewController;
    
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    
    [self.promotionsTableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    [self.promotionsTableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    UITableView *tableView = self.promotionsTableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
        {
            Promotion *changePromotion = [self.fetchedResultsViewController objectAtIndexPath:indexPath];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.text = changePromotion.title;
            
        }
            break;
        case NSFetchedResultsChangeMove:
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:newIndexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
            
        }
            
        default:
            break;
    }
    
}

-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    
    switch (type) {
            
        case NSFetchedResultsChangeInsert:
            [self.promotionsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            
            [self.promotionsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PromotionDetailViewController *detailViewController = [[PromotionDetailViewController alloc] init];
    Promotion *promotion = (Promotion*)[self.fetchedResultsViewController objectAtIndexPath:indexPath];
    
    detailViewController.promotionEntity = promotion;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}


-(void)didFinishWithSuccess:(BOOL)success{
    
    // dismisses either hud or activity on status bar
        if (![self.hud isHidden])
            [self.hud hide:true];
    
    dispatch_async(dispatch_get_main_queue(), ^{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    
    if (success) {
        // explicit call to make sure that table gets updated
        self.promotionsTableView.alpha = 1.0;

        [self.promotionsTableView reloadData];
       
    }
    else
    {
        NSString* message = nil;
        
        AFNetworkReachabilityStatus reachability = [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
        if(reachability == AFNetworkReachabilityStatusNotReachable)
        {
            message = @"Unable to connect to internet. Please check settings.";
            
        }
        else
            message = @"Unable to retrieve promotion information. Please try again after some time.";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Response" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
        
        self.promotionsTableView.alpha = 0.0;
    
    }
    _isBusy = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end