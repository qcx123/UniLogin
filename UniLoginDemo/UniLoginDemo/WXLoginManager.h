//
//  WXLoginManager.h
//  UniSDKDemo
//
//  Created by 乔春晓 on 2021/2/4.
//  Copyright © 2021 乔春晓. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    WXLoginResult_Success = 0,
    WXLoginResult_ReqFail,
    WXLoginResult_RespFail,
    WXLoginResult_WXUninstalled
} WXLoginResult;

@interface WXLoginManager : NSObject<WXApiDelegate>

@property (copy, nonatomic) void (^loginResultBlock)(WXLoginResult loginResult, NSString *msg);

+ (instancetype)shareManager;

- (void)wxLogin;
@end

NS_ASSUME_NONNULL_END
