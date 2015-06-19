//
//  FeedWebViewController.m
//  SampleGRWebServiceManager
//
//  Created by Gnatsel Reivilo on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "FeedWebViewController.h"
#import "FeedItem.h"
#import "UIView+Presenter.h"
#import "Presenter.h"
@implementation FeedWebViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    if(_feedItem){
        [self.view.presenter configureWithObject:_feedItem];
        
    }
}
@end
