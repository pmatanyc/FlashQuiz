//
//  ResultsViewController.m
//  FlashQuiz
//
//  Created by Paola Mata Maldonado on 10/15/14.
//  Copyright (c) 2014 Paola Mata Maldonado. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()

@property (strong, nonatomic) NSArray *highScores;
@property (nonatomic) float highScore;

@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"High Scores";
    self.scoreResultLabel.text = [NSString stringWithFormat:@"%.f", self.score];
    
    NSString *urlString = @"http://flashquiz-api.herokuapp.com/scores";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)displayHighestScore{
    
    self.highScore = 0.0;
    
    for (id score in _highScores) {
        
        if ([score floatValue] > _highScore)
            self.highScore = [score floatValue];
        
    }
    
    if (_score > _highScore)
        self.infoLabel.text = @"You beat the top score!";
    else if (_score == _highScore)
        self.infoLabel.text = @"You matched the top score!";
    else
        self.highScoreLabel.text = [NSString stringWithFormat:@"%.f",_highScore];
    
}

#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {

    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    
    self.highScores = [jsonDictionary valueForKeyPath:@"value"];
    
    [self displayHighestScore];
    
    [self.tableView reloadData];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"%@",error.localizedDescription);
}

#pragma mark TableView Data Source Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
        }

    cell.textLabel.text = [NSString stringWithFormat:@"%d.", indexPath.row + 1];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", _highScores[indexPath.row]];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
