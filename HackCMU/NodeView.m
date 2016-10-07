//
//  NodeView.m
//  HackCMU
//
//  Created by Kaige Liu on 9/16/16.
//  Copyright © 2016 Dustin Liu. All rights reserved.
//

#import "NodeView.h"
@implementation NodeView
-(NodeView *)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if(!self) return nil;
    [[self layer] setCornerRadius:self.frame.size.width/2];
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 4;
    [self setClipsToBounds:YES];
    self.forground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.forground.backgroundColor = [UIColor clearColor];
    self.forground.alpha = 0.8;
    [self addSubview:self.forground];
    [self bringSubviewToFront:self.forground];
    return self;
}




#warning not implemented yet


-(void)setInsulatedLook
{
    UIImageView *thisImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wall"]];
    thisImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:thisImageView];
    [thisImageView setAlpha:0.8];
    
}
-(void)setVaccineLook
{
    UIImageView *thisImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vaccination"]];
    thisImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    thisImageView.alpha = 0.9;
    [self addSubview:thisImageView];

}
-(void)setCuredLook
{
    UIImageView *thisImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cure"]];
    thisImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:thisImageView];
    [self bringSubviewToFront:thisImageView];
    [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        thisImageView.alpha = 0;
    } completion:^(BOOL finished){}];

}

-(void)setForgroundColor:(UIColor *)color
{
    [self.forground setBackgroundColor:color];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
