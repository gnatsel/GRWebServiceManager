//
//  FeedItemWebServiceManager.m
//  SampleGRWebServiceManager
//
//  Created by Olivier Lestang [DAN-PARIS] on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "FeedItemWebServiceManager.h"
#import "FeedItemDAO.h"
#import "DateTools.h"

@implementation FeedItemWebServiceManager
-(instancetype)init{
    if(self = [super init]){
        self.requestMethod = RequestMethodGET;
    }
    return self;
}
-(void)requestSucceededWithObject:(id)responseObject{
    [super requestSucceededWithObject:responseObject];
    if(responseObject){
        NSMutableArray *newFeedItemsArray = [NSMutableArray array];
        NSArray *feedItemsDictionaryArray = nil;
        @try{
            NSDateFormatter *tzDateFormatter = [[NSDateFormatter alloc]init];
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
            [tzDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            
            NSDateFormatter *
            feedItemsDictionaryArray = responseObject[@"jsonFlickrFeed"][@"items"];
            for(NSDictionary *feedItemDictionary in feedItemsDictionaryArray){
                //@"date_taken"
                [newFeedItemsArray addObject:[FeedItemDAO feedItemUpdatedWithDictionary:feedItemDictionary]];
            }
            [FeedItemDAO deleteFeedItemsNotInArray:newFeedItemsArray];
        }
        @catch(NSException *e){
            NSLog(@"error : %@",[e userInfo]);
        }
    }
}
-(void)requestFailedWithError:(NSError *)error forOperation:(AFHTTPRequestOperation *)operation{
    [super requestFailedWithError:error forOperation:operation];
}
@end
