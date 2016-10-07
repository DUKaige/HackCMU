//
//  StartViewViewController.m
//  HackCMU
//
//  Created by Kaige Liu on 9/16/16.
//  Copyright © 2016 Dustin Liu. All rights reserved.
//

#import "StartViewViewController.h"

@interface StartViewViewController ()
@property (weak, nonatomic) IBOutlet UILabel *healthyLabel;
@property (weak, nonatomic) IBOutlet UILabel *virusCarrierLabel;
@property (weak, nonatomic) IBOutlet UILabel *zombiesLabels;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *congratsLabel;
@end

@implementation StartViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"scroll"]];
    [imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:imageView];
    [self.view bringSubviewToFront:_healthyLabel];
    [self.view bringSubviewToFront:_virusCarrierLabel];
    [self.view bringSubviewToFront:_zombiesLabels];
    [self.view bringSubviewToFront:_totalLabel];
    [self.view bringSubviewToFront:_congratsLabel];
    [self.healthyLabel setText:[NSString stringWithFormat:@"Healthy :                                          %lu",(unsigned long)_nb]];
    [self.virusCarrierLabel setText:[NSString stringWithFormat:@"Virus carriers:                                  %lu",(unsigned long)_nh]];
    [self.zombiesLabels setText:[NSString stringWithFormat:@"Zombies:                                          %lu",(unsigned long)_nl]];
    [_totalLabel setText:[NSString stringWithFormat:@"Coins you get in this round:           %lu",(unsigned long)3*_nb + _nh]];
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
