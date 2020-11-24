//
//  JFWkWebView.m
//  cheyijia
//
//  Created by Jeff Xu on 2019/10/14.
//  Copyright © 2019 Jeff Xu. All rights reserved.
//

#import "JFWkWebView.h"
#import <WebKit/WebKit.h>
@interface JFWkWebView ()<WKUIDelegate>

@property (nonatomic , strong) WKWebView *webview;
@property (nonatomic , strong) UIProgressView *progressView;

@end

@implementation JFWkWebView


- (void)viewDidLoad {
    [super viewDidLoad];

    [self navtion];
    [self webbuild];
}

- (void)backBtnClicked
{
    if ([self.webview canGoBack]) {
        [self.webview goBack];
    }else
    {
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.urlStr) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
        [_webview loadRequest:request];
    }
}

///处理alert事件
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        if (object == _webview) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.webview.estimatedProgress animated:YES];
            
            if(self.webview.estimatedProgress >= 1.0f) {
                
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.webview) {
            self.title = self.webview.title;  //JFTip 显示子网页标题
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
    [_webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webview removeObserver:self forKeyPath:@"title"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navtion{
    
    UIView *navtion = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, kNavBarAndStatusBarHeight)];
    navtion.backgroundColor = CThemeColor;
    UILabel *label = [[UILabel alloc]init];
    label.text = self.pageTitle;
    [label setFont:FontNav];
    
    label.textColor = [UIColor whiteColor];
    label.frame = CGRectMake(0, kStatusBarHeight,KScreenWidth,44);
    // label.center = navtion.center;
    label.textAlignment = NSTextAlignmentCenter;
    [navtion addSubview:label];
    
    UIImageView *returnBtn = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back_icon.png"]];
    returnBtn.frame = CGRectMake(8,11 + kStatusBarHeight,22,22);
    [navtion addSubview:returnBtn];
    
    UIButton *btnttttt = [UIButton buttonWithType:UIButtonTypeCustom];
    btnttttt.backgroundColor = [UIColor clearColor];
    [btnttttt addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    btnttttt.frame = CGRectMake(0,0,100,88);
    [navtion addSubview:btnttttt];
    [self.view addSubview:navtion];
}

- (void)webbuild{
    _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarAndStatusBarHeight, KScreenWidth,KScreenHeight-kNavBarAndStatusBarHeight)];
    [self.view addSubview:_webview];
    _webview.UIDelegate = self;
    
    [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [_webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 2)];
    _progressView.progressTintColor = [UIColor blueColor];
    _progressView.trackTintColor = CThemeColor;
    [_webview addSubview:_progressView];
    
}
@end




