//
//  FDGradientLineChartView.m
//  GradientLineChart
//
//  Created by Evelyn on 2017/12/19.
//  Copyright © 2017年 Evelyn. All rights reserved.
//

#import "FDGradientLineChartView.h"
#import <Masonry.h>

#define imageButtonHeight 14
#define pointRadius 3
#define verticalMaxValue 20
#define verticalMinValue 0
#define verticalSpacing 4.0  //  每段代表的数据间隔
// 15-10-25
@interface FDGradientLineChartView ()
@property (nonatomic, strong) UIView *lineChartBackView;
@property (nonatomic, strong) UIView *dateBackView;
@property (nonatomic, strong) UIView *BackView_Y;


@property (nonatomic, strong) UIView *BGCView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer1;
@property (nonatomic, strong) CAGradientLayer *gradientLayer2;
@property (nonatomic, strong) CAGradientLayer *gradientLayer3;

@property (nonatomic, strong) NSMutableArray *horizontalArray; // date

@end


@implementation FDGradientLineChartView

{
    CGFloat _labelWidth_X;
    CGFloat _labelHeight_Y;
    CGFloat _pointSpacing_X;
    CGFloat _left;

    NSMutableArray <UILabel *> *_labelArray;
    NSMutableArray <UILabel *> *_valueLabelArray; // 用于展示每个点的数据

    NSMutableArray *_pointArray; // 存储每个点的坐标

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


#pragma mark - 添加子控件
- (void)configSubViews {
}

- (void)initParameters {
    _labelWidth_X = self.bounds.size.width / 5.0;
    _labelHeight_Y = self.bounds.size.height / 6.0;
    _pointSpacing_X = _labelWidth_X/30.0;
    _left = _labelWidth_X / 2.0;
    _labelArray = [NSMutableArray array];
    _valueLabelArray = [NSMutableArray array];
    _pointArray = [NSMutableArray array];
    self.horizontalArray = [NSMutableArray array];

    // 纵坐标的高度 全部的高度-30-35-10
    _labelHeight_Y = (self.frame.size.height - 65 - imageButtonHeight/2.0) / 5.0;


    [self getDateData];
}

- (void)drawRect:(CGRect)rect {

    [self initParameters];

    [self initBGC];

    [self initDateBackView];

    [self initBackLines];

    [self initVerticalBackView];

    [self initLineChartView];
}

#pragma mark - 渐变区域及线条
- (void)initBGC {
    // 封闭区域的渐变色
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer1 = [CAGradientLayer layer];
    self.gradientLayer1.frame = self.bounds;
    UIColor *color1 = [UIColor colorWithRed:225/255.0 green:204/255.0 blue:103/255.0 alpha:0.2];
    UIColor *color2 = [UIColor colorWithRed:48/255.0 green:236/255.0 blue:213/255.0 alpha:0.2];
    self.gradientLayer1.colors = @[(__bridge id)color1.CGColor,
                                   (__bridge id)color2.CGColor];
    self.gradientLayer1.startPoint = CGPointMake(0, 0);
    self.gradientLayer1.endPoint = CGPointMake(1, 0);
    self.gradientLayer1.locations = @[@0, @1];
    [self.layer addSublayer:self.gradientLayer1];


    // 折线的渐变色
    //初始化CAGradientlayer对象，使它的大小为UIView的大小
    self.gradientLayer2 = [CAGradientLayer layer];
    self.gradientLayer2.frame = self.bounds;
    UIColor *color_2 = [UIColor colorWithRed:45/255.0 green:240/255.0 blue:219/255.0 alpha:1.0];
    UIColor *color_1 = [UIColor colorWithRed:255/255.0 green:225/255.0 blue:50/255.0 alpha:1.0];
    self.gradientLayer2.colors = @[(__bridge id)color_1.CGColor,
                                   (__bridge id)color_2.CGColor];
    self.gradientLayer2.startPoint = CGPointMake(0, 0);
    self.gradientLayer2.endPoint = CGPointMake(1, 0);
    [self.layer addSublayer:self.gradientLayer2];
}

#pragma mark - 带日期的横坐标
- (void)initDateBackView {
    self.dateBackView = [[UIView alloc] init];
    self.dateBackView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.dateBackView];
    [self.dateBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.height.equalTo(@25);
    }];

    for (int i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.text = self.horizontalArray[i];
        label.textColor = [UIColor colorWithRed:99/255.0 green:124/255.0 blue:149/255.0 alpha:1.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:11.0];
        [self.dateBackView addSubview:label];

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*_labelWidth_X);
            make.top.bottom.equalTo(self.dateBackView);
            make.width.mas_equalTo(_labelWidth_X);
        }];
    }
}

#pragma mark - 纵坐标初始化
- (void)initVerticalBackView {
    self.BackView_Y = [[UIView alloc] init];
    [self addSubview:self.BackView_Y];
    self.BackView_Y.backgroundColor = [UIColor clearColor];
    [self.BackView_Y mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@30);
        make.left.equalTo(@15);
        make.width.equalTo(@15);
        make.bottom.equalTo(self.dateBackView.mas_top);
    }];

    for (int i = 0; i < 6; i++) {
        UILabel *label = [[UILabel alloc] init];
        [self.BackView_Y addSubview:label];
        label.font = [UIFont systemFontOfSize:11.0];
        label.textColor = [UIColor colorWithRed:99/255.0 green:124/255.0 blue:149/255.0 alpha:1.0];
        label.text = [NSString stringWithFormat:@"%.0f",verticalMaxValue-(i*verticalSpacing)];
        label.textAlignment = NSTextAlignmentCenter;

        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self.BackView_Y);
            make.height.mas_equalTo(@15);
            make.top.mas_equalTo(i*_labelHeight_Y-7.5);

        }];
        [_labelArray addObject:label];
    }
}

#pragma mark - 背景虚线
- (void)initBackLines {
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i < 5; i++) {
        [path moveToPoint:CGPointMake(30, 30+i*_labelHeight_Y)];
        [path addLineToPoint:CGPointMake(4*_labelWidth_X+imageButtonHeight+30, 30+i*_labelHeight_Y)];
        [path setLineWidth:0.5];

        CGFloat dashPattern[] = {5,5};// 3实线，1空白
        [path setLineDash:dashPattern count:1 phase:1];
        [path setLineDash:dashPattern count:1 phase:1];
        UIColor *color = [UIColor colorWithRed:224/255.0 green:240/255.0 blue:255/255.0 alpha:1.0];
        [color setStroke];
        [path stroke];
    }
}


#pragma mark - 折线图
- (void)initLineChartView {
    self.lineChartBackView = [[UIView alloc] init];
    self.lineChartBackView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.lineChartBackView];
    [self.lineChartBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.top.equalTo(self);
        make.bottom.equalTo(self.dateBackView.mas_top);
    }];

    // ----------   横坐标   ----------
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [UIColor colorWithRed:234/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];
    [self.lineChartBackView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_labelWidth_X*0.5);
        make.size.mas_equalTo(CGSizeMake(_labelWidth_X*4, 1));
        make.bottom.equalTo(self.lineChartBackView).offset(-imageButtonHeight/2.0);
    }];
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [self.lineChartBackView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_labelWidth_X*(i+0.5)-imageButtonHeight/2.0);
            make.size.mas_equalTo(CGSizeMake(imageButtonHeight, imageButtonHeight));
            make.bottom.equalTo(self.lineChartBackView);
        }];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = imageButtonHeight/2.0;
        button.layer.borderColor =  [[UIColor colorWithRed:117/255.0 green:220/255.0 blue:163/255.0 alpha:0.3] CGColor];
        button.layer.borderWidth = 2;
    }


    // -----------  画折线  ----------
    UIBezierPath * path = [[UIBezierPath alloc]init];
    path.lineWidth = 1.0;
    for (int i = 0; i < self.valuesArray.count+2; i++) {
        CGFloat y = 0;
        if (i == 0) {
            y = 30 + (verticalMaxValue-[_valuesArray[0] floatValue])* _labelHeight_Y / verticalSpacing; // 一个整数值所占高度
            [path moveToPoint:CGPointMake(_labelWidth_X*(0.5)-imageButtonHeight/2.0, y)];
        }else if (i == self.valuesArray.count + 1) {
            y = 30 + (verticalMaxValue-[_valuesArray[i-2] floatValue])* _labelHeight_Y / verticalSpacing; // 一个整数值所占高度
            [path addLineToPoint:CGPointMake(_labelWidth_X*(i-2+0.5)+imageButtonHeight/2.0, y)];
        }else {
            y = 30 + (verticalMaxValue-[_valuesArray[i-1] floatValue])* _labelHeight_Y / verticalSpacing; // 一个整数值所占高度
            CGPoint point = CGPointMake(_labelWidth_X*(i-1+0.5), y);
            [path addLineToPoint:point];
        }
    }


    [path stroke];
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = path.CGPath;
    lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    lineLayer.fillColor = [[UIColor clearColor] CGColor];
    lineLayer.lineCap = kCALineCapRound;
    lineLayer.lineJoin = kCALineJoinRound;
    self.gradientLayer2.mask = lineLayer;


    // -----------  渐变区域 - 多画四个点  -----------
    UIBezierPath * path1 = [[UIBezierPath alloc]init];
    for (int i = 0; i < self.valuesArray.count+4; i++) {
        CGFloat StartY = self.frame.size.height - 35 - imageButtonHeight/2.0;
        if (i == 0) {
            [path1 moveToPoint:CGPointMake(_labelWidth_X*0.5-imageButtonHeight/2.0, StartY)];
        }else if (i == 1) {
            CGFloat y = 30 + (verticalMaxValue-[_valuesArray[0] floatValue])* _labelHeight_Y / verticalSpacing;
            [path1 addLineToPoint:CGPointMake(_labelWidth_X*0.5-imageButtonHeight/2.0, y)];
        }else if (i == self.valuesArray.count+2) {
            CGFloat y = 30 + (verticalMaxValue-[_valuesArray[i-3] floatValue])* _labelHeight_Y / verticalSpacing;
            [path1 addLineToPoint:CGPointMake(_labelWidth_X*(self.valuesArray.count-1+0.5)+imageButtonHeight/2.0, y)];
        }else if (i == self.valuesArray.count+3) {
            [path1 addLineToPoint:CGPointMake(_labelWidth_X*(self.valuesArray.count-1+0.5)+imageButtonHeight/2.0, StartY)];
        }else {
            // 一个整数值所占高度
            CGFloat y = 30 + (verticalMaxValue-[_valuesArray[i-2] floatValue])* _labelHeight_Y / verticalSpacing;
            CGPoint point = CGPointMake(_labelWidth_X*(i-2+0.5), y);
            [path1 addLineToPoint:point];
        }
    }
    CAShapeLayer *Layer = [CAShapeLayer layer];
    Layer.path = path1.CGPath;
    self.gradientLayer1.mask = Layer;


    //     -----------  画点  ----------
    for (int i = 0; i < 5; i++) {
        CGFloat y = 30 + (verticalMaxValue-[_valuesArray[i] floatValue])* _labelHeight_Y / verticalSpacing; // 一个整数值所占高度
        [self drawPointWithRect:CGRectMake(_labelWidth_X*(i+0.5)-pointRadius, y-pointRadius, pointRadius*2, pointRadius*2) WithRadius:pointRadius WithIndex:i];
    }
}


- (void)drawPointWithRect:(CGRect)rect WithRadius:(CGFloat)radius WithIndex:(NSInteger)index{
    UIButton *pointButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pointButton setFrame:rect];
    [self addSubview:pointButton];
    pointButton.backgroundColor = [UIColor colorWithRed:60/255.0 green:211/255.0 blue:123/255.0 alpha:1.0];
    pointButton.layer.masksToBounds = YES;
    pointButton.layer.cornerRadius = radius;

    [pointButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    pointButton.tag = 500+index;

    // initLabel
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y-pointRadius, 35, 25)];
    label.text = [NSString stringWithFormat:@"%@", _valuesArray[index]];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:99/255.0 green:124/255.0 blue:149/255.0 alpha:1.0];
    [self addSubview:label];
    [_valueLabelArray addObject:label];
    label.hidden = YES;
}

- (void)buttonAction:(UIButton *)button {
    NSInteger index = button.tag - 500;
    [_valueLabelArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            obj.hidden = NO;
        }else {
            obj.hidden = YES;
        }
    }];
}

#pragma mark - 获取五个月时间
- (void)getDateData {
    for (int i = 0; i < 5; i++) {
        NSDateComponents * components = [[NSDateComponents alloc] init];
        [components setMonth:(i-3)];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *nextData = [calendar dateByAddingComponents:components toDate:[NSDate date] options:NSCalendarMatchStrictly];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy.MM";
        NSString * str1 = [formatter stringFromDate:nextData];
        [self.horizontalArray addObject:str1];
    }
}


/*
 // - 虚线  - 待用
 - (void)initLines {
 for (int i = 0; i < 5; i++) {
 CGContextRef currentContext = UIGraphicsGetCurrentContext();
 //设置虚线颜色
 UIColor *color = [UIColor colorWithRed:224/255.0 green:240/255.0 blue:255/255.0 alpha:1.0];
 CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
 //设置虚线宽度
 CGContextSetLineWidth(currentContext, 0.5);
 //设置虚线绘制起点
 CGContextMoveToPoint(currentContext, 30, 30+i*_labelHeight_Y); // 30=left(15)+width(15)
 //设置虚线绘制终点
 CGContextAddLineToPoint(currentContext, 4*_labelWidth_X+imageButtonHeight+30, 30+i*_labelHeight_Y);
 //设置虚线排列的宽度间隔:下面的arr中的数字表示先绘制3个点再绘制1个点
 CGFloat arr[] = {5,5};
 //下面最后一个参数“2”代表排列的个数。
 CGContextSetLineDash(currentContext, 0, arr, 2);
 CGContextDrawPath(currentContext, kCGPathStroke);
 }
 }

 // - 画点 - 贝塞尔
 - (void)drawPoint {
 for (int i = 0; i < 5; i++) {
 CGFloat y = 30 + (16-[_valuesArray[i] floatValue])* _labelHeight_Y / 2.0; // 一个整数值所占高度
 UIColor *color =  [UIColor colorWithRed:60/255.0 green:211/255.0 blue:123/255.0 alpha:1.0];
 UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(_labelWidth_X*(i+0.5)-pointRadius, y-pointRadius, pointRadius*2, pointRadius*2) cornerRadius:pointRadius];
 path.lineWidth = pointRadius;
 path.lineCapStyle = kCGLineCapRound;
 path.lineJoinStyle = kCGLineJoinRound;
 [color setFill];
 [path fill];
 }
 }
 */

@end
