//
//  ViewController.h
//  Simple Calc
//
//  Created by Teng Liu on 8/24/15.
//  Copyright (c) 2015 NoLabel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PaddedLabel.h"

@interface ViewController : UIViewController{
    //class variables
    NSMutableString *workingOn;
    NSExpression *workingOnFormula;
    NSNumber *resultFormula;
    NSString *lastInput;
    NSNumber *lastResult;
    BOOL goodLastChar;
    BOOL closedParenthesis;
    BOOL currentCharIsDotted;
    BOOL clicked;
    NSNumberFormatter *formatter;
}

@property (weak, nonatomic) IBOutlet PaddedLabel *screenOutput;
@property (weak, nonatomic) IBOutlet PaddedLabel *resultOutput;

//methods
-(IBAction)numberPressed:(UIButton *)sender;
-(IBAction)operatorButton:(UIButton *)sender;
-(IBAction)clearButton:(UIButton *)sender;
-(IBAction)deleteButton:(UIButton *)sender;
-(IBAction)dotButton:(UIButton *)sender;
-(IBAction)ansButton:(UIButton *)sender;
-(IBAction)parenthesisButton:(UIButton *)sender;

@end

