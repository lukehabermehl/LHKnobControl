//
//  LHKnobControl.h
//
//  Created by Luke Habermehl on 3/30/16.
//
//

#import <UIKit/UIKit.h>


#import <UIKit/UIKit.h>


/**
 LHKnobControl is a custom UIControl that provides knob functionality using an image set representing how the knob should look at each value.
 */
@interface LHKnobControl : UIControl

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic) float value;

/** The width, in pixels, of each knob frame */
@property (nonatomic) CGFloat imageWidth;
/** The height, in pixels, of each knob frame */
@property (nonatomic) CGFloat imageHeight;

/** The image containing all of the frames for the knob */
@property (nonatomic) UIImage *image;

/** The number of frame images that exist for the control */
@property (nonatomic) NSUInteger frameCount;

- (void)refresh;

@end
