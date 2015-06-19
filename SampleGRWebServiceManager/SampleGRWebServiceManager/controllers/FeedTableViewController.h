//
//  PRC0_0_FeedTableViewController.h
//  SampleGRWebServiceManager
//
//  Created by Gnatsel Reivilo on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItemWebServiceManager.h"
#import "FeedItemDAO.h"
IB_DESIGNABLE
@interface FeedTableViewController : UITableViewController<NSFetchedResultsControllerDelegate,GRWebServiceManagerDelegate>

@property (nonatomic, assign) IBInspectable BOOL isBookmarkController;
@end
