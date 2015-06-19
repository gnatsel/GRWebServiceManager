//
//  DetailFeedViewController.m
//  SampleGRWebServiceManager
//
//  Created by Gnatsel Reivilo on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "DetailFeedViewController.h"
#import "UIView+Presenter.h"
#import "Presenter.h"
#import "FeedItemPresenter.h"
#import "FeedItem.h"
#import "FeedItemDAO.h"
#import "Constants.h"
#import "FeedWebViewController.h"

@interface DetailFeedViewController()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bookmarkBarButtonItem;
@end
@implementation DetailFeedViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    if(_feedItem){
        if(![_feedItem.isRead boolValue]){
            _feedItem.isRead = @YES;
            [FeedItemDAO saveDatabase];
        }
        [self.view.presenter configureWithObject:_feedItem];
        
    }
}
- (IBAction)bookmarkAction:(id)sender {
    _feedItem.isBookmarked = @(![_feedItem.isBookmarked boolValue]);
    FeedItemPresenter *feedItemPresenter = (FeedItemPresenter *)self.view.presenter;
    [feedItemPresenter configureBookmarkBarButtonItemWithFeedItem:_feedItem];
    [FeedItemDAO saveDatabase];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];
    if([segue.identifier isEqualToString:WEBVIEW_FEED_ITEM_SEGUE]){
        FeedWebViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.feedItem = _feedItem;
    }
}
@end