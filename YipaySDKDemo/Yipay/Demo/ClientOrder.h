//
//  ClientOrder.h
//  Yipay
//
//  Created by YuAng on 2017/4/18.
//  Copyright © 2017年 com.xkw.pay.fun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientOrder : NSObject

@property (nonatomic,copy) NSString *fee;
@property (nonatomic,copy) NSString *seller;
@property (nonatomic,copy) NSString *body;
@property (nonatomic,copy) NSString *subject;

@property (nonatomic,copy) NSString *channel; //支付渠道 YuAng

+(instancetype)testOrder;

+(instancetype)testOrderWithName:(NSString *)name price:(NSString *)price;

-(NSDictionary *)postDictionaryForSign;
@end
