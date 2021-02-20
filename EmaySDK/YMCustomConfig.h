//
//  YMCustomConfig.h
//  UniLogin
//
//  Created by 乔春晓 on 2020/2/11.
//  Copyright © 2020 乔春晓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EAccountHYSDK/EAccountOpenPageConfig.h"
#import "EAccountHYSDK/EAccountOpenPageSDK.h"
#import "TYRZUISDK/UACustomModel.h"
#import "OAuth/ZOAUCustomModel.h"
#import "OAuth/ZUOAuthManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 JVLayoutConstraint 布局参照item

 - JVLayoutItemNone: 不参照任何item。可用来直接设置width、height
 - JVLayoutItemLogo:  参照logo视图
 - JVLayoutItemNumber: 参照号码栏
 - JVLayoutItemSlogan: 参照标语栏
 - JVLayoutItemLogin: 参照登录按钮
 - JVLayoutItemCheck: 参照隐私选择框
 - JVLayoutItemPrivacy: 参照隐私栏
 - JVLayoutItemSuper: 参照父视图
 */
typedef NS_ENUM(NSUInteger, JVLayoutItem) {
    JVLayoutItemNone = 1,
    JVLayoutItemLogo,
    JVLayoutItemNumber,
    JVLayoutItemSlogan,
    JVLayoutItemLogin,
    JVLayoutItemCheck,
    JVLayoutItemPrivacy,
    JVLayoutItemSuper
};


@interface JVLayoutConstraint : NSObject
/**
 授权页布局类，使用Autolayout处理。用法参考系统类NSLayoutConstraint 以及示例demo。
 */

@property (nonatomic, assign) NSLayoutAttribute firstAttribute;
@property (nonatomic, assign) NSLayoutAttribute secondAttribute;
@property (nonatomic, assign) NSLayoutRelation relation;
@property (nonatomic, assign) JVLayoutItem item;
@property (nonatomic, assign) CGFloat multiplier;
@property (nonatomic, assign) CGFloat constant;

/**
 相对父视图的布局约束

 @param attr1 约束类型
 @param relation 与参照视图之间的约束关系
 @param item 参照item
 @param attr2 参照item约束类型
 @param multiplier 乘数
 @param c 常量
 @return JVLayoutConstraint布局对象
 */
+(instancetype)constraintWithAttribute:(NSLayoutAttribute)attr1
                             relatedBy:(NSLayoutRelation)relation
                                toItem:(JVLayoutItem)item
                             attribute:(NSLayoutAttribute)attr2
                            multiplier:(CGFloat)multiplier
                              constant:(CGFloat)c;
@end



@interface YMCustomConfig : NSObject

// 移动
@property (nonatomic, strong) UACustomModel *cmccModel;
// 联通
@property (nonatomic, strong) ZOAUCustomModel *cuccModel;
// 电信
@property (nonatomic, strong) EAccountOpenPageConfig *ctccModel;

// 电信登录是否用mini窗口
@property (nonatomic, assign) BOOL ctccMini;
// 电信
@property (nonatomic, strong) UIViewController *currentVC;


/**
 授权页面的各个控件的Y轴默认值都是以375*667屏幕为基准 系数 ： 当前屏幕高度/667
 1、当设置Y轴并有效时 偏移量OffsetY属于相对导航栏的绝对Y值
 2、（负数且超出当前屏幕无效）为保证各个屏幕适配,请自行设置好Y轴在屏幕上的比例（推荐:当前屏幕高度/667）
 */

/*----------------------------------------授权页面-----------------------------------*/


//MARK:导航栏（联通、电信）*************
/**导航栏背景颜色*/
@property (nonatomic,strong) UIColor *navColor;
/**导航栏标题*/
@property (nonatomic,copy) NSString *navText;
/**导航栏标题字体大小*/
@property (nonatomic,assign) CGFloat navTextSize;
/**导航栏标题颜色*/
@property (nonatomic,strong) UIColor *navTextColor;
/**导航返回图标*/
@property (nonatomic,strong) UIImage *navReturnImg;




//MARK:图片设置（联通、电信）************
/**LOGO图片*/
@property (nonatomic,strong) UIImage *logoImg;
/**LOGO图片宽度*/
@property (nonatomic,assign) CGFloat logoWidth DEPRECATED_MSG_ATTRIBUTE("Please use logoConstraints");
/**LOGO图片高度*/
@property (nonatomic,assign) CGFloat logoHeight DEPRECATED_MSG_ATTRIBUTE("Please use logoConstraints");
/**LOGO图片偏移量*/
@property (nonatomic,assign) CGFloat logoOffsetY DEPRECATED_MSG_ATTRIBUTE("Please use logoConstraints");
/*LOGO图片布局*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint*>* logoConstraints;
/*LOGO图片 横屏布局，横屏时优先级高于logoConstraints*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint*>* logoHorizontalConstraints;
/**LOGO图片隐藏*/
@property (nonatomic,assign) BOOL logoHidden;



//MARK:登录按钮************

/**登录按钮文本*/
@property (nonatomic,strong) NSAttributedString *logBtnText;
/**登录按钮Y偏移量*/
@property (nonatomic,assign) CGFloat logBtnOffsetY DEPRECATED_MSG_ATTRIBUTE("Please use logBtnConstraints");
/*登录按钮布局*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint*>* logBtnConstraints;
/*登录按钮 横屏布局，横屏时优先级高于logBtnConstraints*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint*>* logBtnHorizontalConstraints;
/**登录按钮背景图片添加到数组(顺序如下)
 @[激活状态的图片,失效状态的图片,高亮状态的图片]
 注意:当customPrivacyAlertViewBlock不为空，并且隐私栏为选中时，失效状态的图片设置无效
 */
@property (nonatomic,copy) NSArray *logBtnImgs;

//MARK:号码框设置************
/**手机号码富文本属性 */
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *numberTextAttributes;
/**号码栏Y偏移量*/
@property (nonatomic,assign) CGFloat numFieldOffsetY DEPRECATED_MSG_ATTRIBUTE("Please use numberConstraints");
/*号码栏布局 宽高自适应，不需要设置*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint*>* numberConstraints;
/*号码栏 横屏布局,横屏时优先级高于numberConstraints*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint*>* numberHorizontalConstraints;

//MARK:隐私条款************

/**复选框未选中时图片*/
@property (nonatomic,strong) UIImage *uncheckedImg;
/**复选框选中时图片*/
@property (nonatomic,strong) UIImage *checkedImg;
/*复选框布局*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint*>* checkViewConstraints;
/*复选框 横屏布局，横屏优先级高于checkViewConstraints*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint*>* checkViewHorizontalConstraints;

/**隐私条款一:数组（务必按顺序）
 @[条款名称,条款链接]
 */
@property (nonatomic,strong) NSArray <NSString *>*appPrivacyOne;
/**隐私条款二:数组（务必按顺序）
 @[条款名称,条款链接]
 */
@property (nonatomic,strong) NSArray <NSString *>*appPrivacyTwo;

/**隐私条款名称颜色
 @[基础文字颜色,条款颜色]
 */
@property (nonatomic, strong) NSArray <UIColor *>*appPrivacyColor;
/**隐私条款文本对齐方式，目前仅支持 left、center*/
@property (nonatomic,assign) NSTextAlignment privacyTextAlignment;
/**隐私条款字体大小，默认12*/
@property (nonatomic,assign) CGFloat privacyTextFontSize;
/**隐私条款是否显示书名号，默认不显示*/
@property (nonatomic,assign) BOOL privacyShowBookSymbol;
/**隐私条款行距，默认跟随系统*/
@property (nonatomic,assign) CGFloat privacyLineSpacing;
/**隐私条款Y偏移量(注:此属性为与屏幕底部的距离)*/
@property (nonatomic,assign) CGFloat privacyOffsetY DEPRECATED_MSG_ATTRIBUTE("Please use privacyConstraints");
/**隐私条款拼接文本数组，数组限制4个NSString对象，否则无效
 默认文本1为：”登录即同意“，文本2:”和“，文本3：”、“，文本4：”并使用本机号码登录“
 设置后，隐私协议栏文本修改为 文本1 + 运营商默认协议名称 + 文本2 + 开发者协议名称1 + 文本3 + 开发者协议文本2 + 文本4
 */
@property (nonatomic,strong) NSArray <NSString *>* privacyComponents;
/*隐私条款布局*/
//@property (nonatomic, copy) NSArray <JVLayoutConstraint *>* privacyConstraints;
///*隐私条款 横屏布局，横屏下优先级高于privacyConstraints*/
//@property (nonatomic, copy) NSArray <JVLayoutConstraint *>* privacyHorizontalConstraints;
/**隐私条款check框默认状态 默认:NO */
@property (nonatomic,assign) BOOL privacyState;
/*
 当自定义Alert view,当隐私条款未选中时,点击登录按钮时回调
 当此参数存在时,未选中隐私条款的情况下，登录按钮可以被点击
 block内部参数为自定义Alert view可被添加的控制器，详细用法可参见示例demo
 注意：当此参数不为空并且隐私栏为选中的情况下，logBtnImgs失效状态图片设置无效
 */
//@property (nonatomic,copy) void(^customPrivacyAlertViewBlock)(UIViewController * vc);

/// 为隐私文本添加富文本属性，该方法的设置隐私协议富文本属性的优先级最高
/// @param name  NSAttributedStringKey
/// @param value NSAttributedStringKey 对应的值
/// @param range  对应字符串范围
//- (void)addPrivacyTextAttribute:(NSAttributedStringKey)name value: (id)value range:(NSRange)range;

/// 设置一键登录页面背景视频
/// @param path  视频路径支持在线url或者本地视频路径
/// @param imageName  视频未准备好播放时的占位图片名称
//- (void)setVideoBackgroudResource:(NSString*)path placeHolder:(NSString*)imageName;

//MARK:slogan************

/**slogan偏移量Y*/
@property (nonatomic,assign) CGFloat sloganOffsetY DEPRECATED_MSG_ATTRIBUTE("Please use sloganConstraints");
/*slogan布局，宽高自适应不需要设置*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint *>* sloganConstraints;
/*slogan 横屏布局,横屏下优先级高于sloganConstraints*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint *>* sloganHorizontalConstraints;
/**slogan文字颜色*/
@property (nonatomic,strong) UIColor *sloganTextColor;
/*slogan文字font,默认12*/
@property (nonatomic,strong) UIFont *sloganFont;

/*默认loading布局*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint *>* loadingConstraints;
/*默认loading 横屏布局，横屏下优先级高于loadingConstraints*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint *>* loadingHorizontalConstraints;
/*自定义loading view,当授权页点击登录按钮时回调
 当此参数存在时,默认loading view不会显示,需开发者自行设计loading view
 block内部参数为自定义loading view可被添加的父视图，详细用法可参见示例demo
 */
@property (nonatomic,copy) void(^customLoadingViewBlock)(UIView * View);



/*弹窗样式设置*/
/*是否弹窗，默认no*/
@property (nonatomic, assign) BOOL showWindow;
/*弹框内部背景图片*/
@property (nonatomic, strong) UIImage *windowBackgroundImage;
/*弹窗外侧 透明度  0~1.0*/
@property (nonatomic, assign) CGFloat windowBackgroundAlpha;
/*弹窗圆角数值*/
@property (nonatomic, assign) CGFloat windowCornerRadius;
/*弹窗布局*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint*>* windowConstraints;
/*弹窗横屏布局，横屏下优先级高于windowConstraints*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint*>* windowHorizontalConstraints;


/*弹窗close按钮图片 @[普通状态图片，高亮状态图片]*/
@property (nonatomic, copy) NSArray <UIImage *>*windowCloseBtnImgs;
/*弹窗close按钮布局*/
@property (nonatomic, copy) NSArray <JVLayoutConstraint*>* windowCloseBtnConstraints;
/*弹窗close按钮 横屏布局,横屏下优先级高于windowCloseBtnConstraints */
@property (nonatomic, copy) NSArray <JVLayoutConstraint*>* windowCloseBtnHorizontalConstraints;


/*是否使用autoLayout，默认NO。使用JVLayoutConstraint对象布局，需要改成YES*/
@property (nonatomic, assign) BOOL autoLayout;

/*是否支持自动旋转 默认YES。
 注意: 当授权页为弹框样式时,参数无效，是否旋转由当前视图控制器控制 */
@property (nonatomic,assign) BOOL  shouldAutorotate;
/*设置进入授权页的屏幕方向。不支持UIInterfaceOrientationPortraitUpsideDown
 注意:当授权页为弹框样式时,参数无效，屏幕方向由当前视图控制器控制 */
@property (nonatomic, assign) UIInterfaceOrientation orientation;

/**协议页导航栏背景颜色*/
@property (nonatomic, strong) UIColor *agreementNavBackgroundColor;
/*授权页点击运营商默认协议，进入协议页时, 协议页自定义导航栏标题*/
@property (nonatomic, strong) NSAttributedString *agreementNavText;
/*授权页点击自定义协议1，进入协议页时, 协议页自定义导航栏标题*/
@property (nonatomic, strong) NSAttributedString *firstPrivacyAgreementNavText;
/*授权页点击自定义协议2，进入协议页时, 协议页自定义导航栏标题*/
@property (nonatomic, strong) NSAttributedString *secondPrivacyAgreementNavText;
/*设置授权页点击隐私协议，进入协议页时, 协议页自定义导航栏标题的字体，
 当agreementNavText、secondPrivacyAgreementNavText、
 firstPrivacyAgreementNavText存在时不生效
 */
@property (nonatomic, strong) UIFont *agreementNavTextFont;
/*设置授权页点击隐私协议，进入协议页时, 协议页自定义导航栏标题的颜色，
 当agreementNavText、secondPrivacyAgreementNavText、
 firstPrivacyAgreementNavText存在时不生效
*/
@property (nonatomic, strong) UIColor *agreementNavTextColor;
/*协议页导航栏返回按钮图片*/
@property (nonatomic, strong) UIImage *agreementNavReturnImage;

/**授权页弹出方式,
 弹窗模式下不支持 UIModalTransitionStylePartialCurl*/
@property (nonatomic,assign) UIModalTransitionStyle  modalTransitionStyle;

/*关闭授权页是否有动画。默认YES,有动画。参数仅作用于以下两种情况：
 1、一键登录接口设置登录完成后，自动关闭授权页
 2、用户点击授权页关闭按钮，关闭授权页
 */
@property (nonatomic, assign) BOOL dismissAnimationFlag;

@end

NS_ASSUME_NONNULL_END
