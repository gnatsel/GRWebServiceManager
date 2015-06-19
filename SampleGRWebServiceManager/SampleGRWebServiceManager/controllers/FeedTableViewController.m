//
//  PRC0_0_FeedTableViewController.m
//  SampleGRWebServiceManager
//
//  Created by Gnatsel Reivilo on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "FeedTableViewController.h"
#import "FeedItem.h"
#import "Presenter.h"
#import "UIView+Presenter.h"
#import "FeedItemTableViewCell.h"
#import "Constants.h"
#import "FeedItemWebServiceManager.h"
#import "DetailFeedViewController.h"
#import "GRCustomRefreshView.h"
#import "UIScrollView+GRPullToRefresh.h"

@interface FeedTableViewController ()
@property (strong, nonatomic) NSFetchedResultsController *feedItemFetchedResultsController;
@property (strong, nonatomic) GRCustomRefreshView *pullToRefreshView;

@end
@implementation FeedTableViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _feedItemFetchedResultsController = [FeedItemDAO fetchedResultsControllerWithDelegate:self isBookmarkController:_isBookmarkController];
    [[FeedItemWebServiceManager sharedInstanceWithDelegate:self]perform];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!_pullToRefreshView){
        _pullToRefreshView = [[GRCustomRefreshView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_pullToRefreshView addEndRefreshAnimationCompletionHandler:nil];
        __weak FeedTableViewController *weakSelf = self;
        [self.tableView addPullToRefreshWithActionHandler:^{
            [[FeedItemWebServiceManager sharedInstanceWithDelegate:weakSelf]perform];
        } refreshView:_pullToRefreshView];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];
    if([segue.identifier isEqualToString:DETAIL_FEED_ITEM_SEGUE]){
        DetailFeedViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.feedItem = [_feedItemFetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    }
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _feedItemFetchedResultsController.fetchedObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier = NSStringFromClass([FeedItemTableViewCell class]);
    FeedItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.presenter configureWithObject:[_feedItemFetchedResultsController objectAtIndexPath:indexPath]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:DETAIL_FEED_ITEM_SEGUE sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - NSFetchedResultControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];

}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if(controller == _feedItemFetchedResultsController) {
        @try {
            switch(type) {
                case NSFetchedResultsChangeInsert:{
                    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                }
                case NSFetchedResultsChangeDelete:{
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    break;
                }
                case NSFetchedResultsChangeUpdate:{
                    [[self.tableView cellForRowAtIndexPath:indexPath].presenter configureWithObject:[_feedItemFetchedResultsController objectAtIndexPath:indexPath]];
                    break;
                }
                case NSFetchedResultsChangeMove:{
                    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:indexPath];
                    break;
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
        
    }
}



- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:{
            break;
        }
            
        case NSFetchedResultsChangeDelete:{
            
            break;
        }
        case NSFetchedResultsChangeMove:{
            break;
        }
        case NSFetchedResultsChangeUpdate:{
            break;
        }
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];

    
   
}

#pragma mark - GRWebServiceManagerDelegate
-(void)webServiceManager:(GRWebServiceManager *)webServiceManager didFinishWithSuccess:(BOOL)success{
    
}

-(void)webServiceManager:(GRWebServiceManager *)webServiceManager didReceiveResponseForOperation:(AFHTTPRequestOperation *)operation{
    _pullToRefreshView.shouldEndAnimating = YES;

}
@end
