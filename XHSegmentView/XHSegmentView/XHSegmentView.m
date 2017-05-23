//
//  XHSegmentView.m
//  XHSegmentView
//
//  Created by chengxianghe on 2017/5/22.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "XHSegmentView.h"

@interface XHSegmentView ()

@property (nonatomic, assign) CGFloat viewWidth;                    //组件的宽度
@property (nonatomic, assign) CGFloat viewHeight;                   //组件的高度
@property (nonatomic, assign) CGFloat labelWidth;                   //Label的宽度

@property (nonatomic, strong) UIView * heightLightView;
@property (nonatomic, strong) UIView * heightTopView;
@property (nonatomic, strong) UIView * bottomNormalView;

@property (nonatomic, strong) NSMutableArray * labelMutableArray;
@property (nonatomic,   copy) XHSegmentViewClickBlock clickBlock;
@property (nonatomic,   copy) XHSegmentViewAnimationBlock animationBlock;
@property (nonatomic,   weak) UIButton * currentTapButton;

@end

@implementation XHSegmentView

- (instancetype)init {
    self = [super init];
    if (self) {
        _duration = 0.2;
        _titlesCount = 3;
    }
    return self;
}

//由于 IBInspectable 值是在 initWithCoder:之后和 awakeFromNib:之前设置的,所以可以在 initWithCoder中设置默认值:方法
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _duration = 0.2;
        _titlesCount = 3;
    }
    return self;
}

#pragma mark - layoutSubviews

//#if TARGET_INTERFACE_BUILDER
// this code will execute only in IB
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self xh_layoutSubviews];
}
//#else
//// this code will run in the app itself
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    
//    if ([self.titles count] <= 0) {
//        [self setTitlesCount:_titlesCount];
//    }
//    [self xh_layoutSubviews];
//}
//
//#endif

- (void)xh_layoutSubviews{
    _viewWidth = super.frame.size.width;
    _viewHeight = super.frame.size.height;
    
    [self removeAllSubView];
    
    [self customeData];
    [self createBottomLabels];
    [self createTopLables];
    [self createTopButtons];
    
    if (_currentTapButton != nil) {
        [self tapButton:_currentTapButton isCode:YES];
    }
}

#pragma mark - setter

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setTitlesCount:(NSInteger)titlesCount {
    _titlesCount = titlesCount;
    [self createDefaultTitles];
    [self layoutSubviews];
}

- (void)setTitleFontSize:(CGFloat)titleFontSize {
    _titleFontSize = titleFontSize;
    if (_titleFont) {
        _titleFont = [UIFont fontWithName:_titleFont.fontName size:titleFontSize];
    } else {
        _titleFont = [UIFont systemFontOfSize:titleFontSize];
    }
    [self layoutSubviews];
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    _titlesCount = titles.count;
    [self layoutSubviews];
}

#pragma mark - Public

- (void)setSegmentClickBlock:(XHSegmentViewClickBlock)block{
    if (block) {
        _clickBlock = block;
    }
}

- (void)setSegmentViewAnimationBlock:(XHSegmentViewAnimationBlock)block {
    if (block) {
        _animationBlock = block;
    }
}

- (void)setSelectedIndex:(NSInteger)index {
    if (index < 0 || index > self.titles.count) {
        NSLog(@"index out of range of zlsegment");
        return;
    }
    UIButton *button = [self viewWithTag:index + 100];
    NSLog(@"****selected index: %ld", (long)index);
    [self tapButton:button isCode:YES];
}

- (NSInteger)currentIndex {
    if (_currentTapButton) {
        return _currentTapButton.tag - 100;
    } else {
        return 0;
    }
}

#pragma mark - Private

- (void)removeAllSubView {
    if (_heightLightView != nil) {
        [self removeSubView:_heightLightView];
        [self removeSubView:_heightTopView];
        [self removeSubView:_bottomNormalView];
        [self.labelMutableArray removeAllObjects];
        
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
    }
}

- (void)removeSubView:(UIView *)subView {
    [subView removeFromSuperview];
    subView = nil;
}

/**
 *  提供默认值
 */
- (void)customeData {
    if (_titles == nil) {
        _titlesCount = 3;
        _titles = @[@"Test0", @"Test1", @"Test2"];
    }
    
    if (_titleNormalColor == nil) {
        _titleNormalColor = [UIColor blackColor];
    }
    
    if (_titleSelectedColor == nil) {
        _titleSelectedColor = [UIColor whiteColor];
    }
    
    if (_backgroundNormalColor == nil) {
        _backgroundNormalColor = [UIColor clearColor];
    }
    if (_backgroundSelectedColor == nil) {
        _backgroundSelectedColor = [UIColor cyanColor];
    }
    if (_titleFont == nil) {
        _titleFont = [UIFont systemFontOfSize:14.0];
    }
    
    if (_labelMutableArray == nil) {
        _labelMutableArray = [[NSMutableArray alloc] initWithCapacity:_titles.count];
    }
    _labelWidth = _viewWidth / _titles.count;
}

- (void)createDefaultTitles {
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:_titlesCount];
    for (NSInteger i = 0; i < _titlesCount; i++) {
        [titles addObject:[NSString stringWithFormat:@"Test%d", (int)i]];
    }
    _titles = titles;
}

/**
 *  计算当前高亮的Frame
 *
 *  @param index 当前点击按钮的Index
 *
 *  @return 返回当前点击按钮的Frame
 */
- (CGRect)countCurrentRectWithIndex:(NSInteger)index {
    return CGRectMake(_labelWidth * index, 0, _labelWidth, _viewHeight);
}

/**
 *  根据索引创建Label
 *
 *  @param index     创建的第几个Index
 *  @param textColor Label字体颜色
 *
 *  @return 返回创建好的label
 */
- (UILabel *)createLabelWithTitlesIndex:(NSInteger)index textColor:(UIColor *)textColor {
    CGRect currentLabelFrame = [self countCurrentRectWithIndex:index];
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:currentLabelFrame];
    tempLabel.textColor = textColor;
    tempLabel.text = _titles[index];
    tempLabel.font = _titleFont;
    tempLabel.minimumScaleFactor = 0.1f;
    tempLabel.textAlignment = NSTextAlignmentCenter;
    return tempLabel;
}

/**
 *  创建最底层的Label
 */
- (void)createBottomLabels {
    CGRect heightLightViewFrame = CGRectMake(0, 0, _viewWidth, _viewHeight);
    _bottomNormalView = [[UIView alloc] initWithFrame:heightLightViewFrame];
    _bottomNormalView.clipsToBounds = YES;
    _bottomNormalView.backgroundColor = _backgroundNormalColor;
    _bottomNormalView.layer.cornerRadius = _cornerRadius;
    for (int i = 0; i < _titles.count; i ++) {
        UILabel *tempLabel = [self createLabelWithTitlesIndex:i textColor:_titleNormalColor];
        [_bottomNormalView addSubview:tempLabel];
        [_labelMutableArray addObject:tempLabel];
    }
    [self addSubview:_bottomNormalView];
}

/**
 *  创建上一层高亮使用的Label
 */
- (void)createTopLables {
    CGRect heightLightViewFrame = CGRectMake(0, 0, _labelWidth, _viewHeight);
    _heightLightView = [[UIView alloc] initWithFrame:heightLightViewFrame];
    _heightLightView.clipsToBounds = YES;
    _heightLightView.backgroundColor = _backgroundSelectedColor;
    _heightLightView.layer.cornerRadius = _titleCornerRadius;
    
//    _heightColoreView = [[UIView alloc] initWithFrame:heightLightViewFrame];

//    [_heightLightView addSubview:_heightColoreView];
    
    _heightTopView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, _viewWidth, _viewHeight)];
    for (int i = 0; i < _titles.count; i ++) {
        UILabel *label = [self createLabelWithTitlesIndex:i textColor:_titleSelectedColor];
        [_heightTopView addSubview:label];
    }
    [_heightLightView addSubview:_heightTopView];
    [self addSubview:_heightLightView];
}

- (void)createTopButtons {
    for (int i = 0; i < _titles.count; i ++) {
        CGRect tempFrame = [self countCurrentRectWithIndex:i];
        UIButton *tempButton = [[UIButton alloc] initWithFrame:tempFrame];
        tempButton.tag = 100 + i;
        [tempButton addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tempButton];
    }
}

/**
 *  点击按钮事件
 *
 *  @param sender 点击的相应的按钮
 */
- (void)tapButton:(UIButton *)sender {
    [self tapButton:sender isCode:NO];
}

/**
 *  按钮事件
 *
 *  @param sender 点击的相应的按钮
 */
- (void)tapButton:(UIButton *)sender isCode:(BOOL)isCode {
    _currentTapButton = sender;
    
    NSInteger tag = sender.tag - 100;
    
    if (_clickBlock && tag < _titles.count) {
        _clickBlock(tag, _titles[tag], isCode);
    }
    
    CGRect frame = [self countCurrentRectWithIndex:tag];
    CGRect changeFrame = [self countCurrentRectWithIndex:-tag];

    __weak typeof(self) weak_self = self;
    if (_animationBlock) {
        _animationBlock(^(){
            weak_self.heightLightView.frame = frame;
            weak_self.heightTopView.frame = changeFrame;
        }, weak_self.duration);
    } else {
        [UIView animateWithDuration:_duration animations:^{
            weak_self.heightLightView.frame = frame;
            weak_self.heightTopView.frame = changeFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

/**
 *  抖动效果
 *
 *  @param view 要抖动的view
 */
- (void)shakeAnimationForView:(UIView *) view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x + 1, position.y);
    CGPoint y = CGPointMake(position.x - 1, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.06];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

@end
