//
//  FeedItem.h
//  
//
//  Created by Olivier Lestang [DAN-PARIS] on 04/06/2015.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FeedItem : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * authorId;
@property (nonatomic, retain) NSNumber * dateTaken;
@property (nonatomic, retain) NSString * detailedDescription;
@property (nonatomic, retain) NSNumber * isBookmarked;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * media;
@property (nonatomic, retain) NSNumber * published;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * title;

@end
