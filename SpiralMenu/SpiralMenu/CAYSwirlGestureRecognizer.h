//
//  CAYSwirlGestureRecognizer.h
//  Sense Of Direction
//
//  Created by Scott Erholm on 10/14/13.
//  Copyright (c) 2013 Cayuse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "MenuControl.h"
typedef NS_ENUM(NSInteger, LayerState){
    LayerStateResting,
    LayerStatePickedUp,
};

@protocol CAYSwirlGestureRecognizerDelegate <UIGestureRecognizerDelegate>

@end

@interface CAYSwirlGestureRecognizer : UIGestureRecognizer

@property CGFloat currentAngle;
@property CGFloat previousAngle;
@property (nonatomic, assign) LayerState currentLayerState;

-(instancetype)initWithTarget:(id)target action:(SEL)action menuControl:(MenuControl*)menuControl viewDrag:(UIView*)viewDrag pointCenter:(CGPoint)cgPoint;

@end
