//
//  ViewController.m
//  PopoverTest
//
//  Created by Yaniv Marshaly on 2/13/13.
//  Copyright (c) 2013 SketchHeroes LTD. All rights reserved.
//

#import "ViewController.h"
#import "Popover.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *targetView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Popover * popover = [[Popover alloc]initWithFrame:CGRectMake(self.view.center.x, self.view.center.y
                                                                 , 100, 44)];
    popover.textLabel.text = @"Step 1";
    [popover addTarget:self action:@selector(didPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [popover presentPointingAtView:self.targetView inView:self.view animated:YES];
    
    popover = [[Popover alloc]initWithFrame:CGRectMake(self.view.center.x, self.view.center.y
                                                                 , 100, 44)];
    popover.textLabel.text = @"Step 2";
    [popover addTarget:self action:@selector(didPress:) forControlEvents:UIControlEventTouchUpInside];
    
    [popover presentPointingAtView:self.targetView inView:self.view animated:YES];


    //[self.view addSubview:popover];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)didPress:(id)sender
{
    NSLog(@"Pressing");
}
- (void)viewDidUnload {
    [self setTargetView:nil];
    [super viewDidUnload];
}
@end
