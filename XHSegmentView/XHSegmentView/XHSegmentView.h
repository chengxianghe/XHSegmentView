//
//  XHSegmentView.h
//  XHSegmentView
//
//  Created by chengxianghe on 2017/5/22.
//  Copyright © 2017年 cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XHSegmentViewClickBlock)(NSInteger index, NSString *title, BOOL isCode);
typedef void(^XHSegmentViewAnimationBlock)(void(^animation)(), CGFloat duration);

IB_DESIGNABLE
@interface XHSegmentView : UIView

@property (nonatomic, strong) IBInspectable UIColor *titleNormalColor;        ///<标题的常规颜色
@property (nonatomic, strong) IBInspectable UIColor *titleSelectedColor;      ///<标题高亮颜色
@property (nonatomic, strong) IBInspectable UIColor *backgroundNormalColor;   ///<标题常规背景色
@property (nonatomic, strong) IBInspectable UIColor *backgroundSelectedColor; ///<标题高亮背景色
@property (nonatomic, assign) IBInspectable CGFloat titleCornerRadius;        ///<标题的CornerRadius
@property (nonatomic, assign) IBInspectable CGFloat duration;                 ///<动画时间
@property (nonatomic, assign) IBInspectable NSInteger titlesCount;            ///<标题数量

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;             ///<圆角
@property (nonatomic, strong) IBInspectable UIColor *borderColor;             ///<边框颜色
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;              ///<边框宽度
@property (nonatomic, assign) IBInspectable CGFloat titleFontSize;            ///<标题的字号

@property (nonatomic, strong) NSArray *titles;                  //标题数组
@property (nonatomic, strong) UIFont  *titleFont;               //标题的字体


/**
 点击按钮的回调

 @param block 回调 isCode 是否是代码触发
 */
- (void)setSegmentClickBlock:(XHSegmentViewClickBlock)block;


/**
 自定义切换选项的动画
 需要手动执行 animation
 */
- (void)setSegmentViewAnimationBlock:(XHSegmentViewAnimationBlock)block;

/**
 手动刷新UI
 */
- (void)xh_layoutSubviews;

/**
 手动选择
 
 @param index 选中的index
 */
- (void)setSelectedIndex:(NSInteger)index;


/**
 返回当前选中的index

 @return 选中的index
 */
- (NSInteger)currentIndex;

@end
