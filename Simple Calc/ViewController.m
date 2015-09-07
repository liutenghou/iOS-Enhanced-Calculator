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
/*
 BORDER CASES
 
 add last input (x)
 implement ans button for last answer (x)
 implement brackets (x)
 operator cannot be first (x)
 operator cannot be last (x)
 dot cannot be last (x)
 operator and dot cannot be consecutive (x)
 deal with really large numbers (x)
*/

//numbers
-(IBAction)numberPressed:(UIButton *)sender{
    
    if([self overCharLimit]){
        return;
    }
    
    //add * if number coming after )
    if([[self getLastInput] isEqualToString:@")"]){
        [workingOn appendString:@"*"];
        self.screenOutput.text = workingOn;
    }
    
    NSInteger tag = sender.tag;
    //convert to string
    NSString *tagString = [NSString stringWithFormat:@"%li", (long)tag];
    
    //button animation
    [self animateButtonPress:sender];
    //append
    [workingOn appendString:tagString];
    //update output
    self.screenOutput.text = workingOn;
}


//parenthesis
-(IBAction)parenthesisButton:(UIButton *)sender{
    
    if([self overCharLimit]){
        return;
    }

    //15 = left paren, 16 = right paren
    if(sender.tag == 15 && closedParenthesis){
        
        //add * to previous number if starting (, skip if empty
        if (( workingOn != (id)[NSNull null] || workingOn.length != 0 )){
            [self checkLastInput];
            if (goodLastChar){
                [workingOn appendString:@"*"];
                self.screenOutput.text = workingOn;
            }
        }
        closedParenthesis = FALSE;
        //button animation
        [self animateButtonPress:sender];

        [workingOn appendString:@"("];
        self.screenOutput.text = workingOn;
        closedParenthesis = FALSE;
    }else if(sender.tag == 16 && !closedParenthesis){
        //if first char, do nothing
        if (( workingOn == (id)[NSNull null] || workingOn.length == 0 )){
            return;
        }
        
        [self checkLastInput];
        if (goodLastChar){
            closedParenthesis = TRUE;
            
            //button animation
            [self animateButtonPress:sender];

            [workingOn appendString:@")"];
            self.screenOutput.text = workingOn;
        }
        
    }
}

//operators
- (IBAction)operatorButton:(UIButton *)sender {
    if([self overCharLimit]){
        return;
    }
    
    //operator cannot be first, except for negative
    if (( workingOn == (id)[NSNull null] || workingOn.length == 0 )){
        if(sender.tag != 11){
            return;
        }else{
            //button animation
            [self animateButtonPress:sender];
            
            [workingOn appendString:@"-"];
            self.screenOutput.text = workingOn;
        }
    //not first input
    } else{
        //if last input is dot
        if([[self getLastInput] isEqualToString:@"."]){
            [workingOn appendString:@"0"];
            self.screenOutput.text = workingOn;
        }
        
        //okay if next input is negative
        if(sender.tag != 11){
            //if last input is operator
            [self checkLastInput];
            if(!goodLastChar){
                return;
            }
        }else{
            //next input is negative
            //if previous input is also negative, then no go
            //else okay if negative
            if([[self getLastInput] isEqualToString:@"-"]){
                return;
            }
        }
        
        //all is well, add operator
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
            case 14:
                [workingOn appendString:@"**"];
                break;
            default:
                break;
        }
        //button animation
        [self animateButtonPress:sender];

        self.screenOutput.text = workingOn;
    }
}

//check last input
-(void)checkLastInput{
    //make sure this is never called if nothing is in workingOn
    if (( workingOn == (id)[NSNull null] || workingOn.length == 0 )){
        return;
    }

    lastInput = [self getLastInput];
    if([lastInput isEqualToString:@"+"]
       ||[lastInput isEqualToString:@"-"]
       ||[lastInput isEqualToString:@"*"]
       ||[lastInput isEqualToString:@"/"]
       ||[lastInput isEqualToString:@"^"]
       ||[lastInput isEqualToString:@"("]
       ){
        goodLastChar = FALSE;
    } else {
        goodLastChar = TRUE;
    }
}

//get last char input
-(NSString *)getLastInput{
    //make sure this is never called if nothing is in workingOn
    if (( workingOn == (id)[NSNull null] || workingOn.length == 0 )){
        return @"";
    }
    return [workingOn substringFromIndex:[workingOn length]-1];
}

-(IBAction)clearButton:(UIButton *)sender{
    //if already empty
    if (workingOn == (id)[NSNull null] || workingOn.length == 0 ){
        return;
    }
    
    [workingOn setString:@""];
    self.screenOutput.text = @"";
    self.resultScreenOutput.text = @"";
    result = nil;
    lastInput = nil;
    lastResult = nil;
    goodLastChar = FALSE;
    closedParenthesis = TRUE;
    currentCharIsDotted = FALSE;
    //button animation
    [self animateButtonPress:sender];
    
    
}
-(IBAction)deleteButton:(UIButton *)sender{
    //if already empty
    if (workingOn == (id)[NSNull null] || workingOn.length == 0 ){
        return;
    }
    
    //if deleting a parenthesis, set closed parenthesis
    if([[self getLastInput] isEqualToString:@")"]){
        closedParenthesis = FALSE;
    }else if([[self getLastInput] isEqualToString:@"("]){
        closedParenthesis = TRUE;
    }
    
    //last char, reset
    if (workingOn.length == 1){
        self.screenOutput.text = @"";
        self.resultScreenOutput.text = @"";
        result = nil;
        lastInput = nil;
        lastResult = nil;
        goodLastChar = FALSE;
        closedParenthesis = TRUE;
        currentCharIsDotted = FALSE;
    }
    
    //button animation
    [self animateButtonPress:sender];
    
    [workingOn deleteCharactersInRange:NSMakeRange([workingOn length]-1, 1)];
    self.screenOutput.text = workingOn;
}

- (IBAction)dotButton:(id)sender {
    if([self overCharLimit]){
        return;
    }
   
    if([[self getLastInput] isEqualToString:@"."]){
        return;
    }
        
    //if dot button is first pressed, add zero
    if(workingOn.length == 0){
        [workingOn appendString:@"0"];
    }
    
    //button animation
    [self animateButtonPress:sender];

    
    [workingOn appendString:@"."];
    self.screenOutput.text = workingOn;
}

- (IBAction)ansButton:(UIButton *)sender {
    //if already empty
    if (workingOn == (id)[NSNull null] || workingOn.length == 0 ){
        return;
    }

    //TODO: if ans if inf
    if([self.resultScreenOutput.text containsString:@"\u221E"]){
        return;
    }
    
    //button animation
    [self animateButtonPress:sender];

    [workingOn setString:self.resultScreenOutput.text];
    self.screenOutput.text = workingOn;
}

//Enter Button
- (IBAction)buttonEnter:(id)sender {
    
    @try{
        //if nothing is entered for input
        if (workingOn == (id)[NSNull null] || workingOn.length == 0 ){
            return;
        }
        
        //TODO:if last input is operator
        [self checkLastInput];
        if(!goodLastChar){
            return;
        }
        
        //if parenthesis are not closed
        if (!closedParenthesis){
            return;
        }
        
        //if last input is dot
        if([[self getLastInput] isEqualToString:@"."]){
            [workingOn appendString:@"0"];
            self.screenOutput.text = workingOn;
        }
        
        NSPredicate * parsed = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"1.0 * %@ = 0", workingOn]];
        NSExpression * left = [(NSComparisonPredicate *)parsed leftExpression];
        result = [left expressionValueWithObject:nil context:nil];
         
        //if answer is already shown
        if([self.resultScreenOutput.text isEqual:[formatter stringForObjectValue:result]]){
            return;
        }
        
        //button animation
        [self animateButtonPress:sender];
        
        self.resultScreenOutput.text = [formatter stringForObjectValue:result];
        
    }@catch(NSException *e){
        [self clearButton:nil];
        self.resultScreenOutput.text = @"Syntax Error";
    }@finally{
        
    }
}

-(BOOL)overCharLimit{
    //limit number of characters to 20
    if([workingOn length] >= 15){
        return TRUE;
    }else{
        return FALSE;
    }
}

-(void)animateButtonPress:(UIButton *)sender{
        //animates button 25 pixels right and 25 pixels down. Customize
        CGRect newFrame = CGRectMake(sender.frame.origin.x-4, sender.frame.origin.y-4, sender.frame.size.width, sender.frame.size.height);

        [UIView animateWithDuration:0.1f
                              delay:0.0f
                            options: UIViewAnimationOptionCurveLinear
                         animations:^{
                             [sender setFrame:newFrame];
                             //[sender setFrame:originalFrame];
                         }
                         completion:nil
         ];
        clicked = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenOutput.adjustsFontSizeToFitWidth = YES;
    
    workingOn = [[NSMutableString alloc] init];
    lastInput = [[NSString alloc] init];
    lastResult = [[NSNumber alloc] init];
    goodLastChar = FALSE;
    closedParenthesis = TRUE;
    currentCharIsDotted = FALSE;
    clicked = FALSE;
    
    //formatted output
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:4];
    
    //background
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundImage"]];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
