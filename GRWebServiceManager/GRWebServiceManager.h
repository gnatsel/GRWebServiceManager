//
//  GRWebServiceManager.h
//  SampleGRWebServiceManager
//
//  Created by Gnatsel Reivilo on 04/06/2015.
//  Copyright (c) 2015 Gnatsel Reivilo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@class GRWebServiceManager;

/**
 * Set of methods to be implemented by the delegate of GRWebServiceManager
 */
@protocol GRWebServiceManagerDelegate<NSObject>
/**
 * Method to implement in order to be warned when the GRWebServiceManager instance finished
 * all of its assigned tasks after a request is done
 *
 * @param webServiceManager     the GRWebServiceManager instance that finished its assigned tasks
 * @param success               indicates if the http request was successful or not
 */
-(void)webServiceManager:(GRWebServiceManager *)webServiceManager didFinishWithSuccess:(BOOL)success;

/**
 * Optional method to implement in order to be warned when the request is done
 * @param webServiceManager     the GRWebServiceManager instance that finished the AFHTTPRequestOperation
 * @param operation             the AFHTTPRequestOperation that was performed
 */
@optional
-(void)webServiceManager:(GRWebServiceManager *)webServiceManager didReceiveResponseForOperation:(AFHTTPRequestOperation *)operation;
@end


/**
 * Enum representing the http action that should be performed by the instance of WebServiceManager
 */
typedef NS_ENUM(NSInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
    RequestMethodPUT,
    RequestMethodDELETE
};



@interface GRWebServiceManager : NSObject{
}

/**
 * The parameters that will be sent with the http request (no multipart)
 */
@property (strong, nonatomic) NSDictionary *parameters;

/**
 * The multipart parameters that will be sent with the http request
 */
@property (strong, nonatomic) NSArray *multipartArray;

/**
 * The webservice URL
 */
@property (strong, nonatomic) NSString *urlString;

/**
 * The message corresponding to the last http request performed
 * @note    I usually use it to show what happened in case of error
 */
@property (strong, nonatomic) NSString *message;

/**
 * The AFHTTPRequestOperationManager used to perform http requests
 */
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;

/**
 *  The delegate of the current instance of GRWebServiceManager
 */
@property (weak, nonatomic) id<GRWebServiceManagerDelegate> delegate;

/**
 * The response of the last http request (usually a JSON response mapped to an NSArray or NSDictionary)
 */
@property (strong, nonatomic) id responseObject;

/**
 * The error code of the last http request
 */
@property (assign, nonatomic) NSInteger errorCode;

/**
 * The http action that will be performed by each http request
 */
@property (assign, nonatomic) RequestMethod requestMethod;

/**
 * Boolean indicating if the current instance of GRWebServiceManager is already performing a request
 */
@property (assign, nonatomic) BOOL isUpdating;

/**
 * Boolean indicating if the last http request was successful
 */
@property (assign, nonatomic) BOOL success;

/**
 * @return                  a singleton of GRWebServiceManager
 */
+(instancetype)sharedInstance;

/**
 * @param delegate          the delegate of the GRWebServiceManager singleton
 *
 * @return                  a singleton of GRWebServiceManager with the given delegate set
 */
+(instancetype)sharedInstanceWithDelegate:(id<GRWebServiceManagerDelegate>)delegate;

/**
 * @param delegate          the delegate of the GRWebServiceManager singleton
 * @param requestMethod     the RequestMethod of the GRWebServiceManager singleton
 *
 * @return                  a singleton of GRWebServiceManager with the given delegate and requestMethod set
 */
+(instancetype)sharedInstanceWithDelegate:(id<GRWebServiceManagerDelegate>)delegate
                            requestMethod:(RequestMethod)requestMethod;

/**
 * @param parameters        the parameters that will be sent with the http request of the GRWebServiceManager singleton
 * @param delegate          the delegate of the GRWebServiceManager singleton
 *
 * @return                  a singleton of GRWebServiceManager with the given delegate and requestMethod set
 */
+(instancetype)sharedInstanceWithParameters:(NSDictionary *)parameters
                                   delegate:(id<GRWebServiceManagerDelegate>)delegate;

/**
 * @param parameters        the parameters that will be sent with the http request of the GRWebServiceManager singleton
 * @param delegate          the delegate of the GRWebServiceManager singleton
 * @param requestMethod     the requestMethod of the GRWebServiceManager singleton
 *
 * @return                  a singleton of GRWebServiceManager with the given parameters, delegate and requestMethod set
 */
+(instancetype)sharedInstanceWithParameters:(NSDictionary *)parameters
                                   delegate:(id<GRWebServiceManagerDelegate>)delegate
                              requestMethod:(RequestMethod)requestMethod;

/**
 * @param parameters        the parameters that will be sent with the http request of the GRWebServiceManager singleton
 * @param multipartArray    the multipart parameters that will be sent with the http request of the GRWebServiceManager singleton
 * @param delegate          the delegate of the GRWebServiceManager singleton
 *
 * @return                  a singleton of GRWebServiceManager with the given parameters, multipartArray and delegate set
 */
+(instancetype)sharedInstanceWithParameters:(NSDictionary *)parameters
                        multipartParameters:(NSArray *)multipartArray
                                   delegate:(id<GRWebServiceManagerDelegate>)delegate;

/**
 * @param parameters        the parameters that will be sent with the http request of the GRWebServiceManager singleton
 * @param multipartArray    the multipart parameters that will be sent with the http request of the GRWebServiceManager singleton
 * @param delegate          the delegate of the GRWebServiceManager singleton
 * @param requestMethod     the requestMethod of the GRWebServiceManager singleton
 *
 * @return                  a singleton of GRWebServiceManager with the given parameters, multipartArray, delegate and requestMethod set
 */
+(instancetype)sharedInstanceWithParameters:(NSDictionary *)parameters
                        multipartParameters:(NSArray *)multipartArray
                                   delegate:(id<GRWebServiceManagerDelegate>)delegate
                              requestMethod:(RequestMethod)requestMethod;

/**
 * @param urlString         the url of the webservice
 * @param parameters        the parameters that will be sent with the http request of the GRWebServiceManager singleton
 * @param delegate          the delegate of the GRWebServiceManager singleton
 *
 * @return                  a singleton of GRWebServiceManager with the given urlString, parameters and delegate set
 */
+(instancetype)sharedInstanceWitURLString:(NSString *)urlString
                               parameters:(NSDictionary *)parameters
                                 delegate:(id<GRWebServiceManagerDelegate>)delegate;

/**
 * @param urlString         the url of the webservice
 * @param parameters        the parameters that will be sent with the http request of the GRWebServiceManager singleton
 * @param delegate          the delegate of the GRWebServiceManager singleton
 * @param requestMethod     the requestMethod of the GRWebServiceManager singleton
 *
 * @return                  a singleton of GRWebServiceManager with the given urlString, parameters, delegate and requestMethod set
 */
+(instancetype)sharedInstanceWitURLString:(NSString *)urlString
                               parameters:(NSDictionary *)parameters
                                 delegate:(id<GRWebServiceManagerDelegate>)delegate
                            requestMethod:(RequestMethod)requestMethod;

/**
 * @param urlString         the url of the webservice
 * @param parameters        the parameters that will be sent with the http request of the GRWebServiceManager singleton
 * @param multipartArray    the multipart parameters that will be sent with the http request of the GRWebServiceManager singleton
 * @param delegate          the delegate of the GRWebServiceManager singleton
 * @param requestMethod     the requestMethod of the GRWebServiceManager singleton
 *
 * @return                  a singleton of GRWebServiceManager with the given urlString, parameters, multipartArray and delegate set
 */
+(instancetype)sharedInstanceWitURLString:(NSString *)urlString
                               parameters:(NSDictionary *)parameters
                      multipartParameters:(NSArray *)multipartArray
                                 delegate:(id<GRWebServiceManagerDelegate>)delegate;

/**
 * @param urlString         the url of the webservice
 * @param parameters        the parameters that will be sent with the http request of the GRWebServiceManager singleton
 * @param multipartArray    the multipart parameters that will be sent with the http request of the GRWebServiceManager singleton
 * @param delegate          the delegate of the GRWebServiceManager singleton
 * @param requestMethod     the requestMethod of the GRWebServiceManager singleton
 *
 * @return                  a singleton of GRWebServiceManager with the given urlString, parameters, multipartArray, delegate and requestMethod set
 */
+(instancetype)sharedInstanceWitURLString:(NSString *)urlString
                               parameters:(NSDictionary *)parameters
                      multipartParameters:(NSArray *)multipartArray
                                 delegate:(id<GRWebServiceManagerDelegate>)delegate
                            requestMethod:(RequestMethod)requestMethod;


/**
 * Method called when an http request was successful
 * @note    should be overriden by its children
 */
-(void)requestSucceededWithObject:(id)responseObject;

/**
 * Method called when an http request failed
 * @note    should be overriden by its subclasses
 */
-(void)requestFailedWithError:(NSError *)error forOperation:(AFHTTPRequestOperation *)operation;

/**
 * Perform an http request with the current parameters, multipartArray, urlString and request method
 */
-(void)perform;

@end

