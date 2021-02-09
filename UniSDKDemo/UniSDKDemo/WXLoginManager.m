//
//  WXLoginManager.m
//  UniSDKDemo
//
//  Created by 乔春晓 on 2021/2/4.
//  Copyright © 2021 乔春晓. All rights reserved.
//

#import "WXLoginManager.h"

static WXLoginManager *manager;

@implementation WXLoginManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

+ (instancetype)shareManager {
    
    return [[self alloc] init];
}

- (id)copyWithZone:(NSZone *)zone {
    return manager;
}

- (id)mutableCopy {
    return manager;
}

- (void)wxLogin{
    if ([WXApi isWXAppInstalled]) {
        [self wechatLogin];
    } else {
        !self.loginResultBlock ? : self.loginResultBlock(WXLoginResult_WXUninstalled, @"微信不可用");
    }
}

- (void)wechatLogin {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"wx_oauth_authorization_state";
    [WXApi sendReq:req completion:^(BOOL success) {
        NSLog(@"wechatLogin : %d",success);
        if (!success) {
            !self.loginResultBlock ? : self.loginResultBlock(WXLoginResult_ReqFail, @"sendReq Fail");
        }
    }];
}

-(void)onReq:(BaseReq*)reqonReq {
    NSLog(@"%@",reqonReq);
}

// 授权后回调
- (void)onResp:(BaseResp *)resp {
    // 向微信请求授权后,得到响应结果
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *temp = (SendAuthResp *)resp;
        if (temp && temp.code) {
            NSLog(@"微信登录成功，发送后台验证===code=>%@",temp.code);
            !self.loginResultBlock ? : self.loginResultBlock(WXLoginResult_Success,@"微信登录成功");
        }else {
            NSString *msg = @"temp or code is nil";
            NSLog(@"%@",msg);
            !self.loginResultBlock ? : self.loginResultBlock(WXLoginResult_RespFail,@"temp or code is nil");
        }
    }else {
        NSLog(@"resp isnot the type of SendAuthResp");
        !self.loginResultBlock ? : self.loginResultBlock(WXLoginResult_RespFail,@"resp isnot the type of SendAuthResp");
    }
    
    
}

@end
