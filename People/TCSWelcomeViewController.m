//
//  TCSWelcomeViewController.m
//  People
//
//  Created by Svetlana Brodskaya on 7/1/13.
//  Copyright (c) 2013 Svetlana Brodskaya. All rights reserved.
//

#import "TCSWelcomeViewController.h"

@interface TCSWelcomeViewController ()

@end

@implementation TCSWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor blueColor]];
    
    
    UILabel * loadProccessDesc = [[UILabel alloc] initWithFrame:CGRectMake(30.0,30.0, 250.0, 90.0)];
    
    
    loadProccessDesc.numberOfLines = 0;
    [loadProccessDesc setText:@"Welcome to Info People. "];
    
    [loadProccessDesc setTextColor:[UIColor whiteColor]];
    
    loadProccessDesc.font = [UIFont fontWithName:@"Chalkduster" size:32];
    
    [loadProccessDesc setTextAlignment:UITextAlignmentCenter];
    
    [loadProccessDesc setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:loadProccessDesc];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
