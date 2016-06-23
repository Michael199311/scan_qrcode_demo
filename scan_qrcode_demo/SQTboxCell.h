//
//  SQTboxCell.h
//  scan_qrcode_demo
//
//  Created by Codger on 16/4/1.
//
//

#import <UIKit/UIKit.h>

@interface SQTboxCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TboxidLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *iccidLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@end
