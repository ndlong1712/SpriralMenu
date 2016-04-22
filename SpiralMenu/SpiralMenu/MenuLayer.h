//
//  MenuLayer.h
//  Circular Knob Demo
//
//  Created by LongND9 on 3/11/16.
//  Copyright © 2016 Cayuse Concepts. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

@protocol MenuDelegate


@end

@interface MenuLayer : CALayer

@property (nonatomic) float degress;
@property (nonatomic) float turns;
@property(nonatomic) NSArray *arrPoint;
@property(nonatomic) int indexOfPosition;
@property(nonatomic) int index;
@property (weak , nonatomic) id<MenuDelegate> menuDelegate;

-(instancetype)initLayerWithImgPath:(NSString*)path degress:(float)degress turns:(float)turns index:(int)index ;
-(void)updateIndexOfPosition;
-(void)updateFrame:(CGRect)cgRect;

@end
