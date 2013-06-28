//
//  TCSDetailViewController.m
//  People
//
//  Created by Svetlana Brodskaya on 6/28/13.
//  Copyright (c) 2013 Svetlana Brodskaya. All rights reserved.
//

#import "TCSDetailViewController.h"

@interface TCSDetailViewController ()
- (void)configureView;
@end

@implementation TCSDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"email"] description];
        
        UIImage * img = [self.detailItem valueForKey:@"image"] ;
        //
        UIImageView * imgv = [[UIImageView alloc] initWithImage:img];
        
        float delta = self.view.frame.size.width/img.size.width;
        
        [imgv setFrame:CGRectMake(0, 0, img.size.width*delta, img.size.height*delta)];
        
        
        [self.view addSubview:imgv];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
