//
//  ViewController.m
//  BasicUserRegistrationEmail-ObjC
//
//  Created by Ramon Vitor on 12/10/16.
//  Copyright © 2016 back4app. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

-(void) alert:(NSString*) message title:(NSString*)title;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)alert:(NSString*)message
       title:(NSString*) title {
    // Show some greeting message
    // Creating a simple alert
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    // Creating the actions of the alert
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle your yes please button action here
                               }];
    
    [alert addAction:okButton];
    
    // Showing the alert
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)login:(id)sender {
    //This gets the fields from the UITextFields
    NSString* username = [self.textEmail text];
    NSString* password = [self.textPassword text];
    
    [PFUser logInWithUsernameInBackground:username password:password
      block:^(PFUser *user, NSError *error) {
          if(user) {
              // Checking out if the email has been verified
              if([[user objectForKey:@"emailVerified"] boolValue]) {
                  [self alert:@"Welcome back" title:@"Login"];
              }
              else {
                  [PFUser logOut];
                  [self alert:@"Please check your email inbox!" title:@"Login"];
              }
             
          } else {
             NSString* errorString = [error userInfo][@"error"];
             [self alert:errorString title:@"Error"];
          }
    }];
}

- (IBAction)register:(id)sender {
    //This gets the fields from the UITextFields
    NSString* email = [self.textEmail text];
    NSString* password = [self.textPassword text];
    
    //We are not checking the email here; just for simplicity sake
    PFUser* user = [PFUser user];
    user.username = email;
    user.password = password;
    user.email = email;
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(!error) {
            [self alert:@"Registered successfully! Please check your email." title:@"Register"];
        }
        else {
            NSString* errorString = [error userInfo][@"error"];
            [self alert:errorString title:@"Error"];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
