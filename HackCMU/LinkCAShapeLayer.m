//
//  LinkCAShapeLayer.m
//  HackCMU
//
//  Created by Kaige Liu on 9/16/16.
//  Copyright © 2016 Dustin Liu. All rights reserved.
//

#import "LinkCAShapeLayer.h"

@implementation LinkCAShapeLayer
-(void)getInit:(CGPoint)point1 point2:(CGPoint)point2
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    self.path = [path CGPath];
    self.strokeColor = [[UIColor blackColor] CGColor];
    self.lineWidth = 3.0;
    self.fillColor = [[UIColor clearColor] CGColor];
}

@end
