//
//  ViewController.h
//  PathOfLeastResistance
//
//  Created by Vijay Karthik on 2/3/16.
//  Copyright © 2016 Vijay Karthik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPRModel.h"

@interface ViewController : UIViewController

@property (nonatomic, assign) NSInteger nRowCount;
@property (nonatomic, assign) NSInteger nColumnCount;
@property (nonatomic, strong) NSMutableArray *arrInput;
@property (nonatomic, strong) NSMutableArray *arrOutput;
@property (nonatomic, strong) NSMutableArray *arrFailedOutput;
@property (nonatomic, strong) LPRModel *objLPRModel;

- (void)getRowValues:(NSArray*)arrRowColumn;
- (void)setUpData;

@end

