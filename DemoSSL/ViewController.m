//
//  ViewController.m
//  DemoSSL
//
//  Created by Jack on 16/11/16.
//  Copyright © 2016年 Jack. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <WebKit/WebKit.h>
@interface ViewController ()<WKNavigationDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *urlString =@"地址";
    
    
    //SSL验证
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"证书名称" ofType:@"证书类型"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:YES];
    [securityPolicy setPinnedCertificates:certSet];
    
    
    
    //请求
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置https 验证
    manager.securityPolicy = securityPolicy;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlString parameters:nil progress:^(NSProgress * progress){
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"返回数据 === %@",array);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"返回错误 ==%@",error.description);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
