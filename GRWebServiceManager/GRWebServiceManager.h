//
//  GRWebServiceManager.h
//  SampleGRWebServiceManager
//
//  Created by Olivier Lestang [DAN-PARIS] on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@class GRWebServiceManager;
@protocol GRWebServiceManagerDelegate<NSObject>
-(void)webServiceManager:(GRWebServiceManager *)webServiceManager didFinishWithSuccess:(BOOL)success;
@end

typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
    RequestMethodPUT,
    RequestMethodDELETE
};
@interface GRWebServiceManager : NSObject{
}
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSArray *multipartArray;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *message;
@property (weak, nonatomic) id<GRWebServiceManagerDelegate> delegate;
@property (strong, nonatomic) id responseObject;
@property (assign, nonatomic) NSInteger errorCode;
@property (assign, nonatomic) RequestMethod requestMethod;
@property (assign, nonatomic) BOOL isUpdating;

@property (assign, nonatomic) BOOL success;
+(instancetype)sharedInstance;
+(instancetype)sharedInstanceWithDelegate:(id<GRWebServiceManagerDelegate>)delegate;
+(instancetype)sharedInstanceWithDelegate:(id<GRWebServiceManagerDelegate>)delegate requestMethod:(RequestMethod)requestMethod;
+(instancetype)sharedInstanceWithParameters:(NSDictionary *)parameters delegate:(id<GRWebServiceManagerDelegate>)delegate;
+(instancetype)sharedInstanceWithParameters:(NSDictionary *)parameters delegate:(id<GRWebServiceManagerDelegate>)delegate requestMethod:(RequestMethod)requestMethod;
+(instancetype)sharedInstanceWithParameters:(NSDictionary *)parameters multipartParameters:(NSArray *)multipartArray delegate:(id<GRWebServiceManagerDelegate>)delegate;
+(instancetype)sharedInstanceWithParameters:(NSDictionary *)parameters multipartParameters:(NSArray *)multipartArray delegate:(id<GRWebServiceManagerDelegate>)delegate requestMethod:(RequestMethod)requestMethod;
+(instancetype)sharedInstanceWitURLString:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<GRWebServiceManagerDelegate>)delegate;
+(instancetype)sharedInstanceWitURLString:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<GRWebServiceManagerDelegate>)delegate requestMethod:(RequestMethod)requestMethod;
+(instancetype)sharedInstanceWitURLString:(NSString *)urlString parameters:(NSDictionary *)parameters multipartParameters:(NSArray *)multipartArray delegate:(id<GRWebServiceManagerDelegate>)delegate;
+(instancetype)sharedInstanceWitURLString:(NSString *)urlString parameters:(NSDictionary *)parameters multipartParameters:(NSArray *)multipartArray delegate:(id<GRWebServiceManagerDelegate>)delegate requestMethod:(RequestMethod)requestMethod;

-(void)requestSucceededWithObject:(id)responseObject;
-(void)requestFailedWithError:(NSError *)error forOperation:(AFHTTPRequestOperation *)operation;
-(void)perform;

@end

