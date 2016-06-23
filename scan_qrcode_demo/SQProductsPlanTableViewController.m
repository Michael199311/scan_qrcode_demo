//
//  SQProductsPlanTableViewController.m
//  scan_qrcode_demo
//
//  Created by Codger on 16/4/11.
//
//

#import "SQProductsPlanTableViewController.h"
#import "SQItemTMSHandler.h"
#import "SQModelProductPlan.h"
#import "SQProductsPlanCell.h"
#import "SQHomeViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface SQProductsPlanTableViewController ()

@property (nonatomic, strong) NSMutableArray *productsPlanArr;

@end

@implementation SQProductsPlanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"产品计划列表";
    [self.tableView registerNib:[UINib nibWithNibName:@"SQProductsPlanCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    SQItemTMSHandler *handler = [SQItemTMSHandler new];
    handler.functionName = @"product-plans/";
    [SVProgressHUD showWithStatus:@"获取生产计划中"];
    [handler handleTMSRequestWithHttpMethod:@"GET" block:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200 || statusCode == 201 || statusCode == 202) {
            [SVProgressHUD dismiss];
            NSArray *productPlans = responseObject[@"content"];
            for (NSDictionary *productPlanDic in productPlans) {
                SQModelProductPlan *productPlan = [SQModelProductPlan objectWithKeyValues:productPlanDic];
                [self.productsPlanArr addObject:productPlan];
            }
        }else{
            NSString *detail = responseObject[@"detail"];
            [SVProgressHUD showErrorWithStatus:detail];
        }
        
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productsPlanArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SQProductsPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    SQModelProductPlan *productPlan = self.productsPlanArr[indexPath.row];
    cell.patchNumberLabel.text = productPlan.batchNo;
    cell.amountLabel.text = [NSString stringWithFormat:@"%ld",(long)productPlan.planTotal] ;
    cell.accomplishAmountLabel.text = [NSString stringWithFormat:@"%ld",(long)productPlan.actualTotal];
    NSString *firstNumber = [NSString stringWithFormat:@"%@%@",productPlan.batchNo,productPlan.startNo];
    NSString *lastNumber = [NSString stringWithFormat:@"%ld",firstNumber.integerValue + productPlan.planTotal];
    cell.numberSectionLabel.text = [NSString stringWithFormat:@"%@-%ld",firstNumber,(lastNumber.integerValue-1)];
    
    cell.deadlineLabel.text = productPlan.deliveryDeadline;
    if ([productPlan.status isEqualToString:@"01"]) {
        cell.statusLabel.text = @"已计划";
    }else if ([productPlan.status isEqualToString:@"02"]){
        cell.statusLabel.text = @"录入中";
    }else if ([productPlan.status isEqualToString:@"03"]){
        cell.statusLabel.text = @"已录完";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 164;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SQHomeViewController *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"homeVC"];
    homeVC.productPlan = self.productsPlanArr[indexPath.row];
    [self.navigationController pushViewController:homeVC animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableArray *)productsPlanArr{
    if (!_productsPlanArr) {
        _productsPlanArr = [[NSMutableArray alloc] init];
    }
    return _productsPlanArr;
}

@end
