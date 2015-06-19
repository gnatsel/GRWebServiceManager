//
//  FeedItemPresenter.h
//  SampleGRWebServiceManager
//
//  Created by Gnatsel Reivilo on 02/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "Presenter.h"

@class FeedItem;
typedef NS_ENUM(NSInteger, FeedItemPresenterStyle) {
    FeedItemPresenterStyleDefault = 0,
    FeedItemPresenterStyleDetail = 1
};


IB_DESIGNABLE
@interface FeedItemPresenter : Presenter<UIWebViewDelegate>
@property (nonatomic,assign) IBInspectable NSInteger presenterStyle;

@property (nonatomic,weak) IBOutlet UIImageView *mediaImageView;
@property (nonatomic,weak) IBOutlet UILabel *titleFeedLabel;
@property (nonatomic,weak) IBOutlet UILabel *publicationInfoLabel;

@property (nonatomic,weak) IBOutlet UIWebView *detailedDescriptionWebView;
@property (nonatomic,weak) IBOutlet UIWebView *linkWebView;
@property (nonatomic,weak) IBOutlet UIBarButtonItem *bookmarkBarButtonItem;


-(void)configureBookmarkBarButtonItemWithFeedItem:(FeedItem *)feedItem;

@end
