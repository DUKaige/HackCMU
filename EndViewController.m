
//
//  EndViewController.m
//  HackCMU
//
//  Created by Kaige Liu on 9/16/16.
//  Copyright © 2016 Dustin Liu. All rights reserved.
//

#import "EndViewController.h"

@interface EndViewController ()

@end

@implementation EndViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"scroll"]];
    [imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
