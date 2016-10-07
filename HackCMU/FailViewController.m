//
//  FailViewController.m
//  HackCMU
//
//  Created by Kaige Liu on 9/17/16.
//  Copyright © 2016 Dustin Liu. All rights reserved.
//

#import "FailViewController.h"

@implementation FailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"scroll"]];
    [imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:imageView];
}
@end
