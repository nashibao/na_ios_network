//
//  na_ios_testTests.m
//  na_ios_testTests
//
//  Created by nashibao on 2012/10/29.
//  Copyright (c) 2012年 nashibao. All rights reserved.
//
#import "NANetworkGCDHelperTest.h"

#import "NANetworkGCDHelper.h"

#import "NAAsyncOCUnit.h"

#import "NSURLRequest+na.h"

@implementation NANetworkGCDHelperTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testSendAsynchronousRequest
{
    STAsynchronousTestStart(test);
    NSURLRequest *req = [NSURLRequest request:@"http://www.google.co.jp" query:nil protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    
    [NANetworkGCDHelper sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:NO successHandler:^(NSURLResponse *resp, id data) {
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)resp;
        STAssertEquals(httpResp.statusCode, 200, @"status code must be 200");
        STAssertFalse([data isKindOfClass:[NSDictionary class]], @"is not json class");
        STAssertTrue(YES, @"success!!!!!");
    } errorHandler:^(NSURLResponse *resp, NSError *err) {
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)resp;
        STAssertEquals(httpResp.statusCode, 200, @"status code must be 200");
        STAssertTrue(NO, @"error!!!!!");
    } completeHandler:^{
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, @"complete handler");
        STAsynchronousTestDone(test);
    }];
    STAsynchronousTestWait(test, 0.5);
}

- (void)testSendAsynchronousRequest404
{
    STAsynchronousTestStart(test);
    NSURLRequest *req = [NSURLRequest request:@"http://ozuma.sakura.ne.jp/httpstatus/404" query:nil protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    
    [NANetworkGCDHelper sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:NO successHandler:^(NSURLResponse *resp, id data) {
        STAssertFalse([data isKindOfClass:[NSDictionary class]], @"is not json class");
        STAssertTrue(NO, @"success!!!!!");
        STAsynchronousTestDone(test);
    } errorHandler:^(NSURLResponse *resp, NSError *err) {
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)resp;
        STAssertEquals(httpResp.statusCode, 404, @"status code must be 200");
        STAssertTrue(YES, @"error!!!!!");
        STAsynchronousTestDone(test);
    }];
    STAsynchronousTestWait(test, 0.5);
}

- (void)atestSendAsynchronousRequest401
{
    STAsynchronousTestStart(test);
    NSURLRequest *req = [NSURLRequest request:@"http://ozuma.sakura.ne.jp/httpstatus/401" query:nil protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    
    [NANetworkGCDHelper sendAsynchronousRequest:req returnEncoding:NSShiftJISStringEncoding returnMain:NO successHandler:^(NSURLResponse *resp, id data) {
        STAssertFalse([data isKindOfClass:[NSDictionary class]], @"is not json class");
        STAssertTrue(NO, @"success!!!!!");
        STAsynchronousTestDone(test);
    } errorHandler:^(NSURLResponse *resp, NSError *err) {
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
        NSHTTPURLResponse *httpResp = (NSHTTPURLResponse *)resp;
        STAssertEquals(httpResp.statusCode, 401, @"status code must be 401");
        STAssertTrue(YES, @"error!!!!!");
        STAsynchronousTestDone(test);
    }];
    STAsynchronousTestWait(test, 0.5);
}

- (void)testSendJSONAsynchronousRequest
{
    STAsynchronousTestStart(test);
    NSURLRequest *req = [NSURLRequest request:@"http://www.google.co.jp" query:nil protocol:NANetworkProtocolGET encoding:NSUTF8StringEncoding];
    
    [NANetworkGCDHelper sendJsonAsynchronousRequest:req jsonOption:NSJSONReadingAllowFragments returnEncoding:NSShiftJISStringEncoding returnMain:NO successHandler:^(NSURLResponse *resp, id data) {
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, data);
        STAssertTrue([data isKindOfClass:[NSDictionary class]], @"is json class");
        STAsynchronousTestDone(test);
    } errorHandler:^(NSURLResponse *resp, NSError *err) {
        NSLog(@"%s|%@", __PRETTY_FUNCTION__, err);
        STAssertTrue(YES, @"error!!!!!");
        STAsynchronousTestDone(test);
    }];
    STAsynchronousTestWait(test, 0.5);
}

@end
