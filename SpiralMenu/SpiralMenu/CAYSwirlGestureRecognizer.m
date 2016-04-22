//
//  CAYSwirlGestureRecognizer.m
//  Sense Of Direction
//
//  Created by Scott Erholm on 10/14/13.
//  Copyright (c) 2013 Cayuse. All rights reserved.
//

#import "CAYSwirlGestureRecognizer.h"
#import "MenuLayer.h"
#import "MenuControl.h"
#import "ViewController.h"



@interface CAYSwirlGestureRecognizer ()

@property (strong, nonatomic) id target;
@property (nonatomic) SEL action;
@property (strong, nonatomic) MenuControl *menuControl;
@property (nonatomic, assign) CGPoint oldPoint;
@property (strong, nonatomic) MenuLayer *menuLayerPicked;
@property (strong, nonatomic) UIView *viewDrag;
@property ( nonatomic) CGPoint pointCenter;
@property ( nonatomic) float startAngle;

@end

@implementation CAYSwirlGestureRecognizer


- (id)initWithTarget:(id)target action:(SEL)action menuControl:(MenuControl *)menuControl viewDrag:(UIView*)viewDrag pointCenter:(CGPoint)cgPoint{
    self = [super init];
    if (self) {
        self.target = target;
        self.action = action;
        self.menuControl = menuControl;
        self.currentLayerState = LayerStateResting;
        self.viewDrag = viewDrag;
        self.pointCenter = cgPoint;
    }
    return self;
}


- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[touches anyObject] locationInView:self.view];
//    NSLog(@"localtion:%@",NSStringFromCGPoint(location));
    float x1 = location.x - self.pointCenter.x;
    float y1 = location.y - self.pointCenter.y;
    NSLog(@"x: %f y: %f",x1,y1);
    
   float angle = [self degressWithPointCenter:self.pointCenter location:location];
    self.startAngle = angle;
    self.oldPoint = location;
    for (MenuLayer *menu in self.menuControl.menuCompunent) {
        if(CGRectContainsPoint(menu.frame, location)){
            self.currentLayerState = LayerStatePickedUp;
            self.menuLayerPicked = menu;
            [CATransaction begin];
            [CATransaction setAnimationDuration:.5f];
            [CATransaction setCompletionBlock:^{
                menu.zPosition = 40.f;
                menu.transform = CATransform3DRotate(menu.transform, .1, 0.f, 1.f,0.f);
            }];
            
            [CATransaction commit];
            return;
        }
    }
    self.currentLayerState = LayerStateResting;
    if (touches.count > 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint location = [[touches anyObject] locationInView:self.view];
    if(self.currentLayerState == LayerStatePickedUp){
        [CATransaction begin];
        [CATransaction setAnimationDuration:0.f];
        self.menuLayerPicked.position =  CGPointMake(self.menuLayerPicked.position.x + (location.x - self.oldPoint.x), self.menuLayerPicked.position.y + (location.y - self.oldPoint.y));
        [CATransaction commit];
        self.oldPoint = location;
    }
    
    self.currentAngle = [self getTouchAngle:[touch locationInView:touch.view]];
    self.previousAngle = [self getTouchAngle:[touch previousLocationInView:touch.view]];

//    CGPoint prevPoint = [touch previousLocationInView:touch.view];
    CGPoint currPoint = [touch locationInView:touch.view];
    float angle = [self degressWithPointCenter:self.pointCenter location:currPoint];
    NSLog(@"angle start : %f",self.startAngle * 180/ M_PI);
    NSLog(@"angle current : %f",angle * 180/ M_PI);
    NSLog(@"angle : %f",(angle * 180/ M_PI) - (self.startAngle * 180/ M_PI));
   
    if ([self.target respondsToSelector:self.action]) {
        [self.target performSelector:self.action withObject:self];
        
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
     CGPoint location = [[touches anyObject] locationInView:self.view];
    float angle = [self degressWithPointCenter:self.pointCenter location:location];
//    NSLog(@"End %f",angle);
    if(self.currentLayerState == LayerStatePickedUp){
        BOOL drag = [self dragIconToView:self.viewDrag location:location];
        if (drag) {
            self.viewDrag.alpha = 1.0;
        }else{
        }
        [CATransaction begin];
        [CATransaction setAnimationDuration:.5f];
        [CATransaction setCompletionBlock:^{
            self.menuLayerPicked.zPosition = 0.f;
            self.menuLayerPicked.transform = CATransform3DIdentity;
        }];
        NSValue *pointCenter = [self.menuLayerPicked.arrPoint objectAtIndex:self.menuLayerPicked.indexOfPosition];
        self.menuLayerPicked.position =  [pointCenter CGPointValue];
        [CATransaction commit];
    }
    [super touchesEnded:touches withEvent:event];
    [super setState:UIGestureRecognizerStateEnded];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self.view];
    for (MenuLayer *menu in self.menuControl.menuCompunent) {
        if(CGRectContainsPoint(menu.frame, location)){
//            NSLog(@"DEGRESS: %f",menu.degress);
            self.currentLayerState = LayerStatePickedUp;
            return;
        }
    }
    self.currentLayerState = LayerStateResting;
    [super touchesCancelled:touches withEvent:event];
    [super setState:UIGestureRecognizerStateCancelled];
}

-(float)degressWithPointCenter:(CGPoint)pointCenter location:(CGPoint)location{
//    float x1 = location.x - self.pointCenter.x;
//    float y1 = location.y - self.pointCenter.y;
    
//    NSLog(@"x: %f y: %f",x1,y1);
//    NSLog(@"Deg began: %f",atanf(y1/x1));
    return atan2f( location.y - pointCenter.y , location.x - pointCenter.x);;
}

-(BOOL)dragIconToView:(UIView*)view location:(CGPoint)location{
    if(CGRectContainsPoint(view.layer.frame, location)){
        return YES;
    }
    return NO;
}

- (float)getTouchAngle:(CGPoint)touch {
    
    // Translate into cartesian space with origin at the center of a 320-pixel square
    float x = touch.x - 160;
    float y = -(touch.y - 160);
    
    // Take care not to divide by zero!
    if (y == 0) {
        if (x > 0) {
            return M_PI_2;
        }
        else {
            return 3 * M_PI_2;
        }
    }
    
    float arctan = atanf(x/y);
    
    // Figure out which quadrant we're in
    
    // Quadrant I
    if ((x >= 0) && (y > 0)) {
        return arctan;
    }
    // Quadrant II
    else if ((x < 0) && (y > 0)) {
        return arctan + 2 * M_PI;
    }
    // Quadrant III
    else if ((x <= 0) && (y < 0)) {
        return arctan + M_PI;
    }
    // Quadrant IV
    else if ((x > 0) && (y < 0)) {
        return arctan + M_PI;
    }
    
    return -1;
}

@end
