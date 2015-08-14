GRWebServiceManager
===============
Web service manager for JSON web service based on AFNetworking

Installation
----------
### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like AFNetworking in your projects. See the ["Getting Started" guide of AFNetworking for more information](https://github.com/AFNetworking/AFNetworking/wiki/Getting-Started-with-AFNetworking).

#### Podfile

```ruby
platform :ios, '7.0'
pod "AFNetworking", "~> 2.0"
```

How to use
----------

```objective-c
//RequestMethodType
/**
 * Enum representing the http action that should be performed by the instance of WebServiceManager
 */
typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
    RequestMethodPUT,
    RequestMethodDELETE
};
```

## Subclassing GRWebServiceManager 

```objective-c
//FeedItemWebServiceManager.m
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
                                        options: 0
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


```

## Request without parameters using a GRWebServiceManager

```objective-c
[[FeedItemWebServiceManager sharedInstanceWithDelegate:self]perform];
```

## Request with parameters using a GRWebServiceManager

```objective-c

[[FeedItemWebServiceManager sharedInstanceWithParameters:@{
                                                               @"param0":@"value0",
                                                               @"param1":@"value1"
                                                               }
                                               delegate:self] perform];
```

## Request with parameters and multipart parameters using a GRWebServiceManager

```objective-c
    [[FeedItemWebServiceManager sharedInstanceWithParameters:@{
                                                               @"param0":@"value0",
                                                               @"param1":@"value1"
                                                               }
                                         multipartParameters:@[
                                                               @{
                                                                   @"name":@"image0.png",
                                                                   @"path":@"http://www.example.com/"
                                                                   },
                                                               @{
                                                                   @"name":@"image1.png",
                                                                   @"path":[[NSBundle mainBundle]pathForResource:@"image1" ofType:@"png"]
                                                                   },
                                                               @{
                                                                   @"name":@"image2.png",
                                                                   @"data":[NSData dataWithContentsOfFile:@"image2.png"]
                                                               },
                                                               @{
                                                                   @"name":@"image3.png",
                                                                   @"image":[UIImage imageNamed:@"image3.png"]
                                                                   }
                                                               ]
                                                    delegate:self] perform];
```


## Delegate

```objective-c
#pragma mark - GRWebServiceManagerDelegate
-(void)webServiceManager:(GRWebServiceManager *)webServiceManager didFinishWithSuccess:(BOOL)success{
    
}

-(void)webServiceManager:(GRWebServiceManager *)webServiceManager didReceiveResponseForOperation:(AFHTTPRequestOperation *)operation{

}
```

## License
The MIT License (MIT)

Copyright (c) 2015 gnatsel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

