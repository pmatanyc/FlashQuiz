//
//  ResultsViewController.m
//  FlashQuiz
//
//  Created by Paola Mata Maldonado on 10/15/14.
//  Copyright (c) 2014 Paola Mata Maldonado. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"FlashQuiz";
    
    NSLog(@"Your score: %.f", self.score);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
