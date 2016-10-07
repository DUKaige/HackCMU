//
//  GameViewController.h
//  HackCMU
//
//  Created by Kaige Liu on 9/16/16.
//  Copyright © 2016 Dustin Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NodeView.h"
#import "LinkCAShapeLayer.h"
@class NodeView;

@interface GameViewController : UIViewController
-(void)tapNodeWithOrder:(NSUInteger)order;
@end
