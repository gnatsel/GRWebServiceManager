//
//  DetailFeedViewController.h
//  SampleGRWebServiceManager
//
//  Created by Gnatsel Reivilo on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItemDAO.h"
@interface DetailFeedViewController : UIViewController
@property (nonatomic, strong) FeedItem *feedItem;
@end
