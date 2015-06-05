//
//  FeedItemPresenter.m
//  SampleGRWebServiceManager
//
//  Created by Olivier Lestang [DAN-PARIS] on 02/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "FeedItemPresenter.h"
#import "FeedItem.h"
@implementation FeedItemPresenter
-(void)awakeFromNib{
    [super awakeFromNib];
    
}
-(void)configureWithObject:(id)anObject{
    [super configureWithObject:anObject];
    [self configureWithFeedItem:anObject];
}

-(void)configureWithFeedItem:(FeedItem *)feedItem{
    
}

@end
