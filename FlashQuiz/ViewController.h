//
//  ViewController.h
//  FlashQuiz
//
//  Created by Paola Mata Maldonado on 10/15/14.
//  Copyright (c) 2014 Paola Mata Maldonado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>{
    
    NSMutableData *responseData;
}

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;

@property (strong, nonatomic) IBOutlet UITextField *answerTextField;

@property (strong, nonatomic) IBOutlet UIButton *submitAnswerButton;

- (IBAction)submitAnswerButtonPressed:(id)sender;



@end

