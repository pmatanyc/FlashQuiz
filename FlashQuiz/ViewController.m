//
//  ViewController.m
//  FlashQuiz
//
//  Created by Paola Mata Maldonado on 10/15/14.
//  Copyright (c) 2014 Paola Mata Maldonado. All rights reserved.
//

#import "ViewController.h"
#import "ResultsViewController.h"

@interface ViewController ()

@property (nonatomic) int index;
@property (nonatomic) int attempt;
@property (nonatomic) float score;
    
@property (strong, nonatomic) NSArray *questions;
@property (strong, nonatomic) NSArray *answers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Flash Quiz";
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:NO];
    
    self.index = 0;
    self.attempt = 1;
    
    NSString *urlString = @"http://flashquiz-api.herokuapp.com/flash_cards";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}


-(void)askQuestion{
    
    if (_questions.count == 0) {
        self.questionLabel.text = @"All out of quiz questions!";
        self.submitAnswerButton.enabled = NO;
    }
    else if (_index < _questions.count) {
        self.questionLabel.text = _questions[_index];
    }
    else{
    
        ResultsViewController *resultsVC = [[ResultsViewController alloc]initWithNibName:@"ResultsViewController" bundle:nil];
    
        resultsVC.score = _score;
        
        [self.navigationController pushViewController:resultsVC animated:YES];
    }
    
}

#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {

    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    
    self.questions = [jsonDictionary valueForKeyPath:@"question"];
    self.answers = [jsonDictionary valueForKeyPath:@"answer"];
    
    if (_questions.count !=0) {
         self.score = 100/_questions.count;
    }
    
    [self askQuestion];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"Error: %@",error.localizedDescription);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitAnswerButtonPressed:(id)sender{
    
    
    
    if ([[_answerTextField.text capitalizedString] isEqualToString: _answers[_index]]) {
        
        switch (_attempt) {
            case 1:
                self.score = _score * 1;
                break;
            case 2:
                self.score = _score * .75;
            case 3:
                self.score = _score * .5;
                break;
                
        }
        
        [self clearBoard];
        [self askQuestion];
    }
    
    else {
        
        switch (_attempt) {
            case 1:{
                self.attempt++;
                [self showErrorAlert];
            }
                break;
            case 2:{
                self.attempt++;
                [self showErrorAlert];
            }
                break;
            case 3:{
                [self clearBoard];
                [self askQuestion];
            }
                break;

        }
    }
        
}


-(void)showErrorAlert{
    
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Wrong answer." delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil, nil];
    [errorAlert show];

}

-(void)clearBoard{
    
    self.index++;
    self.attempt = 1;
    self.answerTextField.text = nil;

}
@end
