//
//  GameViewController.m
//  HackCMU
//
//  Created by Kaige Liu on 9/16/16.
//  Copyright © 2016 Dustin Liu. All rights reserved.
//

#import "GameViewController.h"
#import "StartViewViewController.h"
@interface GameViewController ()
@property float nodeRadius;


@property (retain) NSMutableArray *nodes;
@property (retain) NSMutableArray *links;
@property (retain) NSTimer *timerCountDown;
@property NSUInteger countDownNumber;
@property NSUInteger countUpNumber;
@property NSUInteger vaccinationDur;
@property NSUInteger insulationDur;
@property NSString *clickingCondition;//v for vaccine, i for insulation, c for cure, and n for normal.
@property float probOfTurnGreen;
@property float probOfCured;
@property float probOfPropOfH;
@property float probOfPropOfL;
@property NSUInteger numberOfVaccines;
@property NSUInteger numberOfInsulations;
@property NSUInteger numberOfCures;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;
@property (weak, nonatomic) IBOutlet UIButton *cureButton;
@property (weak, nonatomic) IBOutlet UIButton *vaccineButton;
@property (weak, nonatomic) IBOutlet UILabel *countUpLabel;
@property NSUInteger globalTime;
@property (weak, nonatomic) IBOutlet UIButton *insulationButton;
@property (retain) NSTimer *timerCountUp;
@property (retain) NSTimer *visibleClock;
@property NSUInteger greyToGreenCountdown;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCuresLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfVaccinesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfInsulationsLabel;
@property NSUInteger internalClockInterval;

@end
@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc ]initWithImage:[UIImage imageNamed:@"zombie"]];
    [imageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:imageView];
    [imageView setAlpha:0.3];
    [self.view sendSubviewToBack:imageView];
    [self setInitialVariables];
    
    [self produceNodesAndLinks];
    self.timerCountDown = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(countDown)
                                                         userInfo:nil
                                                          repeats:YES];
    self.countUpNumber = 0;
    self.countDownNumber = 3;
    [self.countUpLabel setText:@""];

    // Do any additional setup after loading the view.
}

-(void)setInitialVariables
{
    _nodeRadius = 20;
    _greyToGreenCountdown = 4;
    _vaccinationDur = 10;
    _insulationDur = 10;
    _probOfTurnGreen = 0.5;
    _probOfCured = 0.9;
    _probOfPropOfH = 0.15;
    _probOfPropOfL = 0.35;
    _internalClockInterval = 1;
    
    _numberOfVaccines = 7;
    _numberOfCures = 7;
    _numberOfInsulations = 7;
    [_numberOfCuresLabel setText:[NSString stringWithFormat:@"x%lu",(unsigned long)_numberOfCures]];
    [_numberOfVaccinesLabel setText:[NSString stringWithFormat:@"x%lu",(unsigned long)_numberOfVaccines]];
    [_numberOfInsulationsLabel setText:[NSString stringWithFormat:@"x%lu",(unsigned long)_numberOfInsulations]];
}
-(void)countDown
{
    if (_countDownNumber == 0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.countDownLabel.alpha = 0;}];
        self.timerCountUp = [NSTimer scheduledTimerWithTimeInterval:_internalClockInterval target:self selector:@selector(update) userInfo:nil repeats:YES];
        self.visibleClock = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVisibleClock) userInfo:nil repeats:YES];
        [self.timerCountDown invalidate];
    }
    else
    {
        [self.countDownLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)self.countDownNumber]];
        self.countDownNumber -= 1;


    }
}


-(void)update
{
    if (_globalTime == 30)
    {
        [self gameOver];
    }
    BOOL lose = YES;
    for (NSUInteger i = 0; i < [_nodes count];i += 1)
    {
        if (![[[_nodes objectAtIndex:i] status] isEqualToString:@"l"])
        {
            lose = NO;
            break;
        }
    }
    if (lose)
    {
        [self gameOver];
    }
    //check time
    _globalTime += 1;
    //check whether turn grey
    NSArray *oneOrZeroOfGrey = [self getArrayOfGrey];
    for (NSUInteger i = 0; i<[oneOrZeroOfGrey count]; i+=1)
    {
        NSUInteger index = [[oneOrZeroOfGrey objectAtIndex:i] integerValue];
        if([[[_nodes objectAtIndex:index] status] isEqualToString:@"b"])
        {
            if (![[_nodes objectAtIndex:index] vaccinated])
            {
                [[_nodes objectAtIndex:index] setStatus:@"h"];
                
                [[_nodes objectAtIndex:index] setForgroundColor:[UIColor grayColor]];
                [[_nodes objectAtIndex:index] setGreyToGreenCountdown:_greyToGreenCountdown];
            }
        }
    }
    
    
    //check whether turn green/turn no color
    for (NSUInteger i = 0; i < [_nodes count]; i+=1)
    {
        if ([[[_nodes objectAtIndex:i] status] isEqualToString:@"h"])
        {
            if ([[_nodes objectAtIndex:i] greyToGreenCountdown] == 0)
            {
                NSUInteger randomNumber = arc4random()%100;
                if (randomNumber <= 100*_probOfTurnGreen)
                {
                    [[_nodes objectAtIndex:i] setStatus:@"l"];
                    [[_nodes objectAtIndex:i] setForgroundColor:[UIColor greenColor]];
                }
                else
                {
                    [[_nodes objectAtIndex:i] setStatus:@"b"];
                    [[_nodes objectAtIndex:i] setForgroundColor:[UIColor clearColor]];

                }
            }
            else
            {
                [[_nodes objectAtIndex:i] setGreyToGreenCountdown:[[_nodes objectAtIndex:i] greyToGreenCountdown] - 1];
            }
        }
    }
    //check whether out of insulation
    for (NSUInteger i = 0; i < [_nodes count]; i+=1)
    {
        if ([[_nodes objectAtIndex:i] insulated])
        {
            if ([[_nodes objectAtIndex:i] insulationCountdown] == 0)
            {
                [[_nodes objectAtIndex:i] setInsulated:NO];
                [[[[_nodes objectAtIndex:i] subviews] objectAtIndex:0] removeFromSuperview];
            }
            else
            {
                [[_nodes objectAtIndex:i] setInsulationCountdown:[[_nodes objectAtIndex:i] insulationCountdown] - 1];
            }
        }

    }
    //check whether out of vaccination
    for (NSUInteger i = 0; i < [_nodes count]; i+=1)
    {
        if ([[_nodes objectAtIndex:i] vaccinated])
        {
            if ([[_nodes objectAtIndex:i] vaccinationCountdown] == 0)
            {
                [[_nodes objectAtIndex:i] setVaccinated:NO];
                [[[[_nodes objectAtIndex:i] subviews] objectAtIndex:0] removeFromSuperview];

            }
            else
            {
                [[_nodes objectAtIndex:i] setVaccinationCountdown:[[_nodes objectAtIndex:i] vaccinationCountdown] - 1];
            }
        }
    }
}

-(NSArray *)getArrayOfGrey
{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (NSUInteger i = 0; i< [_nodes count]; i+=1)
    {
        NodeView *tmp = [_nodes objectAtIndex:i];
        if (![tmp vaccinated] && [[tmp status] isEqualToString:@"b"])
        {
            NSUInteger nh = 0;
            NSUInteger nl = 0;
            for (LinkCAShapeLayer *thisLink in [tmp links])
            {
                NodeView *neighbor = [[thisLink nodes] objectAtIndex:1];
                if ([[[thisLink nodes] objectAtIndex:0] isEqual:tmp])
                {
                    neighbor = [[thisLink nodes] objectAtIndex:1];
                }
                else if ([[[thisLink nodes] objectAtIndex:1] isEqual:tmp])
                {
                    neighbor = [[thisLink nodes] objectAtIndex:0];
                }
                if ([[neighbor status] isEqualToString:@"h"])
                {
                    nh += 1;
                }
                else if ([[neighbor status] isEqualToString:@"l"])
                {
                    nl += 1;
                }
            }
            float prob = 1-powf(1-_probOfPropOfH, nh)*powf(1-_probOfPropOfL, nl);
            if (arc4random()%1000 < prob*1000)
            {
                [result addObject:[NSNumber numberWithInteger:i]];
            }
        }
    }
    return result;
}
/*
        }
        if (![tmp insulated])
        {
            if ([[tmp status] isEqualToString:@"h"])
            {
                NSMutableArray *choices = [[NSMutableArray alloc]init];
                for (NSUInteger j = 0; j< [[tmp links] count]; j+=1)
                {
                    LinkCAShapeLayer *thisLink =[[tmp links] objectAtIndex:j];
                    if ([[[thisLink nodes] objectAtIndex:0] isEqual:tmp])
                    {
                        [choices addObject:[NSNumber numberWithInteger:[[[thisLink nodes] objectAtIndex:1] order]]];
                    }
                    else if ([[[thisLink nodes] objectAtIndex:1] isEqual:tmp])
                    {
                        [choices addObject:[NSNumber numberWithInteger:[[[thisLink nodes] objectAtIndex:0] order]]];
                    }
                    else
                    {
                        NSLog(@"bugsbugsbugs");
                    }
                    
                }
                
                for (NSUInteger i = 0; i < [choices count];i += 1)
                {
                    if ( ![result containsObject:[choices objectAtIndex:i]])
                    {
                        if (arc4random()%100 < _probOfPropOfH*100)
                        {
                            [result addObject:[choices objectAtIndex:i]];
                        }
                    }
                }
            }
            else if ([[tmp status] isEqualToString:@"l"])
            {
                NSMutableArray *choices = [[NSMutableArray alloc]init];
                for (NSUInteger j = 0; j< [[tmp links] count]; j+=1)
                {
                    LinkCAShapeLayer *thisLink =[[tmp links] objectAtIndex:j];
                    if ([[[thisLink nodes] objectAtIndex:0] order] == [tmp order])
                    {
                        [choices addObject:[NSNumber numberWithInteger:[[[thisLink nodes] objectAtIndex:1] order]]];
                    }
                    else if ([[[thisLink nodes] objectAtIndex:1] order] == [tmp order])
                    {
                        [choices addObject:[NSNumber numberWithInteger:[[[thisLink nodes] objectAtIndex:0] order]]];
                    }
                    else
                    {
                        NSLog(@"bugsbugsbugs");
                    }
                    
                }
                
                NSArray *indexes = [self randomArrayWithMaxNumber:[choices count] lengthOfReturn:[choices count]*_probOfTurnGreen];
                for (NSUInteger i = 0; i < [choices count];i += 1)
                {
                    if ( ![result containsObject:[choices objectAtIndex:i]])
                    {
                        if (arc4random()%100 < _probOfPropOfL*100)
                        {
                            [result addObject:[choices objectAtIndex:i]];
                        }
                    }
                }
            }
*/
        



-(void)updateVisibleClock
{
    [self.countUpLabel setText:[NSString stringWithFormat:@"%lu/60",(unsigned long)self.countUpNumber]];
    _countUpNumber += 1;
}

-(void)gameOver
{
    if (_globalTime == 30)
    {
        [self performSegueWithIdentifier:@"winSegue" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"loseSegue" sender:self];

    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"winSegue"])
    {
        NSUInteger nb = 0;
        NSUInteger nh = 0;
        NSUInteger nl = 0;
        for (NSUInteger i = 0; i< [_nodes count];i += 1)
        {
            NodeView *thisNode = [_nodes objectAtIndex:i];
            NSLog(@"%@",[thisNode status]);
            if ([[thisNode status] isEqualToString:@"b"])
            {
                nb += 1;
            }
            
            if ([[thisNode status] isEqualToString:@"h"])
            {
                nh += 1;
            }
            
            if ([[thisNode status] isEqualToString:@"l"])
            {
                nl += 1;
            }
        }
        StartViewViewController *controller = segue.destinationViewController;
        controller.nl = nl;
        controller.nh = nh;
        controller.nb = nb;

    }
}


-(void)produceNodesAndLinks
{
#warning not finished yet(data not aquired)
//eachNodesInfo data struct:
//in each element:[x,y,"b"/"h"/"l"]
    
    self.nodes = [[NSMutableArray alloc]init];
    self.links = [[NSMutableArray alloc]init];
    NSMutableArray *eachLinkInfo = [[NSMutableArray alloc]init];
    

    NSMutableArray *eachNodeInfo =[[NSMutableArray alloc]initWithArray:[self positionsOfEachNodeOnScreen:30 width:self.view.frame.size.width height:self.view.frame.size.height dia:_nodeRadius*2]];
    /*
    [eachLinkInfo addObject:@[@0,@7]];
    [eachLinkInfo addObject:@[@0,@11]];
    [eachLinkInfo addObject:@[@1,@2]];
    [eachLinkInfo addObject:@[@1,@11]];
    [eachLinkInfo addObject:@[@2,@3]];
    [eachLinkInfo addObject:@[@3,@7]];
    [eachLinkInfo addObject:@[@3,@8]];
    [eachLinkInfo addObject:@[@3,@12]];
    [eachLinkInfo addObject:@[@3,@13]];
    [eachLinkInfo addObject:@[@3,@15]];
    [eachLinkInfo addObject:@[@4,@8]];
    [eachLinkInfo addObject:@[@4,@9]];
    [eachLinkInfo addObject:@[@4,@10]];
    [eachLinkInfo addObject:@[@4,@14]];
    [eachLinkInfo addObject:@[@5,@6]];
    [eachLinkInfo addObject:@[@5,@12]];
    [eachLinkInfo addObject:@[@6,@9]];
    [eachLinkInfo addObject:@[@8,@14]];
    [eachLinkInfo addObject:@[@13,@15]];
    [eachLinkInfo addObject:@[@6,@16]];
    [eachLinkInfo addObject:@[@12,@16]];
    [eachLinkInfo addObject:@[@14,@16]];
    [eachLinkInfo addObject:@[@13,@17]];
    [eachLinkInfo addObject:@[@15,@17]];
    [eachLinkInfo addObject:@[@1,@18]];
    [eachLinkInfo addObject:@[@8,@18]];
    [eachLinkInfo addObject:@[@4,@18]];
    [eachLinkInfo addObject:@[@11,@18]];
    [eachLinkInfo addObject:@[@12,@18]];
    [eachLinkInfo addObject:@[@10,@19]];
    [[eachNodeInfo objectAtIndex:0] setObject:@"h" atIndex:2];
    [[eachNodeInfo objectAtIndex:5] setObject:@"h" atIndex:2];
    [[eachNodeInfo objectAtIndex:14] setObject:@"h" atIndex:2];
/*


//in each element:[node1Order,node2Order]
    /* Only for testing
    NSMutableArray *eachNodeInfo = [[NSMutableArray alloc]init];

    [eachNodeInfo addObject:@[@100,@100,@"l"]];
    [eachNodeInfo addObject:@[@200,@100,@"b"]];
    [eachNodeInfo addObject:@[@300,@100,@"b"]];
    [eachNodeInfo addObject:@[@400,@100,@"b"]];
    [eachNodeInfo addObject:@[@500,@100,@"b"]];
    [eachNodeInfo addObject:@[@600,@100,@"b"]];
    [eachNodeInfo addObject:@[@700,@100,@"b"]];
    [eachNodeInfo addObject:@[@800,@100,@"b"]];
*/
    
    
    [eachLinkInfo addObject:@[@0,@7]];
    
    [eachLinkInfo addObject:@[@0,@11]];
    
    [eachLinkInfo addObject:@[@1,@2]];
    
    [eachLinkInfo addObject:@[@1,@11]];
    
    [eachLinkInfo addObject:@[@2,@3]];
    
    [eachLinkInfo addObject:@[@3,@7]];
    
    [eachLinkInfo addObject:@[@3,@8]];
    
    [eachLinkInfo addObject:@[@3,@12]];
    
    [eachLinkInfo addObject:@[@3,@13]];
    
    [eachLinkInfo addObject:@[@3,@15]];
    
    [eachLinkInfo addObject:@[@4,@8]];
    
    [eachLinkInfo addObject:@[@4,@9]];
    
    [eachLinkInfo addObject:@[@4,@10]];
    
    [eachLinkInfo addObject:@[@4,@14]];
    
    [eachLinkInfo addObject:@[@5,@6]];
    
    [eachLinkInfo addObject:@[@5,@12]];
    
    [eachLinkInfo addObject:@[@6,@9]];
    
    [eachLinkInfo addObject:@[@8,@14]];
    
    [eachLinkInfo addObject:@[@13,@15]];
    
    [eachLinkInfo addObject:@[@6,@16]];
    
    [eachLinkInfo addObject:@[@12,@16]];
    
    [eachLinkInfo addObject:@[@14,@16]];
    
    [eachLinkInfo addObject:@[@13,@17]];
    
    [eachLinkInfo addObject:@[@15,@17]];
    
    [eachLinkInfo addObject:@[@1,@18]];
    
    [eachLinkInfo addObject:@[@8,@18]];
    
    [eachLinkInfo addObject:@[@4,@18]];
    
    [eachLinkInfo addObject:@[@11,@18]];
    
    [eachLinkInfo addObject:@[@12,@18]];
    
    [eachLinkInfo addObject:@[@10,@19]];
    
    [eachLinkInfo addObject:@[@3,@20]];
    
    [eachLinkInfo addObject:@[@8,@20]];
    
    [eachLinkInfo addObject:@[@8,@21]];
    
    [eachLinkInfo addObject:@[@6,@22]];
    
    [eachLinkInfo addObject:@[@13,@22]];
    
    [eachLinkInfo addObject:@[@6,@23]];
    
    [eachLinkInfo addObject:@[@0,@24]];
    
    [eachLinkInfo addObject:@[@2,@25]];
    
    [eachLinkInfo addObject:@[@15,@25]];
    
    [eachLinkInfo addObject:@[@17,@25]];
    
    [eachLinkInfo addObject:@[@21,@26]];
    
    [eachLinkInfo addObject:@[@5,@27]];
    
    [eachLinkInfo addObject:@[@22,@27]];
    
    [eachLinkInfo addObject:@[@0,@28]];
    
    [eachLinkInfo addObject:@[@7,@28]];
    
    [eachLinkInfo addObject:@[@9,@29]];
    
    [eachLinkInfo addObject:@[@21,@29]];
    
    
    
    [[eachNodeInfo objectAtIndex:0] setObject:@"h" atIndex:2];
    
    [[eachNodeInfo objectAtIndex:5] setObject:@"h" atIndex:2];
    
    [[eachNodeInfo objectAtIndex:8] setObject:@"h" atIndex:2];
    
    [[eachNodeInfo objectAtIndex:14] setObject:@"h" atIndex:2];
    int count = 0;
    for (NSArray *array in eachNodeInfo)
    {
        NodeView *thisNodeView = [[NodeView alloc]initWithFrame:CGRectMake([[array objectAtIndex:0] floatValue] - _nodeRadius, [[array objectAtIndex:1] floatValue] - _nodeRadius, _nodeRadius*2, _nodeRadius*2)];
        thisNodeView.order = count;
        thisNodeView.status = [array objectAtIndex:2];
        if ([thisNodeView.status isEqualToString:@"h"])
        {
            thisNodeView.greyToGreenCountdown = _greyToGreenCountdown;
            [thisNodeView setForgroundColor:[UIColor grayColor]];
        }
        if ([thisNodeView.status isEqualToString:@"l"])
        {
            [thisNodeView setForgroundColor:[UIColor greenColor]];

        }
        NSString *imageString = [[NSString alloc] initWithFormat:@"%d",count];
        
        UIImageView *thisImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageString]];
        thisImageView.frame = CGRectMake(0, 0, thisNodeView.frame.size.width, thisNodeView.frame.size.height);
        [thisNodeView addSubview:thisImageView];
        [thisNodeView sendSubviewToBack:thisImageView];
        
        
        
        count += 1;
        [self.view addSubview:thisNodeView];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, thisNodeView.frame.size.width, thisNodeView.frame.size.height)];
        thisNodeView.links = [[NSMutableArray alloc]init];
        [thisNodeView addSubview:button];
        [button setAlpha:1];
        [thisNodeView bringSubviewToFront:button];
        [button addTarget:self action:@selector(tapNodeWithOrder:) forControlEvents:UIControlEventTouchDown];
        [self.nodes addObject:thisNodeView];
        

    }
    count = 0;
    for (NSArray *array in eachLinkInfo)
    {
        NSUInteger index1 = [[array objectAtIndex:0]integerValue];
        NSUInteger index2 = [[array objectAtIndex:1]integerValue];
        CGPoint point1 = CGPointMake([[self.nodes objectAtIndex:index1] frame].origin.x + [[self.nodes objectAtIndex:index1] frame].size.width/2, [[self.nodes objectAtIndex:index1] frame].origin.y + [[self.nodes objectAtIndex:index1] frame].size.height/2);
        CGPoint point2 = CGPointMake([[self.nodes objectAtIndex:index2] frame].origin.x + [[self.nodes objectAtIndex:index2] frame].size.width/2, [[self.nodes objectAtIndex:index2] frame].origin.y + [[self.nodes objectAtIndex:index2] frame].size.height/2);
        LinkCAShapeLayer *shapeLayer = [LinkCAShapeLayer layer];
        shapeLayer.nodes = [[NSMutableArray alloc]init];
        
        [[shapeLayer nodes] addObject:[_nodes objectAtIndex:index1]];
        [[shapeLayer nodes] addObject:[_nodes objectAtIndex:index2]];
        [[[_nodes objectAtIndex:index1] links] addObject:shapeLayer];
        [[[_nodes objectAtIndex:index2] links] addObject:shapeLayer];
        [shapeLayer getInit:point1 point2:point2];
        [self.view.layer insertSublayer:shapeLayer atIndex:0];
    }
    // after this, the array nodes and links should be done.
}

-(void)tapNodeWithOrder:(NodeView *)sender
{
    NodeView *tmp = [sender superview];
    if ([_clickingCondition  isEqualToString: @"i"])
    {
        if (_numberOfInsulations > 0)
        {
            if (![[tmp status] isEqualToString:@"b"] && ![tmp insulationUsed])
            {
                _numberOfInsulations -= 1;
                [_numberOfInsulationsLabel setText:[NSString stringWithFormat:@"x%lu",(unsigned long)_numberOfInsulations]];
                [[_nodes objectAtIndex:[tmp order]] setInsulated:YES];
                [[_nodes objectAtIndex:[tmp order]] setInsulationCountdown:_insulationDur];
                [[_nodes objectAtIndex:[tmp order]] setInsulationUsed:YES];
                [[_nodes objectAtIndex:[tmp order]] setInsulatedLook];
                if (_numberOfInsulations == 0)
                {
                    [_insulationButton removeFromSuperview];
                }
            }
        }
    }
    
    else if ([_clickingCondition  isEqualToString: @"c"]&& ![[_nodes objectAtIndex:[tmp order]] cureUsed])
    {
        if (_numberOfCures > 0)
        {
            if (  arc4random() % 100 < 100*_probOfCured)
            {
                [[_nodes objectAtIndex:[tmp order]] setStatus:@"b"];
                [[_nodes objectAtIndex:[tmp order]] setForgroundColor:[UIColor clearColor]];
                [[_nodes objectAtIndex:[tmp order]] setGreyToGreenCountdown:0];
                [[_nodes objectAtIndex:[tmp order]] setCureUsed:YES];
                [[_nodes objectAtIndex:[tmp order]] setCuredLook];
            }
            _numberOfCures -= 1;
            [_numberOfCuresLabel setText:[NSString stringWithFormat:@"x%lu",(unsigned long)_numberOfCures]];

            if (_numberOfCures == 0)
            {
                [_cureButton removeFromSuperview];
            }
        }

    }
    else if ([_clickingCondition  isEqualToString: @"v"])
    {
        if (_numberOfVaccines > 0)
        {
            if ([[[_nodes objectAtIndex:[tmp order]] status] isEqualToString:@"b"]&& ![[_nodes objectAtIndex:[tmp order]] vaccineUsed])
            {
                _numberOfVaccines -= 1;
                [_numberOfVaccinesLabel setText:[NSString stringWithFormat:@"x%lu",(unsigned long)_numberOfVaccines]];

                [[_nodes objectAtIndex:[tmp order]] setVaccinated:YES];
                [[_nodes objectAtIndex:[tmp order ]] setVaccinationCountdown:_vaccinationDur];
                [[_nodes objectAtIndex:[tmp order]] setVaccineUsed:YES];
                [[_nodes objectAtIndex:[tmp order]] setVaccineLook];
                
                if (_numberOfVaccines == 0)
                {
                    [_vaccineButton removeFromSuperview];
                }
            }
        }
    }
    _clickingCondition = @"";

}

-(NSArray *)randomArrayWithMaxNumber:(NSUInteger)number lengthOfReturn:(NSUInteger)ll
{
    NSMutableArray *batch = [[NSMutableArray alloc]init];
    for (int i = 0;i < number;i++)
    {
        [batch addObject:[NSNumber numberWithInteger:i]];
    }
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (int j = 0;j < ll;j++)
    {
        int randomNumber = arc4random()%[batch count];
        [result addObject:[batch objectAtIndex:randomNumber]];
        [batch removeObjectAtIndex:randomNumber];
    }
    return [NSArray arrayWithArray:result];
}
- (IBAction)insulate:(id)sender
{
    self.clickingCondition = @"i";
}
- (IBAction)cure:(id)sender {
    self.clickingCondition = @"c";
}
- (IBAction)vaccine:(id)sender {
    self.clickingCondition = @"v";
}

-(NSArray *)positionsOfEachNodeOnScreen:(NSUInteger)pop width:(NSUInteger)width height:(NSUInteger)height dia:(NSUInteger)dia
{
    NSMutableArray *container = [[NSMutableArray alloc]init];
    for (NSUInteger i = 0; i < (width - 80)/dia/2;i += 1)
    {
        for (NSUInteger j = 0; j<(height)/dia/2;j += 1)
        {
            [container addObject:@[[NSNumber numberWithInteger:i],[NSNumber numberWithInteger:j]]];
        }
    }
    NSLog(@"%@",container);
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (int counter = 0;counter < pop;counter += 1)
    {
        NSUInteger thisRand =arc4random()%[container count];
        NSArray *randomIndexes = [container objectAtIndex:thisRand];
        NSUInteger x = [[randomIndexes objectAtIndex:0] integerValue] * dia*2 + (width%dia)+10 + 100;
        NSUInteger y = [[randomIndexes objectAtIndex:1] integerValue] * dia*2 + (width%dia)+10;
        [result addObject:[NSMutableArray arrayWithArray:@[[NSNumber numberWithInteger:x],[NSNumber numberWithInteger:y],@"b"]]];
        [container removeObjectAtIndex:thisRand];
    }
    return result;
    
}

@end
