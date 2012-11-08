//
//  ViewController.m
//  Example Project
//
//  Created by Alexander Blunck on 11/8/12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import "ViewController.h"
#import "ABSwitch.h"

@interface ViewController () <ABSwitchDelegate>
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithWhite:0.251 alpha:1.000];
    
    //Default Style
    ABSwitch *defaultSwitch = [[ABSwitch alloc] initWithDefaultStyle];
    defaultSwitch.center = self.view.center;
    defaultSwitch.frame = CGRectMake(defaultSwitch.frame.origin.x, 100, defaultSwitch.frame.size.width, defaultSwitch.frame.size.height);
    [defaultSwitch setBlock:^(NSInteger currentIndex) {
        NSLog(@"Default Switch changed Index: %i", currentIndex);
    }];
    [self.view addSubview:defaultSwitch];
    
    //Custom Style
    ABSwitch *customSwitch = [[ABSwitch alloc] initWithBackgroundImage:[UIImage imageNamed:@"custom-switch-background.png"] switchImage:[UIImage imageNamed:@"custom-switch.png"] shadowImage:nil];
    customSwitch.center = self.view.center;
    customSwitch.frame = CGRectMake(customSwitch.frame.origin.x, 200, customSwitch.frame.size.width, customSwitch.frame.size.height);
    customSwitch.leftText = @"";
    customSwitch.rightText = @"";
    customSwitch.leftColor = [UIColor clearColor];
    customSwitch.rightColor = [UIColor clearColor];
    customSwitch.switchOffsetY = -0.5f;
    customSwitch.switchOffsetXRight = 1.8f;
    customSwitch.delegate = self;
    [self.view addSubview:customSwitch];
    
}

#pragma mark - ABSwitchDelegate
-(void) abSwitch:(id)abSwitch DidChangeIndex:(NSInteger)currentIndex {
    NSLog(@"Switch Did Change Index: %i", currentIndex);
}

@end
