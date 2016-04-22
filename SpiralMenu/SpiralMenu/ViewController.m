//
//  ViewController.m
//  SpiralMenu
//
//  Created by LongND9 on 3/17/16.
//  Copyright © 2016 LongND9. All rights reserved.
//

#import "ViewController.h"
#import "MenuLayer.h"
#import "MenuControl.h"

@interface ViewController ()
{
    NSTimer *timer;
}
@property (strong, nonatomic) CAYSwirlGestureRecognizer *swirlGestureRecognizer;
@property (strong, nonatomic)NSArray *arrSize;
@property (strong, nonatomic)NSMutableArray *arrPosition;
//@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;


@end
#define P(x,y) CGPointMake(x, y)
@implementation ViewController

float bearing;
float bearingPre;
MenuControl *menuControl;
CGMutablePathRef pathToDraw;
BOOL reverse;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrSize = @[@20,@20,@27,@40,@56,@60,@80,@100,@100,@100];

}

-(void)viewDidLayoutSubviews {
//    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetToZero:)];
//    [self.tapGestureRecognizer setDelegate:self];
//    self.tapGestureRecognizer.numberOfTapsRequired = 2;
//    [self.controlsView addGestureRecognizer:self.tapGestureRecognizer];
//    [self.swirlGestureRecognizer requireGestureRecognizerToFail:self.tapGestureRecognizer];
    self.arrPosition = [[NSMutableArray alloc]init];
    
    CGPoint center = CGPointMake((self.knob.center.x -5), self.knob.center.y -8);
    CGSize size = CGSizeMake(440, 450);
    
    CATransform3D perspectiveTransform = CATransform3DIdentity;
    perspectiveTransform.m34 = -1/500.f;
    self.controlsView.layer.sublayerTransform = perspectiveTransform;
    
    menuControl = [[MenuControl alloc]initMenuWithSize:size pointCenter:center turns:2];
    pathToDraw = CGPathCreateMutable();
    
    //    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    //draw spiral
    [menuControl addOpenningSpiralOnPath:pathToDraw size:size pointCenter:center numberOfTurns:2 show:NO];
    
    MenuLayer *car = [[MenuLayer alloc]initLayerWithImgPath:@"ico-menu-building.png" degress:220 turns:1 index:0];
    MenuLayer *car1 = [[MenuLayer alloc]initLayerWithImgPath:@"ico-menu-car.png" degress:244 turns:1 index:1];
    MenuLayer *car2 = [[MenuLayer alloc]initLayerWithImgPath:@"ico-menu-note.png" degress:268 turns:1 index:2];
    MenuLayer *car3 = [[MenuLayer alloc]initLayerWithImgPath:@"ico-menu-eat.png" degress:294 turns:1 index:3];
    MenuLayer *car4 = [[MenuLayer alloc]initLayerWithImgPath:@"ico-menu-note.png" degress:332 turns:1 index:4];
    MenuLayer *car5 = [[MenuLayer alloc]initLayerWithImgPath:@"ico-menu-meeting.png" degress:8 turns:2 index:5];
    MenuLayer *car6 = [[MenuLayer alloc]initLayerWithImgPath:@"ico-train-train.png" degress:48 turns:2 index:6];
    MenuLayer *car7 = [[MenuLayer alloc]initLayerWithImgPath:@"ico-menu-other-1.png" degress:94 turns:2  index:7];
    MenuLayer *car8 = [[MenuLayer alloc]initLayerWithImgPath:@"ico-menu-training.png" degress:142 turns:2 index:8];
    MenuLayer *car9 = [[MenuLayer alloc]initLayerWithImgPath:@"ico-menu-walking.png" degress:182 turns:2 index:9];
    
    CGPoint position = [menuControl positionMenu:car];
    CGPoint position1 = [menuControl positionMenu:car1];
    CGPoint position2 = [menuControl positionMenu:car2];
    CGPoint position3 = [menuControl positionMenu:car3];
    CGPoint position4 = [menuControl positionMenu:car4];
    CGPoint position5 = [menuControl positionMenu:car5];
    CGPoint position6 = [menuControl positionMenu:car6];
    CGPoint position7 = [menuControl positionMenu:car7];
    CGPoint position8 = [menuControl positionMenu:car8];
    CGPoint position9 = [menuControl positionMenu:car9];
    
    [self.arrPosition addObject:[NSValue valueWithCGPoint:position]];
    [self.arrPosition addObject:[NSValue valueWithCGPoint:position1]];
    [self.arrPosition addObject:[NSValue valueWithCGPoint:position2]];
    [self.arrPosition addObject:[NSValue valueWithCGPoint:position3]];
    [self.arrPosition addObject:[NSValue valueWithCGPoint:position4]];
    [self.arrPosition addObject:[NSValue valueWithCGPoint:position5]];
    [self.arrPosition addObject:[NSValue valueWithCGPoint:position6]];
    [self.arrPosition addObject:[NSValue valueWithCGPoint:position7]];
    [self.arrPosition addObject:[NSValue valueWithCGPoint:position8]];
    [self.arrPosition addObject:[NSValue valueWithCGPoint:position9]];
    
    CGRect grect =  CGRectMake(position.x, position.y, 20.0, 20.0);
    CGRect grect1 =  CGRectMake(position1.x , position1.y, 20.0, 20.0);
    CGRect grect2 =  CGRectMake(position2.x , position2.y, 27.0, 27.0);
    CGRect grect3 =  CGRectMake(position3.x , position3.y, 40.0, 40.0);
    CGRect grect4 =  CGRectMake(position4.x , position4.y, 56.0, 56.0);
    CGRect grect5 =  CGRectMake(position5.x , position5.y, 60.0, 60.0);
    CGRect grect6 =  CGRectMake(position6.x , position6.y, 80.0, 80.0);
    CGRect grect7 =  CGRectMake(position7.x , position7.y, 100.0, 100.0);
    CGRect grect8 =  CGRectMake(position8.x , position8.y, 100.0, 100.0);
    CGRect grect9 =  CGRectMake(position9.x , position9.y, 100.0, 100.0);
    
    [car updateFrame:grect];
    [car1 updateFrame:grect1];
    [car2 updateFrame:grect2];
    [car3 updateFrame:grect3];
    [car4 updateFrame:grect4];
    [car5 updateFrame:grect5];
    [car6 updateFrame:grect6];
    [car7 updateFrame:grect7];
    [car8 updateFrame:grect8];
    [car9 updateFrame:grect9];
    
    [menuControl addCompunent:car];
    [menuControl addCompunent:car1];
    [menuControl addCompunent:car2];
    [menuControl addCompunent:car3];
    [menuControl addCompunent:car4];
    [menuControl addCompunent:car5];
    [menuControl addCompunent:car6];
    [menuControl addCompunent:car7];
    [menuControl addCompunent:car8];//aassa
    [menuControl addCompunent:car9];
    
    [car updateIndexOfPosition];
    [car1 updateIndexOfPosition];
    [car2 updateIndexOfPosition];
    [car3 updateIndexOfPosition];
    [car4 updateIndexOfPosition];
    [car5 updateIndexOfPosition];
    [car6 updateIndexOfPosition];
    [car7 updateIndexOfPosition];
    [car8 updateIndexOfPosition];
    [car9 updateIndexOfPosition];
    
    [self.controlsView.layer addSublayer:menuControl.spiral];
    [self.controlsView.layer addSublayer:car];
    [self.controlsView.layer addSublayer:car1];
    [self.controlsView.layer addSublayer:car2];
    [self.controlsView.layer addSublayer:car3];
    [self.controlsView.layer addSublayer:car4];
    [self.controlsView.layer addSublayer:car5];
    [self.controlsView.layer addSublayer:car6];
    [self.controlsView.layer addSublayer:car7];
    [self.controlsView.layer addSublayer:car8];
    [self.controlsView.layer addSublayer:car9];
    
    //        CAKeyframeAnimation *animate;
    //        CAKeyframeAnimation *animate1;
    //        CAKeyframeAnimation *animate2;
    //        [self frameAnimation:animate duration:5.0 withTrackPath:trackPath menu:car];
    //        [self frameAnimation:animate1 duration:4.0 withTrackPath:trackPath1 menu:car1];
    //        [self frameAnimation:animate2 duration:4.5 withTrackPath:trackPath2 menu:car2 ];
    self.swirlGestureRecognizer = [[CAYSwirlGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:) menuControl:menuControl viewDrag:self.viewDrag pointCenter:center];
    [self.swirlGestureRecognizer setDelegate:self];
    [self.controlsView addGestureRecognizer:self.swirlGestureRecognizer];
    //    [self.viewDrag addGestureRecognizer:self.swirlGestureRecognizer];wefqwfqwf
    
}

- (void)rotationAction:(id)sender {
    if([(CAYSwirlGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        return;
    }
    if (self.swirlGestureRecognizer.currentLayerState == LayerStatePickedUp) {
        return;
    }
    CGFloat direction = ((CAYSwirlGestureRecognizer*)sender).currentAngle - ((CAYSwirlGestureRecognizer*)sender).previousAngle;
//    CGFloat angle1 = (CAYSwirlGestureRecognizer*)sender).currentAngle ;
//     CGFloat angle2 = (CAYSwirlGestureRecognizer*)sender).currentAngle ;
    bearing += 180 * direction / M_PI;
//    NSLog(@"Degress : %f",bearing);
    
    CGAffineTransform knobTransform = self.knob.transform;
    CGAffineTransform newKnobTransform = CGAffineTransformRotate(knobTransform, direction);
    [self.knob setTransform:newKnobTransform];
    
    if (direction>0) {
        //        if (bearing > 345) {
        //            bearing = 0;
        //            bearingPre = 0;
        //        }
        //        if (bearing - bearingPre >= 5) {
        //            bearingPre = bearing;
        [menuControl changePositionOfMenuWithdirection:direction arraySize:self.arrSize arrayPosition:self.arrPosition];
        //        }
    } else if (direction < 0){
        //        if (bearing < 15) {
        //            bearing = 360;
        //            bearingPre = 360;
        //        }
        //        if (!reverse) {
        //            bearingPre = 360;
        //            reverse = YES;
        //        }
        //        if (bearingPre - bearing >= 5) {
        //            bearingPre = bearing;
        [menuControl changePositionOfMenuWithdirection:direction arraySize:self.arrSize arrayPosition:self.arrPosition];
        //        }
    }
    
}

- (void)resetToZero:(id)sender {
    [self animateRotationToBearing:0];
}

- (void)animateRotationToBearing:(int)direction {
    
    bearing = direction;
    
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(180 * direction / M_PI);
    [UIImageView beginAnimations:nil context:nil];
    [UIImageView setAnimationDelegate:self];
    [UIImageView setAnimationDuration:0.8f];
    [UIImageView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [self.knob setTransform:rotationTransform];
    [UIImageView commitAnimations];
    
    
}




//-(void)frameAnimation:(CAKeyframeAnimation*)animate duration:(float)duration withTrackPath:(UIBezierPath*)trackPath menu:(MenuLayer*)menu{
//    animate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    animate.path = trackPath.CGPath;
//    animate.rotationMode = kCAAnimationRotateAuto;
//    animate.repeatCount = HUGE_VALF;
//    animate.duration = duration;
//    [menu addAnimation:animate forKey:@"race"];
//}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end