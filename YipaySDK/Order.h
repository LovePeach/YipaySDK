//
//  Order.h
//  Yipay
//
//  Created by YuAng on 2017/4/18.
//  Copyright © 2017年 com.xkw.pay.fun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface Order : NSObject

@property (nonatomic,copy) NSString *body;
@property (nonatomic,copy) NSString *subject;

@property (nonatomic,copy) NSString *_Nullable channel; //支付渠道 YuAng
@property (nonatomic,copy) NSString *app_id;
@property (nonatomic,copy) NSString *extra;
@property (nonatomic,copy) NSString *order_no;
@property (nonatomic,copy) NSString *seller_id;
@property (nonatomic,copy) NSString *sign;
@property (nonatomic,copy) NSString *sign_type;
@property (nonatomic,copy) NSString *timestamp;
@property (nonatomic,assign) NSInteger amount;
@property (nonatomic,assign) NSInteger time_expire;

-(NSDictionary *)postDictionaryForCredential;

+(instancetype _Nullable)modelWithData:(NSData * _Nullable)data;
@end
NS_ASSUME_NONNULL_END

@interface NSObject (Json)

/**
 根据NSData或NSString转化为模型 YuAng
 
 @param json json格式的字符串或NSData
 @return 指定一个模型
 */
+(instancetype _Nullable )modelWithJosn:(id _Nullable )json;

/**
 根据NSData或NSString转化为模型 YuAng
 
 @param json json格式的字符串或NSData
 @return 指定一个模型数组
 */
+(NSArray *_Nullable)modelsWithJosn:(id _Nullable )json;


/**
 根据NSData或NSString转化为字典 YuAng
 
 @param jsonData json格式的字符串或NSData
 @return 一个字典
 */
+(nullable id)dictionaryWithJsonString:(id _Nullable )jsonData;


/**
 如果字典里有中文，保证打印出中文 YuAng
 
 @param dict 目标字典
 */
+(void)logDict:(NSDictionary *_Nullable)dict;

@end
