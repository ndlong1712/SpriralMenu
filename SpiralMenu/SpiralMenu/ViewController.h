//
//  ViewController.h
//  SpiralMenu
//
//  Created by LongND9 on 3/17/16.
//  Copyright © 2016 LongND9. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CAYSwirlGestureRecognizer.h"

@interface ViewController : UIViewController<CAYSwirlGestureRecognizerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *controlsView;

@property (strong, nonatomic) IBOutlet UIImageView *knob;
@property (weak, nonatomic) IBOutlet UIView *viewDrag;


@end

