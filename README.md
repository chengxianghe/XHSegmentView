# XHSegmentView

- 项目使用 ARC 和 CocoaPods 
- iOS 7.0
- swift 3.0
- 支持 IB_DESIGNABLE，IBInspectable


#### GitHub：[chengxianghe](https://github.com/chengxianghe) 

#### pod
```
use_frameworks!

pod XHSegmentView
```

#### 有什么问题请issue我

## Screenshots

<img src="https://github.com/chengxianghe/watch-gif/blob/master/XHSegmentView/WX20170523-113002.png?raw=true" width = "400" alt="预览图"/>

<img src="https://github.com/chengxianghe/watch-gif/blob/master/XHSegmentView/WX20170523-113724.png?raw=true" width = "400" alt="预览图"/>

## Useage

- 如果是直接Xib使用，需要注意要 先设置 "titlesCount" 属性, 再设置别的属性才能实时显示
- 如果是代码创建使用，需要注意最后要手动调用 "xh_layoutSubviews" 方法才能显示
