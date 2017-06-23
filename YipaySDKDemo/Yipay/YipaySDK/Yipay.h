//
//  Yipay.h
//  xkwpay
//
//  Created by YuAng on 2017/4/11.
//  Copyright © 2017年 com.xkw.pay.fun. All rights reserved.
//

////////////////////////////////////////////////////////
///////////////// 学科网标准版本支付SDK ///////////////////
/////////// version:1.0.0  motify:2017.04.18 ///////////
////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Order.h"


//kDtmall_CreateOrder_Url 具体app：将该URL替换为当前App的后台创建签名订单接口 YuAng
#define kDtmall_CreateOrder_Url         @"http://10.1.22.32:8088/demo/createorder"

//对调以下俩个URL值可以进入测试流程 YuAng
#define CASHIER_BASE_URL                @"http://cashier.xkw.com"
#define CASHIER_TEST_URL                @"http://10.1.22.32:80"

#define kNoChannel                      @"请选择支付方式"

/* 支付宝支付 YuAng */
#define kAliPay                         @"alipay_app"
#define kAliAppId                       @"com.xkw.pay.fun"

/* 微信支付 YuAng */
#define kWXPay                          @"wx"
#define kWXAppId                        @"wxfe940f89a86a970c"

#define kAppName                        @"app_xysc"
#define kSetChannelSureNotification     @"SetChannelSure"               //在当前支付渠道获取到支付凭证时发送该通知：用来锁定该渠道 YuAng
#define kOrderStatusAfterUseThirdPay    @"OrderStatusAfterUseThirdPay"  //在第三方支付的回调方法里发送该通知：统一处理了错误信息 YuAng

@interface Yipay : NSObject

+(void)registerAppForWX;

/**
 通过app订单信息完成支付流程

 @param order app订单信息
 @param vc 发起的控制器
 */
+(void)payOrder:(Order *_Nullable)order vc:(UIViewController *_Nullable)vc;

/**
 第三方回调结果处理

 @param url 来自appdelegate代理方法
 @return 成功或失败
 */
+(BOOL)yipayOpenURL:(NSURL *_Nonnull)url;

@end

@interface Yipay (Tools)

+(void)postWithURLStrig:(NSString *_Nonnull)urlString params:(NSDictionary *_Nonnull)params
      completionHandler:(void (^_Nullable)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

+(void)hideAlert;
+(void)showAlertWait;
+(void)showAlertMessage:(NSString*_Nullable)msg;
@end


