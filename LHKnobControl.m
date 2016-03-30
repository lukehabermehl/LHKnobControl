//
//  LHKnobControl.m
//  AudioUnitV3Example
//
//  Created by Luke on 3/30/16.
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

@property (nonatomic) UIImageView *imageView;

@end

@implementation LHKnobControl

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.imageBaseName = @"knob";
        _value = 0.0;
        _minimumValue = 0.0;
        _maximumValue = 10.0;
        _frameCount = 30;
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

- (void)setImageBaseName:(NSString *)imageBaseName
{
    _imageBaseName = imageBaseName;
    [self refresh];
}

- (void)setMinimumValue:(float)minimumValue
{
    _minimumValue = minimumValue;
    [self refresh];
}

- (void)setMaximumValue:(float)maximumValue
{
    _maximumValue = maximumValue;
    [self refresh];
}

- (void)setFrameCount:(NSUInteger)frameCount
{
    _frameCount = frameCount;
    [self refresh];
}

- (UIImage *)imageForValue:(float)value
{
    float percent = (_value - _minimumValue) / (_maximumValue - _minimumValue);
    int imageNo = round(percent * (self.frameCount - 1));
    NSString *imageName = [NSString stringWithFormat:@"%@-%02d.png", self.imageBaseName, imageNo];
    
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
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
