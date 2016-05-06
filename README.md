# LHKnobControl
## Custom Knob Control for iOS

This simple class allows you to easily create custom controls using an image containing frames for all of the possible states of your control.
(See my example file [here](http://files.lukehabermehl.com/docs/wp/knob.png)). I designed this class specifically to handle images created by the
[JKnobMan software](http://www.g200kg.com/en/software/knobman.html)

### How to set up an LHKnobControl instance

If you are using Interface Builder, drag a UIView into your parent view and assign its class to be LHKnobControl. Set its frame size to match
the dimensions of a single frame of your image file. Connect it to an IBOutlet as you normally would.

In the code, all you have to do is tell the LHKnobControl instance a little information about the image and the control value range. Here is an example:

  ```objective-c
  //In View Controller .m file
      
  @interface MyViewController ()
  
  @property (weak, nonatomic) IBOutlet LHKnobControl *knob;
      
  @end
      
  @implementation MyViewController
      
  - (void)viewDidLoad
  {
    [super viewDidLoad];
        
    UIImage *knobImage = [UIImage imageNamed:@"knob.png"];
    //You must assign this
    self.knob.image = knobImage;
    
    //These are all default values. Change them to fit your needs
    self.knob.frameCount = 31;
    self.knob.imageHeight = 64.0;
    self.knob.imageWidth = 64.0;
    self.knob.minimumValue = 0.0;
    self.knob.maximumValue = 10.0;
    self.knob.value = 0.0;
  }
      
  @end
  ```

To detect when the knob value is changed, you can connect an IBAction for 'value changed' from Interface Builder or programatically with:

  ```objective-c
  [knob addTarget:self action:@selector(knobValueChanged:) forControlEvents:UIControlEventValueChanged];
  ```

As for any UIControl, the selector it calls will receive one parameter, the LHKnobControl instance that sent the value changed event.

To finish my example:

  ```objective-c
  - (void)knobValueChanged:(LHKnobControl *)sender
  {
    NSLog(@"changed the knob value to: %f", sender.value);
  }
  ```
  