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
@property (nonatomic,assign) CGFloat logoWidth;
/**LOGO图片高度*/
@property (nonatomic,assign) CGFloat logoHeight;
/**LOGO图片隐藏*/
@property (nonatomic,assign) BOOL logoHidden;



//MARK:登录按钮************

/**登录按钮文本*/
@property (nonatomic,strong) NSAttributedString *logBtnText;
/**登录按钮背景图片添加到数组(顺序如下)
 @[激活状态的图片,失效状态的图片,高亮状态的图片]
 注意:当customPrivacyAlertViewBlock不为空，并且隐私栏为选中时，失效状态的图片设置无效
 */
@property (nonatomic,copy) NSArray *logBtnImgs;

//MARK:号码框设置************
/**手机号码富文本属性 */
@property (nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *numberTextAttributes;

//MARK:隐私条款******务必按顺序设置******

/**复选框未选中时图片*/
@property (nonatomic,strong) UIImage *uncheckedImg;
/**复选框选中时图片*/
@property (nonatomic,strong) UIImage *checkedImg;

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
/**隐私条款行距，默认跟随系统*/
@property (nonatomic,assign) CGFloat privacyLineSpacing;
/**隐私条款拼接文本数组，数组限制4个NSString对象，否则无效
 默认文本1为：”登录即同意“，文本2:”和“，文本3：”、“，文本4：”并使用本机号码登录“
 设置后，隐私协议栏文本修改为 文本1 + 运营商默认协议名称 + 文本2 + 开发者协议名称1 + 文本3 + 开发者协议文本2 + 文本4
 */
@property (nonatomic,strong) NSArray <NSString *>* privacyComponents;
/**隐私条款check框默认状态 默认:NO */
@property (nonatomic,assign) BOOL privacyState;


@end

NS_ASSUME_NONNULL_END
