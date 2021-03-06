//
//  BluetoothAPI.h
//  BluetoothAPIDemo
//
//  Created by YangYuxin on 15/4/25.
//  Copyright (c) 2015年 YYX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef enum ErrorCode{
    ErrorCodeUnLock
}ErrorCode;

/**
 手机向TCU发送的指令
 */
typedef enum MTInstruction{
    MTInstructionGetParameter,//获取参数
    MTInstructionButtonCheck,//按键检测
    MTInstructionCheckVersion,//校验协议版本信息
    MTInstructionTCUPair,//配对
    MTInstructionWhistle,//鸣笛
    MTInstructionLockDoor,//锁门
    MTInstructionUnLockDoor,//开门
    MTInstructionFireCar,//点火
    MTInstructionCheckGps,//获取GPS信息以用来校验
    MTInstructionReturnCar//还车
}MTInstruction;

/**
 TCU指令操作成功
 */
typedef enum TMInstructionSuccess{
    TMInstructionSuccessGetParameter,//获取参数成功
    TMInstructionSuccessButtonUp,//按键是弹出状态
    TMInstructionSuccessButtonDown,//按键是按下状态
    TMInstructionSuccessCheckVersion,//检验协议版本信息
    TMInstructionSuccessPair,//配对成功
    TMInstructionSuccessWhsitle,//鸣笛成功
    TMInstructionSuccessUnlock,//开门成功
    TMInstructionSuccessLock,//锁门成功
    TMInstructionSuccessFire,//点火成功
    TMInstructionSuccessGPS,//获取还车验证的GPS信息成功
    TMInstructionSuccessReturnCar//还车成功
}TMInstructionSuccess;
/**
 TCU指令操作失败
 */
typedef enum TMInstructionFailure{
    TMInstructionFailureGetParameter,//获取参数失败
    TMInstructionFailureGprsError,//gprs模块错误
    TMInstructionFailureGpsError,//gps模块错误
    TMInstructionFailureEppromError,//Epprom模块错误
    TMInstructionFailureCanError,//can模块错误
    TMInstructionFailureButtonCheck,//按键检测错误
    TMInstructionFailureUnKnow,//未知指令
    TMInstructionFailureCheckVersion,//校验版本错误
    TMInstructionFailureCheckError,//校验错误
    TMInstructionFailurePairOrderLock,//已还车，订单被锁
    TMInstructionFailurePairFail,//配对失败
    TMInstructionFailurePairCodeError,//配对码错误
    TMInstructionFailureWhsitle,//鸣笛失败
    TMInstructionFailureUnlock,//开门失败
    TMInstructionFailureLock,//锁门失败
    TMInstructionFailureFire,//点火失败
    TMInstructionFailureCheckGps,//检验GPS信息失败
    TMInstructionFailureFireCodeError,//PIN码错误
    TMInstructionFailureFirePullCharningLine,//点火时没拔充电线
    TMInstructionFailureReturnUnlock,//还车时门未关
    TMInstructionFailureReturnInsertChargingLine,//还车时未插入充电线
    TMInstructionFailureReturnKeyNotOff,//还车时，钥匙未回到off
    TMInstructionFailureReturnWrongStation,//还车点非指定的站点
    TMInstructionFailureReturnUnChargeing,//汽车不在充电
    TMInstructionFailureReturnError,//还车失败
    TMInstructionFailureCarIsRunning//车正在行驶中(鸣笛、解锁、落锁时都可能出现这种错误)
}TMInstructionFailure;

#pragma mark - Protocol
@protocol BluetoothAPIDelegate <NSObject>

@optional
//设备不支持当前蓝牙时调用
- (void)centralManagerUnsportted;
//与扫描蓝牙模块中
- (void)scanning;
//蓝牙模块为打开
- (void)centralManagerStatePoweredOff;
//与蓝牙模块建立连接时调用
-(void)didConnect;

//与蓝牙模块断开连接时调用
-(void)didDisConnect;

//未能成功建立连接时调用
-(void)failToConnect;

//成功建立连接后每1.5秒调用一次，参数为rssi值（rssi的值范围为-127~0,需另行处理）
-(void)timerToShow:(NSNumber*)rssi;

/**
 *  处理指令操作TCU成功的回调
 *
 *  @param instrucionSuccess TMinstructionSuccess
 */
- (void)requestToTCUSuccess:(TMInstructionSuccess)instrucionSuccess;
/**
 *  处理指令操作TCU失败的回调
 *
 *  @param instructionFailure TMInstrctionFailre
 */
- (void)requestToTCUFailure:(TMInstructionFailure)instructionFailure;

@end

#pragma mark - Public Interface
@interface BluetoothAPI : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>
@property(nonatomic,assign) id<BluetoothAPIDelegate> delegate;
@property (nonatomic, assign) BOOL isPair;
@property (nonatomic, strong) NSString *firstOpenTime;
@property (nonatomic, strong) NSString *firstFireTime;
@property (nonatomic, strong) NSString *returnCarTime;
@property (nonatomic, strong) NSString *returnCarCommand;
/**
 *  还车校验时的GPS信息
 */
@property (nonatomic, strong) NSString *checkGps;
/**
 *  真正还车时的GPS信息
 */
@property (nonatomic, strong) NSString *returnGps;
/**
 *  获取到的TCU参数信息
 */
@property (nonatomic, strong) NSString *parameter;

@property (nonatomic, strong) NSString *scanInfo;

@property (nonatomic, strong) NSString *iccid;

@property (nonatomic, strong) NSString *tboxVersion;
/**
 *  当前执行的指令
 */
@property (nonatomic, assign) MTInstruction currentInstruction;
+ (BluetoothAPI*)sharedInstance;

- (void)start:(NSString*)carName withId:(NSString*)identify;
- (void)cleanup;
/**
 *  手机向TCU发送相关的操作
 *
 *  @param instruction 需要执行的操作，见MTInstruction
 *  @param pin         点火时需要输入的安全验证码，其他操作可不传
 */
- (void)TCUPostRequestWithInstruction:(MTInstruction )instruction firePin:(NSString *)pin;

@end