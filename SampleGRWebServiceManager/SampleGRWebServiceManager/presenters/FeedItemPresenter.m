//
//  FeedItemPresenter.m
//  SampleGRWebServiceManager
//
//  Created by Gnatsel Reivilo on 02/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "FeedItemPresenter.h"
#import "FeedItem.h"
#import "UIImageView+WebCache.h"
#import "UIColor+ColorUtils.h"

@implementation FeedItemPresenter
-(void)awakeFromNib{
    [super awakeFromNib];
    
}
-(void)configureWithObject:(id)anObject{
    [super configureWithObject:anObject];
    [self configureWithFeedItem:anObject];
}

-(void)configureWithFeedItem:(FeedItem *)feedItem{
    [self configureMediaWithFeedItem:feedItem];
    [self configureTitleFeedLabelWithFeedItem:feedItem];
    [self configurePublicationInfoLabelWithFeedItem:feedItem];
    [self configureLinkWebViewWithFeedItem:feedItem];
    [self configureDetailedDescriptionWebViewWithFeedItem:feedItem];
    [self configureBookmarkBarButtonItemWithFeedItem:feedItem];

}

-(void)configureMediaWithFeedItem:(FeedItem *)feedItem{
    if(_mediaImageView){
        [_mediaImageView sd_setImageWithURL:[NSURL URLWithString:feedItem.media]];
    }
}
-(void)configureTitleFeedLabelWithFeedItem:(FeedItem *)feedItem{
    if(_titleFeedLabel){
        _titleFeedLabel.text = feedItem.title;
        if(_presenterStyle == FeedItemPresenterStyleDefault)
            _titleFeedLabel.textColor = [feedItem.isRead boolValue]?[UIColor lightGrayColor] : [UIColor blackColor];
    }
}

-(void)configurePublicationInfoLabelWithFeedItem:(FeedItem *)feedItem{
    if(_publicationInfoLabel){
        //published at %@ by %@, taken at %@
        _publicationInfoLabel.text = [NSString stringWithFormat:@"published at %@\nby %@\ntaken at %@",
                                      [self dateStringFromDateNumber:feedItem.published],
                                      feedItem.author,
                                      [self dateStringFromDateNumber:feedItem.dateTaken]];
        if(_presenterStyle == FeedItemPresenterStyleDefault)
            _publicationInfoLabel.textColor = [feedItem.isRead boolValue]?[UIColor lightGrayColor] : [UIColor blackColor];

    }
}
-(void)configureDetailedDescriptionWebViewWithFeedItem:(FeedItem *)feedItem{
    if(_detailedDescriptionWebView){
        
        NSMutableString *htmlString = [NSMutableString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1 maximum-scale=1\"><style>body{margin:0;padding:0;}</style></head><body>"];
        [htmlString appendString:feedItem.detailedDescription];
        [htmlString appendString:@"</body></html>"];
        [_detailedDescriptionWebView loadHTMLString:htmlString baseURL:nil];
    }
}
-(void)configureLinkWebViewWithFeedItem:(FeedItem *)feedItem{
    if(_linkWebView){
        [_linkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:feedItem.link]]];
    }
    
}


-(void)configureBookmarkBarButtonItemWithFeedItem:(FeedItem *)feedItem{
    if(_bookmarkBarButtonItem){
        _bookmarkBarButtonItem.tintColor = [feedItem.isBookmarked boolValue]?  [UIColor colorWithHex:@"0E7AFE"]: [UIColor lightGrayColor];
    }
    
}


-(NSString *)dateStringFromDateNumber:(NSNumber *)dateNumber{
    NSTimeInterval dateTimeInterval = [dateNumber doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateTimeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"hh:mm:ss, MMMM dd YYYY";
    return [dateFormatter stringFromDate:date];
}




@end
