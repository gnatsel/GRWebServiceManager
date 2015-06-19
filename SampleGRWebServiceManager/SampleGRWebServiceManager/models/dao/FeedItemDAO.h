//
//  FeedItemDAO.h
//  SampleGRWebServiceManager
//
//  Created by Gnatsel Reivilo on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "GRCoreDataUtils+AppDelegate.h"
@class FeedItem;
@interface FeedItemDAO : GRCoreDataUtils
+(FeedItem *)feedItemUpdatedWithDictionary:(NSDictionary *)dictionary;
+(FeedItem *)feedItemUpdatedWithKeyPaths:(NSArray *)keyPaths
                         withDictionary:(NSDictionary *)dictionary
                    andKeysInDictionary:(NSArray *)keysInDictionary;

+(void)deleteFeedItemsNotInArray:(NSArray *)feedItemsArray;
+(void)deleteFeedItemsNotInArray:(NSArray *)feedItemsArray predicateFormat:(NSString *)predicateFormat;

+(NSFetchedResultsController *)fetchedResultsControllerWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate;
+(NSFetchedResultsController *)fetchedResultsControllerWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate isBookmarkController:(BOOL)isBookmarkController;

@end
