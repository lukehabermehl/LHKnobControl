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
@property (nonatomic) BOOL isAnimating;

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
        _isAnimating = NO;
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
    
    return [self imageForImageNumber:imageNo];
}

- (UIImage *)imageForImageNumber:(NSUInteger)number
{
    CGRect cropRegion = CGRectMake(0.0, self.imageHeight * number, self.imageWidth, self.imageHeight);
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

- (void)setValue:(float)value animated:(BOOL)animated
{
    if (self.isAnimating)
        return;
    
    if (!animated || value == _value)
    {
        [self setValue:value];
        return;
    }
    
    _isAnimating = YES;
    
    value = clampf(value, self.minimumValue, self.maximumValue);
    
    NSMutableArray *images = [NSMutableArray new];
    float percentCurrent = (_value - _minimumValue) / (_maximumValue - _minimumValue);
    float percentTarget = (value - _minimumValue) / (_maximumValue - _minimumValue);
    NSUInteger imgNoCurrent = round(percentCurrent * (self.frameCount - 1));
    NSUInteger imgNoTarget = round(percentTarget * (self.frameCount - 1));
    
    if (value > _value)
    {
        for (NSUInteger imgNo = imgNoCurrent; imgNo < imgNoTarget; imgNo++)
        {
            [images addObject:[self imageForImageNumber:imgNo]];
        }
    }
    
    else
    {
        for (NSUInteger imgNo = imgNoCurrent; imgNo > imgNoTarget; imgNo--)
        {
            [images addObject:[self imageForImageNumber:imgNo]];
        }
    }
    
    _value = value;
    UIImageView *animationView = [[UIImageView alloc] initWithFrame:self.imageView.bounds];
    animationView.animationImages = images;
    animationView.animationDuration = 0.02 * images.count;
    animationView.animationRepeatCount = 1;
    [self addSubview:animationView];
    [animationView startAnimating];
    [self.imageView setImage:[self imageForValue:value]];
    
    __weak  LHKnobControl *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationView.animationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakSelf.isAnimating = NO;
    });
}

@end
