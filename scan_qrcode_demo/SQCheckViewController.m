//
//  ViewController.m
//  scan_qrcode_demo
//
//  Created by strivingboy on 14/11/3.
//
//

#import "SQCheckViewController.h"
#import "SQModelTboxInfo.h"
#import "NSObject+MJKeyValue.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <AVFoundation/AVFoundation.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import "ASIHTTPRequest.h"
#import "SQItemTMSHandler.h"
#import "ASIFormDataRequest.h"
#import "SQModelLocation.h"
#import "BluetoothAPI.h"
#import "UIDevice+CurrentDevice.h"
#import "CRBimaSwitch.h"
#import "UIView+CRAdditions.h"
#import "UIView+LayoutMethods.h"


static const char *kScanQRCodeQueueName = "ScanQRCodeQueue";

@interface SQCheckViewController () <AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,UITextFieldDelegate,BluetoothAPIDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    
    SQModelTboxInfo *TCUInfo;
    BOOL unlockSuccess;
    BOOL lockSuccess;
    BOOL whistleSuccess;
    BOOL startSuccess;
    BOOL buttonCheckSuccess;
}

@property (weak, nonatomic) IBOutlet UIView *scanView;
@property (weak, nonatomic) IBOutlet UIView *scanFrameView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lockAndUnlockViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationViewHeigh;
@property (nonatomic, strong) CRBimaSwitch *bimaSwitch;
@property (weak, nonatomic) IBOutlet UIView *lockAndUnlockView;
@property (weak, nonatomic) IBOutlet UIView *operationView;
@property (weak, nonatomic) IBOutlet UIButton *unlockButton;
@property (weak, nonatomic) IBOutlet UIButton *lockButton;
@property (weak, nonatomic) IBOutlet UIButton *whistleButton;
@property (weak, nonatomic) IBOutlet UIButton *fireButton;
@property (weak, nonatomic) IBOutlet UIButton *returnCarButton;
@property (weak, nonatomic) IBOutlet UILabel *buttonTypeLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *carTypePickerView;
@property (weak, nonatomic) IBOutlet UIButton *checkButton;

/**
 *  车锁开关状态 YES 门锁着
 */

@property (assign, nonatomic) BOOL isLock;
@property (nonatomic) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic) BOOL lastResut;
@property (nonatomic, strong) NSString *result;
@property (nonatomic, strong) NSMutableArray *locationsArr;
@property (nonatomic, strong) NSMutableArray *tboxsArr;
@property (nonatomic, strong) NSMutableArray *carTypeArr;
@property (nonatomic, strong) NSDictionary *choosedCarType;
@end

@implementation SQCheckViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"功能检查";
    unlockSuccess = NO;
    lockSuccess = NO;
    whistleSuccess = NO;
    startSuccess = NO;
    buttonCheckSuccess = NO;
    self.scanView.hidden = YES;
    [self userButtonIsEnable:NO];
    _lastResut = YES;
    self.isLock = YES;
    [self configDefaultView];
    [self connectTbox];
    [self getCarTypeInfo];
}

- (void)dealloc
{
    [self stopReading];
    [[BluetoothAPI sharedInstance] cleanup];
    [SVProgressHUD dismiss];
    [BluetoothAPI sharedInstance].delegate = nil;
}

- (IBAction)checkButtonType:(id)sender {
    [[BluetoothAPI sharedInstance] TCUPostRequestWithInstruction:MTInstructionButtonCheck firePin:nil];
}

- (IBAction)unlock:(id)sender {
    if (self.isLock == YES) {
        [SVProgressHUD showWithStatus:@"开门中，请稍后" maskType:SVProgressHUDMaskTypeGradient];
        //当前门锁着,发送锁门指令
        [[BluetoothAPI sharedInstance] TCUPostRequestWithInstruction:MTInstructionUnLockDoor firePin:nil];
    }else{
        [SVProgressHUD showErrorWithStatus:@"当前车辆已经是开门状态"];
    }
}
- (IBAction)lock:(id)sender {
    if (self.isLock == NO){
        [SVProgressHUD showWithStatus:@"锁门中，请稍后" maskType:SVProgressHUDMaskTypeGradient];
        //当前门开着,发送锁门指令
        [[BluetoothAPI sharedInstance] TCUPostRequestWithInstruction:MTInstructionLockDoor firePin:nil];
    }else{
        [SVProgressHUD showErrorWithStatus:@"当前车辆已经是锁门状态"];
    }
}
- (IBAction)whistle:(id)sender {
    [self userButtonIsEnable:NO];
    [[BluetoothAPI sharedInstance] TCUPostRequestWithInstruction:MTInstructionWhistle firePin:nil];
}
- (IBAction)start:(id)sender {
    [self userButtonIsEnable:NO];
    [[BluetoothAPI sharedInstance] TCUPostRequestWithInstruction:MTInstructionFireCar firePin:@"111111"];
}
- (IBAction)returnCar:(id)sender {
    //[[BluetoothAPI sharedInstance] TCUPostRequestWithInstruction:MTInstructionReturnCar firePin:@"111111"];
}

- (IBAction)scanQRCode:(id)sender {
    if (!unlockSuccess) {
        [SVProgressHUD showErrorWithStatus:@"尚未进行开门检验"];
        return;
    }else if (!lockSuccess) {
        [SVProgressHUD showErrorWithStatus:@"尚未进行锁门检验"];
        return;
    }else if (!whistleSuccess) {
        [SVProgressHUD showErrorWithStatus:@"尚未进行鸣笛检验"];
        return;
    }else if (!startSuccess) {
        [SVProgressHUD showErrorWithStatus:@"尚未进行点火检验"];
        return;
    }else if (!buttonCheckSuccess) {
        [SVProgressHUD showErrorWithStatus:@"尚未进行按钮检验"];
        return;
    }else if (!self.choosedCarType) {
        [SVProgressHUD showErrorWithStatus:@"尚未选择车型"];
        return;
    }else{
        self.scanView.hidden = NO;
        [self startReading];
    }
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.carTypeArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row == 0) {
        return @"请选择车型";
    }
    NSDictionary *carTypeDic = self.carTypeArr[row];
    return carTypeDic[@"model"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row != 0) {
        self.choosedCarType = self.carTypeArr[row];
    }
}

#pragma mark - private methods

- (void)configDefaultView{
    [self.lockAndUnlockView makeCornerRadiusOfRadius:3 andBorderWidth:1 andBorderColor:[UIColor colorWithRed:206 green:206 blue:209 alpha:1]];
    [self.operationView makeCornerRadiusOfRadius:3 andBorderWidth:1 andBorderColor:[UIColor colorWithRed:206 green:206 blue:209 alpha:1]];
    iPhoneModel currentDeviceModel = [UIDevice iphoneModel];
    switch (currentDeviceModel) {
        case iPhoneModelIPhone4:
            _lockAndUnlockViewHeight.constant = 40;
            _operationViewHeigh.constant = 67.61;
            break;
        case iPhoneModelIPhone5:
            _lockAndUnlockViewHeight.constant = 49;
            _operationViewHeigh.constant = 80;
            break;
        case iPhoneModelIPhone6:
            _lockAndUnlockViewHeight.constant = 55;
            _operationViewHeigh.constant = 93.94;
            break;
        case iPhoneModelIPhone6Plus:
            _lockAndUnlockViewHeight.constant = 60;
            _operationViewHeigh.constant = 103.66;
            break;
        default:
            break;
    }
    _bimaSwitch = [CRBimaSwitch loadNibName:@"CRBimaSwitch"];
    _bimaSwitch.frame = CGRectMake(self.view.width / 2.0 - 58 ,( _lockAndUnlockViewHeight.constant-49)/2.0 + 3, 116, 49);
    __weak typeof(self)weekSelf = self;
    _bimaSwitch.buttonActionBlock = ^(NSDictionary *info, NSInteger type){
        switch (type) {
            case 0:
                //开门
                [weekSelf unlock:nil];
                break;
            case 1:
                //关门
                [weekSelf lock:nil];
                break;
            case 2:
                //点击了switchBall
                break;
            default:
                break;
        }
    };
    [self.lockAndUnlockView addSubview:_bimaSwitch];
    //防止用户同上点击开关门、点火、还车、鸣笛等按钮
    [self.bimaSwitch setExclusiveTouch:YES];
    [self.unlockButton setExclusiveTouch:YES];
    [self.lockButton setExclusiveTouch:YES];
    [self.whistleButton setExclusiveTouch:YES];
    [self.fireButton setExclusiveTouch:YES];
    [self.returnCarButton setExclusiveTouch:YES];
}

- (void)getCarTypeInfo{
    SQItemTMSHandler *handler = [SQItemTMSHandler new];
    handler.functionName = @"cars/";
    [SVProgressHUD showWithStatus:@"获取T车型信息中"];
    [handler handleTMSRequestWithHttpMethod:@"GET" block:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200 || statusCode == 201 || statusCode == 202) {
            [SVProgressHUD dismiss];
            NSArray *responseArr = responseObject[@"content"];
            for (NSDictionary *dic in responseArr) {
                [self.carTypeArr addObject:dic];
            }
            [self.carTypePickerView reloadAllComponents];
        }else{
            NSString *detail = responseObject[@"detail"];
            [SVProgressHUD showErrorWithStatus:detail];
        }
    }];
}

- (BOOL)startReading
{
    // 获取 AVCaptureDevice 实例
    NSError * error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    // 创建会话
    _captureSession = [[AVCaptureSession alloc] init];
    // 添加输入流
    [_captureSession addInput:input];
    // 初始化输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    // 添加输出流
    [_captureSession addOutput:captureMetadataOutput];
    
    // 创建dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(kScanQRCodeQueueName, NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    // 设置元数据类型 AVMetadataObjectTypeQRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // 创建输出对象
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_scanFrameView.layer.bounds];
    [_scanFrameView.layer addSublayer:_videoPreviewLayer];
    // 开始会话
    [_captureSession startRunning];
    
    return YES;
}

- (void)stopReading
{
    // 停止会话
    [_captureSession stopRunning];
    _captureSession = nil;
}

- (void)reportScanResult:(NSString *)result
{
    [self stopReading];
    if (!_lastResut) {
        return;
    }
    _lastResut = NO;
    [self commitScanInfoWithResult:result];
    // 以及处理了结果，下次扫描
    _lastResut = YES;
}

- (void)systemLightSwitch:(BOOL)open
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (open) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }else{
        [SVProgressHUD showErrorWithStatus:@"该设备没有照明灯"];
    }
}

- (void)commitScanInfoWithResult:(NSString *)result{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:result delegate:self cancelButtonTitle:@"注册TCU" otherButtonTitles:@"取消", nil];
    alert.tag = 1;
    [alert show];
}

- (void)clearBoundInfo{
    TCUInfo = nil;
}

/**
 *  蓝牙连接Tbox
 */
- (void)connectTbox{
    [BluetoothAPI sharedInstance].isPair = YES;
    [BluetoothAPI sharedInstance].delegate = self;
    [[BluetoothAPI sharedInstance] start:@"JXTECH1" withId:@"111111"];
    [SVProgressHUD showWithStatus:@"蓝牙配对中..."];
}
/**
 *  获取Tbox信息：iccid/version/tcuid
 */
- (void)getTboxInfo{
    if (!self.choosedCarType) {
        [SVProgressHUD showErrorWithStatus:@"请选择车型!"];
        return;
    }
    [SVProgressHUD showWithStatus:@"获取车辆信息中"];
    [self userButtonIsEnable:NO];
    //向tbox获取信息
    [BluetoothAPI sharedInstance].scanInfo = [NSString stringWithFormat:@"%@_%@_UNIM2M.GZM2MAPN",self.result,self.choosedCarType[@"code"]];
    //[BluetoothAPI sharedInstance].scanInfo = @"1512250127_001_UNIM2M.GZM2MAPN";
    [[BluetoothAPI sharedInstance] TCUPostRequestWithInstruction:MTInstructionGetParameter firePin:nil];
}

/**
 *  上传Tbox信息到TMS
 */
- (void)uploadTboxInfo{
    NSDictionary *postDic = @{@"uuid":self.result,
                              @"iccid":[BluetoothAPI sharedInstance].parameter,
                              @"carModel":self.choosedCarType[@"model"]
                              };
    SQItemTMSHandler *handler = [SQItemTMSHandler new];
    handler.parameterDic = postDic;
    handler.functionName = @"tboxs/";
    NSLog(@"传入的参数:%@",postDic);
    [SVProgressHUD showWithStatus:@"上传Tbox信息到服务器中..."];
    [handler handleTMSRequestWithHttpMethod:@"POST" block:^(id responseObject, NSInteger statusCode) {
        if (statusCode == 200 || statusCode == 201 || statusCode == 202) {
            //[SVProgressHUD showSuccessWithStatus:@"上传Tbox信息成功"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传Tbox信息成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.tag = 2;
            [alert show];
        }else{
            NSString *detail = responseObject[@"detail"];
            [SVProgressHUD showErrorWithStatus:detail];
        }
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.navigationController popViewControllerAnimated:YES];
//        });
        
        //[self startReading];
    }];
}

- (void)userButtonIsEnable:(BOOL)enable{
        self.bimaSwitch.useAble = enable;
        self.returnCarButton.enabled = enable;
        self.fireButton.enabled = enable;
        self.whistleButton.enabled = enable;
        self.lockButton.enabled = enable;
        self.unlockButton.enabled = enable;
        self.checkButton.enabled = enable;
}

- (void)leftButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSString *result;
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            result = metadataObj.stringValue;
            self.result = result;
            NSLog(@"扫描出来的二维码是:%@",result);
        } else {
            result = @"不是二维码";
            NSLog(@"不是二维码");
        }
        [self performSelectorOnMainThread:@selector(reportScanResult:) withObject:result waitUntilDone:NO];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            //配置TCU
            [self getTboxInfo];
        }else if (buttonIndex == 1){
            //不配置TCU，重新扫描
            [self startReading];
        }
    }
    else if (alertView.tag == 2) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - BlueToothDelegate
- (void)scanning{
    //[SVProgressHUD showWithStatus:@"连接Tbox中，请稍候" maskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"连接蓝牙中..."];
    NSLog(@"扫描中...");
}

- (void)didConnect{
    [JDStatusBarNotification dismissAnimated:YES];
    [self userButtonIsEnable:YES];
}

-(void)failToConnect
{
    [JDStatusBarNotification showWithStatus:@"蓝牙链接失败" styleName:JDStatusBarStyleError];
}
- (void)didDisConnect
{
    [JDStatusBarNotification showWithStatus:@"蓝牙链接已断开" styleName:JDStatusBarStyleError];
}

- (void)timerToShow:(NSNumber *)rssi{
    NSLog(@"当前蓝牙信号强度:%@",rssi);
}

- (void)requestToTCUSuccess:(TMInstructionSuccess)instrucionSuccess{
    switch (instrucionSuccess) {
        case TMInstructionSuccessGetParameter:{
            [SVProgressHUD dismiss];
            [self uploadTboxInfo];
            [self userButtonIsEnable:YES];
            break;
        }
        case TMInstructionSuccessButtonUp: {
            //按钮状态：弹起
            self.buttonTypeLabel.text = @"弹起";
            self.buttonTypeLabel.textColor = [UIColor redColor];
            buttonCheckSuccess = YES;
            break;
        }
        case TMInstructionSuccessButtonDown: {
            //按钮状态:按下
            self.buttonTypeLabel.text = @"按下";
            self.buttonTypeLabel.textColor = [UIColor greenColor];
            buttonCheckSuccess = YES;
            break;
        }
        case TMInstructionSuccessCheckVersion:{
            [[BluetoothAPI sharedInstance] TCUPostRequestWithInstruction:MTInstructionTCUPair firePin:nil];//配对
            [self userButtonIsEnable:NO];
            break;
        }
        case TMInstructionSuccessPair: {
            //[self startReading];
            [self userButtonIsEnable:YES];
            [SVProgressHUD showSuccessWithStatus:@"蓝牙配对成功!"];
//            [SVProgressHUD dismiss];
            break;
        }
        case TMInstructionSuccessWhsitle: {
            [SVProgressHUD showSuccessWithStatus:@"鸣笛成功"];
            whistleSuccess = YES;
            [self userButtonIsEnable:YES];
            break;
        }
        case TMInstructionSuccessUnlock: {
            //得到开锁成功与否的消息之后控件恢复可以交互的状态
            [SVProgressHUD showSuccessWithStatus:@"开门成功"];
            unlockSuccess  = YES;
            [self.bimaSwitch setSwitchState:CRBimaSwitchStateRight];
            if ([BluetoothAPI sharedInstance].firstOpenTime) {
                [BluetoothAPI sharedInstance].firstOpenTime = nil;
            }
            self.isLock = NO;
            break;
        }
        case TMInstructionSuccessLock: {
            [SVProgressHUD showSuccessWithStatus:@"上锁成功"];
            lockSuccess = YES;
            [self.bimaSwitch setSwitchState:CRBimaSwitchStateLeft];
            [self userButtonIsEnable:YES];
            self.isLock = YES;
            break;
        }
        case TMInstructionSuccessFire: {
            [SVProgressHUD showSuccessWithStatus:@"点火成功，请发动汽车"];
            startSuccess = YES;
            [self userButtonIsEnable:YES];
            break;
        }
        case TMInstructionSuccessGPS: {
            [self userButtonIsEnable:NO];
            break;
        }
        case TMInstructionSuccessReturnCar: {
            NSLog(@"用车----------还车成功");
            [SVProgressHUD dismiss];
            break;
        }
        default: {
            break;
        }
    }
    [self userButtonIsEnable:YES];
}

- (void)requestToTCUFailure:(TMInstructionFailure)instructionFailure{
    switch (instructionFailure) {
        case TMInstructionFailureGetParameter:{
            //[SVProgressHUD showErrorWithStatus:@"获取TCU参数错误"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"获取TCU参数错误" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
        case TMInstructionFailureCheckError:{
            [SVProgressHUD showErrorWithStatus:@"校验错误"];
            break;
        }
        case TMInstructionFailurePairOrderLock: {
            [SVProgressHUD showErrorWithStatus:@"当前订单已完结，请重新下单"];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(leftButtonAction) userInfo:nil repeats:NO];
            break;
        }
        case TMInstructionFailurePairFail:
        case TMInstructionFailurePairCodeError: {
            [SVProgressHUD showErrorWithStatus:@"车辆派送失败，请稍后重试"];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(leftButtonAction) userInfo:nil repeats:NO];
            break;
        }
        case TMInstructionFailureWhsitle: {
            [SVProgressHUD showErrorWithStatus:@"鸣笛失败，请重试"];
            break;
        }
        case TMInstructionFailureUnlock: {
            //开锁失败，开关状态回到锁门状态
            [SVProgressHUD showErrorWithStatus:@"开门失败，请重试"];
            break;
        }
        case TMInstructionFailureLock: {
            [SVProgressHUD showErrorWithStatus:@"上锁失败，请重试"];
            break;
        }
        case TMInstructionFailureCarIsRunning:{
            [SVProgressHUD showErrorWithStatus:@"车正在行驶中，无法进行此操作"];
            break;
        }
        case TMInstructionFailureFire: {
            [SVProgressHUD showErrorWithStatus:@"点火失败，请重试"];
            
            break;
        }
        case TMInstructionFailureFireCodeError: {
            [SVProgressHUD showErrorWithStatus:@"pin码错误,请重新输入"];
            
            break;
        }
        case TMInstructionFailureFirePullCharningLine: {
            [SVProgressHUD showErrorWithStatus:@"充电线未拔，请拔下充电线后再点火"];
            
            break;
        }
        case TMInstructionFailureReturnUnlock: {
            [SVProgressHUD showErrorWithStatus:@"车门未锁，请锁好车门，再还车"];
            break;
        }
        case TMInstructionFailureReturnInsertChargingLine: {
            [SVProgressHUD showErrorWithStatus:@"请插入充电线并确认充电后再还车"];
            break;
        }
        case TMInstructionFailureReturnKeyNotOff: {
            [SVProgressHUD showErrorWithStatus:@"请将车钥匙拧到off后再还车"];
            break;
        }
        case TMInstructionFailureReturnWrongStation: {
            [SVProgressHUD showErrorWithStatus:@"当前还车站点不是指定还车站点"];
            break;
        }
        case TMInstructionFailureReturnUnChargeing: {
            [SVProgressHUD showErrorWithStatus:@"请确认车辆充电后再还车"];
            break;
        }
        case TMInstructionFailureReturnError: {
            [SVProgressHUD showErrorWithStatus:@"还车失败，请重试"];
            break;
        }case TMInstructionFailureGpsError:{
            //[SVProgressHUD showErrorWithStatus:@"gps模块错误"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"gps模块错误" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }case TMInstructionFailureGprsError:{
            //[SVProgressHUD showErrorWithStatus:@"gprs模块错误"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"gprs模块错误" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }case TMInstructionFailureEppromError:{
            //[SVProgressHUD showErrorWithStatus:@"epprom错误"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"epprom模块错误" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }case TMInstructionFailureCanError: {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"can模块错误" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            break;
        }
        default: {
            break;
        }
    }
    [SVProgressHUD dismiss];
    [self userButtonIsEnable:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)locationsArr{
    if (!_locationsArr) {
        _locationsArr = [[NSMutableArray alloc] init];
    }
    return _locationsArr;
}

- (NSMutableArray *)tboxsArr{
    if (!_tboxsArr) {
        _tboxsArr = [[NSMutableArray alloc] init];
    }
    return _tboxsArr;
}

- (NSMutableArray *)carTypeArr{
    if (!_carTypeArr) {
        _carTypeArr = [[NSMutableArray alloc] init];
        [_carTypeArr addObject:@"请选择车型"];
    }
    return _carTypeArr;
}


@end
