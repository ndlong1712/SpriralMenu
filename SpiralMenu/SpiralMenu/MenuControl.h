//
//  MenuControl.h
//  Circular Knob Demo
//
//  Created by LongND9 on 3/11/16.
//  Copyright © 2016 Cayuse Concepts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuLayer.h"

@interface MenuControl : NSObject

@property(strong , nonatomic)NSMutableArray *menuCompunent;
@property(strong , nonatomic)NSMutableArray *arrPointOfspiral;
@property(strong , nonatomic) CAShapeLayer* spiral;
@property(nonatomic)CGSize size;
@property(nonatomic)CGPoint pointCenter;
@property(nonatomic)float turns;

-(instancetype)initMenuWithSize:(CGSize)size pointCenter:(CGPoint)center turns:(float)turns;
-(CGPoint)positionMenu:(MenuLayer*)menu;
-(void)addOpenningSpiralOnPath:(CGMutablePathRef)path
                          size:(CGSize)size
                   pointCenter:(CGPoint)pointCenter
                 numberOfTurns: (int)turns
                          show:(BOOL)show;

-(void)addCompunent:(CALayer*)menuLayer;
-(void)drawSpiralWithPath:(CGMutablePathRef)path lineWidth:(float)width position:(CGPoint)position color:(UIColor*)color;
-(void)changePositionOfMenuWithdirection:(float)direction arraySize:(NSArray*)arrSize arrayPosition:(NSMutableArray*)arrPosition;

@end
