//
//  NANetworkHelper.m
//  SK3
//
//  Created by nashibao on 2012/09/25.
//  Copyright (c) 2012年 s-cubism. All rights reserved.
//

#import "NANetworkGCDHelper.h"

#import "NSOperationQueue+na.h"

#import "NANetworkActivityIndicatorManager.h"

#import "JSONKit.h"

typedef void (^ERROR_BLOCK)(NSURLResponse *resp, NSError *err);

@implementation NANetworkGCDHelper

static ERROR_BLOCK __global_error_block__;

NSInteger __networking__count__ = 0;

+ (void)_sendAsynchronousRequest:(NSURLRequest *)request
                  returnEncoding:(NSStringEncoding)returnEncoding
                          isJson:(BOOL)isJSON
                      jsonOption:(NSJSONReadingOptions)jsonOption
                      returnMain:(BOOL)returnMain
                        maskType:(NAProgressHUDMaskType)maskType
                  successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                    errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler
                 completeHandler:(void(^)())completeHandler{
    
    [[NANetworkActivityIndicatorManager sharedManager] incrementActivityCount:nil maskType:maskType option:nil];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue globalBackgroundQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *err) {
        NSError *_err = nil;
        id _result = nil;
        if([data length] > 0 && err == nil){
            if(isJSON){
                NSError *jsonErr;
                NSDictionary *result = [data objectFromJSONDataWithParseOptions:JKParseOptionStrict error:&jsonErr];
                if(jsonErr){
                    _err = jsonErr;
                }else{
                    _result = result;
                }
            }else{
                NSString *result = [[NSString alloc] initWithData:data encoding:returnEncoding];
                _result = result;
            }
        }else{
            _err = err;
        }
        if(_err || !_result){
            NSString *result = [[NSString alloc] initWithData:data encoding:returnEncoding];
            //gNSLog(@"%s|%@", __PRETTY_FUNCTION__, result);
            if(errorHandler){
                if(returnMain){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        errorHandler(resp, _err);
                    });
                }else{
                    errorHandler(resp, _err);
                }
            }
            if(__global_error_block__){
                dispatch_async(dispatch_get_main_queue(), ^{
                    __global_error_block__(resp, _err);
                });
            }
            [[NANetworkActivityIndicatorManager sharedManager] decrementActivityCount:nil error:[NSString stringWithFormat:@"%@", _err] ?: @"no result"];
        }else{
            if(successHandler){
                if(returnMain){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        successHandler(resp, _result);
                    });
                }else{
                    successHandler(resp, _result);
                }
            }
            [[NANetworkActivityIndicatorManager sharedManager] decrementActivityCount:nil];
        }
        if(completeHandler){
            dispatch_async(dispatch_get_main_queue(), ^{
                completeHandler();
            });
        }
    }];
}

+ (void)sendJsonAsynchronousRequest:(NSURLRequest *)request
                         jsonOption:(NSJSONReadingOptions)jsonOption
                     returnEncoding:(NSStringEncoding)returnEncoding
                         returnMain:(BOOL)returnMain
                     successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                       errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler{
    [self _sendAsynchronousRequest:request returnEncoding:returnEncoding isJson:YES jsonOption:jsonOption returnMain:returnMain maskType:NAProgressHUDMaskTypeDefault successHandler:successHandler errorHandler:errorHandler completeHandler:nil];
}


+ (void)sendJsonAsynchronousRequest:(NSURLRequest *)request
                         jsonOption:(NSJSONReadingOptions)jsonOption
                     returnEncoding:(NSStringEncoding)returnEncoding
                         returnMain:(BOOL)returnMain
                     successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                       errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler
                    completeHandler:(void (^)())completeHandler{
    [self _sendAsynchronousRequest:request returnEncoding:returnEncoding isJson:YES jsonOption:jsonOption returnMain:returnMain maskType:NAProgressHUDMaskTypeDefault successHandler:successHandler errorHandler:errorHandler completeHandler:completeHandler];
}


+ (void)sendJsonAsynchronousRequest:(NSURLRequest *)request
                         jsonOption:(NSJSONReadingOptions)jsonOption
                     returnEncoding:(NSStringEncoding)returnEncoding
                         returnMain:(BOOL)returnMain
                           maskType:(NAProgressHUDMaskType)maskType
                     successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                       errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler
                    completeHandler:(void (^)())completeHandler{
    [self _sendAsynchronousRequest:request returnEncoding:returnEncoding isJson:YES jsonOption:jsonOption returnMain:returnMain maskType:maskType successHandler:successHandler errorHandler:errorHandler completeHandler:completeHandler];
}

+ (void)sendAsynchronousRequest:(NSURLRequest *)request
                 returnEncoding:(NSStringEncoding)returnEncoding
                     returnMain:(BOOL)returnMain
                 successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                   errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler{
    [self _sendAsynchronousRequest:request returnEncoding:returnEncoding isJson:NO jsonOption:NSJSONReadingAllowFragments returnMain:returnMain maskType:NAProgressHUDMaskTypeDefault successHandler:successHandler errorHandler:errorHandler completeHandler:nil];
}

+ (void)sendAsynchronousRequest:(NSURLRequest *)request
                 returnEncoding:(NSStringEncoding)returnEncoding
                     returnMain:(BOOL)returnMain
                 successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                   errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler
                completeHandler:(void (^)())completeHandler{
    [self _sendAsynchronousRequest:request returnEncoding:returnEncoding isJson:NO jsonOption:NSJSONReadingAllowFragments returnMain:returnMain maskType:NAProgressHUDMaskTypeDefault successHandler:successHandler errorHandler:errorHandler completeHandler:completeHandler];
}

+ (void)sendAsynchronousRequest:(NSURLRequest *)request
                 returnEncoding:(NSStringEncoding)returnEncoding
                     returnMain:(BOOL)returnMain
                       maskType:(NAProgressHUDMaskType)maskType
                 successHandler:(void(^)(NSURLResponse *resp, id data))successHandler
                   errorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler
                completeHandler:(void (^)())completeHandler{
    [self _sendAsynchronousRequest:request returnEncoding:returnEncoding isJson:NO jsonOption:NSJSONReadingAllowFragments returnMain:returnMain maskType:maskType successHandler:successHandler errorHandler:errorHandler completeHandler:completeHandler];
}

+ (void)setGlobalErrorHandler:(void(^)(NSURLResponse *resp, NSError *err))errorHandler{
    __global_error_block__ = errorHandler;
}

@end
