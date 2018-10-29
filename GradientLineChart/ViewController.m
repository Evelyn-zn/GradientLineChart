//
//  ViewController.m
//  GradientLineChart
//
//  Created by Evelyn on 2017/12/19.
//  Copyright © 2017年 Evelyn. All rights reserved.
//

#import "ViewController.h"
#import "FDGradientLineChartView.h"


@interface ViewController ()
@property (nonatomic, strong) UIView *backview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.backview = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.width)];
    self.backview.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:self.backview];
    FDGradientLineChartView *chartView = [[FDGradientLineChartView alloc] initWithFrame:self.backview.bounds];
    chartView.valuesArray = @[@7.7, @12.1, @9.5, @15.8, @11, @16, @19];
    chartView.backgroundColor = [UIColor whiteColor];
    [self.backview addSubview:chartView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
