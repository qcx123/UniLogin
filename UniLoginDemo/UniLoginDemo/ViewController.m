//
//  ViewController.m
//  UniLogin
//
//  Created by 乔春晓 on 2019/10/9.
//  Copyright © 2019 乔春晓. All rights reserved.
//

#import "ViewController.h"
#import "NSData+AES.h"
#import "WXLoginManager.h"
#import "UniLogin.h"

#define AppId @"1462c43c1a31453bbaa39dbd949534f2"
#define SecretKey @"32e7cd9f87de4d33"

#define SecretKey_Phone @"745b4715860840ea"

@interface ViewController ()<UniLoginDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textview;

@property (nonatomic,strong)UIDocumentInteractionController *documentController;

@property (nonatomic,assign) BOOL authWindow;
@property (nonatomic,assign) BOOL landscapeleft;
@property (nonatomic,assign) BOOL shouldAuthorVCStatusBarWhite;

@property (nonatomic, strong) YMCustomConfig *customConfig;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@一键登录Demo",[[UniLogin shareInstance] getVersion]];
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tap];
    _authWindow = NO;
    _landscapeleft = NO;
    _shouldAuthorVCStatusBarWhite = YES;
    NSLog(@"networkInfo: %@",[[UniLogin shareInstance] getNetworkInfo]);
}

-(void)tapView {
    [self.view endEditing:YES];
}

- (YMCustomConfig *)createCustomModel:(BOOL)isMini {
    _customConfig = [[YMCustomConfig alloc] init];
    _customConfig.navColor = [UIColor whiteColor];
    _customConfig.navText = @"欢迎登录";
    _customConfig.navTextSize = 20;
    _customConfig.navTextColor = [UIColor darkGrayColor];
    _customConfig.navReturnImg = [UIImage imageNamed:@"返回"];
    
    _customConfig.logoImg = [UIImage imageNamed:@"Logo"];
    _customConfig.logoWidth = 80;
    _customConfig.logoHeight = 80;
    _customConfig.logoHidden = NO;
    
    _customConfig.logBtnText = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:@{NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: [UIFont systemFontOfSize:20]}];
    _customConfig.logBtnImgs = @[[UIImage imageNamed:@"LoginBtnBGImage"],[UIImage imageNamed:@"LoginBtnBGImage"],[UIImage imageNamed:@"LoginBtnBGImage"]];
    
    _customConfig.numberTextAttributes = @{NSForegroundColorAttributeName:UIColor.darkGrayColor,NSFontAttributeName:[UIFont systemFontOfSize:30]};
    
    _customConfig.uncheckedImg = [UIImage imageNamed:@"checkOn"];
    _customConfig.checkedImg = [UIImage imageNamed:@"timg.jpg"];
    _customConfig.appPrivacyOne = @[@"亿美用户协议", @"https://www.baidu.com"];
    _customConfig.appPrivacyTwo = @[@"亿美用户协议2", @"https://www.baidu.com"];
    _customConfig.appPrivacyColor = @[[UIColor blackColor], [UIColor blueColor]];
    _customConfig.privacyTextAlignment = NSTextAlignmentCenter;
    _customConfig.privacyTextFontSize = 12;
    _customConfig.privacyShowBookSymbol = YES;
    _customConfig.privacyComponents = @[@"登录即表明同意", @"以及", @"和", @"进行本机号码登录", ];
    _customConfig.privacyState = YES;
    return _customConfig;
}


/// 移动model设置
- (UACustomModel *)createCMCCModel:(BOOL)isMini {
    /*注意事项:********************************model测试专用******************************************************************
         UACustomModel的 currentVC 必须要传*/
        UACustomModel *model = [self createCustomModel:isMini].cmccModel;
        //1、当前VC 必传 不传会提示调用失败
        model.currentVC = self;
        model.statusBarStyle = self.shouldAuthorVCStatusBarWhite ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
        model.modalPresentationStyle = UIModalPresentationCustom;
    model.numberTextAttributes = @{NSForegroundColorAttributeName:UIColor.darkGrayColor,NSFontAttributeName:[UIFont systemFontOfSize:30]};
    model.presentType = UAPresentationDirectionRight;
    
    if (!isMini) {
        model.numberOffsetY_B = @(self.view.bounds.size.height - 230);
        model.logBtnOffsetY = @(270);
    }
    __weak ViewController *weakSelf = self;
        model.authViewBlock = ^(UIView *customView, CGRect numberFrame , CGRect loginBtnFrame,CGRect checkBoxFrame, CGRect privacyFrame) {
            
            CGFloat status = self.authWindow ? 10 : [[UIApplication sharedApplication]statusBarFrame].size.height;
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20,  status  + (44-30)/2, 20, 20)];
            [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(closeAutoVC) forControlEvents:(UIControlEventTouchUpInside)];
            [customView addSubview:btn];
            
            if (!isMini) {
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.frame.origin.y, 150, 25)];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.font = [UIFont systemFontOfSize:25];
                titleLabel.text = @"欢迎登录";
                [customView addSubview:titleLabel];
                titleLabel.center = CGPointMake(customView.center.x, btn.frame.origin.y + 10);
            }
            
            
            UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
            logo.frame = CGRectMake(0, numberFrame.origin.y - 80, 80, 80);
            logo.center = CGPointMake(customView.center.x, logo.center.y);
            [customView addSubview:logo];
            
            [weakSelf setThirdViewWithCustom:customView isSmall:isMini frame:loginBtnFrame];
        };
//        model.checkTipText = @"请勾选同意服务条款";
        model.privacyState = YES;
        //此处判断是否打开强制横屏开关，或者当前设备已处于横屏状态，则弹窗也横屏弹出。
        if (self.landscapeleft || [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight ) {
            model.faceOrientation = UIInterfaceOrientationLandscapeRight;
        }else if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft){
            model.faceOrientation = UIInterfaceOrientationLandscapeLeft;
        }else{
            model.faceOrientation = UIInterfaceOrientationPortrait;
        }
    
        #pragma mark 隐私条款
//        model.uncheckedImg = [UIImage imageNamed:@"checkOn"];
        //17、隐私条款chexBox选中图片
//        model.checkedImg = [UIImage imageNamed:@"timg.jpg"];
        //18、复选框大小（只能正方形）必须大于12*/
        model.checkboxWH = @30;
        //*19、隐私条款（包括check框）的左右边距*/
        model.appPrivacyOriginLR = @[@10,@30];
        //20、隐私的内容模板
//        model.appPrivacyDemo = [[NSAttributedString alloc]initWithString:@"登录即表明同意&&默认&&以及亿美用户协议和百度协议进行本机号码登录" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Marion" size:13],NSForegroundColorAttributeName:UIColor.blackColor}];
//        NSAttributedString *str1 = [[NSAttributedString alloc]initWithString:@"亿美用户协议" attributes:@{NSLinkAttributeName:@"https://www.qq.com"}];
//        NSAttributedString *str2 = [[NSAttributedString alloc]initWithString:@"百度协议" attributes:@{NSLinkAttributeName:@"https://www.baidu.com"}];
        //21、隐私条款默认协议是否开启书名号
//        model.privacySymbol = YES;
        //23、隐私条款:数组对象
//        model.appPrivacy = @[str1,str2];
        //24、隐私条款名称颜色（协议）
//        model.privacyColor = [UIColor blackColor];
        //25、隐私条款偏移量
//        model.privacyOffsetY = [NSNumber numberWithFloat:(100/2)];
        //26、隐私条款check框默认状态
//        model.privacyState = YES;
        model.webNavReturnImg = [UIImage imageNamed:@"返回"];
        model.webNavColor = [UIColor  whiteColor];
        model.webNavTitleAttrs = @{NSForegroundColorAttributeName:[UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]};
    model.privacyOffsetY_B = @10;
    #pragma mark--是否开启自定义属性设置
    #if 0 //0 为默认界面 ，1为以下设置界面
        
        #pragma mark 自定义控件
        //2、授权界面自定义控件View的Block
        model.authViewBlock = ^(UIView *customView, CGRect numberFrame, CGRect loginBtnFrame, CGRect checkBoxFrame, CGRect privacyFrame) {
            CGFloat status = [[UIApplication sharedApplication]statusBarFrame].size.height;
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, status + (44-30)/2, 20, 20)];
            [btn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(closeAutoVC) forControlEvents:(UIControlEventTouchUpInside)];
            [customView addSubview:btn];
        };
        //3、授权页面推出的动画效果
        model.presentType = 3;
        //4、设置授权界面背景图片
    //    model.authPageBackgroundImage = [UIImage imageNamed:@"timg"];
        //5、loading
        model.authLoadingViewBlock = ^(UIView *loadingView) {
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            [arr addObject:[UIImage imageNamed:@"微博"]];
            [arr addObject:[UIImage imageNamed:@"微信"]];
            [arr addObject:[UIImage imageNamed:@"Logo"]];
            [arr addObject:[UIImage imageNamed:@"checkOn"]];
            [arr addObject:[UIImage imageNamed:@"Logo"]];
            [arr addObject:[UIImage imageNamed:@"Logo"]];
            [arr addObject:[UIImage imageNamed:@"fanhui"]];
            [arr addObject:[UIImage imageNamed:@"timg"]];
            [arr addObject:[UIImage imageNamed:@"WechatIMG16"]];

            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 90, 200, 400)];
            imageView.backgroundColor = [UIColor redColor];
            imageView.animationImages = arr;
            imageView.animationDuration = 3;
            
            [loadingView addSubview:imageView];
            [imageView startAnimating];
        };
        //6、登录按钮修改
        #pragma mark 登录按钮
        model.logBtnText = [[NSAttributedString alloc]initWithString:@"自定义登录按钮" attributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]}];
        //7、按钮偏移量Y
        model.logBtnOffsetY = @150;
        //8、按钮左右边距
        model.logBtnOriginLR = @[@200,@100];
        //9、登录按钮的高h
        model.logBtnHeight = 80;
        //10、授权界面登录按钮三种状态
        UIImage *norMal = [UIImage imageNamed:@"timg"];
        UIImage *invalied = [UIImage imageNamed:@"WechatIMG16"];
        UIImage *highted = [UIImage imageNamed:@"checkOn"];
        model.logBtnImgs = @[norMal,invalied,highted];
        /**11、登录按钮高距离底部的高度*/
    //    model.logBtnOffsetY_B = @10;
        #pragma mark 号码框设置
        //12、号码栏字体大小
//        model.numberText = [[NSAttributedString alloc]initWithString:@"sfdsfd" attributes:@{NSForegroundColorAttributeName:UIColor.orangeColor,NSFontAttributeName:[UIFont systemFontOfSize:30]}];
        //13、号码栏X偏移量
        model.numberOffsetX = @70;
        //14、号码栏Y偏移量
        model.numberOffsetY = @300;
        //15、切换按钮隐藏开关
    //    model.numberOffsetY_B = @30;
        //16、隐私条款uncheckedImg选中图片
        #pragma mark 隐私条款
        model.uncheckedImg = [UIImage imageNamed:@"checkOn"];
        //17、隐私条款chexBox选中图片
        model.checkedImg = [UIImage imageNamed:@"timg.jpg"];
        //18、复选框大小（只能正方形）必须大于12*/
        model.checkboxWH = @30;
        //*19、隐私条款（包括check框）的左右边距*/
        model.appPrivacyOriginLR = @[@100,@122];
        //20、隐私的内容模板
        model.appPrivacyDemo = [[NSAttributedString alloc]initWithString:@"登录&&默认&&本界面并同意授权hdhhhhdhddh腾讯协议和百度协议、进行本机号码登录" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Marion" size:13],NSForegroundColorAttributeName:UIColor.orangeColor}];
        NSAttributedString *str1 = [[NSAttributedString alloc]initWithString:@"腾讯协议" attributes:@{NSLinkAttributeName:@"https://www.qq.com"}];
        NSAttributedString *str2 = [[NSAttributedString alloc]initWithString:@"百度协议" attributes:@{NSLinkAttributeName:@"https://www.baidu.com"}];
        //21、隐私条款默认协议是否开启书名号
        model.privacySymbol = YES;
        //22、隐私条款文字内容的方向:默认是居左
        model.appPrivacyAlignment = NSTextAlignmentLeft;
        //23、隐私条款:数组对象
        model.appPrivacy = @[str1,str2];
        //24、隐私条款名称颜色（协议）
        model.privacyColor = [UIColor blackColor];
        //25、隐私条款偏移量
        model.privacyOffsetY = [NSNumber numberWithFloat:(100/2)];
        //26、隐私条款check框默认状态
        model.privacyState = NO;
        //27、隐私条款Y偏移量(注:此属性为与屏幕底部的距离)
    //    model.privacyOffsetY_B = @33;
        //28、web协议界面导航返回图标(尺寸根据图片大小)
        model.webNavReturnImg = [UIImage imageNamed:@"返回"];
        //29、web协议界面导航标题栏
//        model.webNavText = [[NSAttributedString alloc]initWithString:@"我是协议界面" attributes:@{NSForegroundColorAttributeName:[UIColor yellowColor]}];
        //30、web协议界面导航标题栏颜色
        model.webNavColor = [UIColor redColor];

    #endif

    #pragma mark ----------------------弹窗竖屏:(温馨提示:由于受屏幕影响，小屏幕（5S,5E,5）需要改动字体和另自适应和布局)--------------------
        if (self.authWindow && self.landscapeleft) {
            //⑴居中弹窗 特殊方式 -----务必在设置控件位置时，自行查看各个机型是否正常
            
            //要匹配更多屏幕,此处为控件大小控制设置（建议只更改Logo大小）
            //31、弹窗退出动画
            model.authWindow = YES;
            //32、居中弹窗开关
            //UIModalTransitionStyleCoverVertical, 下推 0
            //UIModalTransitionStyleFlipHorizontal,翻转 1
            //UIModalTransitionStyleCrossDissolve, 淡出 2
            model.modalTransitionStyle = 0;
            //33、自定义窗口弧度
            model.cornerRadius = 15;
            //34、自定义窗口宽-缩放系数(屏幕宽乘以系数) 默认是0.8 其它比例自行配置
            model.scaleW = 0.8;
            //35、自定义窗口高-缩放系数(屏幕高乘以系数) 默认是0.5 其它比例自行配置
            model.scaleH = 0.5;
            model.privacyOffsetY_B = @10;
            //在5、5s、5e下,需要改字体才能适配
            BOOL isSmallScreen = UIScreen.mainScreen.bounds.size.height < 667.0f;
            if (isSmallScreen) {
                model.numberOffsetY = @90;
                model.scaleW = 0.7;
                model.privacyOffsetY = @5;
                
            }
           
        }
    #pragma mark ----------------------弹窗横屏:(温馨提示:由于受屏幕影响，小屏幕（5S,5E,5）需要改动字体和另自适应和布局)--------------------
        else if(self.authWindow &&!self.landscapeleft){
            CGFloat overallScaleH = UIScreen.mainScreen.bounds.size.height/ 375.f;
            CGFloat overallScaleW = UIScreen.mainScreen.bounds.size.width/ 667.f;
            model.authWindow = YES;
            model.cornerRadius = 10;
            model.modalTransitionStyle = 1;
            BOOL isSmallScreen = UIScreen.mainScreen.bounds.size.height < 375.f;
            model.scaleH = 0.7;
            model.scaleW = 0.7;

            model.numberOffsetX = @(-155 * overallScaleW);
            model.logBtnOffsetY = @(110 * overallScaleH);
            model.numberOffsetY = @((110 + (40 - 23.86)/2) * overallScaleH);
            model.privacyOffsetY_B = @(55 * overallScaleH);
            model.authViewBlock = ^(UIView *customView, CGRect numberFrame , CGRect loginBtnFrame,CGRect checkBoxFrame, CGRect privacyFrame) {
                
           
                
                CGFloat subViewH = isSmallScreen ? 45 : 55;
                UIImage *imageS = [UIImage imageNamed:@"Logo"];
                CGFloat imageH = isSmallScreen ? 30 : 40;
                CGFloat widthI = imageS.size.width / imageS.size.height * imageH;
                UIImageView *imageV = [[UIImageView alloc]initWithImage:imageS];
                imageV.frame = CGRectMake(10, 10, widthI, imageH);
                [customView addSubview:imageV];
                
                
    //            CGFloat status = [[UIApplication sharedApplication]statusBarFrame].size.height;
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(customView.frame.size.width - 20 - 10, (imageH-20)/2 + 10, 20, 20)];
                [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(closeAutoVC) forControlEvents:(UIControlEventTouchUpInside)];
                [customView addSubview:btn];
                
                UIView *line = [[UIView alloc]init];
                line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
                line.frame = CGRectMake(0, subViewH, customView.frame.size.width,1);
                [customView addSubview:line];
                
                UIView *thirdView = [[UIView alloc]init];
                thirdView.frame = CGRectMake(0, customView.frame.size.height - subViewH, customView.frame.size.width, subViewH);
                thirdView.backgroundColor = [UIColor colorWithRed:233/255.f green:234/255.f blue:254/255.f alpha:1];
                
                [customView addSubview:thirdView];
                
                //自定义------控件（仅供参考）
                //        CGFloat screenh = customView.frame.size.height;
                UIButton *btnWeChat = [self setBtnWith:@"微信"];
                UIButton *btnQQ = [self setBtnWith:@"qq"];
                UIButton *btnWebo = [self setBtnWith:@"微博"];
                [btnWeChat setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                [btnQQ setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                [btnWebo setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                
                UILabel *label = [[UILabel alloc]init];
                label.text = @"其它登录方式:";
                label.textColor = [UIColor grayColor];
                label.font = [UIFont systemFontOfSize:isSmallScreen ? 12 :15];
                label.textAlignment = NSTextAlignmentLeft;
                CGSize sizeLabel = [label.text sizeWithAttributes:@{NSForegroundColorAttributeName:label.textColor,NSFontAttributeName:label.font}];
                CGRect labelFrame =  label.frame;
                labelFrame.size = sizeLabel;
                label.frame = labelFrame;
                label.frame = CGRectMake(0, 0, thirdView.frame.size.width, label.frame.size.height);
                [thirdView addSubview:label];
                
                CGFloat btnW = subViewH - label.frame.size.height;
                CGFloat margin = 40;
                
                btnWeChat.frame = CGRectMake((thirdView.frame.size.width - 3 *btnW - 2 *margin)/2, CGRectGetMaxY(label.frame),btnW , btnW);
                btnQQ.frame = CGRectMake(CGRectGetMaxX(btnWeChat.frame) + margin, CGRectGetMaxY(label.frame), btnW, btnW);
                btnWebo.frame = CGRectMake(CGRectGetMaxX(btnQQ.frame) + margin, CGRectGetMaxY(label.frame), btnW, btnW);
                [thirdView addSubview:btnWeChat];
                [thirdView addSubview:btnQQ];
                [thirdView addSubview:btnWebo];
                
            };
            
        }
        
    #pragma mark ----------------------边缘弹窗:(温馨提示:authWindow必须为NO,由于受屏幕影响，小屏幕（5S,5E,5）需要改动字体和另自适应和布局)--------------------
        else if(!self.authWindow && !self.landscapeleft && isMini){
//            CGFloat overallScaleH = UIScreen.mainScreen.bounds.size.height/ 667.f;
    //        CGFloat overallScaleW = UIScreen.mainScreen.bounds.size.width/ 375.f;
            //推出动画由model中的presentType来决定
            model.presentType = 0;
            //36、边缘弹窗方式中的VC尺寸
            model.controllerSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height/2);
            model.numberOffsetY_B = @(UIScreen.mainScreen.bounds.size.height/2 - 50);
            model.privacyOffsetY = @((UIScreen.mainScreen.bounds.size.height)/2 - 35);
            __weak ViewController *weakSelf = self;
            model.authViewBlock = ^(UIView *customView, CGRect numberFrame , CGRect loginBtnFrame,CGRect checkBoxFrame, CGRect privacyFrame) {
                
                CGFloat status = 10;
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(40,  status  + (44-30)/2, 20, 20)];
                [btn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(closeAutoVC) forControlEvents:(UIControlEventTouchUpInside)];
                [customView addSubview:btn];
                
                [weakSelf setThirdViewWithCustom:customView isSmall:isMini frame:loginBtnFrame];
                
            };
            
        }
//        UIImage *norMal = [UIImage imageNamed:@"LoginBtnBGImage"];
//        model.logBtnImgs = @[norMal,norMal];
//    model.logBtnText = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:@{NSForegroundColorAttributeName: UIColor.whiteColor, NSFontAttributeName: [UIFont systemFontOfSize:20]}];
    return model;
}

- (void)closeAutoVC {
    [[UniLogin shareInstance] closeUniLoginViewControlerAnimated:NO completion:nil];
    [self showResultData:nil msg:@"CANCLE_LOGIN"];
}

- (void)setThirdViewWithCustom:(UIView *)customView isSmall:(BOOL)isSmallScreen frame:(CGRect)frame{
    
    //自定义------控件（仅供参考）
    CGFloat screenW = customView.frame.size.width;
    CGFloat screenH = customView.frame.size.height;
    UIView *v = [[UIView alloc]init];
    v.frame = CGRectMake(frame.origin.x, CGRectGetMaxY(frame) + 10 , screenW - frame.origin.x * 2, (screenH - CGRectGetMaxY(frame) - 150));
    UIButton *btnWeChat = [self setBtnWith:@"微信"];
    UIButton *btnQQ = [self setBtnWith:@"qq"];
    UIButton *btnWebo = [self setBtnWith:@"微博"];
    
    UIButton *messageLoginBtn = [[UIButton alloc]init];
    messageLoginBtn.frame = CGRectMake(0, 10, v.frame.size.width, isSmallScreen ? 12 :15);
    [messageLoginBtn setTitle:@"短信验证登录" forState:(UIControlStateNormal)];
    messageLoginBtn.titleLabel.font = [UIFont systemFontOfSize:isSmallScreen ? 12 :15];
    [messageLoginBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [messageLoginBtn addTarget:self action:@selector(messageWayLogin:) forControlEvents:(UIControlEventTouchUpInside)];
    [v addSubview:messageLoginBtn];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"其它登录方式";
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:isSmallScreen ? 12 :15];
    label.textAlignment = NSTextAlignmentCenter;
    CGSize sizeLabel = [label.text sizeWithAttributes:@{NSForegroundColorAttributeName:label.textColor,NSFontAttributeName:label.font}];
    CGRect labelFrame =  label.frame;
    labelFrame.size = sizeLabel;
    label.frame = labelFrame;
    label.frame = CGRectMake(0, isSmallScreen ? 82 :85, v.frame.size.width, label.frame.size.height);
    [v addSubview:label];
    
    CGFloat btnW = (v.frame.size.width - label.frame.size.height)/3;
    
    btnWeChat.frame = CGRectMake(0, CGRectGetMaxY(label.frame),btnW , btnW);
    btnQQ.frame = CGRectMake(btnW, CGRectGetMaxY(label.frame), btnW, btnW);
    btnWebo.frame = CGRectMake(btnW * 2, CGRectGetMaxY(label.frame), btnW, btnW);
    [v addSubview:btnWeChat];
    [v addSubview:btnQQ];
    [v addSubview:btnWebo];
    [customView addSubview:v];
    
    [btnWeChat addTarget:self action:@selector(btnWeChatClick) forControlEvents:(UIControlEventTouchUpInside)];
}

/// 联通demo设置
- (ZOAUCustomModel *)createCUCCModel:(BOOL)isMini {
    ZOAUCustomModel *model = [self createCustomModel:isMini].cuccModel;
    if (isMini) {
        model.navBarHidden = YES;
        model.logoImg = [UIImage imageNamed:@"Logo"];
        CGFloat topCustomHeight = 330;
        model.controllerType = PresentController;
        model.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
        UIImage *bgImg = [self imageWithColor:[UIColor colorWithRed:255/255.0 green:248/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height - topCustomHeight + 30)];
        model.bgImage = bgImg;
        model.modalPresentationStyle = UIModalPresentationOverFullScreen;
        model.privacyOffsetY = -10;
        model.topCustomHeight = topCustomHeight;
        model.stringAfterPrivacy = @"\n";
        model.ifAddPrivacyPageBG = YES;
        model.logoOffsetY = 0;
        model.logoWidth = 35;
        model.logoHeight = 35;
        model.numberOffsetY = 5;
        model.brandOffsetY = 5;
        model.logBtnOffsetY = 5;
        model.logBtnHeight = 20;
        model.logBtnLeading = 100;
        model.swithAccOffsetX = 30;
        model.navReturnImg = [UIImage imageNamed:@"back_1"];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"close" style:0 target:self action:@selector(stopLogining)];
            model.navControl = rightItem;
        });
        [[ZUOAuthManager getInstance]customUIWithParams:model topCustomViews:^(UIView *customView) {

            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(customView.frame.size.width-55, customView.frame.size.height-25, 50, 20);
            button.backgroundColor = UIColor.redColor;
            [button setTitle:@"关闭" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(stopLogining) forControlEvents:UIControlEventTouchUpInside];
            [customView addSubview:button];
        } bottomCustomViews:nil];
        
        // 第二种
        /**
        model.controllerType = PresentController;
        model.backgroundColor=[UIColor colorWithWhite:0 alpha:0];
        model.bgImage = [UIImage imageNamed:@"1234"];
        model.modalPresentationStyle = UIModalPresentationOverFullScreen;
        model.navBarHidden = YES;
        model.privacyOffsetY = 100;
        model.stringAfterPrivacy = @"\n";
        model.ifAddPrivacyPageBG = YES;
        model.navReturnImg = [UIImage imageNamed:@"back_1"];
         //        dispatch_async(dispatch_get_main_queue(), ^{
         //            UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:@"close" style:0 target:self action:@selector(stopLogining:)];
         //            model.navControl = rightItem;
         //        });
             
        [[ZUOAuthManager getInstance]customUIWithParams:model topCustomViews:^(UIView *customView) {
                 
             UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
             button.frame = CGRectMake(250, 60, 30, 30);
             button.backgroundColor = UIColor.redColor;
             [button setTitle:@"关闭" forState:UIControlStateNormal];
             [button addTarget:self action:@selector(stopLogining) forControlEvents:UIControlEventTouchUpInside];
             [customView addSubview:button];
                 
        } bottomCustomViews:nil];
         */
    }else {
        model.modalPresentationStyle = UIModalPresentationOverFullScreen;
        model.statusBarStyle = UIStatusBarStyleLightContent;
        model.statusBarStyleInWebView = UIStatusBarStyleDefault;
        model.navBarHidden = NO;
            
            
        model.backgroundColor = [UIColor whiteColor];
//        model.bgImage = [self createImageWithColor:UIColor.yellowColor];

        model.navBottomLineHidden = YES;
//        model.navBgColor = UIColor.whiteColor;
//        model.navText = @"欢迎登录";
//        model.navTextFont = [UIFont boldSystemFontOfSize:25];
//        model.navTextColor = UIColor.darkGrayColor;
            
        model.topCustomHeight = 5;
//        model.logoImg = [UIImage imageNamed:@"Logo"];
        model.logoWidth = 80;
        model.logoHeight = 80;
        model.logBtnOffsetY = 0;
                
        model.appNameHidden = YES;
        model.appNameColor = UIColor.redColor;
        model.appNameFont = [UIFont boldSystemFontOfSize:23];;
        model.appNameOffsetY = 5;
                
//        model.numberColor = UIColor.darkGrayColor;
//        model.numberFont = [UIFont boldSystemFontOfSize:25];;
        model.numberOffsetY = 0;
                
        model.brandColor = UIColor.redColor;
        model.brandFont = [UIFont boldSystemFontOfSize:10];;
        model.brandOffsetY = 5;
        model.brandHidden = YES;
                
//        model.logBtnText = @"一键登录";
//        model.logBtnTextFont =[UIFont boldSystemFontOfSize:20];;
//        model.logBtnTextColor = UIColor.whiteColor;
        model.logBtnOffsetY = 50;
        model.logBtnRadius = 10;
//        model.logBtnImageSelected = [UIImage imageNamed:@"LoginBtnBGImage"];
//        model.logBtnImageDeselected = [UIImage imageNamed:@"LoginBtnBGImage"];
        model.logBtnLeading = 100;
        model.logBtnHeight = 50;
    //    model.logBtnImageSelected = [UIImage imageNamed:@"btn_uncheck"];
    //    model.logBtnImageDeselected = [UIImage imageNamed:@"btn_check"];
                
                
        model.swithAccTextColor = UIColor.blueColor;
        model.swithAccTextFont  =[UIFont boldSystemFontOfSize:15];;
        model.swithAccOffsetY = 20;
        model.swithAccOffsetX = 0;
        model.switchText = @"自定义其他登录方式按钮";
        model.swithAccHidden = YES;
        
//        model.stringBeforeDefaultPrivacyText = @"登录即表明同意";
//        model.defaultPrivacyName = @"《中国联通服务协议》";
//        model.stringBeforeAppFPrivacyText = @"以及";
//        model.stringBeforeAppSPrivacyText = @"和";
//        model.stringAfterPrivacy = @"进行";
//        model.stringAfterAppName = @"本机号码登录";
//        model.appFPrivacyText=@"《亿美用户协议》";
//        model.appFPrivacyUrl = @"http://www.baidu.com";
//        model.appSPrivacyText=@"《百度协议》";
//        model.appSPrivacyUrl = @"http://www.baidu.com";
//        model.checkBoxHidden= YES;
//        model.loadingText= @"请稍后";
        model.privacyColor = [UIColor blueColor];
        model.privacyTextColor  = [UIColor blackColor];

        //        model.interfaceOrientation = UIInterfaceOrientationPortrait;
                
                //动画
                //用法一
                model.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            //
                //用法二
//        CATransition *animation = [CATransition animation];
//        animation.duration = 0.5;
//        animation.type = @"cube";
//        animation.subtype = kCATransitionFromBottom;
//        model.presentTransition = animation;
//        model.dismissTransition = animation;
            
                
                
        [[ZUOAuthManager getInstance]customUIWithParams:model topCustomViews:^(UIView *customView) {
//            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake(250, 0, 60, 15);
//            button.backgroundColor = UIColor.redColor;
//            [button setTitle:@"自定义按钮" forState:UIControlStateNormal];
//            [customView addSubview:button];
            
        } bottomCustomViews:^(UIView *customView) {
            [self setThirdViewWithCustom:customView isSmall:isMini frame:CGRectMake(50, 0, [UIScreen mainScreen].bounds.size.width - 100, 0)];
        }];
    }
    return model;
}


/// 电信demo设置, 新增的Mini登录页面，无勾选框、弹窗、Logo等控件
- (EAccountOpenPageConfig *)createCTCCModel:(BOOL)isMini {
    EAccountOpenPageConfig *config = [self createCustomModel:isMini].ctccModel;
        
        /*==========================================资源文件名配置示例========================================*/
        //v3.8.3 xib中隐私协议部分变更为UITextView，动态配置代码也更新了，详见后面的示例代码
        //推荐使用v3.8.3最新的隐私协议，接入更加便捷，xib参考EAccountAuthVC_dynamic_textview、EAccountMiniAuthVC_center_textview、EAccountMiniAuthVC_bottom_textview
        if(!isMini){
            config.nibNameOfLoginVC = @"EAccountAuthVC_dynamic_textview";
        } else {
//            config.nibNameOfLoginVC = @"EAccountMiniAuthVC_center_textview";
            config.nibNameOfLoginVC = @"EAccountMiniAuthVC_bottom_textview";
        }
    
    
//    config.logoImg = [UIImage imageNamed:@"Logo"];
    
    //    config.nibNameOfPrivacAgreementVC = @"EAccountWebViewVC_dynamic";
//        config.EAccountBundleName = @"EAccountOpenPageResource";
        
        /*===========================================导航栏配置示例===========================================*/
    //    config.navColor = [UIColor greenColor];
    ////        config.barStyle = UIBarStyleBlack;
        config.navLineColor = [UIColor clearColor];
    //    config.navText = @"测试标题";
    //    config.navTextSize = 28;
    //    config.navTextColor = [UIColor redColor];
    //    config.navGoBackImg_normal = [self readImageByNameFromBundle:@"logo_mini"];
    //    config.navGoBackImg_highlighted = [EAccountOPSDataConfig readImageByNameFromBundle:@"logo_mini"];
        
        /*===========================================logo配置示例===========================================*/
//        config.logoImg = [self readImageByNameFromBundle:@"LOGO"];
//        config.logoOffsetY = 200;
//        config.logoHidden = NO;
//        config.logoWidth = 30;
//        config.logoHeight = 40;
        
        /*===========================================手机号标签配置示例========================================*/
    //    config.numberColor = [UIColor redColor];
    //    config.numberTextSize = 30;
    //    config.numFieldOffsetY = 100;
        
        /*===========================================中部小logo及标签配置示例======================================*/
    //    config.brandLabelOffsetY = 250;
    //    config.brandLabelTextColor = [UIColor blueColor];
    //    config.brandLabelTextSize = 16;
        
        /*===========================================登录按钮配置示例=============================================*/
    //    config.logBtnText = @"按一下";
    //    config.logBtnOffsetY = 120;
    //    config.logBtnTextColor = [UIColor yellowColor];
    //    config.logBtnWidth = 200;
    //    config.logBtnHeight = 30;
    //    config.logBtnTextSize = 12;
    ////        config.logBtnBackground = EACCOUNT_LOGINBUTTON_BACKGROUND_COLOR;
    //    config.logBtnBackground = EACCOUNT_LOGINBUTTON_BACKGROUND_IMAGES;
    //    config.logBtnCornerRadius = 10;
    //    config.logBtnBgColor_normal = [UIColor redColor];
    //    config.logBtnBgColor_disable = [UIColor greenColor];
    //    config.logBtnBgColor_highlighted = [UIColor blueColor];
    //    //@[激活状态的图片,失效状态的图片,高亮状态的图片]
    //    UIImage *buttongImage1 = [self readImageByNameFromBundle:@"189m"];
    //    UIImage *buttongImage2 = [self readImageByNameFromBundle:@"test2"];
    //    UIImage *buttongImage3 = [self readImageByNameFromBundle:@"btn-close"];
    //    NSArray *btnImgs = [NSArray arrayWithObjects:buttongImage1,buttongImage2,buttongImage3, nil];
    //    config.logBtnImgs = btnImgs;
    //    config.loadingImg = [self readImageByNameFromBundle:@"logo_mini"];
        
        /*============================================其他登录方式按钮配置示例=========================================*/
    //    config.otherWayLogBtnText = @"到别的地方";
    //    config.otherWayLogBtnOffsetY = 150;
    //    config.otherWayLogBtnTextColor_normal = [UIColor blueColor];
    //    config.otherWayLogBtnTextColor_highlighted = [UIColor redColor];
    //    config.otherWayLogBtnTextSize = 22;
    //    config.otherWayLogBtnHidden = NO;
        
        /*=============================================勾选按钮 配置示例=============================================*/
    //    config.checkState = EACCOUNT_CHECKSTATE_UNCHECKED;
    //    config.checkBtnImg_unchecked = [self readImageByNameFromBundle:@"btn-close"];
    //    config.checkBtnImg_checked = [self readImageByNameFromBundle:@"goback_sel"];
        
        /*=============================================v3.8.3隐私协议动态配置示例===========================================*/
        
        //字体大小、行间距
    /*
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing= 3;
        NSDictionary *attributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:12],
            NSParagraphStyleAttributeName:paragraphStyle
        };

        EAccountCustomPrivacyAgreement *pa = [[EAccountCustomPrivacyAgreement alloc] init];
        pa.attrStr = [[NSMutableAttributedString alloc] initWithString:@"登录即同意《天翼账号服务与隐私协议》《合作方协议1》和《合作方协议2》并授权[一键登录]获取手机号码" attributes:attributes];
        [pa addAttributeWithUrl:@"https://e.189.cn/sdk/agreement/detail.do?hidetop=true&appKey=" Color:[UIColor redColor] Title:@"《天翼账号服务与隐私协议》" Range:NSMakeRange(5, 13)];
        [pa addAttributeWithUrl:@"https://www.baidu.com" Color:[UIColor orangeColor] Title:@"合作方协议1" Range:NSMakeRange(18, 8)];

        [pa addAttributeWithUrl:@"https://www.sina.com.cn" Color:[UIColor orangeColor] Title:@"合作方协议2" Range:NSMakeRange(27, 8)];
        [pa addAttributeWithUrl:@"" Color:[UIColor greenColor] Title:@"" Range:NSMakeRange(38, 6)];
        //    pa.offsetY = 100;
        config.customPrivacyAgreement = pa;
        */
        
        /** ====== 以下为弹窗确认框隐私协议动态配置示例代码 ====== */
        //字体大小、行间距
//        NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle2.lineSpacing= 10;
//        NSDictionary *attributes2 = @{
//            NSFontAttributeName:[UIFont systemFontOfSize:14],
//            NSParagraphStyleAttributeName:paragraphStyle2
//        };
//
//        EAccountCustomPrivacyAgreement *pa2 = [[EAccountCustomPrivacyAgreement alloc] init];
//        pa2.attrStr = [[NSMutableAttributedString alloc] initWithString:@"同意《天翼账号服务与隐私协议》《合作方协议1》及《合作方协议2》" attributes:attributes2];
//        [pa2 addAttributeWithUrl:@"https://e.189.cn/sdk/agreement/detail.do?hidetop=true&appKey=" Color:[UIColor redColor] Title:@"服务与隐私协议" Range:NSMakeRange(2, 13)];
//        [pa2 addAttributeWithUrl:@"https://www.baidu.com" Color:[UIColor orangeColor] Title:@"合作方协议1" Range:NSMakeRange(15, 8)];
//        [pa2 addAttributeWithUrl:@"https://www.sina.com.cn" Color:[UIColor blueColor] Title:@"合作方协议2" Range:NSMakeRange(24, 8)];
//        //如果是弹窗确认框的隐私协议，务必设置该值为YES
//        pa2.isDialogPrivacy = YES;
//        config.dialogPrivacyAgreement = pa2;
        
        /*==============================================迷你登录框动态配置示例============================================*/
    //    config.miniBoxYPosition = EACCOUNT_MINI_POSITION_TOP;
    //    config.miniBoxWidth = 100;
    //    config.miniBoxHeight = 200;
        
        /*==============================================自定义动画动态配置示例==============================================*/
    //    EACustomAnimatedTransitioning *obj = [[EACustomAnimatedTransitioning alloc] init];
    //    obj.targetEdge = UIRectEdgeTop;
    //    config.AnimatedTransitioningObj = obj;
        
        
        /*==============================================调用打开登录页面接口示例============================================*/
        
        /**v3.7.2新增动态配置接口，多了一个controller参数，openAuthVC为全屏，openMiniAuthVC是Mini框形式
         *支持自定义动画传入
         *注意：Mini登录页面，无勾选框、弹窗、Logo等控件
         */
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //合作方自定义操作
            [EAccountOpenPageSDK customOperationWithEventHandler:^(UIView * _Nonnull view, EAccountHYUiEventHandler *eUiHandler) {
                
                if ([view isKindOfClass:[UIButton class]] && view.tag == config.logBtnTag) {//登录按钮
                    //获取其他view，如checkBtn
                    UIView *checkBtnView = [eUiHandler getViewByTag:config.checkBtnTag];
                    UIButton *checkBtn = nil;
                    if ([checkBtnView isKindOfClass:[UIButton class]]) {
                        checkBtn = (UIButton *)checkBtnView;
                    }
                    
                    if (checkBtn && !checkBtn.isSelected) {//全屏授权页面，用户未勾选同意协议
                        //TODO:自定义操作（弹toast、改变view之类）
                        NSLog(@"未勾选同意协议");
                    } else if ((checkBtn && checkBtn.isSelected) || isMini) {//全屏授权页面，用户已经勾选同意协议。或者是mini授权页面
                        //TODO:自定义操作
                        
                        //让sdk继续执行往下的流程（必须调用）
                        if (eUiHandler.continueExecutionWithParams) {
                            //若传入NO，sdk将会把登录按钮置为不可按状态，文字置为空，并加载loading
                            //若传入YES，sdk不会改变登录按钮的状态
                            eUiHandler.continueExecutionWithParams(NO);
                        }
                    }
                    
                }else if(view.tag == config.otherWayLogBtnTag) {
                    //TODO:自定义操作

                    //让sdk继续执行往下的流程（必须调用）
                    if (eUiHandler.continueExecution) {
                        eUiHandler.continueExecution();
                    }
                }else if(view.tag == 21301) {
                    //TODO:自定义操作
                    NSLog(@"电信自定义按钮tag = %ld",view.tag);
                    [self showResultData:@"自定义按钮" msg:[NSString stringWithFormat:@"tag:%ld",view.tag]];
                    //让sdk继续执行往下的流程（必须调用）
                    if (eUiHandler.continueExecution) {
                        eUiHandler.continueExecution();
                    }
                }if (view.tag == 21302) {
                    [self btnWeChatClick];
                    if (eUiHandler.continueExecution) {
                        eUiHandler.continueExecution();
                    }
                }else {//其他的按钮控件处理，如返回按钮。注意：不处理将无法继续往下流程，如，无法返回
                    //让sdk继续执行往下的流程（必须调用）
                    if (eUiHandler.continueExecution) {
                        eUiHandler.continueExecution();
                    }
                }
            }];
            
        });
    return config;
}

- (IBAction)pressLogin:(id)sender {
//    [self loginWithMini:NO];
    [self newLoginWithMini:NO];
}

- (IBAction)miniLogin:(id)sender {
    [self loginWithMini:YES];
//    [self newLoginWithMini:YES];
}

- (void)loginWithMini:(BOOL)isMini {
    YMCustomConfig *config = [YMCustomConfig new];
    config.cmccModel = [self createCMCCModel:isMini];
    config.cuccModel = [self createCUCCModel:isMini];
    config.ctccModel = [self createCTCCModel:isMini];
    config.ctccMini = isMini;
    [UniLogin shareInstance].delegate = self;
    [[UniLogin shareInstance] loginWithViewControler:self customConfig:config appId:AppId secretKey:SecretKey complete:^(NSString * _Nullable mobile, NSString * _Nullable msg) {
        NSString *decMobile = nil;
        if (mobile) {
            NSLog(@"登录成功");
            decMobile = mobile;
//            decMobile = [self decryptWithStr:mobile];
            [[UniLogin shareInstance] closeUniLoginViewControlerAnimated:NO completion:nil];
        }else {
            NSLog(@"登录失败");
            [[UniLogin shareInstance] closeUniLoginViewControlerAnimated:NO completion:nil];
        }
        [self showResultData:decMobile msg:msg];
    }];
}

// v5版本新增的分布登录方法的调用方式，更加容易控制
- (void)newLoginWithMini:(BOOL)isMini {
    
    [UniLogin shareInstance].delegate = self;
    [[UniLogin shareInstance] initWithAppId:AppId secretKey:SecretKey complete:^(BOOL isSuccess, NSString * _Nonnull msg) {
        if (isSuccess) {
            [[UniLogin shareInstance] prepareLoginWithTimeout:30 complete:^(BOOL isSuccess, NSString * _Nonnull msg, NSDictionary * _Nullable result) {
                if (isSuccess) {
                    YMCustomConfig *config = [YMCustomConfig new];
                    config.cmccModel = [self createCMCCModel:isMini];
                    config.cuccModel = [self createCUCCModel:isMini];
                    config.ctccModel = [self createCTCCModel:isMini];
                    config.ctccMini = isMini;
                    [[UniLogin shareInstance] openAtuhVCWithConfig:config timeout:30 controller:self complete:^(NSString * _Nullable mobile, NSString * _Nullable msg, id  _Nullable result) {
                        NSString *decMobile = nil;
                        if (mobile) {
                            NSLog(@"登录成功");
                            decMobile = mobile;
//                            decMobile = [self decryptWithStr:mobile];
                            [[UniLogin shareInstance] closeUniLoginViewControlerAnimated:NO completion:nil];
                        }else {
                            NSLog(@"登录失败 %@",result);
                            [[UniLogin shareInstance] closeUniLoginViewControlerAnimated:NO completion:nil];
                        }
                        [self showResultData:decMobile msg:msg];
                    }];
                }else {
//                    [self showResultData:@"预登录失败" msg:msg];
                    [self showResultData:@"预登录失败" msg:msg dict:result];
                }
            }];
        }else {
            [self showResultData:@"初始化失败" msg:msg];
        }
    }];
}

- (void)ctccCustomBtnClick:(NSString *)senderTag {
    NSLog(@"电信自定义按钮tag = %@",senderTag);
    [self showResultData:@"自定义按钮" msg:[NSString stringWithFormat:@"tag:%@",senderTag]];
    if ([senderTag integerValue] == 21302) {
        [self btnWeChatClick];
    }
}

- (void)stopLogining {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ZUOAuthManager getInstance]interruptTheCULoginFlow:0 ifDisapperTheShowingLoginPage:1 cancelTheNextAuthorizationPageToPullUp:0];
    });
    [self showResultData:nil msg:@"CANCLE_LOGIN"];
}

//- (NSString *)decryptWithStr:(NSString *)str {
//    NSData* data = [self convertHexStrToData:str];
//    data = [data AES128DecryptWithKey:SecretKey_Phone];
//    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    return result;
//}

-(void)showResultData:(NSString * _Nullable )data msg:(NSString*)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textview.text=[NSString stringWithFormat:@"%@\nmobile=%@ msg=%@",self.textview.text,data,msg];
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"结果" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
    });
}

-(void)showResultData:(NSString * _Nullable )data msg:(NSString*)msg dict:(NSDictionary * _Nullable)dict
{
    NSString *jsonStr = nil;
    if (dict) {
        jsonStr = [self convertToJsonData:dict];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textview.text=[NSString stringWithFormat:@"%@\nmobile=%@ msg=%@ result = %@",self.textview.text,data,msg,jsonStr];
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"结果" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
    });
}

// 16进制 --> data
- (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}


// 根据颜色生成UIImage
- (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size{
    // 开始画图的上下文
    UIGraphicsBeginImageContext(self.view.frame.size);
    // 设置背景颜色
//    [[UIColor colorWithRed:255/255.0 green:248/255.0 blue:220/255.0 alpha:1] set];
    [color set];
    // 设置填充区域
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    // 返回UIImage
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    //改变该图片的方向
    UIImage *backImage = [UIImage imageWithCGImage:image.CGImage
                                    scale:image.scale
                              orientation:UIImageOrientationDown];
    return backImage;
}

- (UIButton *)setBtnWith:(NSString *)imageName{
    UIButton *btn = [[UIButton alloc]init];
    UIImage *img = [UIImage imageNamed:imageName];
    if (img) {
        [btn setImage:img forState:(UIControlStateNormal)];
    }else {
        [btn setTitle:imageName forState:(UIControlStateNormal)];
    }
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(30, 30, 30, 30)];
    [btn addTarget:self action:@selector(otherWayLogin:) forControlEvents:(UIControlEventTouchUpInside)];
    return btn;
}

- (void)otherWayLogin:(UIButton *)btn {
//    [[UniLogin shareInstance] closeUniLoginViewControlerAnimated:YES completion:nil];
    [self showResultData:nil msg:@"CHANGE_LOGIN_TYPE"];
}

- (void)messageWayLogin:(UIButton *)btn {
    [[UniLogin shareInstance] closeUniLoginViewControlerAnimated:YES completion:nil];
    [self showResultData:nil msg:@"CHANGE_LOGIN_TYPE"];
}

- (UIImage *)readImageByNameFromBundle:(NSString *)name {
    UIImage *image = nil;
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"EAccountOpenPageResource" ofType:@"bundle"];
    NSString *imagePath = [NSString pathWithComponents:@[bundlePath, name]];
    image = [UIImage imageNamed:imagePath];
    return image;
}
// 字典转json字符串方法

-(NSString *)convertToJsonData:(NSDictionary *)dict {
     NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

#pragma mark WX

- (void)btnWeChatClick {
    WXLoginManager *manager = [WXLoginManager shareManager];
    manager.loginResultBlock = ^(WXLoginResult loginResult, NSString * _Nonnull msg) {
        [self showResultData:nil msg:msg];
        if (loginResult == WXLoginResult_Success) {
            [[UniLogin shareInstance] closeUniLoginViewControlerAnimated:NO completion:nil];
        }
    };
    [manager wxLogin];
}

@end


