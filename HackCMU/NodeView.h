//
//  NodeView.h
//  HackCMU
//
//  Created by Kaige Liu on 9/16/16.
//  Copyright © 2016 Dustin Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
@class GameViewController;
@interface NodeView : UIButton
@property NSUInteger order;
@property float propagationProportion;
@property float infectedProb;
@property NSString *status;
@property NSString *statusToBeChangedTo;
@property BOOL vaccinated;
@property BOOL insulated;
@property BOOL insulationUsed;
@property BOOL vaccineUsed;
@property BOOL cureUsed;
@property NSMutableArray *links;
@property UIView *forground;

@property NSUInteger greyToGreenCountdown;
@property NSUInteger vaccinationCountdown;
@property NSUInteger insulationCountdown;
-(NodeView *)initWithFrame:(CGRect)rect;
-(void)setInsulatedLook;
-(void)setVaccineLook;
-(void)setCuredLook;
-(void)setForgroundColor:(UIColor *)color;
@end
