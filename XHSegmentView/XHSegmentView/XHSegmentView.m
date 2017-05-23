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

@property (nonatomic,   weak) UIView *heightLightView;
@property (nonatomic,   weak) UIView *heightTopView;
@property (nonatomic,   weak) UIView *bottomNormalView;

@property (nonatomic, strong) NSMutableArray * labelMutableArray;
@property (nonatomic,   copy) XHSegmentViewClickBlock clickBlock;
@property (nonatomic,   copy) XHSegmentViewAnimationBlock animationBlock;
@property (nonatomic,   weak) UIButton * currentTapButton;

@end

@implementation XHSegmentView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

//由于 IBInspectable 值是在 initWithCoder:之后和 awakeFromNib:之前设置的,所以可以在 initWithCoder中设置默认值:方法
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (void)defaultConfig {
    _duration = 0.2;
    _titles = @[@"Title0", @"Title1", @"Title2"];
    _titlesCount = _titles.count;
    _titleNormalColor = [UIColor blackColor];
    _titleSelectedColor = [UIColor whiteColor];
    _backgroundNormalColor = [UIColor clearColor];
    _backgroundSelectedColor = [UIColor cyanColor];
    _titleFontSize = 14.0;
    _titleFont = [UIFont systemFontOfSize:_titleFontSize];
    _labelMutableArray = [[NSMutableArray alloc] initWithCapacity:_titles.count];
    _labelWidth = _viewWidth / _titles.count;
}

#pragma mark - layoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self xh_layoutSubviews];
}

- (void)xh_layoutSubviews{
    _viewWidth = super.frame.size.width;
    _viewHeight = super.frame.size.height;
    
    [self removeAllSubView];
    
#if TARGET_INTERFACE_BUILDER
    // this code will execute only in IB
    if (_titlesCount == 0) {
        _titlesCount = 3;
    }
    if (_titles == nil) {
        [self createDefaultTitles];
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
        _titleFontSize = [_titleFont pointSize];
    }
    if (_labelMutableArray == nil) {
        _labelMutableArray = [[NSMutableArray alloc] initWithCapacity:_titles.count];
    }
#endif
    
    // 更新label宽度
    if (_titles.count) {
        _labelWidth = _viewWidth / _titles.count;
        [self createBottomLabels];
        [self createTopLables];
        [self createTopButtons];
    }
    
    if (_currentTapButton != nil) {
        [self tapButton:_currentTapButton isCode:YES animated:NO];
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

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    _titleFontSize = [titleFont pointSize];
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

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    if (index < 0 || index > self.titles.count) {
        NSLog(@"index out of range of XHSegmentView");
        return;
    }
    UIButton *button = [self viewWithTag:index + 100];
    [self tapButton:button isCode:YES animated:animated];
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

- (void)createDefaultTitles {
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:_titlesCount];
    for (NSInteger i = 0; i < _titlesCount; i++) {
        [titles addObject:[NSString stringWithFormat:@"Title%d", (int)i]];
    }
    _titles = titles;
}

- (CGRect)countCurrentRectWithIndex:(NSInteger)index {
    return CGRectMake(_labelWidth * index, 0, _labelWidth, _viewHeight);
}

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

- (void)createBottomLabels {
    CGRect heightLightViewFrame = CGRectMake(0, 0, _viewWidth, _viewHeight);
    UIView *bottomNormalView = [[UIView alloc] initWithFrame:heightLightViewFrame];
    _bottomNormalView = bottomNormalView;
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

- (void)createTopLables {
    CGRect heightLightViewFrame = CGRectMake(0, 0, _labelWidth, _viewHeight);
    UIView *heightLightView = [[UIView alloc] initWithFrame:heightLightViewFrame];
    _heightLightView = heightLightView;
    _heightLightView.clipsToBounds = YES;
    _heightLightView.backgroundColor = _backgroundSelectedColor;
    _heightLightView.layer.cornerRadius = _titleCornerRadius;
    
    UIView *heightTopView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, _viewWidth, _viewHeight)];
    _heightTopView = heightTopView;
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

- (void)tapButton:(UIButton *)sender {
    [self tapButton:sender isCode:NO animated:YES];
}

/**
 点击的相应的按钮触发事件

 @param sender 按钮
 @param isCode 是否是代码触发
 @param animated 是否动画
 */
- (void)tapButton:(UIButton *)sender isCode:(BOOL)isCode animated:(BOOL)animated {
    _currentTapButton = sender;
    
    NSInteger tag = sender.tag - 100;
    
    if (_clickBlock && tag < _titles.count) {
        _clickBlock(tag, _titles[tag], isCode);
    }
    
    CGRect frame = [self countCurrentRectWithIndex:tag];
    CGRect changeFrame = [self countCurrentRectWithIndex:-tag];

    if (animated) {
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
    } else {
        self.heightLightView.frame = frame;
        self.heightTopView.frame = changeFrame;
    }
}

@end
