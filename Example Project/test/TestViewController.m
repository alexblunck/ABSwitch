//
//  TestViewController.m
//  test
//
//  Created by Alexander Blunck on 11/7/12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import "TestViewController.h"
#import "ABSwitch.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithWhite:0.369 alpha:1.000];
    
    ABSwitch *mySwitch = [[ABSwitch alloc] initWithDefaultStyle];
    mySwitch.frame = CGRectMake((self.view.frame.size.width-mySwitch.frame.size.width)/2, (self.view.frame.size.height-mySwitch.frame.size.height)/2, mySwitch.frame.size.width, mySwitch.frame.size.height);
    mySwitch.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:14.0f];
    mySwitch.currentIndex = 1;
    
    [self.view addSubview:mySwitch];
    
}

@end
