//
//  FeedItemDAO.m
//  SampleGRWebServiceManager
//
//  Created by Olivier Lestang [DAN-PARIS] on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "FeedItemDAO.h"
#import "FeedItem.h"
@implementation FeedItemDAO

+(FeedItem *)feedItemUpdatedWithDictionary:(NSDictionary *)dictionary{
    return (FeedItem *)[FeedItemDAO feedItemUpdatedWithKeyPaths:@[@"title",@"link",@"media",@"dateTaken",@"detailedDescription",@"published",@"author",@"authorId",@"tags"]
                                                 withDictionary:dictionary
                                            andKeysInDictionary:@[@"title",@"link",@"media.@m",@"date_taken",@"description",@"published",@"author",@"author_id",@"tags"]];
}


+(FeedItem *)feedItemUpdatedWithKeyPaths:(NSArray *)keyPaths
                         withDictionary:(NSDictionary *)dictionary
                    andKeysInDictionary:(NSArray *)keysInDictionary{
    return (FeedItem *)[FeedItemDAO managedObjectForEntityClass:[FeedItem class]
                                                predicateFormat:[NSString stringWithFormat:@"link = '%@'",dictionary[@"link"]]
                                          managedObjectKeyPaths:keyPaths
                                                 withDictionary:dictionary
                                            andKeysInDictionary:keysInDictionary];
}
+(void)deleteFeedItemsNotInArray:(NSArray *)feedItemsArray{
    [FeedItemDAO deleteFeedItemsNotInArray:feedItemsArray predicateFormat:[NSString stringWithFormat:@"isBookmarked = %@",@NO]];
}
+(void)deleteFeedItemsNotInArray:(NSArray *)feedItemsArray predicateFormat:(NSString *)predicateFormat{
    [FeedItemDAO deleteManagedObjectsNotInArray:feedItemsArray forEntityClass:[FeedItem class] predicateFormat:predicateFormat];
}

@end
