//
//  SQItemTMSHandler.m
//  scan_qrcode_demo
//
//  Created by Codger on 16/3/29.
//
//

#import "SQItemTMSHandler.h"

@implementation SQItemTMSHandler

- (void)handleTMSRequestWithHttpMethod:(NSString *)method block:(ResponseBlock)blcok{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",TMS_BASE_URL,self.functionName];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:method];
    if (self.parameterDic) {
        //if (![method isEqualToString:@"GET"]) {
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:self.parameterDic options:NSJSONWritingPrettyPrinted error:nil];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: postData];
        //}
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"response:%@",response);
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        //NSDictionary* headers = [urlResponse allHeaderFields];
        NSInteger statusCode = [urlResponse statusCode];
        NSDictionary *receivedDic;
        if (data) {
            receivedDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }else{
            receivedDic = nil;
        }
        
        NSLog(@"data:%@",receivedDic);
        NSLog(@"connectionErrr:%@",connectionError);
        blcok(receivedDic, statusCode);
    }];
}


@end
