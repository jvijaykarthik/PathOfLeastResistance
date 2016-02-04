//
//  PathOfLeastResistanceTests.m
//  PathOfLeastResistanceTests
//
//  Created by Vijay Karthik on 2/3/16.
//  Copyright © 2016 Vijay Karthik. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPRModel.h"
#import "ViewController.h"

@interface PathOfLeastResistanceTests : XCTestCase {
    ViewController *objViewCtrlr;
}

@end

@implementation PathOfLeastResistanceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    objViewCtrlr = [[ViewController alloc] init];
}

- (void)tearDown {
    objViewCtrlr = nil;
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLPRModelClassExists {
    LPRModel *lprModel = [[LPRModel alloc] init];
    XCTAssertNotNil(lprModel,@"Least path resistance model class exists.");
}

- (void)testMinAndMaxCountSuccess {
    [objViewCtrlr getRowValues:[[NSArray alloc] initWithObjects:@"1",@"5", nil]];
    XCTAssertTrue([objViewCtrlr nRowCount] >= 1 && [objViewCtrlr nRowCount] <= 10 && [objViewCtrlr nColumnCount] >= 5 && [objViewCtrlr nColumnCount] <= 100 ,@"Values are within limit");
}

- (void)testMinAndMaxCountFailure {
    [objViewCtrlr getRowValues:[[NSArray alloc] initWithObjects:@"11",@"5", nil]];
    XCTAssertFalse([objViewCtrlr nRowCount] >= 1 && [objViewCtrlr nRowCount] <= 10 && [objViewCtrlr nColumnCount] >= 5 && [objViewCtrlr nColumnCount] <= 100 ,@"Values are within limit");
}

- (void)testScenario1
{
    [objViewCtrlr setNRowCount:2];
    [objViewCtrlr setNColumnCount:5];
    
    NSArray *arr1 = [[NSArray alloc] initWithObjects:@"3",@"5",@"7",@"9",@"10", nil];
    NSArray *arr2 = [[NSArray alloc] initWithObjects:@"23",@"5",@"23",@"-12",@"1", nil];
    
    [objViewCtrlr setArrInput:[[NSMutableArray alloc] initWithObjects:arr1,arr2, nil]];
    [objViewCtrlr setArrOutput:[[NSMutableArray alloc] init]];
    [objViewCtrlr setUpData];
    
    XCTAssertTrue([[objViewCtrlr objLPRModel] pathTotal] < 50 ,@"Path print have not exceeded the total limit");
    XCTAssertEqual([[objViewCtrlr objLPRModel] pathTotal], 4, @"Path total matches");
    XCTAssertEqualObjects([[objViewCtrlr objLPRModel] pathPrint], @"11122", @"Path print matches");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
