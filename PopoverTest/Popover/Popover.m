//
//  Popover.m
//  PopoverTest
//
//  Created by Yaniv Marshaly on 2/13/13.
//  Copyright (c) 2013 SketchHeroes LTD. All rights reserved.
//

#import "Popover.h"

static CGFloat kAnchorPoint = 4.5f;
static CGFloat kArrowFrameWidth = 11.0f;

typedef NS_ENUM(NSInteger, kPopoverMovingMode)
{
    kPopoverMovingModeNone = 0,
    kPopoverMovingModeLeft,
    kPopoverMovingModeRight,
    
};

@interface Popover ()

@property (strong,nonatomic) UIView * targetView;

@property (strong,nonatomic) UIView * containerView;

@property (nonatomic) kPopoverMovingMode moveMode;

@property (nonatomic) CGFloat positionIndicator;

@property (nonatomic) CGFloat stepValue;

@property (nonatomic) BOOL shouldMoveArrowOnly;

@property (nonatomic) CGRect arrowFrame;

@end



@implementation Popover

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.positionIndicator = floor((CGRectGetWidth(self.bounds) - 11) * 0.51724 + 0.5);

        self.moveMode = kPopoverMovingModeNone;
        
    }
    return self;
}
-(UILabel*)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont boldSystemFontOfSize:13];
        _textLabel.textAlignment = UITextAlignmentCenter;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        self.opaque = NO;
        
        
        [self addSubview:_textLabel];

    }
    return _textLabel;
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    CGFloat y = ((frame.size.height - 26) / 3)+9;
    
    if (frame.size.height < 38)
        y = 9;
    
    self.textLabel.frame = CGRectMake(0, y, frame.size.width, 26);
}
-(void)setMoveMode:(kPopoverMovingMode)moveMode
{
    _moveMode = moveMode;
    switch (moveMode) {
        case kPopoverMovingModeNone :
            
            if (self.positionIndicator > (CGRectGetMinX(self.bounds) + floor((CGRectGetWidth(self.bounds) - 11) * 0.51724 + 0.5))) {
                _moveMode = kPopoverMovingModeLeft;
                [self setMoveMode:self.moveMode];
                 self.shouldMoveArrowOnly = NO;
                return;
            }else if (self.positionIndicator < (CGRectGetMinX(self.bounds) + floor((CGRectGetWidth(self.bounds) - 11) * 0.51724 + 0.5))) {
                _moveMode = kPopoverMovingModeRight;
                [self setMoveMode:self.moveMode];
                 self.shouldMoveArrowOnly = NO;
                return;
            }
            
            self.positionIndicator = floor((CGRectGetWidth(self.bounds) - 11) * 0.51724 + 0.5);
    
            self.shouldMoveArrowOnly = NO;
            break;
        case kPopoverMovingModeRight:
        {
        
            if (CGRectGetMaxX(self.arrowFrame) < (CGRectGetWidth(self.bounds)-kAnchorPoint-1.5f)) {
                self.positionIndicator = CGRectGetMinX(self.arrowFrame)+1;
                self.shouldMoveArrowOnly = YES;
            }
        }
            break;
        case kPopoverMovingModeLeft:
        {
            if (CGRectGetMinX(self.arrowFrame) > kAnchorPoint) {
                self.positionIndicator = CGRectGetMinX(self.arrowFrame)-1;
              self.shouldMoveArrowOnly = YES;
            }
        }
            break;
       
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    // Drawing code
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* gradientColor = [UIColor colorWithRed: 0.267 green: 0.303 blue: 0.335 alpha: 1];
    UIColor* gradientColor2 = [UIColor colorWithRed: 0.04 green: 0.04 blue: 0.04 alpha: 1];
    //// Color Declarations
    if (self.highlighted) {
        gradientColor = [UIColor colorWithRed: 0.421 green: 0.581 blue: 0.941 alpha: 1];
        gradientColor2 = [UIColor colorWithRed: 0.07 green: 0.150 blue: 0.770 alpha: 1];
    }
 
    UIColor* shadowColor2 = [UIColor colorWithRed: 0.524 green: 0.553 blue: 0.581 alpha: 0.3];
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)gradientColor.CGColor,
                               (id)gradientColor2.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    //// Shadow Declarations
    UIColor* innerShadow = shadowColor2;
    CGSize innerShadowOffset = CGSizeMake(0, 1.5);
    CGFloat innerShadowBlurRadius = 0.5;
    
    //// Frames
    CGRect frame = self.bounds;

    //// Subframes
    CGRect frame2 = CGRectZero;
    switch (self.moveMode) {
        case kPopoverMovingModeNone:
            frame2 = CGRectMake(CGRectGetMinX(frame) + floor((CGRectGetWidth(frame) - 11) * 0.51724 + 0.5),0, 11, 9);
            break;
        case kPopoverMovingModeRight:
        case kPopoverMovingModeLeft:
            //NSLog(@"%f",CGRectGetMinX(frame) + floor((CGRectGetWidth(frame) - (11+self.positionIndicator)) * 0.51724 + 0.5));
            frame2 = CGRectMake(self.positionIndicator, 0, 11, 9);//CGRectMake(CGRectGetMinX(frame) + floor((CGRectGetWidth(frame) - (11)) * 0.51724 + 0.5),0, 11, 9);
        default:
            break;
    }
   
    self.arrowFrame = frame2;
    
    //CGRectGetMinY(frame) + CGRectGetHeight(frame) - 9
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    



    [bezierPath moveToPoint:CGPointMake(CGRectGetMaxX(frame)-0.5, CGRectGetMaxY(frame)-kAnchorPoint)];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(frame)-0.5, CGRectGetMinY(frame)+CGRectGetHeight(frame2)+kAnchorPoint)];
    
   /* NSLog(@"From %@",NSStringFromCGPoint(CGPointMake(CGRectGetMaxX(frame)-0.5, CGRectGetMinY(frame)+CGRectGetHeight(frame2)+kAnchorPoint)));
    
    NSLog(@"TO %@",NSStringFromCGPoint(CGPointMake(CGRectGetMaxX(frame)-kAnchorPoint, CGRectGetMinY(frame)+CGRectGetHeight(frame2)+1.5)));
    

 
    NSLog(@"POINT 1 %@",NSStringFromCGPoint(CGPointMake(CGRectGetMaxX(frame)-0.5, CGRectGetMinY(frame)+CGRectGetHeight(frame2)+2.21)));
    NSLog(@"POINT 2 %@",NSStringFromCGPoint(CGPointMake(CGRectGetMaxX(frame) - 2.29, CGRectGetMinY(frame)+CGRectGetHeight(frame2)+1.5)));*/

    //right corner
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMaxX(frame)-kAnchorPoint, CGRectGetMinY(frame)+CGRectGetHeight(frame2)+1.5) controlPoint1:CGPointMake(CGRectGetMaxX(frame)-0.5, CGRectGetMinY(frame)+CGRectGetHeight(frame2)+2.21) controlPoint2:CGPointMake(CGRectGetMaxX(frame) - 2.29, CGRectGetMinY(frame)+CGRectGetHeight(frame2)+1.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame2) + 10.64, CGRectGetMaxY(frame2) + 1.5)];
    
    //Arrow Lines Drawing
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMidX(frame2), 0.5)];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame2) + 0.36,  CGRectGetMaxY(frame2) + 1.5)];
    
    
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(frame) + kAnchorPoint, CGRectGetMaxY(frame2) + 1.5)];

    //left corner
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMaxY(frame2) + kAnchorPoint) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 2.79, CGRectGetMaxY(frame2) + 1.5) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 0.5,  CGRectGetMaxY(frame2) + 2.21)];

    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMaxY(frame)-kAnchorPoint)];
    
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMinX(frame) + kAnchorPoint, CGRectGetMaxY(frame)-0.5) controlPoint1:CGPointMake(CGRectGetMinX(frame) + 0.5, CGRectGetMaxY(frame)-2.79) controlPoint2:CGPointMake(CGRectGetMinX(frame) + 2.21, CGRectGetMaxY(frame)-0.5)];
    
    /*NSLog(@"From %@",NSStringFromCGPoint(CGPointMake(CGRectGetMaxX(frame)-kAnchorPoint, CGRectGetMaxY(frame)-0.5)));
    
    NSLog(@"TO %@",NSStringFromCGPoint(CGPointMake(CGRectGetMaxX(frame)-0.5, CGRectGetMaxY(frame)-kAnchorPoint)));
    
    NSLog(@"POINT 1 %@",NSStringFromCGPoint(CGPointMake(CGRectGetMaxX(frame)-2.29, CGRectGetMaxY(frame)-2.21)));
    
    NSLog(@"POINT 2 %@",NSStringFromCGPoint(CGPointMake(CGRectGetMaxX(frame)-kAnchorPoint, CGRectGetMaxY(frame)-0.5)));*/
    
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(frame)-kAnchorPoint, CGRectGetMaxY(frame)-0.5)];
    
    [bezierPath addCurveToPoint:CGPointMake(CGRectGetMaxX(frame)-0.5, CGRectGetMaxY(frame)-kAnchorPoint) controlPoint1:CGPointMake(CGRectGetMaxX(frame)-0.5, CGRectGetMaxY(frame)-2.29) controlPoint2:CGPointMake(CGRectGetMaxX(frame)-2.21, CGRectGetMaxY(frame)-2.29)];
  
    [bezierPath closePath];
    CGContextSaveGState(context);
    [bezierPath addClip];
    CGRect bezierBounds = bezierPath.bounds;
    
    CGContextDrawLinearGradient(context, gradient,
                                CGPointMake(CGRectGetMidX(bezierBounds), CGRectGetMinY(bezierBounds)),
                                CGPointMake(CGRectGetMidX(bezierBounds), CGRectGetMaxY(bezierBounds)),
                                0);
    CGContextRestoreGState(context);
    
    ////// Bezier Inner Shadow
    CGRect bezierBorderRect = CGRectInset([bezierPath bounds], -innerShadowBlurRadius, -innerShadowBlurRadius);
    bezierBorderRect = CGRectOffset(bezierBorderRect, -innerShadowOffset.width, -innerShadowOffset.height);
    bezierBorderRect = CGRectInset(CGRectUnion(bezierBorderRect, [bezierPath bounds]), -1, -1);
    
    UIBezierPath* bezierNegativePath = [UIBezierPath bezierPathWithRect: bezierBorderRect];
    [bezierNegativePath appendPath: bezierPath];
    bezierNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = innerShadowOffset.width + round(bezierBorderRect.size.width);
        CGFloat yOffset = innerShadowOffset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    innerShadowBlurRadius,
                                    innerShadow.CGColor);
        
        [bezierPath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(bezierBorderRect.size.width), 0);
        [bezierNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [bezierNegativePath fill];
    }
    CGContextRestoreGState(context);
    
    [[UIColor blackColor] setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];
    
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
#pragma mark Public Methods
- (void)presentPointingAtView:(UIView *)targetView inView:(UIView *)containerView animated:(BOOL)animated
{
    [containerView addSubview:self];
    self.containerView = containerView;
    self.targetView = targetView;
    self.stepValue = CGRectGetWidth(self.bounds)/CGRectGetWidth(self.targetView.bounds);
       self.frame = CGRectMake(CGRectGetWidth(targetView.frame)/2 - CGRectGetWidth(self.frame), CGRectGetMaxY(targetView.frame) , CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self setNeedsDisplay];
}
#pragma mark Touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = YES;
    dispatch_async(dispatch_get_main_queue(),^{
        [self setNeedsDisplayInRect:self.bounds];
    });
  
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint center = [touch locationInView:self.targetView];
    if(self.targetView)
    {

        if((center.x + CGRectGetMidX(self.bounds)) > CGRectGetMaxX(self.targetView.bounds)){
            self.moveMode = kPopoverMovingModeRight;
        }else if(center.x < CGRectGetMidX(self.bounds)){
            self.moveMode = kPopoverMovingModeLeft;
        }else{
            self.moveMode = kPopoverMovingModeNone;
        }

        center.y = CGRectGetMaxY(self.targetView.frame)+CGRectGetHeight(self.frame)/2;
        
        if (!self.shouldMoveArrowOnly) {
           
                     self.center = center;
          
       
        }
        
        dispatch_async(dispatch_get_main_queue(),^{
            [self setNeedsDisplayInRect:self.bounds];
        });
    }
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    dispatch_async(dispatch_get_main_queue(),^{
        [self setNeedsDisplayInRect:self.bounds];
    });

}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    dispatch_async(dispatch_get_main_queue(),^{
        [self setNeedsDisplayInRect:self.bounds];
    });
}
@end
