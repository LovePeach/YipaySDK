//
//  ClientOrder.m
//  Yipay
//
//  Created by YuAng on 2017/4/18.
//  Copyright © 2017年 com.xkw.pay.fun. All rights reserved.
//

#import "ClientOrder.h"

@implementation ClientOrder
+(instancetype)testOrder {
    ClientOrder *order = [ClientOrder new];
    order.subject = @"高等项目反应理论";
    order.fee = @"1";
    order.seller = @"seller";
    order.body = @"商品描述";
    order.channel = @"";
    return order;
}

+(instancetype)testOrderWithName:(NSString *)name price:(NSString *)price {
    ClientOrder *order = [ClientOrder new];
    order.subject = name;
    order.fee = price;
    order.channel = @"";
    return order;
}

-(NSDictionary *)postDictionaryForSign {
    NSDictionary *dict = @{@"fee": self.fee,@"body": self.body,@"seller":self.seller,@"subject": self.subject,@"channel": self.channel};
    return dict;
}
@end
