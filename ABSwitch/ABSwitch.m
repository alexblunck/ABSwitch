//
//  ABSwitch.m
//  test
//
//  Created by Alexander Blunck on 11/7/12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import "ABSwitch.h"
#import <QuartzCore/QuartzCore.h>

@interface ABSwitch () {
    UIImageView *backgroundView;
    UIImageView *backgroundShadowView;
    UIImageView *switchView;
    float oldTouchPointX;
    
    UIView *colorViewContainmentView;
    UIView *leftColorView;
    UIView *rightColorView;
    
    UITextField *leftLabel;
    UITextField *rightLabel;
}
@end

@implementation ABSwitch

-(id) initWithBackgroundImage:(UIImage*)bgImage switchImage:(UIImage*)switchImage shadowImage:(UIImage*)shadowImage
{
    self = [super init];
    if (self) {
        
        //Switch Background
        UIImage *backgroundViewImage = bgImage;
        backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backgroundViewImage.size.width, backgroundViewImage.size.height)];
        backgroundView.image = backgroundViewImage;
        backgroundView.layer.cornerRadius = self.cornerRadius;
        backgroundView.clipsToBounds = YES;
        backgroundView.userInteractionEnabled = YES;
        [self addSubview:backgroundView];
        
        //The Switch itself
        UIImage *switchViewImage = switchImage;
        switchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, switchViewImage.size.width, switchViewImage.size.height)];
        switchView.userInteractionEnabled = YES;
        switchView.image = switchViewImage;
        [backgroundView addSubview:switchView];
        
        if (self.showShadow) {
            switchView.layer.shadowColor = [[UIColor blackColor] CGColor];
            switchView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
            switchView.layer.shadowOpacity = 0.5f;
            switchView.layer.shadowRadius = 2.0f;
        }
        
        colorViewContainmentView = [[UIView alloc] initWithFrame:backgroundView.frame];
        colorViewContainmentView.layer.cornerRadius = self.cornerRadius;
        colorViewContainmentView.clipsToBounds = YES;
        [backgroundView insertSubview:colorViewContainmentView belowSubview:switchView];
        
        //Left Color
        leftColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, switchView.center.x, backgroundView.frame.size.height)];
        leftColorView.backgroundColor = self.leftColor;
        [colorViewContainmentView insertSubview:leftColorView belowSubview:switchView];
         
        //Right Color
        rightColorView = [[UIView alloc] initWithFrame:CGRectMake(switchView.center.x, 0, backgroundView.frame.size.width-switchView.center.x, backgroundView.frame.size.height)];
        rightColorView.backgroundColor = self.rightColor;
        [colorViewContainmentView insertSubview:rightColorView belowSubview:switchView];
        
        //Left Title Label
        leftLabel = [UITextField new];
        leftLabel.userInteractionEnabled = NO;
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        leftLabel.contentVerticalAlignment = NSTextAlignmentCenter;
        leftLabel.textColor = [UIColor colorWithWhite:0.892 alpha:1.000];
        leftLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        leftLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        leftLabel.layer.shadowOpacity = 1.0f;
        leftLabel.layer.shadowRadius = 0.0f;
        [switchView addSubview:leftLabel];
        
        //Right Title Label
        rightLabel = [UITextField new];
        rightLabel.userInteractionEnabled = NO;
        rightLabel.backgroundColor = [UIColor clearColor];
        rightLabel.textAlignment = NSTextAlignmentCenter;
        rightLabel.contentVerticalAlignment = NSTextAlignmentCenter;
        rightLabel.enabled = NO;
        rightLabel.textColor = [UIColor colorWithWhite:0.892 alpha:1.000];
        rightLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        rightLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        rightLabel.layer.shadowOpacity = 1.0f;
        rightLabel.layer.shadowRadius = 0.0f;
        [switchView addSubview:rightLabel];
        
        //Shadow View
        backgroundShadowView = [[UIImageView alloc] initWithImage:shadowImage];
        backgroundShadowView.frame = CGRectOffset(backgroundShadowView.frame, self.backgroundShadowOffset.x, self.backgroundShadowOffset.y);
        [backgroundView insertSubview:backgroundShadowView belowSubview:switchView];
        
        //Pan Gesture Recognizer
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handlePan:)];
        [switchView addGestureRecognizer:panGesture];
        
        //Set own frame to background view frame
        self.frame = backgroundView.frame;
        
        //Set Default Values
        self.currentIndex = 0;
        self.cornerRadius = 3.0f;
        self.switchOffsetY = 1.5f;
        self.switchOffsetXLeft = 1.5f;
        self.switchOffsetXRight = 2.5f;
        self.colorViewInset = 3.0f;
        self.backgroundShadowOffset = CGPointMake(1.0f, 1.5f);
        self.showShadow = YES;
        self.leftColor = [UIColor colorWithWhite:0.234 alpha:1.000];
        self.rightColor = [UIColor colorWithRed:0.308 green:0.598 blue:0.570 alpha:1.000];
        self.font = [UIFont fontWithName:@"" size:14.0f];
        self.leftText = @"OFF";
        self.rightText = @"ON";
        
    }
    return self;
}

-(id) initWithDefaultStyle {
    return [self initWithBackgroundImage:[UIImage imageNamed:@"ABSwitch-background.png"] switchImage:[UIImage imageNamed:@"ABSwitch-switch.png"] shadowImage:[UIImage imageNamed:@"ABSwitch-background-shadow.png"]];
}

-(id) init {
    return [self initWithDefaultStyle];
}

-(void)handlePan:(UIPanGestureRecognizer*)panGesture;
{
    //Handle Pan Gesture
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint center = switchView.center;
        CGPoint translation = [panGesture translationInView:switchView];
        center = CGPointMake(center.x + translation.x,
                             switchView.center.y);
        
        //If switchView is within bounds allow movement
        if (switchView.frame.origin.x >= 0 && switchView.frame.origin.x <= self.frame.size.width-switchView.frame.size.width) {
            switchView.center = center;
            [panGesture setTranslation:CGPointZero inView:switchView];
            
            //Update Left / Right Color
            leftColorView.frame = CGRectMake(leftColorView.frame.origin.x, leftColorView.frame.origin.y, switchView.center.x, leftColorView.frame.size.height);
            rightColorView.frame = CGRectMake(switchView.center.x, rightColorView.frame.origin.y, self.frame.size.width-switchView.frame.origin.x, rightColorView.frame.size.height);
            
        }
        
        //Keep switchView frame within bounds (panning it will cuase it to go 0.5 over/under bounds)
        if (switchView.frame.origin.x < 0) {
            switchView.frame = CGRectMake(0, switchView.frame.origin.y, switchView.frame.size.width, switchView.frame.size.height);
        }
        if (switchView.frame.origin.x > self.frame.size.width-switchView.frame.size.width) {
            switchView.frame = CGRectMake(self.frame.size.width-switchView.frame.size.width, switchView.frame.origin.y, switchView.frame.size.width, switchView.frame.size.height);
        }
        
    }
    
    //Catch Pan end
    else if (panGesture.state == UIGestureRecognizerStateEnded) {
        [self panEnd];
    }
}

-(void) animateSwitchRight
{
    [UIView animateWithDuration:0.2f animations:^{
        switchView.frame = CGRectMake(self.frame.size.width-switchView.frame.size.width-self.switchOffsetXRight, switchView.frame.origin.y, switchView.frame.size.width, switchView.frame.size.height);
        //Update Left / Right Color
        leftColorView.frame = CGRectMake(leftColorView.frame.origin.x, leftColorView.frame.origin.y, self.frame.size.width-(switchView.frame.size.width/2), leftColorView.frame.size.height);
        rightColorView.frame = CGRectMake(self.frame.size.width-(switchView.frame.size.width/2), rightColorView.frame.origin.y, self.frame.size.width-(switchView.frame.size.width/2), rightColorView.frame.size.height);
    }];
    //Update index
    self.currentIndex = 1;
    
    //Execute block if set
    if (self.block) {
        self.block(self.currentIndex);
    }
    
    //If delegate is set inform delegate of index change
    if (self.delegate && [self.delegate respondsToSelector:@selector(abSwitch:DidChangeIndex:)]) {
        [self.delegate abSwitch:self DidChangeIndex:self.currentIndex];
    }
}
-(void) animateSwitchLeft
{
    [UIView animateWithDuration:0.2f animations:^{
        switchView.frame = CGRectMake(0+self.switchOffsetXLeft, switchView.frame.origin.y, switchView.frame.size.width, switchView.frame.size.height);
        //Update Left / Right Color
        leftColorView.frame = CGRectMake(leftColorView.frame.origin.x, leftColorView.frame.origin.y, switchView.frame.size.width/2, leftColorView.frame.size.height);
        rightColorView.frame = CGRectMake(switchView.center.x, 0, self.frame.size.width-switchView.center.x, rightColorView.frame.size.height);
    }];
    //Update index
    self.currentIndex = 0;
    
    //Execute block if set
    if (self.block) {
        self.block(self.currentIndex);
    }
    
    //If delegate is set inform delegate of index change
    if (self.delegate && [self.delegate respondsToSelector:@selector(abSwitch:DidChangeIndex:)]) {
        [self.delegate abSwitch:self DidChangeIndex:self.currentIndex];
    }
}

//Called after pan ended
-(void) panEnd
{
    //If switchView is nearer to the left animate to the left
    if (switchView.center.x < self.frame.size.width/2) {
        [self animateSwitchLeft];
    }
    //If switchView is nearer to the right animate to the right
    else {
        [self animateSwitchRight];
    }
}

//Called on simple Tap
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Toggle oposit Side / Index
    if (self.currentIndex == 0) {
        [self animateSwitchRight];
    } else if (self.currentIndex == 1) {
        [self animateSwitchLeft];
    }
    
}

#pragma mark - Setters

-(void) setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    if (_currentIndex == 0) {
        switchView.frame = CGRectMake(0+self.switchOffsetXLeft, switchView.frame.origin.y, switchView.frame.size.width, switchView.frame.size.height);
        //Update Left / Right Color
        leftColorView.frame = CGRectMake(leftColorView.frame.origin.x, leftColorView.frame.origin.y, switchView.frame.size.width/2, leftColorView.frame.size.height);
        rightColorView.frame = CGRectMake(switchView.center.x, 0, self.frame.size.width-switchView.center.x, rightColorView.frame.size.height);
    } else if (_currentIndex == 1) {
        switchView.frame = CGRectMake(self.frame.size.width-switchView.frame.size.width-self.switchOffsetXRight, switchView.frame.origin.y, switchView.frame.size.width, switchView.frame.size.height);
        //Update Left / Right Color
        leftColorView.frame = CGRectMake(leftColorView.frame.origin.x, leftColorView.frame.origin.y, self.frame.size.width-(switchView.frame.size.width/2), leftColorView.frame.size.height);
        rightColorView.frame = CGRectMake(self.frame.size.width-(switchView.frame.size.width/2), rightColorView.frame.origin.y, self.frame.size.width-(switchView.frame.size.width/2), rightColorView.frame.size.height);
    }
}

-(void) setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    
    backgroundView.layer.cornerRadius = _cornerRadius;
    colorViewContainmentView.layer.cornerRadius = _cornerRadius;
}

-(void) setSwitchOffsetY:(CGFloat)switchOffsetY {
    _switchOffsetY = switchOffsetY;
    switchView.frame = CGRectOffset(switchView.frame, 0, _switchOffsetY);
}

-(void) setSwitchOffsetXLeft:(CGFloat)switchOffsetXLeft {
    _switchOffsetXLeft = switchOffsetXLeft;
    if (self.currentIndex == 0) {
        switchView.frame = CGRectOffset(switchView.frame, switchOffsetXLeft, 0);
    }
}

-(void) setSwitchOffsetXRight:(CGFloat)switchOffsetXRight {
    _switchOffsetXRight = switchOffsetXRight;
    if (self.currentIndex == 1) {
        switchView.frame = CGRectOffset(switchView.frame, -switchOffsetXRight, 0);
    }
}

-(void) setColorViewInset:(CGFloat)colorViewInset {
    _colorViewInset = colorViewInset;
    
    CGRect colorViewFrame = colorViewContainmentView.frame;
    colorViewFrame.origin.y += _colorViewInset/2;
    colorViewFrame.origin.x += _colorViewInset/2;
    colorViewFrame.size.height -= _colorViewInset;
    colorViewFrame.size.width -= (_colorViewInset+self.switchOffsetXRight-self.switchOffsetXLeft);
    colorViewContainmentView.frame = colorViewFrame;
}

-(void) setBackgroundShadowOffset:(CGPoint)backgroundShadowOffset {
    _backgroundShadowOffset = backgroundShadowOffset;
    backgroundShadowView.frame = CGRectOffset(backgroundShadowView.frame, backgroundShadowOffset.x, backgroundShadowOffset.y);
}

-(void) setShowShadow:(BOOL)showShadow {
    _showShadow = showShadow;
    if (self.showShadow) {
        switchView.layer.shadowColor = [[UIColor blackColor] CGColor];
        switchView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        switchView.layer.shadowOpacity = 0.5f;
        switchView.layer.shadowRadius = 2.0f;
    } else {
        switchView.layer.shadowOpacity = 0.0f;
    }
}

-(void) setLeftColor:(UIColor *)leftColor {
    _leftColor = leftColor;
    leftColorView.backgroundColor = _leftColor;
}

-(void) setRightColor:(UIColor *)rightColor {
    _rightColor = rightColor;
    rightColorView.backgroundColor = _rightColor;
}

-(void) setFont:(UIFont *)font {
    _font = font;
    leftLabel.font = _font;
    rightLabel.font = _font;
    [self setLeftText:self.leftText];
    [self setRightText:self.rightText];
}

-(void) setLeftText:(NSString *)leftText {
    _leftText = leftText;
    leftLabel.text = _leftText;
    [leftLabel sizeToFit];
    leftLabel.frame = CGRectMake(-leftLabel.frame.size.width-((switchView.frame.size.width-leftLabel.frame.size.width)/2), (switchView.frame.size.height-leftLabel.frame.size.height)/2, leftLabel.frame.size.width, leftLabel.frame.size.height);
}

-(void) setRightText:(NSString *)rightText {
    _rightText = rightText;
    rightLabel.text = _rightText;
    [rightLabel sizeToFit];
    rightLabel.frame = CGRectMake(switchView.frame.size.width+((switchView.frame.size.width-rightLabel.frame.size.width)/2), (switchView.frame.size.height-rightLabel.frame.size.height)/2, rightLabel.frame.size.width, rightLabel.frame.size.height);
}

@end














