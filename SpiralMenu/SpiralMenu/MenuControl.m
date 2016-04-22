//
//  MenuControl.m
//  Circular Knob Demo
//
//  Created by LongND9 on 3/11/16.
//  Copyright © 2016 Cayuse Concepts. All rights reserved.
// spiral http://stackoverflow.com/questions/18476778/spiral-path-animation-using-cgmutablepathref
//

#import "MenuControl.h"
#import "MenuLayer.h"

#define P(x,y) CGPointMake(x, y)
@implementation MenuControl
float x;
float y;
-(instancetype)initMenuWithSize:(CGSize)size pointCenter:(CGPoint)center turns:(float)turns {
    self = [super init];
    if (self) {
        self.size = size;
        self.pointCenter = center;
        self.turns = turns;
        self.menuCompunent = [[NSMutableArray alloc]init];
        self.spiral = [[CAShapeLayer alloc] init];
        self.arrPointOfspiral = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - spiral

/*
 return position of layer on spiral by
 degress: compare to coordinate angles
 atTurns: located on which turns
 size: size of spiral
 pointCenter: point center for openning spiral
 */
-(CGPoint)positionMenu:(MenuLayer*)menu {
    for (int turn = 1; turn <= self.turns; turn++) {
        CGSize largeSize = CGSizeMake(self.size.width * turn/self.turns, self.size.height * turn/self.turns);
        CGSize smallSize = CGSizeMake(self.size.width * (turn-1) / self.turns, self.size.height * (turn-1) / self.turns);
        CGFloat wStep = (largeSize.width/2 - smallSize.width/2 ) / 360;
        CGFloat hStep = (largeSize.height/2 - smallSize.height/2 ) / 360;
        for (CGFloat i = 0; i<=360; i = i + 2) {
            CGFloat iRad = i * M_PI / 180.0f;
            CGPoint p = CGPointMake(cosf(iRad) * (smallSize.width/2 + wStep * i),
                                    sinf(iRad) * (smallSize.height/2 + hStep * i));
            if (turn == menu.turns && menu.degress == i) {
                return CGPointMake(self.pointCenter.x + p.x, self.pointCenter.y + p.y);
            }
        }
    }
    return CGPointMake(self.pointCenter.x , self.pointCenter.y );
}

/*
 add point of spiral to arrayPoint
 path: pathRef for draw spiral
 draw: draw or not
 size: size of spiral
 pointCenter: point center for openning spiral
 */
-(void)addOpenningSpiralOnPath:(CGMutablePathRef)path
                          size:(CGSize)size
                   pointCenter:(CGPoint)pointCenter
                 numberOfTurns: (int)turns
                          show:(BOOL)show {
    BOOL addPath = NO;
    
    CGPathMoveToPoint(path, NULL, 0, 0);
    for (int turn = 1; turn <= turns; turn++) {
        CGSize largeSize = CGSizeMake(size.width * turn/turns, size.height * turn/turns);
        CGSize smallSize = CGSizeMake(size.width * (turn-1) / turns, size.height * (turn-1) / turns);
        CGFloat wStep = (largeSize.width/2 - smallSize.width/2 ) / 360;
        CGFloat hStep = (largeSize.height/2 - smallSize.height/2 ) / 360;
        
        for (CGFloat i = 0; i<=360; i = i + 2) {
            CGFloat iRad = i * M_PI / 180.0f ;
            CGPoint p = CGPointMake(cosf(iRad) * (smallSize.width/2 + wStep * i),
                                    sinf(iRad) * (smallSize.height/2 + hStep * i));
            if (i >= 210 && turn == 1) {
                addPath = YES;
            }
            if (turn == 2 && i > 184 ) {
                addPath = NO;
            }
            if (addPath) {
                [self.arrPointOfspiral addObject: [NSValue valueWithCGPoint:P(pointCenter.x + p.x, pointCenter.y  + p.y)]];
            }
            
            CGPathAddLineToPoint(path, nil, p.x, p.y);
        }
    }
    if (show) {
        [self drawSpiralWithPath:path lineWidth:1 position:pointCenter color:[UIColor blueColor]];
        
    }
    
}

/*
 point of spiral path from position certain to arrayPoint
 */
-(void)spiralOnPath:(UIBezierPath*)path
               size: (CGSize)size
        pointCenter:(CGPoint)pointCenter
      numberOfTurns: (int)turns
           arrPoint:(NSMutableArray*)arrPoint
    positionAddPath:(CGPoint)point {
    BOOL addPath = NO;
    [path moveToPoint:P(point.x, point.y)]; // ! don't deficient
    for (int turn = 1; turn <= turns; turn++) {
        CGSize largeSize = CGSizeMake(size.width * turn/turns, size.height * turn/turns);
        CGSize smallSize = CGSizeMake(size.width * (turn-1) / turns, size.height * (turn-1) / turns);
        CGFloat wStep = (largeSize.width/2 - smallSize.width/2 ) / 360;
        CGFloat hStep = (largeSize.height/2 - smallSize.height/2 ) / 360;
        for (CGFloat i = 0; i<=360; i = i + 2) {
            CGFloat iRad = i * M_PI / 180.0f;
            CGPoint p = CGPointMake(cosf(iRad) * (smallSize.width/2 + wStep * i),
                                    sinf(iRad) * (smallSize.height/2 + hStep * i));
            if (point.x == pointCenter.x+ p.x &&  point.y == p.y + pointCenter.y ) {
                addPath = YES;
            }
            if (addPath) {
                [arrPoint addObject: [NSValue valueWithCGPoint:P(pointCenter.x + p.x, pointCenter.y  + p.y)]];
                [path addCurveToPoint:P(pointCenter.x + p.x, pointCenter.y  + p.y)
                        controlPoint1:P(pointCenter.x  + p.x, pointCenter.y  + p.y)
                        controlPoint2:P(pointCenter.x  + p.x, pointCenter.y  + p.y)];
            }
        }
    }
}

//current point of item (x, y)

//rM = 4r0; tetaM = 90; alpha0 = 0; alphaM = 360
static float r0 = 10.0;
static float alpha0 = 30.0;
-(CGPoint) currentPointOfItem:(float) angle centerPoint:(CGPoint)point0 {
    float r = r0*(1 + 3*angle/360);
    float alpha = angle + (360-90)*angle*angle/(90*90);
    float x = point0.x + r*cosf(alpha);
    float y = point0.y + r*sinf(alpha);
    return CGPointMake(x, y);
}


-(void)drawSpiralWithPath:(CGMutablePathRef)path lineWidth:(float)width position:(CGPoint)position color:(UIColor *)color{
    self.spiral.path = path;
    self.spiral.position = position;
    self.spiral.fillColor = [UIColor clearColor].CGColor;
    self.spiral.strokeColor = color.CGColor;
    self.spiral.lineWidth = width;
}

#pragma mark- compunent

-(void)addCompunent:(MenuLayer*)menuLayer{
    [self.menuCompunent addObject:menuLayer];
    menuLayer.arrPoint = self.arrPointOfspiral;
    
}

-(void)changePositionOfMenuWithdirection:(float)direction arraySize:(NSArray*)arrSize arrayPosition:(NSMutableArray*)arrPosition{
    for (MenuLayer *menu in self.menuCompunent) {
        if (menu.indexOfPosition < 0){
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue
                             forKey:kCATransactionDisableActions];
            menu.position = [[menu.arrPoint objectAtIndex:menu.arrPoint.count -1] CGPointValue];
            menu.indexOfPosition = (int) menu.arrPoint.count -1;
            [CATransaction commit];
            
        } else if (menu.indexOfPosition >= menu.arrPoint.count){
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue
                             forKey:kCATransactionDisableActions];
            menu.position = [[menu.arrPoint objectAtIndex:0] CGPointValue];
            menu.indexOfPosition = 0;
            [CATransaction commit];
            
        } else{
            for (int i = 0; i< arrPosition.count; i++) {
                BOOL identical =  CGPointEqualToPoint([arrPosition[i] CGPointValue], menu.position);
                if (identical) {
                    NSNumber *newSize = [arrSize objectAtIndex:i];
                    CGPoint point = [menu.arrPoint[menu.indexOfPosition] CGPointValue];
                    menu.frame = CGRectMake(point.x, point.y, [newSize floatValue], [newSize floatValue]);
                    menu.index = i;
                        break;
                }
            }
            [CATransaction begin];
            [CATransaction setAnimationDuration: 0.01];
            [CATransaction setDisableActions: TRUE];
            //            NSLog(@"posit old: X: %f Y:%f",menu.position.x,menu.position.y);
            menu.position = [menu.arrPoint[menu.indexOfPosition] CGPointValue];
            [CATransaction commit];
            
        }
        if (direction > 0) {
            menu.indexOfPosition++;
            
        }else if(direction < 0){
            menu.indexOfPosition--;
        }
       
      
        }
    
}

@end
