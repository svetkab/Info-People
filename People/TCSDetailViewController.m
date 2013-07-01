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
        self.emailLabel.text = [[self.detailItem valueForKey:@"email"] description];
        self.nameLabel.text = [[self.detailItem valueForKey:@"name"] description];
        
        UIImage * img = [self.detailItem valueForKey:@"image"] ;
        
        _imgv = [[UIImageView alloc] initWithImage:img];
        
        float delta = (self.view.frame.size.width/img.size.width)*0.65;
        
        [_imgv setFrame:CGRectMake(10.0, 10.0, img.size.width*delta, img.size.height*delta)];
   
        [self.view addSubview:_imgv];
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

- (void)viewDidUnload {
    [self setNameLabel:nil];
    [self setEmailLabel:nil];
    [super viewDidUnload];
}
- (void)adjustOrientation
{
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        [_imgv setFrame:CGRectMake(10.0, 10.0, _imgv.frame.size.width, _imgv.frame.size.height)];
    } else {
        [_imgv setFrame:CGRectMake(10.0, 10.0, _imgv.frame.size.width, _imgv.frame.size.height)];
    }
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self adjustOrientation];
}


- (void) viewDidAppear:(BOOL)animated
{
    [self adjustOrientation];
}
@end
