//
//  LHKnobControl.m
//
//  Created by Luke Habermehl on 3/30/16.
//
//

#import "LHKnobControl.h"

float clampf(float value, float min, float max)
{
    if (value < min)
        return min;
    
    if (value > max)
        return max;
    
    return value;
}

@interface LHKnobControl ()
{
    CGPoint _previousTouchPoint;
}


@property (nonatomic) UIImageView *imageView;

@end

@implementation LHKnobControl

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _value = 0.0;
        _minimumValue = 0.0;
        _maximumValue = 10.0;
        _frameCount = 31;
        _imageWidth = 64.0;
        _imageHeight = 64.0;
    }
    
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    _previousTouchPoint = [touch locationInView:self];
    
    return TRUE;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [touch locationInView:self];
    
    float delta = _previousTouchPoint.y - touchPoint.y;
    float valueDelta = (delta / self.bounds.size.height) * (_maximumValue - _minimumValue);
    
    _previousTouchPoint = touchPoint;
    
    _value += valueDelta;
    self.value = clampf(_value, _minimumValue, _maximumValue);
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)setValue:(float)value
{
    _value = value;
    self.imageView.image = [self imageForValue:_value];
    
}

- (UIImage *)imageForValue:(float)value
{
    if (!self.image)
    {
        return nil;
    }
    
    float percent = (_value - _minimumValue) / (_maximumValue - _minimumValue);
    int imageNo = round(percent * (self.frameCount - 1));
    
    CGRect cropRegion = CGRectMake(0.0, self.imageHeight * imageNo, self.imageWidth, self.imageHeight);
    CGImageRef subImage = CGImageCreateWithImageInRect(self.image.CGImage, cropRegion);
    UIImage *croppedImage = [UIImage imageWithCGImage:subImage];
    
    return croppedImage;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    
    if (!self.imageView.image)
        self.imageView.image = [self imageForValue:self.value];
    
}

- (void)refresh
{
    self.value = clampf(_value, _minimumValue, _maximumValue);
}

@end
