//
//  MenuLayer.m
//  Circular Knob Demo
//
//  Created by LongND9 on 3/11/16.
//  Copyright © 2016 Cayuse Concepts. All rights reserved.
//

#import "MenuLayer.h"


@implementation MenuLayer

-(instancetype)initLayerWithImgPath:(NSString *)path degress:(float)degress turns:(float)turns index:(int)index {
    self = [super init];
    if (self) {
        self.degress = degress;
        self.turns = turns;
        self.contents = (id)([UIImage imageNamed:path].CGImage);
        self.arrPoint = [[NSMutableArray alloc]init];
        self.index = index;
    }
    return self;
}

-(void)updateIndexOfPosition{
    for (int i =0 ; i< [self.arrPoint count]; i++) {
        if (CGRectGetMinX(self.bounds)== [self.arrPoint[i] CGPointValue].x
            && CGRectGetMinY(self.bounds)== [self.arrPoint[i] CGPointValue].y) {
            self.indexOfPosition = i;
            return;
        }
    }
}

-(void)updateFrame:(CGRect)cgRect{
    self.bounds = cgRect;
    self.position = CGPointMake(CGRectGetMinX(cgRect), CGRectGetMinY(cgRect));
}



@end
