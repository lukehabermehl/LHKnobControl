//
//  LHKnobControl.h
//  AudioUnitV3Example
//
//  Created by Luke on 3/30/16.
//
//

#import <UIKit/UIKit.h>


/**
        LHKnobControl is a custom UIControl that provides knob functionality using a set of images representing how the knob should look at each value.
*/
@interface LHKnobControl : UIControl
{
    CGPoint _previousTouchPoint;
}

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic) float value;

/** The control will load images in the file format: "<imageBaseName>-<frameNumber>.png"
    
    For example, if imageBaseName is set to "knob" (default), the control would attempt to load the image for the first frame from "knob-00.png".
*/
@property (nonatomic) NSString *imageBaseName;

/** The number of frame images that exist for the control */
@property (nonatomic) NSUInteger frameCount;

@end
