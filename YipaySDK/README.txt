重要!-YuAng

YipaySDK 1.0.0

本SDK主要提供以下方法

[1]+(void)payOrder:(Order *_Nullable)order vc:(UIViewController *_Nullable)vc; //具体使用方法参见Yipay.h

--- 微信支付相关配置 ---
[1]iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。
受此影响，当你的应用在iOS 9中需要使用微信SDK的相关能力（分享、收藏、支付、登录等）时，需要在“Info.plist”里增加如下代码：
<key>LSApplicationQueriesSchemes</key>
<array>
<string>weixin</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
[2]微信开放平台新增了微信模块用户统计功能，便于开发者统计微信功能模块的用户使用和活跃情况。开发者需要在工程中链接上:SystemConfiguration.framework, libz.dylib, libsqlite3.0.dylib, libc++.dylib, Security.framework, CoreTelephony.framework, CFNetwork.framework。
[3] 在你的工程文件中选择Build Setting，在"Other Linker Flags"中加入"-Objc -all_load"，在Search Paths中添加 libWeChatSDK.a ，WXApi.h，WXApiObject.h

--- 其他注意点 ---
[1] 具体使用请参看Demo
[2] 支付宝SDK version:15.3.3 
[3] 微信SDK version:1.7.7
