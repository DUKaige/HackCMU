//
//  LinkCAShapeLayer.h
//  HackCMU
//
//  Created by Kaige Liu on 9/16/16.
//  Copyright © 2016 Dustin Liu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface LinkCAShapeLayer : CAShapeLayer
@property (retain) NSMutableArray *nodes;
-(void)getInit:(CGPoint)point1 point2:(CGPoint)point2;
@end
