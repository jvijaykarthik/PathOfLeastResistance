//
//  ViewController.m
//  PathOfLeastResistance
//
//  Created by Vijay Karthik on 2/3/16.
//  Copyright © 2016 Vijay Karthik. All rights reserved.
//

#import "ViewController.h"
#import "LPRModel.h"

@interface ViewController ()

@end

@implementation ViewController

NSMutableArray *arrInput;
NSMutableArray *arrOutput;
NSMutableArray *arrFailedOutput;
NSMutableDictionary *dicData;

//int nRowCount;
//int nColumnCount;
int nMinRowCount = 1;
int nMaxRowCount = 10;
int nMinColCount = 5;
int nMaxColCount = 100;
int nTotalResist = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    arrOutput = [[NSMutableArray alloc] init];
    arrFailedOutput = [[NSMutableArray alloc] init];
    dicData = [[NSMutableDictionary alloc] init];
    arrInput = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startProcess:(id)sender
{
    @try {
        [self getInput];
    }
    @catch (NSException *exception) {
        NSLog(@"OOPS I am not responsible for this %@", [exception description]);
    }
}

- (void)getInput
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Path of Least Resistance"
                                          message:@"Enter number of rows and columns in following format X,Y"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    __weak UIAlertController *weakAlert = alertController;
    __block ViewController *blockSelf = self;
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                   NSString *strRowColumn = ((UITextField*)[weakAlert.textFields objectAtIndex:0]).text;
                                   NSArray *arrRowColumn = [self strIntoArray:strRowColumn];
                                   [blockSelf getRowValues:arrRowColumn];
                               }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *inputTextField)
     {
         inputTextField.placeholder = @"X,Y";
     }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getRowValues:(NSArray*)arrRowColumn
{
    if ([arrRowColumn count] == 2)
    {
        arrInput = [[NSMutableArray alloc] initWithCapacity:[[arrRowColumn objectAtIndex:0] integerValue]];
//        nRowCount = [[arrRowColumn objectAtIndex:0] intValue];
//        nColumnCount = [[arrRowColumn objectAtIndex:1] intValue];
        [self setNRowCount:[[arrRowColumn objectAtIndex:0] integerValue]];
        [self setNColumnCount:[[arrRowColumn objectAtIndex:1] integerValue]];
        if (_nRowCount >= nMinRowCount && _nColumnCount >= nMinColCount && _nRowCount <= nMaxRowCount && _nColumnCount <= nMaxColCount) {
            [self showAlert:0];
        } else {
            [self showErrorAlert:[NSString stringWithFormat:@"Please enter valid numbers \n Minimum Row & Column is %d,%d \n Maximum Row & Column is %d,%d", nMinRowCount, nMinColCount, nMaxRowCount, nMaxColCount]];
        }
    }
    else
    {
        [self showErrorAlert:@"Please enter number of rows and columns in following format X,Y"];
    }
}

- (void)showErrorAlert:(NSString*)strMessage
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Path of Least Resistance"
                                                                             message:strMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAlert:(NSInteger)nRow
{
    if (nRow < _nRowCount)
    {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Path of Least Resistance"
                                              message:[NSString stringWithFormat:@"Enter values for Row : %ld",nRow+1]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        __weak UIAlertController *weakAlert = alertController;
        __block ViewController *blockSelf = self;
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {
                                       NSString *strRowValue = ((UITextField*)[weakAlert.textFields objectAtIndex:0]).text;
                                       NSArray *arrRowValue = [self strIntoArray:strRowValue];
                                       [arrInput insertObject:arrRowValue atIndex:nRow];
                                       [blockSelf showAlert:nRow+1];
                                   }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *inputTextField)
         {
             inputTextField.placeholder = @"X,Y,Z";
         }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        @try {
            [self setUpData];
        }
        @catch (NSException *exception) {
            NSLog(@"OOPS I am not responsible for this %@", [exception description]);
        }
    }
}

- (void)setUpData
{
    int i, j;
    
    /* output each array element's value into dictionary */
    for ( i = 0; i < _nRowCount; i++ )
    {
        // Hint : column - 1 because last column needs no recursion
        for ( j = 0; j < (_nColumnCount - 1); j++ )
        {
            [self setDataAsDicForX:i forY:j];
        }
    }
    
    /* find all possible resistance using the above dictionary */
    for ( i = 0; i < _nRowCount; i++ )
    {
        // Hint : Y is always 0 because we start to traverse from 1st column of every row
        [self recursionDicForX:i
                          forY:0
                withInitialKey:[NSString stringWithFormat:@"%d",i+1]
              withInitialTotal:[[[arrInput objectAtIndex:i] objectAtIndex:0] integerValue]];
    }
    
    /* Print the output */
    [self printOutput];
}

- (void)setDataAsDicForX:(int)locX forY:(int)locY
{
    NSMutableArray *arrVal = [[NSMutableArray alloc] init];
    
    //    Forward Traverse
    NSString *fwdValue = [NSString stringWithFormat:@"%d,%d",locX,(locY + 1)];
    [arrVal addObject:fwdValue];
    
    if (_nRowCount > 1) {
        //    Up Traverse
        int nUp = locX - 1;
        if (locX == 0) {
            nUp = (int)_nRowCount - 1;
        }
        NSString *upValue = [NSString stringWithFormat:@"%d,%d",nUp,(locY + 1)];
        [arrVal addObject:upValue];
        
        //    Down Traverse
        int nDown = locX + 1;
        if (nDown == _nRowCount) {
            nDown = 0;
        }
        if (nDown != nUp) {
            NSString *downValue = [NSString stringWithFormat:@"%d,%d",nDown,(locY + 1)];
            [arrVal addObject:downValue];
        }
    }
    [dicData setValue:arrVal forKey:[NSString stringWithFormat:@"%d,%d",locX,locY]];
}

- (void)recursionDicForX:(int)locX forY:(int)locY withInitialKey:(NSString*)initialKey withInitialTotal:(NSInteger)nTotal
{
    NSArray *arrTemp = [dicData objectForKey:[NSString stringWithFormat:@"%d,%d",locX,locY]];
    for (int nTemp = 0; nTemp < [arrTemp count]; nTemp++)
    {
        NSString *strTemp = [arrTemp objectAtIndex:nTemp];
        NSArray *arrSubString = [self strIntoArray:strTemp];
        if ([arrSubString count] == 2)
        {
            NSString *strPathPrint = [NSString stringWithFormat:@"%@%d",initialKey,([[arrSubString objectAtIndex:0] intValue] + 1)];
            NSInteger nPathTotal = nTotal + [[[arrInput objectAtIndex:[[arrSubString objectAtIndex:0] integerValue]] objectAtIndex:[[arrSubString objectAtIndex:1] integerValue]] integerValue];
            
            LPRModel *objOPModel = [[LPRModel alloc] init];
            if (nPathTotal < nTotalResist)
            {
                [objOPModel setPathPrint:strPathPrint];
                [objOPModel setPathTotal:nPathTotal];
                
                if ([strPathPrint length] == _nColumnCount)
                {
                    [arrOutput addObject:objOPModel];
                }
                [self recursionDicForX:[[arrSubString objectAtIndex:0] intValue]
                                  forY:[[arrSubString objectAtIndex:1] intValue]
                        withInitialKey:strPathPrint
                      withInitialTotal:nPathTotal];
            }
            else
            {
                [objOPModel setPathPrint:initialKey];
                [objOPModel setPathTotal:nTotal];
                [arrFailedOutput addObject:objOPModel];
            }
        }
    }
}

- (void)printOutput
{
    NSArray *sortedArray = [arrOutput sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSInteger first = [(LPRModel*)a pathTotal];
        NSInteger second = [(LPRModel*)b pathTotal];
        return first > second;
    }];
    NSString *strAlert = [NSString stringWithFormat:@"Sorry all paths exceeds total resitance of %d",nTotalResist];
    if ([sortedArray count] > 0) {
        LPRModel *obj = (LPRModel*)[sortedArray objectAtIndex:0];
        strAlert = [NSString stringWithFormat:@"%@ \n %ld \n %@",([obj pathTotal] < nTotalResist && [[obj pathPrint] length] == _nColumnCount) ? @"YES" : @"NO", (long)[obj pathTotal], [obj pathPrint]];
        
    } else {
        sortedArray = [arrFailedOutput sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSInteger first = [(LPRModel*)a pathTotal];
            NSInteger second = [(LPRModel*)b pathTotal];
            return first < second;
        }];
        if ([sortedArray count] > 0) {
            LPRModel *obj = (LPRModel*)[sortedArray objectAtIndex:0];
            strAlert = [NSString stringWithFormat:@"NO \n %ld \n %@", (long)[obj pathTotal], [obj pathPrint]];
        }
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Path of Least Resistance"
                                                                             message:strAlert
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSArray*)strIntoArray:(NSString*)strInput
{
    return [strInput componentsSeparatedByString:@","];
}

@end
