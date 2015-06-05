//
//  GRWebServiceManager.m
//  SampleGRWebServiceManager
//
//  Created by Olivier Lestang [DAN-PARIS] on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import "GRWebServiceManager.h"

@implementation GRWebServiceManager


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

-(void)performGETRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager
     GET:_urlString
     parameters:_parameters
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [self requestSucceededWithObject:responseObject];
         if(_delegate && [_delegate respondsToSelector:@selector(webServiceManager:didFinishWithSuccess:)]){
             [_delegate webServiceManager:self didFinishWithSuccess:_success];
             _delegate = nil;
         }
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self requestFailedWithError:error forOperation:operation];
         if(_delegate && [_delegate respondsToSelector:@selector(webServiceManager:didFinishWithSuccess:)]){
             [_delegate webServiceManager:self didFinishWithSuccess:_success];
             _delegate = nil;
         }
     }];
}

-(void)performPOSTRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if(_multipartArray){
        
    }
        [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        
        [manager
         POST:_urlString
         parameters:_parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             [self requestSucceededWithObject:responseObject];
             if(_delegate){
                 [_delegate webServiceManager:self didFinishWithSuccess:_success];
                 _delegate = nil;
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self requestFailedWithError:error forOperation:operation];
             if(_delegate){
                 [_delegate webServiceManager:self didFinishWithSuccess:_success];
                 _delegate = nil;
             }
             
             
             
         }];
    
    
}

-(void)performPOSTRequestMultipart{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [manager POST:_urlString parameters:_parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(_multipartArray){
            for(NSDictionary *fileDescription in _multipartArray){
                NSURL *path = [fileDescription objectForKey:@"path"] ;
                NSString *name = [fileDescription objectForKey:@"name"];
                if(path && name)
                    [formData appendPartWithFileURL:path name:name error:nil];
                else{
                    NSData *data = [fileDescription objectForKey:@"data"];
                    if(data){
                        [formData appendPartWithFormData:data name:name ];
                    }
                    else {
                        UIImage *image = [fileDescription objectForKey:@"image"];
                        if(image){
                            [formData appendPartWithFormData:UIImagePNGRepresentation(image) name:name ];
                            
                        }
                    }
                }
            }
            
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestSucceededWithObject:responseObject];
        if(_delegate){
            [_delegate webServiceManager:self didFinishWithSuccess:_success];
            _delegate = nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailedWithError:error forOperation:operation];
        if(_delegate){
            [_delegate webServiceManager:self didFinishWithSuccess:_success];
            _delegate = nil;
        }
    }];
}

-(void)performPUTRequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [manager
     PUT:_urlString
     parameters:_parameters
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [self requestSucceededWithObject:responseObject];
          if(_delegate){
              [_delegate webServiceManager:self didFinishWithSuccess:_success];
              _delegate = nil;
          }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFailedWithError:error forOperation:operation];
        if(_delegate){
            [_delegate webServiceManager:self didFinishWithSuccess:_success];
            _delegate = nil;
        }
    }];
}


-(void)performDELETERequest{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [manager
     DELETE:_urlString
     parameters:_parameters
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [self requestSucceededWithObject:responseObject];
         if(_delegate){
             [_delegate webServiceManager:self didFinishWithSuccess:_success];
             _delegate = nil;
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self requestFailedWithError:error forOperation:operation];
         if(_delegate){
             [_delegate webServiceManager:self didFinishWithSuccess:_success];
             _delegate = nil;
         }
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
