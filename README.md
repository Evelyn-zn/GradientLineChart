# GradientLineChart
GradientLineChart

简易渐变折线图：

#### 参数
valuesArray：折线图点纵坐标数值


#### 使用方法
```
FDGradientLineChartView *chartView = [[FDGradientLineChartView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.width)];
chartView.valuesArray = @[@7.7, @12.1, @9.5, @15.8, @11, @16, @19];
chartView.backgroundColor = [UIColor whiteColor];
[self.view addSubview:chartView];
```

#### 展示效果
![效果图展示](https://github.com/Evelyn-zn/GradientLineChart/blob/master/images/%E6%95%88%E6%9E%9C%E5%9B%BE.png)



