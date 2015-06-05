//
//  FeedItemDAO.h
//  SampleGRWebServiceManager
//
//  Created by Olivier Lestang [DAN-PARIS] on 04/06/2015.
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
/*
+(NSFetchedResultsController *)fetchedResultsControllerForEntityClass:(Class)entityClass delegate:(id<NSFetchedResultsControllerDelegate>)delegate predicateFormat:(NSString *)predicateFormat sortDescriptors:(NSArray *)sortDescriptors{
    
}*/
@end
