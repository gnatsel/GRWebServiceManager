//
//  GRWebServiceManager.m
//  SampleGRWebServiceManager
//
//  Created by Gnatsel Reivilo on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "GRWebServiceManager.h"

@implementation GRWebServiceManager

-(instancetype)init{
    if(self = [super init]){
        _requestOperationManager = [AFHTTPRequestOperationManager manager];
        
        [_requestOperationManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        NSMutableSet *acceptableContentTypes = [_requestOperationManager.responseSerializer.acceptableContentTypes mutableCopy];
        [acceptableContentTypes addObject:@"application/x-javascript"];
        [acceptableContentTypes addObject:@"application/javascript"];
        AFJSONResponseSerializer *responseSerializer = (AFJSONResponseSerializer *)(_requestOperationManager.responseSerializer);
        responseSerializer.acceptableContentTypes = acceptableContentTypes;
        
    }
    return self;
}

-(void)perform{
    _isUpdating = YES;
    switch (self.requestMethod) {
        case RequestMethodGET:{
            [self performGETRequest];
            break;
        }
        case RequestMethodPOST:{
            !_multipartArray? [self performPOSTRequest] : [self performPOSTRequestMultipart];
            break;
        }
        case RequestMethodPUT:{
            [self performPUTRequest];
        }
        case RequestMethodDELETE:{
            [self performDELETERequest];
        }
        default:
            break;
    }
}
-(void)handleHTTPResponseForOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject error:(NSError *)error{
    if(_delegate && [_delegate respondsToSelector:@selector(webServiceManager:didReceiveResponseForOperation:)]){
        [_delegate webServiceManager:self didReceiveResponseForOperation:operation];
        _delegate = nil;
    }
    error? [self requestFailedWithError:error forOperation:operation] : [self requestSucceededWithObject:responseObject];
    if(_delegate && [_delegate respondsToSelector:@selector(webServiceManager:didFinishWithSuccess:)]){
        [_delegate webServiceManager:self didFinishWithSuccess:_success];
        _delegate = nil;
    }
}



-(void)performGETRequest{
    [_requestOperationManager GET:_urlString
                       parameters:_parameters
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              [self handleHTTPResponseForOperation:operation responseObject:responseObject error:nil];
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              [self handleHTTPResponseForOperation:operation responseObject:nil error:error];
                          }];
}

-(void)performPOSTRequest{
    [_requestOperationManager POST:_urlString
                        parameters:_parameters
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               [self handleHTTPResponseForOperation:operation responseObject:responseObject error:nil];
                           }
                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               [self handleHTTPResponseForOperation:operation responseObject:nil error:error];
                               
                           }];
    
    
}

-(void)performPOSTRequestMultipart{
    [_requestOperationManager POST:_urlString
                        parameters:_parameters
         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
             if(_multipartArray){
                 for(NSDictionary *fileDescription in _multipartArray){
                     NSURL *path = fileDescription[@"path"] ;
                     NSString *name = fileDescription[@"name"];
                     if(path && name)
                         [formData appendPartWithFileURL:path name:name error:nil];
                     else{
                         NSData *data = fileDescription[@"data"];
                         if(data){
                             [formData appendPartWithFormData:data name:name ];
                         }
                         else {
                             UIImage *image = fileDescription[@"image"];
                             if(image){
                                 [formData appendPartWithFormData:UIImagePNGRepresentation(image) name:name ];
                                 
                             }
                         }
                     }
                 }
             }
         }
                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                               [self handleHTTPResponseForOperation:operation responseObject:responseObject error:nil];
                           }
                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                               [self handleHTTPResponseForOperation:operation responseObject:nil error:error];
                               
                           }];
}

-(void)performPUTRequest{
    
    [_requestOperationManager PUT:_urlString
                       parameters:_parameters
                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              [self handleHTTPResponseForOperation:operation responseObject:responseObject error:nil];
                          }
                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                              [self handleHTTPResponseForOperation:operation responseObject:nil error:error];
                              
                          }];
}


-(void)performDELETERequest{
    [_requestOperationManager DELETE:_urlString
                          parameters:_parameters
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [self handleHTTPResponseForOperation:operation responseObject:responseObject error:nil];
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 [self handleHTTPResponseForOperation:operation responseObject:nil error:error];
                                 
                             }];
}

-(void)requestSucceededWithObject:(id)responseObject{
    _isUpdating = NO;
    _responseObject = responseObject;

}


-(void)requestFailedWithError:(NSError *)error forOperation:(AFHTTPRequestOperation *)operation{
    _isUpdating = NO;
    NSLog(@"%@",error);
    
    _message = [NSString stringWithFormat:@"%@",[error userInfo]];
}



+ (instancetype)sharedInstance {
    static id sharedInstanceDictionary = nil;
    id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstanceDictionary = [[NSMutableDictionary alloc] init];
    });
    NSString *sharedInstanceClassString = NSStringFromClass([self class]);
    if(!(sharedInstance = [sharedInstanceDictionary objectForKey:sharedInstanceClassString])){
        [sharedInstanceDictionary setObject:[[[self class]alloc]init] forKey:sharedInstanceClassString];
        sharedInstance = [sharedInstanceDictionary objectForKey:sharedInstanceClassString];
    }
    return sharedInstance;
}


+(instancetype)sharedInstanceWithDelegate:(id<GRWebServiceManagerDelegate>)delegate{
    GRWebServiceManager *webServicesManager = [[self class] sharedInstance];
    if(webServicesManager){
        webServicesManager.delegate = delegate;
    }
    return webServicesManager;
}
+(instancetype)sharedInstanceWithDelegate:(id<GRWebServiceManagerDelegate>)delegate requestMethod:(RequestMethod)requestMethod{
    GRWebServiceManager *webServicesManager = [[self class] sharedInstance];
    if(webServicesManager){
        webServicesManager.delegate = delegate;
        webServicesManager.requestMethod = requestMethod;
    }
    return webServicesManager;
}

+(instancetype)sharedInstanceWithParameters:(NSDictionary *)parameters delegate:(id<GRWebServiceManagerDelegate>)delegate{
    GRWebServiceManager *webServicesManager = [[self class] sharedInstance];
    if(webServicesManager){
        webServicesManager.parameters = parameters;
        webServicesManager.delegate = delegate;
    }
    return webServicesManager;
}
+(instancetype)sharedInstanceWithParameters:(NSDictionary *)parameters delegate:(id<GRWebServiceManagerDelegate>)delegate requestMethod:(RequestMethod)requestMethod{
    GRWebServiceManager *webServicesManager = [[self class] sharedInstance];
    if(webServicesManager){
        webServicesManager.parameters = parameters;
        webServicesManager.delegate = delegate;
        webServicesManager.requestMethod = requestMethod;
    }
    return webServicesManager;
}
+(instancetype)sharedInstanceWithParameters:(NSDictionary *)parameters multipartParameters:(NSArray *)multipartArray delegate:(id<GRWebServiceManagerDelegate>)delegate{
    GRWebServiceManager *webServicesManager = [[self class] sharedInstance];
    if(webServicesManager){
        webServicesManager.parameters = parameters;
        webServicesManager.multipartArray = multipartArray;
        webServicesManager.delegate = delegate;
    }
    return webServicesManager;
}

+(instancetype)sharedInstanceWithParameters:(NSDictionary *)parameters multipartParameters:(NSArray *)multipartArray delegate:(id<GRWebServiceManagerDelegate>)delegate requestMethod:(RequestMethod)requestMethod{
    GRWebServiceManager *webServicesManager = [[self class] sharedInstance];
    if(webServicesManager){
        webServicesManager.parameters = parameters;
        webServicesManager.multipartArray = multipartArray;
        webServicesManager.delegate = delegate;
        webServicesManager.requestMethod = requestMethod;
    }
    return webServicesManager;
}

+(instancetype)sharedInstanceWitURLString:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<GRWebServiceManagerDelegate>)delegate{
    GRWebServiceManager *webServicesManager = [[self class] sharedInstance];
    if(webServicesManager){
        webServicesManager.urlString = urlString;
        webServicesManager.parameters = parameters;
        webServicesManager.delegate = delegate;
    }
    return webServicesManager;
}
+(instancetype)sharedInstanceWitURLString:(NSString *)urlString parameters:(NSDictionary *)parameters delegate:(id<GRWebServiceManagerDelegate>)delegate requestMethod:(RequestMethod)requestMethod{
    GRWebServiceManager *webServicesManager = [[self class] sharedInstance];
    if(webServicesManager){
        webServicesManager.urlString = urlString;
        webServicesManager.parameters = parameters;
        webServicesManager.delegate = delegate;
        webServicesManager.requestMethod = requestMethod;
    }
    return webServicesManager;
}
+(instancetype)sharedInstanceWitURLString:(NSString *)urlString parameters:(NSDictionary *)parameters multipartParameters:(NSArray *)multipartArray delegate:(id<GRWebServiceManagerDelegate>)delegate{
    GRWebServiceManager *webServicesManager = [[self class] sharedInstance];
    if(webServicesManager){
        webServicesManager.urlString = urlString;
        webServicesManager.parameters = parameters;
        webServicesManager.multipartArray = multipartArray;
        webServicesManager.delegate = delegate;
    }
    return webServicesManager;
}

+(instancetype)sharedInstanceWitURLString:(NSString *)urlString parameters:(NSDictionary *)parameters multipartParameters:(NSArray *)multipartArray delegate:(id<GRWebServiceManagerDelegate>)delegate requestMethod:(RequestMethod)requestMethod{
    GRWebServiceManager *webServicesManager = [[self class] sharedInstance];
    if(webServicesManager){
        webServicesManager.urlString = urlString;
        webServicesManager.parameters = parameters;
        webServicesManager.multipartArray = multipartArray;
        webServicesManager.delegate = delegate;
        webServicesManager.requestMethod = requestMethod;
    }
    return webServicesManager;
}


@end
