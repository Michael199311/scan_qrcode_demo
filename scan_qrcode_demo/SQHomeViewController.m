//
//  SQHomeViewController.m
//  scan_qrcode_demo
//
//  Created by Codger on 16/4/1.
//
//

#import "SQHomeViewController.h"
#import "SQItemTMSHandler.h"
#import "SQModelTboxInfo.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "SQTboxListTableViewController.h"
#import "SQCheckViewController.h"

@interface SQHomeViewController ()
@property (nonatomic, strong) NSMutableArray *locationsArr;
@property (weak, nonatomic) IBOutlet UILabel *batchLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberSectionLbel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation SQHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"生产计划";
    self.batchLabel.text = [NSString stringWithFormat:@"%@批次注册",self.productPlan.batchNo];
    self.countLabel.text = [NSString stringWithFormat:@"已成功注册:%ld/%ld",(long)self.productPlan.actualTotal,(long)self.productPlan.planTotal];
    NSString *firstNumber = [NSString stringWithFormat:@"%@%@",self.productPlan.batchNo,self.productPlan.startNo];
    NSString *lastNumber = [NSString stringWithFormat:@"%ld",(firstNumber.integerValue + self.productPlan.planTotal)];
    self.numberSectionLbel.text = [NSString stringWithFormat:@"%@-%ld",firstNumber,(lastNumber.integerValue - 1)];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getTboxInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewTboxList:(id)sender {
    SQTboxListTableViewController *tboxListVC = [[SQTboxListTableViewController alloc] init];
    tboxListVC.tboxArr = self.locationsArr;
    [self.navigationController pushViewController:tboxListVC animated:YES];
}

- (IBAction)scanQRCode:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SQCheckViewController *scanVC = [storyBoard instantiateViewControllerWithIdentifier:@"scanVC"];
    [self.navigationController pushViewController:scanVC animated:YES];
}


/**
 *  获取所有该生产计划的Tbox信息
 */
- (void)getTboxInfo{
    SQItemTMSHandler *handler = [SQItemTMSHandler new];
    handler.functionName = [NSString stringWithFormat:@"tboxs/search?params=uuid:%@",self.productPlan.batchNo];
//    handler.functionName = @"tboxs/search?params=";
//    handler.parameterDic = @{
//                            @"uuid":@"1509"
//    };
    [SVProgressHUD showWithStatus:@"获取Tbox信息中"];
    [handler handleTMSRequestWithHttpMethod:@"GET" block:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200 || statusCode == 201 || statusCode == 202) {
            [SVProgressHUD dismiss];
            NSArray *responseArr = responseObject[@"content"];
            for (NSDictionary *dic in responseArr) {
                SQModelTboxInfo *tbox = [SQModelTboxInfo objectWithKeyValues:dic];
                [self.locationsArr addObject:tbox];
            }
        }else{
            NSString *detail = responseObject[@"detail"];
            [SVProgressHUD showErrorWithStatus:detail];
        }
    }];
}

- (NSMutableArray *)locationsArr{
    if (!_locationsArr) {
        _locationsArr = [[NSMutableArray alloc] init];
    }
    return _locationsArr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
