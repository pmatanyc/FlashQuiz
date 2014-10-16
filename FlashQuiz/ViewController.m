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
    
    self.title = @"FlashQuiz";
    
    _index = 0;
    _attempt = 1;
    
    NSString *baseURL = @"http://flashquiz-api.herokuapp.com/flash_cards";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:baseURL]];
    
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
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSError *error;
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    
    _questions = [jsonDictionary valueForKeyPath:@"question"];
    _answers = [jsonDictionary valueForKeyPath:@"answer"];
    
    if (_questions.count !=0) {
         _score = 100/_questions.count;
    }
    
    [self askQuestion];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"%@",error.localizedDescription);
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
                _score = _score * 1;
                break;
            case 2:
                _score = _score * .75;
            case 3:
                _score = _score * .5;
                break;
                
        }
        
        [self clearBoard];
        [self askQuestion];
    }
    
    else {
        
        switch (_attempt) {
            case 1:{
                _attempt++;
                [self showErrorAlert];
            }
                break;
            case 2:{
                _attempt++;
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
    
    _index++;
    _attempt = 1;
    _answerTextField.text = nil;

}
@end
