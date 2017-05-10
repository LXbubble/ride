

#import "UIButton+ColorScale.h"
@interface UIButton()

@end
@implementation UIButton (ColorScale)

- (void)DQButtonColorScale:(CGFloat)colorScale{

    colorScale = colorScale;
    // [UIColor colorWithRed:0.98 green:0.38 blue:0.39 alpha:1.00]
    // 39 97 254
    if(colorScale < 0.3) return; // 微调闪烁效果
    CGFloat r = 98/255.0 *colorScale;
    CGFloat g = 38/255.0 *colorScale;
    CGFloat b = 39/255.0 *colorScale;
    if( (r+g+b)/3 < 0.38 ) return; // 如果接近黑色, 则返回
    
    UIColor *temScaleColor = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    CGFloat minScale  = 0.9;
    CGFloat trueScale = minScale + (1 - minScale) * colorScale;
    
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
    [self setTitleColor:temScaleColor forState:UIControlStateNormal];

}

@end
