//
//  ResultsViewController.h
//  FlashQuiz
//
//  Created by Paola Mata Maldonado on 10/15/14.
//  Copyright (c) 2014 Paola Mata Maldonado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableData *responseData;
}

@property (strong, nonatomic) IBOutlet UILabel *scoreResultLabel;

@property (nonatomic)float score;


@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
