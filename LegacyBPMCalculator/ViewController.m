//
//  ViewController.m
//  LegacyBPMCalculator
//
//  Created by Michael A. Crawford on 7/7/16.
//  Copyright © 2016 Crawford Design Engineering, LLC. All rights reserved.
//

#import "LegacyBPMCalculator.h"
#import "ViewController.h"

@interface ViewController ()
{
    LegacyBPMCalculator* bpmCalculator;
    UILabel* BPMLabel;
    UILabel* BPMValue;
    UIButton* sampleButton;
    UILabel* STDDEVLabel;
    UILabel* STDDEVValue;
}

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    
    if ( self )
    {
        bpmCalculator = [[LegacyBPMCalculator alloc] initWithSize:10];
    }
    
    return self;
}

- (void)loadView
{
    // view
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    view.backgroundColor = UIColor.whiteColor;
    
    // sample-button
    sampleButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    sampleButton.frame = CGRectMake(60, 60, 200, 44);
    sampleButton.backgroundColor = UIColor.whiteColor;
    [view addSubview:sampleButton];
    
    // BPM display
    BPMLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 120, 80, 22)];
    [view addSubview:BPMLabel];
    
    BPMValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 120, 80, 22)];
    [view addSubview:BPMValue];
    
    // STDDEV display
    STDDEVLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 150, 80, 22)];
    [view addSubview:STDDEVLabel];
    
    STDDEVValue = [[UILabel alloc] initWithFrame:CGRectMake(160, 150, 80, 22)];
    [view addSubview:STDDEVValue];
    
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BPMLabel.text = @"BPM:";
    [sampleButton addTarget:self
                     action:@selector(sample:)
           forControlEvents:UIControlEventTouchUpInside];
    STDDEVLabel.text = @"STDDEV:";
}

- (IBAction)sample:(id)sender
{
    double stddev = 0;
    double bpm = [bpmCalculator inputSample:&stddev];
    
    if ( bpm > 0 )
    {
        BPMValue.text = [NSString stringWithFormat:@"%g", bpm];
        STDDEVValue.text = [NSString stringWithFormat:@"%g", stddev];
    }
}

@end
