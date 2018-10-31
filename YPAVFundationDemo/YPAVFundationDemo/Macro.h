//
//  Macro.h
//  YPToolsUpdate
//
//  Created by Work_Zyp on 2017/5/5.
//  Copyright © 2017年 Work_Zyp. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

//-------------------获取设备大小⬇️-------------------------
/** 获取屏幕 宽度、高度*/
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

/**  设置Frame*/
#define kRect(x,y,width,height) CGRectMake((x), (y), (width), (height))
/**  设置Size*/
#define kSize(width,height) CGSizeMake((width), (height))
/**  屏幕宽度实际值比例系数 414*/
#define kScaleW     (kScreenWidth / 414.0)
/**  屏幕宽度像素比例系数  1242*/
#define kPixScaleW     (kScreenWidth / 1242.0)
/** x,y正常传，witdth，height传入像素读取值*/
#define kRectPix(x,y,width,height) CGRectMake(x, y, (width) * kPixScaleW, (height) * kPixScaleW)
/**  x，y，width，height全像素取点*/
#define kPixRect(x,y,width,height) CGRectMake((x) * kPixScaleW, (y) * kPixScaleW, (width) * kPixScaleW, (height) * kPixScaleW)

/** 常用控件高度*/
#define kTabBar_Height        49.0f
#define kStatusBar_Height     20.0f
#define kNavigationBar_Height 44.0f
//-------------------获取设备大小⬆️-------------------------



//-------------------打印日志⬇️-------------------------
/**DEBUG  模式下打印日志,当前行*/
#ifdef DEBUG

#define DLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#else

#define DLog(...)

#endif

//#ifdef DEBUG
//#   define DLog(fmt, ...) NSLog((@"[类 方法]%s 行数:[Line %d] 打印内容:"fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#   define DLog(...)
//#endif

//Printing while in the debug model and pop an alert.       模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

/** print 打印rect,size,point */
#ifdef DEBUG
#define kLogPoint(point)    NSLog(@"%s = { x:%.4f, y:%.4f }", #point, point.x, point.y)
#define kLogSize(size)      NSLog(@"%s = { w:%.4f, h:%.4f }", #size, size.width, size.height)
#define kLogRect(rect)      NSLog(@"%s = { x:%.4f, y:%.4f, w:%.4f, h:%.4f }", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#endif
//-------------------打印日志⬆️-------------------------



//----------------------系统⬇️----------------------------
/** 获取系统版本*/
#define kiOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
#define kCurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
/** 获取当前语言*/
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
/** 是否高于iOS6（包涵iOS6） */
#define kIsOveriOS6 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) ? YES : NO)
/** 是否高于iOS7（包涵iOS7）*/
#define kIsOveriOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)
/** 是否高于iOS8 （包涵iOS8）*/
#define kIsOveriOS8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)
/** 是否高于iOS9 （包涵iOS9）*/
#define kIsOveriOS9 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? YES : NO)
/** 是否高于iOS10 （包涵iOS10）*/
#define kIsOveriOS10 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) ? YES : NO)

//判断是否 Retina屏、设备是否iPhone 5、是否是iPad
#define kIsRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
/** 判断是否为iPhone */
#define kIsiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/** 判断是否是iPad */
#define kIsiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
/** 判断是否为iPod */
#define kIsiPod ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

/** 设备是否为iPhone 4/4S 分辨率320x480，像素640x960，@2x */
#define kIsiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
/** 设备是否为iPhone 5C/5/5S 分辨率320x568，像素640x1136，@2x */
#define kIsiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
/** 设备是否为iPhone 6 分辨率375x667，像素750x1334，@2x */
#define kIsiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
/** 设备是否为iPhone 6 Plus 分辨率414x736，像素1242x2208，@3x */
#define kIsiPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/**  keyWindow 主窗口*/
#define kKeyWindow [UIApplication sharedApplication].keyWindow
//----------------------系统⬆️----------------------------



//----------------------内存⬇️----------------------------
/** 使用ARC和不使用ARC*/
#if __has_feature(objc_arc)
//compiling with ARC
#else
// compiling without ARC
#endif

/** 释放一个对象*/
#define SAFE_DELETE(P) if(P) { [P release], P = nil; }
#define SAFE_RELEASE(x) [x release];x=nil

/**  弱引用*/
#define kWeakSelf(type) __weak typeof(type)  weak##type = type;
/**  强引用*/
#define kStrongSelf(type) __strong typeof(type)  type = weak##type;
//----------------------内存⬆️----------------------------



//----------------------图片⬇️----------------------------
/** 读取本地图片，不缓存，适用于不常用的大图，只能访问工程根木录条件下的图片*/
#define kLocalImage(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:ext]]
/** 读取本地图片，不缓存，适用于不常用的大图，只能访问工程根木录条件下的图片*/
#define kImageWithResource(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]
/** 定义UIImage对象，自动缓存，适用于程序常用的小图片，切能够访问Assets.ccassets文件下的图片*/
#define kImageNamed(imageName) [UIImage imageNamed:(imageName)]
//建议使用前两种宏定义,性能高于后者 PS：前两种

/**  网络加载未完成时，默认展示的加载中的图片*/
#define kWaitLoadingImg     kLocalImage(@"",@"png")
//----------------------图片⬆️----------------------------



//----------------------颜色类⬇️---------------------------
/** rgb颜色转换(16进制->10进制)*/
#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
/** 带有RGBA的颜色设置*/
#define kRGBA_Color(R, G, B, A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)]
/** 获取RGB颜色*/
#define kRGB_Color(r,g,b) kRGBA_Color(r,g,b,1.0f)
/** 默认背景色*/
#define kNorBackGround_Color [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]
/** 透明色*/
#define kClearColor [UIColor clearColor]
/**  随机颜色*/
#define kRandomColor kRGB_Color(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256))

/**  eg*/
#define kCOLOR_BLUE_             UIColorFromRGB(0x41CEF2)
#define kCOLOR_GRAY_             UIColorFromRGB(0xababab) //171
#define kCOLOR_333               UIColorFromRGB(0x333333) //51
#define kCOLOR_666               UIColorFromRGB(0x666666) //102
#define kCOLOR_888               UIColorFromRGB(0x888888) //136
#define kCOLOR_999               UIColorFromRGB(0x999999) //153
#define kCOLOR_PLACEHOLD_        UIColorFromRGB(0xc5c5c5) //197
#define kCOLOR_RED_              UIColorFromRGB(0xff5400) //红色
#define kCOLOR_GREEN_            UIColorFromRGB(0x31d8ab)//绿色
#define kCOLOR_YELLOW_           UIColorFromRGB(0xffa200)//黄色
#define kCOLOR_SEPARATE_LINE     UIColorFromRGB(0xC8C8C8)//200
#define kCOLOR_LIGHTGRAY         COLOR(200, 200, 200, 0.4)//淡灰色
//----------------------颜色类⬆️--------------------------



//----------------------通知中心⬇️--------------------------
/**  通知对象*/
#define kNotificationCenter   [NSNotificationCenter defaultCenter]
/**  发通知*/
#define kPostNotification(notificationName)     [kNotificationCenter postNotificationName:notificationName object:nil]
/**  接收通知*/
#define kAddObserver(action,notificationName)  [kNotificationCenter addObserver:self selector:@selector(action) name:notificationName object:nil]
/** 移除对象所有通知*/
#define kRemoveAllObserver(_id_)   [[NSNotificationCenter defaultCenter] removeObserver:_id_]
/** 移除对象指定通知*/
#define kRemoveObserverWithName(_id_,_name_,_obj_) [[NSNotificationCenter defaultCenter] removeObserver:_id_ name:_name_ object:_obj_];
//----------------------通知中心⬆️--------------------------


//----------------------本地沙盒⬇️--------------------------
#define kUserDefaults    [NSUserDefaults standardUserDefaults]
/** 根据Key值保存Object到沙盒中*/
#define kUserDefaultsSetObjectForKey(object,key)     \
{\
[kUserDefaults setObject:object forKey:key];\
[kUserDefaults synchronize];\
}
/** 根据Key值获取沙盒中对应的内容*/
#define kUserDefaultsValueForKey(key)      [kUserDefaults valueForKey:(key)]
/** 根据Key值删除沙盒中对应的内容*/
#define kUserDefaultsRemoveObjectForKey(key) \
{\
[kUserDefaults removeObjectForKey:key];\
[kUserDefaults synchronize];\
}
//----------------------本地沙盒⬆️--------------------------



//----------------------其他⬇️----------------------------
/**  系统 普通字体*/
#define kSystem_FontSize(fontSize) [UIFont systemFontOfSize:(fontSize)]
/**  系统 加粗字体*/
#define kSystem_BoldFontSize(fontSize)  [UIFont boldSystemFontOfSize:(fontSize)]

/** 是否存在系统外的默认字体 更改值为YES or NO*/
#define kHasCustomFont      NO
/**  系统外的默认字体库的名字*/
#define kCustomFontName     @"HiraMinProN-W3"
#define kCustomBoldFontName @""
/**  控件基础字体设置 非加粗*/
#define kBaseNorFont(fontSize)     kHasCustomFont ? [UIFont fontWithName:kCustomFontName size:(fontSize)] : kSystem_FontSize(fontSize)
/**  控件基础字体设置 加粗*/
#define kBaseBoldFont(fontSize)     kHasCustomFont ? [UIFont fontWithName:kCustomBoldFontName size:(fontSize)] : kSystem_BoldFontSize(fontSize)

/**  控件设置时默认的Tag值*/
#define kNorTag  (arc4random() % 1000000 + 1000000)

/** 显示加载loading*/
#define kMBProgressHUD_Show(view) [MBProgressHUD showHUDAddedTo:view animated:YES];
/** 隐藏加载loading*/
#define kMBProgressHUD_Hide(view) [MBProgressHUD hideAllHUDsForView:view animated:YES]

/**  安全拿到字符串对象*/
#define kSafeGetString(str)         [NSString stringWithFormat:@"%@",str]
/** kUrlByStr 拿到URL*/
#define kUrlByStr(str)      [NSURL URLWithString:str]

/** 快速查询一段代码的执行时间 */
/** 用法
 TICK
 do your work here
 TOCK
 */
#define TICK NSDate *startTime = [NSDate date];
#define TOCK NSLog(@"Time:%f", -[startTime timeIntervalSinceNow]);

/**  单例化一个类*/
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] init]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
}
//----------------------其他⬆️----------------------------


//----------------------GCD⬇️----------------------------
#define GCDWithGlobal(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCDWithMain(block) dispatch_async(dispatch_get_main_queue(),block)
//----------------------GCD⬆️----------------------------


//----------------------提示类信息⬇️----------------------------
/**  请求数据错误时的提示信息*/
#define kError_Tips @"网络访问异常，请重试~"
//----------------------提示类信息⬆️----------------------------









#endif /* Macro_pch */
