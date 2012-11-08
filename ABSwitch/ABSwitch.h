//
//  ABSwitch.h
//  test
//
//  Created by Alexander Blunck on 11/7/12.
//  Copyright (c) 2012 Ablfx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ABSwitchDelegate <NSObject>
@optional
-(void) abSwitch:(id)abSwitch DidChangeIndex:(NSInteger)currentIndex;
@end

@interface ABSwitch : UIView

-(id) initWithBackgroundImage:(UIImage*)bgImage switchImage:(UIImage*)switchImage shadowImage:(UIImage*)shadowImage;
-(id) initWithDefaultStyle;

/*
 Current selected Index (Either 0 or 1)
 */
@property (nonatomic, assign) NSInteger currentIndex;

/*
 Block that is called everytime index changes
 */
@property (nonatomic, assign) void (^block) (NSInteger currentIndex);

/*
 Delegate as alternative to using Blocks
 */
@property (nonatomic, strong) id <ABSwitchDelegate> delegate;

/*
 Text for both Indices
 */
@property (nonatomic, strong) NSString *leftText;
@property (nonatomic, strong) NSString *rightText;

/*
 Label Font
 */
@property (nonatomic, strong) UIFont *font;

/*
 If your background image uses rounded corners adjust this value to make the left/right color views fit with the background
 */
@property (nonatomic, assign) CGFloat cornerRadius;

/*
 Adjust vertical offset of switch image to make it fit with switch background
 */
@property (nonatomic, assign) CGFloat switchOffsetY;

/*
 Adjust horizontal offset of switch image to make it fit with the LEFT corner of the switch background
 */
@property (nonatomic, assign) CGFloat switchOffsetXLeft;

/*
 Adjust horizontal offset of switch image to make it fit with the RIGHT corner of the switch background
 */
@property (nonatomic, assign) CGFloat switchOffsetXRight;

/*
 Adjust inset of left / right Color View to make it fit into the switch background
 */
@property (nonatomic, assign) CGFloat colorViewInset;

/*
 Adjust
 */
@property (nonatomic, assign) CGPoint backgroundShadowOffset;

/*
 Set Colors for both Indices
 */
@property (nonatomic, strong) UIColor *leftColor;
@property (nonatomic, strong) UIColor *rightColor;

/*
 Show shadow below switch
 */
@property (nonatomic, assign) BOOL showShadow;

@end
