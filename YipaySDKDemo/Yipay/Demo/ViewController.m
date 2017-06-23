//
//  ViewController.m
//  xkwpay
//
//  Created by YuAng on 2017/4/10.
//  Copyright © 2017年 com.xkw.pay.fun. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ClientOrder.h"
#import "Order.h"

#define KBtn_width        200
#define KBtn_height       40
#define KXOffSet          (self.view.frame.size.width - KBtn_width) / 2
#define KYOffSet          20

#define kWaiting          @"正在获取支付凭据,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

#define kPlaceHolder      @"支付金额"
#define kMaxAmount        9999999


@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic,retain) UITextField *mTextField;
@property (nonatomic,strong) UIButton *currentBtn;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) ClientOrder *order;
@property (nonatomic,strong) Order *s_order;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:)
                                                 name:kSetChannelSureNotification object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"学科网支付";
    [self appendUI];
    [self clientOrder];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setOlnyBtn:self.currentBtn];
}

#pragma mark - 支付操作 2017年04月14日08:42:27 YuAng

-(void)payAction:(UIButton *)btn {
    _currentBtn = btn;
    if (btn.tag == 5) {
        self.order.channel = kAliPay;
    }
    else if (btn.tag == 6) {
        self.order.channel = kWXPay;
    }
    else {
        self.order.channel = @"";
    }
    [self loadOrder];
}

-(void)loadOrder {
    [Yipay showAlertWait]; //@"正在获取%@支付凭据\n请稍后..."
    if (self.s_order) {
        [Yipay payOrder:self.s_order vc:self];
        return;
    }
    NSDictionary *clientOrder = [self.order postDictionaryForSign];
    if (!clientOrder) {
        [Yipay showAlertMessage:@"😞 请求参数为空"];
        return;
    }
    [Yipay postWithURLStrig:kDtmall_CreateOrder_Url params:clientOrder
            completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (!error) {
                    Order *order = [Order modelWithData:data];
                    if (order.body) {
                        order.channel = self.order.channel;
                        self.s_order = order;
                        [Yipay payOrder:order vc:self];
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if ([NSThread isMainThread]) {
                                [Yipay showAlertMessage:@"订单创建失败"];
                            }
                        });
                    }
                }
                else {
                    NSLog(@"😞 请求错误%@",error);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([NSThread isMainThread]) {
                            [Yipay showAlertMessage:error.localizedDescription];
                        }
                    });
                }
            }];
}

-(void)clientOrder {
    self.order = [ClientOrder testOrder];
    self.s_order = nil;
}

#pragma mark - 内部方法 2017年04月14日08:42:35 YuAng
-(void)updateData:(NSNotification *)notify {
    if (notify.object) { //凭证生成后，只保留当前支付按钮可用 YuAng
        self.order.channel = notify.object;
        [self setOlnyBtn:self.currentBtn];
    }
}

- (void)okButtonAction:(id)sender
{
    [_mTextField resignFirstResponder];
    [self setNewOrder];
}

- (void) textFieldDidChange:(UITextField *) textField
{
    [self setNewOrder];
    NSString *text = textField.text;
    self.order.fee = text;
}

-(void)setNewOrder {
   // [[Yipay sharePayManager] clearOrder];
    [self setOlnyBtn:nil]; //新订单恢复支付按钮 YuAng
    [self clientOrder];
}

-(void)setOlnyBtn:(UIButton *)btn {
    if (btn) {
        if(btn.tag == 4) {
            if ([self.order.channel isEqualToString:kAliPay]) {
                btn = [self.view viewWithTag:5];
            }
            else if ([self.order.channel isEqualToString:kWXPay]) {
                btn = [self.view viewWithTag:6];
            }
            else {
                return;
            }
        }
        for (NSInteger i = 4; i <8; i++) {
            UIButton *abtn = [self.view viewWithTag:i];
            abtn.enabled = (abtn == btn);
        }
    }
    else {
        for (NSInteger i = 4; i <8; i++) {
            UIButton *abtn = [self.view viewWithTag:i];
            abtn.enabled = YES;
        }
    }
}

#pragma mark - 准备工作 2017年04月13日13:58:52 YuAng
-(void)appendUI {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setScrollEnabled:YES];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    UIImage *headerImg = [UIImage imageNamed:@"home.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:headerImg];
    [imgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imgView.tag = 1;
    [scrollView addSubview:imgView];
    
    _mTextField = [[UITextField alloc] init];
    _mTextField.borderStyle = UITextBorderStyleRoundedRect;
    _mTextField.backgroundColor = [UIColor whiteColor];
    _mTextField.placeholder = kPlaceHolder;
    _mTextField.text = @"1";
    _mTextField.keyboardType = UIKeyboardTypeNumberPad;
    _mTextField.returnKeyType = UIReturnKeyDone;
    _mTextField.delegate = self;
    [_mTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _mTextField.tag = 2;
    [scrollView addSubview:_mTextField];
    
    UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneButton setTitle:@"OK" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton.layer setMasksToBounds:YES];
    [doneButton.layer setCornerRadius:8.0];
    [doneButton.layer setBorderWidth:1.0];
    [doneButton.layer setBorderColor:[UIColor grayColor].CGColor];
    doneButton.tag = 3;
    [scrollView addSubview:doneButton];
    
    NSArray *btnArray = @[@"确认付款",@"支付宝",@"微信"];
    
    [btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setTitle:btnArray[idx] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(payAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:8.0];
        [btn.layer setBorderWidth:1.0];
        [btn.layer setBorderColor:[UIColor grayColor].CGColor];
        btn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
        btn.tag = (idx + 4);
        [scrollView addSubview:btn];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:self.scrollView.subviews.count];
    CGRect viewRect = [[UIScreen mainScreen] bounds];
    CGRect windowRect = viewRect;
    UIImage *headerImg = [UIImage imageNamed:@"home.png"];
    CGFloat imgViewWith = windowRect.size.width * 0.9;
    CGFloat imgViewHeight = headerImg.size.height * imgViewWith / headerImg.size.width;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:headerImg];
    [imgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    CGFloat imgx = windowRect.size.width/2-imgViewWith/2;
    CGRect imgFrame = CGRectMake(imgx, KYOffSet, imgViewWith, imgViewHeight);
    CGRect textFiledFrame = CGRectMake(imgx, KYOffSet+imgViewHeight+40, imgViewWith-40, 40);
    CGRect doneBtnFrame = CGRectMake(imgx+imgViewWith-35, KYOffSet+imgViewHeight+40, 40, 40);

    [muArray addObject:NSStringFromCGRect(imgFrame)];
    [muArray addObject:NSStringFromCGRect(textFiledFrame)];
    [muArray addObject:NSStringFromCGRect(doneBtnFrame)];
    NSArray *btnArray = @[@"收银台",@"支付宝",@"微信"];
    [btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect selectBtnFrame = CGRectMake(imgx, KYOffSet+imgViewHeight+90 + (idx*50), imgViewWith, KBtn_height);
        [muArray addObject:NSStringFromCGRect(selectBtnFrame)];
    }];
    self.scrollView.frame = viewRect;
    [muArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.scrollView viewWithTag:(idx + 1)].frame = CGRectFromString(obj);
    }];
    
    CGRect lastFrrame = CGRectFromString(muArray.lastObject);
    [self.scrollView setContentSize:CGSizeMake(viewRect.size.width, CGRectGetMaxY(lastFrrame) + 64)];
}

@end

