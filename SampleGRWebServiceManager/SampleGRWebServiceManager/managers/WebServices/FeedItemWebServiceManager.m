//
//  FeedItemWebServiceManager.m
//  SampleGRWebServiceManager
//
//  Created by Gnatsel Reivilo on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "FeedItemWebServiceManager.h"
#import "FeedItemDAO.h"
#import "DateTools.h"

@implementation FeedItemWebServiceManager
-(instancetype)init{
    if(self = [super init]){
        self.requestMethod = RequestMethodGET;
        self.urlString = @"http://api.flickr.com/services/feeds/photos_public.gne?lang=en-us&format=json&nojsoncallback=1";
    }
    return self;
}
-(void)requestSucceededWithObject:(id)responseObject{
    [super requestSucceededWithObject:responseObject];
    if(responseObject){
        NSMutableArray *newFeedItemsArray = [NSMutableArray array];
        @try{
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
            NSDateFormatter *tzDateFormatter = [[NSDateFormatter alloc]init];
            [tzDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            NSDateFormatter *ssZZZDateFormatter = [[NSDateFormatter alloc]init];
            [ssZZZDateFormatter setDateFormat:@"yyyy-MM-dd\'T\'HH:mm:ssZZZZZ"];
            
            NSArray *feedItemsDictionaryArray = responseObject[@"items"];
            for(NSDictionary *feedItemDictionary in feedItemsDictionaryArray){
                NSMutableDictionary *newFeedItemDictionary = [feedItemDictionary mutableCopy];
                NSDate *dateTaken = [tzDateFormatter dateFromString:newFeedItemDictionary[@"date_taken"]];
                NSDate *publishedDate = [ssZZZDateFormatter dateFromString:newFeedItemDictionary[@"published"]];
                newFeedItemDictionary[@"date_taken"] = @([dateTaken timeIntervalSince1970]);
                newFeedItemDictionary[@"published"] = @([publishedDate timeIntervalSince1970]);
                newFeedItemDictionary[@"media"] = newFeedItemDictionary[@"media"];

                [newFeedItemsArray addObject:[FeedItemDAO feedItemUpdatedWithDictionary:newFeedItemDictionary]];
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
    //Fix for flickr JSON feed : incorrect escape for character '
    if(error.code == 3840){
        NSString *originalJSONString = [[NSString alloc]initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        NSString *fixedJSONString = [originalJSONString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
        NSData *fixedJSONData = [fixedJSONString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError;
        id fixedResponseObject = [NSJSONSerialization JSONObjectWithData: fixedJSONData
                                        options: NSJSONReadingMutableContainers
                                          error: &jsonError];
        if(!jsonError){
            self.success = YES;
            [self requestSucceededWithObject:fixedResponseObject];
        }
        else{
            NSLog(@"error : %@",[jsonError userInfo]);
        }
    }
}
@end
