//
//  ViewController.m
//  Simple Calc
//
//  Created by Teng Liu on 8/24/15.
//  Copyright (c) 2015 NoLabel. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController
/*TODO: border cases
 add last input
 implement ans button for last answer
 implement brackets
 
 operator cannot be first (x)
 operator cannot be last (x)
 dot cannot be last (x)
 operator and dot cannot be consecutive (x)
 deal with really large numbers
 
 
*/

//numbers
-(IBAction)numberPressed:(UIButton *)sender{
NSInteger tag = sender.tag;
//convert to string
NSString *tagString = [NSString stringWithFormat:@"%li", tag];

//append
[workingOn appendString:tagString];
//update output
self.screenOutput.text = workingOn;
}

//operators
- (IBAction)operatorButton:(UIButton *)sender {
    //operator cannot be first
    if (( workingOn == (id)[NSNull null] || workingOn.length == 0 )){
        if(sender.tag != 11){
            return;
        }else{
            [workingOn appendString:@"-"];
            self.screenOutput.text = workingOn;
        }
    } else{
        //not first input
        //if last input is dot
        if([[self getLastInput] isEqualToString:@"."]){
            [workingOn appendString:@"0"];
            self.screenOutput.text = workingOn;
        }
        
        //if last input is operator
        [self checkLastInput];
        if(!goodLastChar){
            return;
        }
        
        switch(sender.tag){
            case 10:
                [workingOn appendString:@"+"];
                break;
            case 11:
                [workingOn appendString:@"-"];
                break;
            case 12:
                [workingOn appendString:@"*"];
                break;
            case 13:
                [workingOn appendString:@"/"];
                break;
            default:
                break;
        }
        
        self.screenOutput.text = workingOn;

    }
        
}

-(IBAction)clearButton:(UIButton *)sender{
    [workingOn setString:@""];
    self.screenOutput.text = @"";
    self.resultOutput.text = @"";
    workingOnFormula = nil;
    resultFormula = nil;
    
    
}
-(IBAction)deleteButton:(UIButton *)sender{
    //if already empty
    if (workingOn == (id)[NSNull null] || workingOn.length == 0 ){
        return;
    }
    
    [workingOn deleteCharactersInRange:NSMakeRange([workingOn length]-1, 1)];
    self.screenOutput.text = workingOn;
}

- (IBAction)dotButton:(id)sender {
    //if dot button is first pressed, add zero
    if(workingOn.length == 0){
        [workingOn appendString:@"0"];
    }
    
    [workingOn appendString:@"."];
    self.screenOutput.text = workingOn;
}

//Enter Button
- (IBAction)buttonEnter:(id)sender {
    //if nothing is entered for input
    if (workingOn == (id)[NSNull null] || workingOn.length == 0 ){
        return;
    }
    //TODO:if last input is operator
    [self checkLastInput];
    if(!goodLastChar){
        return;
    }
    
    //if last input is dot
    if([[self getLastInput] isEqualToString:@"."]){
        [workingOn appendString:@"0"];
        self.screenOutput.text = workingOn;
    }
    
    //workingOnFormula is NSExpression
    workingOnFormula = [NSExpression expressionWithFormat:workingOn];
    resultFormula = [workingOnFormula expressionValueWithObject:nil context:nil];
    self.resultOutput.text = [NSString stringWithFormat:@"%f",[resultFormula floatValue]];
}

//check last input
-(void)checkLastInput{
    lastInput = [self getLastInput];
    if([lastInput isEqualToString:@"+"]
       ||[lastInput isEqualToString:@"-"]
       ||[lastInput isEqualToString:@"*"]
       ||[lastInput isEqualToString:@"/"]
       ){
        goodLastChar = FALSE;
    } else {
        goodLastChar = TRUE;
    }
}

//get last char input
-(NSString *)getLastInput{
    return [workingOn substringFromIndex:[workingOn length]-1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    workingOn = [[NSMutableString alloc] init];
    workingOnFormula = [[NSExpression alloc] init];
    lastInput = [[NSString alloc] init];
    lastResult = [[NSNumber alloc] init];
    goodLastChar = FALSE;
    
    
    [[_clearB layer] setBorderWidth:2.0f];
    [[_clearB layer] setBorderColor:[UIColor greenColor].CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
