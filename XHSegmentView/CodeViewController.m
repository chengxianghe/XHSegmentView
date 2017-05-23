//
//  CodeViewController.m
//  XHSegmentView
//
//  Created by chengxianghe on 2017/5/22.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "CodeViewController.h"
#import "XHSegmentView.h"


@interface CodeViewController ()

@end

@implementation CodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Code";
    [self performSelector:@selector(configSegmentView) withObject:nil afterDelay:1];
}

- (void)configSegmentView {
    XHSegmentView *v = [[XHSegmentView alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 26)];
    [self.view addSubview:v];
//    v.backgroundColor = [UIColor clearColor];
    v.cornerRadius = 13;
    v.borderColor = [UIColor whiteColor];
    v.borderWidth = 1;
    
    v.cornerRadius = 13.0;
    
    NSArray *titles = @[@"Title0", @"Title1", @"Title2",];
    v.titles = titles;
    v.duration = 0.3f;
    v.titleCornerRadius = 13.0;
    v.titleNormalColor = [UIColor whiteColor];
    v.titleSelectedColor = [UIColor colorWithRed:90/255.0 green:112/255.0 blue:168/255.0 alpha:1.0];
    v.backgroundSelectedColor = [UIColor whiteColor];
    v.titleFont = [UIFont systemFontOfSize:12.0];
    //    __weak typeof(self)weak_self = self;
    [v setSegmentClickBlock:^(NSInteger index, NSString *title, BOOL isCode) {
        NSLog(@"index = %ld, title = %@", (long)index, title);
    }];
    [v setSegmentViewAnimationBlock:^(void (^animation)(void), CGFloat duration) {
        [UIView animateWithDuration:1.5 delay:0 usingSpringWithDamping:10 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            animation();
        } completion:^(BOOL finished) {
            
        }];
    }];
    
    [v xh_layoutSubviews];

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
