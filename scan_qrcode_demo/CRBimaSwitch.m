//
//  CRBimaSwitch.m
//  CarRental
//
//  Created by Codger on 16/3/8.
//  Copyright © 2016年 JieXing. All rights reserved.
//

#import "CRBimaSwitch.h"



@interface CRBimaSwitch(){
    CGFloat  _minusTranslate;
}

@property (weak, nonatomic) IBOutlet UIImageView *switchBall;

@property (weak, nonatomic) IBOutlet UIImageView *switchBar;

//@property (nonatomic, strong) UIImageView *switchBall;
//
//@property (nonatomic, strong) UIImageView *switchBar;

@end

@implementation CRBimaSwitch

- (void)awakeFromNib{
    _minusTranslate = self.switchBar.width/2;
    UITapGestureRecognizer *tapBallGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBluetoothInfo)];
    UITapGestureRecognizer *tapBarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchBarTaped:)];
    UIPanGestureRecognizer *panBallGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(switchBallDraged:)];
    [self.switchBall addGestureRecognizer:tapBallGesture];
    [self.switchBall addGestureRecognizer:panBallGesture];
    [self.switchBar addGestureRecognizer:tapBarGesture];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
//    self.switchBall.frame = CGRectMake(0, 0, self.height, self.height);
//    NSLog(@"弼马开关的高度:%f,宽度:%f",self.height,self.width);
//    CGFloat barHeight = self.height * 16.0 / 49.0;
//    CGFloat barWidth = barHeight * 81.0 / 16.0;
//    CGFloat x = (self.width - barWidth)/2.0;
//    CGFloat y = self.height * 22.0 / 49 + barHeight / 2.0;
//    self.switchBar.frame = CGRectMake(x, y, barWidth, barHeight);
//    [self addSubview:self.switchBall];
//    [self addSubview:self.switchBar];
}

- (void)switchBarTaped:(UITapGestureRecognizer *)gesture{
    CGPoint location = [gesture locationInView:self];
    if (location.x <= _minusTranslate) {
        //点击的是左半部分
        if (_switchState == CRBimaSwitchStateRight) {
            //[self setSwitchState:CRBimaSwitchStateLeft];
            [self lock];
        }
    }else if (location.x > _minusTranslate){
        //点击的是右半部分
        if (_switchState == CRBimaSwitchStateLeft) {
            //[self setSwitchState:CRBimaSwitchStateRight];
            [self unlock];
        }
    }
}

- (void)switchBallDraged:(UIPanGestureRecognizer *)gesture{
    CGFloat translation = [gesture translationInView:gesture.view].x;
    if (gesture.state == UIGestureRecognizerStateChanged) {
        //translation < 0表示向左滑，>0表示向右滑
        if (translation < 0) {
            if (_switchState == CRBimaSwitchStateLeft) {
                [self moveBallTranslation:0];
            }
        }else if (translation > 0){
            if (_switchState == CRBimaSwitchStateRight){
                [self moveBallTranslation:65];
            }
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        CGFloat translationX = fabs(translation);
        if (_switchState == CRBimaSwitchStateLeft) {
            if (translation < 0) {
                return;
            }
            if (translationX >= _minusTranslate/2) {
                //[self setSwitchState:CRBimaSwitchStateRight];
                [self unlock];
            }
        }else if (_switchState == CRBimaSwitchStateRight){
            if (translation > 0) {
                return;
            }
            if (translationX >= _minusTranslate/2) {
                //[self setSwitchState:CRBimaSwitchStateLeft];
                [self lock];
            }
        }
        
    }
}

- (void)lock{
    if (self.buttonActionBlock) {
        self.buttonActionBlock (nil, 1);
    }
}

- (void)unlock{
    if (self.buttonActionBlock) {
        self.buttonActionBlock(nil, 0);
    }
}

- (void)lockOrUnlock{
    switch (self.switchState) {
        case CRBimaSwitchStateLeft:
            //开门
            if (self.buttonActionBlock) {
                self.buttonActionBlock(nil, 0);
            }
            break;
        case CRBimaSwitchStateRight:
            //锁门
            if (self.buttonActionBlock) {
                self.buttonActionBlock(nil, 1);
            }
            break;
        default:
            break;
    }
}

- (void)showBluetoothInfo{
    if (self.buttonActionBlock) {
        self.buttonActionBlock(nil, 2);
    }
}

- (void)moveBallTranslation:(CGFloat)translation{
    [UIView animateWithDuration:0.5f animations:^{
        self.switchBall.transform = CGAffineTransformMakeTranslation(translation, 0);
    } completion:nil];
}

- (void)setSwitchState:(CRBimaSwitchState)switchState{
    _switchState = switchState;
    //[self lockOrUnlock];
    switch (switchState) {
        case CRBimaSwitchStateLeft:
            self.switchBall.image = [UIImage imageNamed:@"Usecar_leftBar"];
            [self moveBallTranslation:0];
            break;
        case CRBimaSwitchStateRight:
            self.switchBall.image = [UIImage imageNamed:@"Usecar_rightBar"];
            [self moveBallTranslation:65.5];
        default:
            break;
    }
}

- (void)setUseAble:(BOOL)useAble{
    _useAble = useAble;
    if (useAble) {
        self.switchBall.userInteractionEnabled = YES;
        self.switchBar.userInteractionEnabled = YES;
    }else{
        self.switchBall.userInteractionEnabled = NO;
        self.switchBar.userInteractionEnabled = NO;
    }
}

//- (UIImageView *)switchBall{
//    if (!_switchBall) {
//        _switchBall = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Usecar_leftBar"]];
//        UITapGestureRecognizer *tapBallGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBluetoothInfo)];
//        UIPanGestureRecognizer *panBallGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(switchBallDraged:)];
//        [_switchBall addGestureRecognizer:tapBallGesture];
//        [_switchBall addGestureRecognizer:panBallGesture];
//    }
//    return _switchBall;
//}
//
//- (UIImageView *)switchBar{
//    if (!_switchBar) {
//        _switchBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Usecar_switchBar"]];
//        UITapGestureRecognizer *tapBarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchBarTaped:)];
//        [_switchBar addGestureRecognizer:tapBarGesture];
//    }
//    return _switchBar;
//}

@end
