//
//  XibViewController.m
//  XHSegmentView
//
//  Created by chengxianghe on 2017/5/22.
//  Copyright © 2017年 cn. All rights reserved.
//

#import "XibViewController.h"
#import "XHSegmentView.h"

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface XibViewController ()

@property (weak, nonatomic) IBOutlet XHSegmentView *segment;

@end

@implementation XibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Xib";
    [self performSelector:@selector(configSegmentView) withObject:nil afterDelay:1];
}

- (void)configSegmentView {
    XHSegmentView *v = self.segment;
//    [v setTitlesCount:6];
    v.titles = @[@"11",@"22",@"33",@"44",@"55",@"66"];
//    [v setTitleFontSize:12];
    [v setSegmentClickBlock:^(NSInteger index, NSString *title, BOOL isCode) {
        NSLog(@"index = %ld, title = %@", (long)index, title);
    }];    
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
