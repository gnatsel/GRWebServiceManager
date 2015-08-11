//
//  FeedItemDAO.m
//  SampleGRWebServiceManager
//
//  Created by Gnatsel Reivilo on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "FeedItemDAO.h"
#import "FeedItem.h"
@implementation FeedItemDAO

+(FeedItem *)feedItemUpdatedWithDictionary:(NSDictionary *)dictionary{
    return (FeedItem *)[FeedItemDAO feedItemUpdatedWithKeyPaths:@[@"title",@"link",@"media",@"dateTaken",@"detailedDescription",@"published",@"author",@"authorId",@"tags"]
                                                 withDictionary:dictionary
                                            andKeysInDictionary:@[@"title",@"link",@"media.m",@"date_taken",@"description",@"published",@"author",@"author_id",@"tags"]];
}


+(FeedItem *)feedItemUpdatedWithKeyPaths:(NSArray *)keyPaths
                         withDictionary:(NSDictionary *)dictionary
                    andKeysInDictionary:(NSArray *)keysInDictionary{
    return (FeedItem *)[FeedItemDAO managedObjectForEntityClass:[FeedItem class]
                                                predicateFormat:[NSString stringWithFormat:@"link = '%@'",dictionary[@"link"]]
                                          managedObjectKeyPaths:keyPaths
                                                 withDictionary:dictionary
                                            dictionaryKeyPaths:keysInDictionary];
}
+(void)deleteFeedItemsNotInArray:(NSArray *)feedItemsArray{
    [FeedItemDAO deleteFeedItemsNotInArray:feedItemsArray predicateFormat:[NSString stringWithFormat:@"isBookmarked = %@",@NO]];
}
+(void)deleteFeedItemsNotInArray:(NSArray *)feedItemsArray predicateFormat:(NSString *)predicateFormat{
    [FeedItemDAO deleteManagedObjectsNotInArray:feedItemsArray forEntityClass:[FeedItem class] predicateFormat:predicateFormat];
}

+(NSFetchedResultsController *)fetchedResultsControllerWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate{
    return [FeedItemDAO fetchedResultsControllerWithDelegate:delegate isBookmarkController:NO];
}

+(NSFetchedResultsController *)fetchedResultsControllerWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate isBookmarkController:(BOOL)isBookmarkController{
    
    return [FeedItemDAO fetchedResultsControllerForEntityClass:[FeedItem class]
                                                      delegate:delegate
                                               predicateFormat:isBookmarkController? [NSString stringWithFormat:@"isBookmarked = %@",@(isBookmarkController)]: nil
                                               sortDescriptors:@[
                                                                 [NSSortDescriptor sortDescriptorWithKey:@"published" ascending:NO]
                                                                 ]
                                            sectionNameKeyPath:nil];
}

@end
