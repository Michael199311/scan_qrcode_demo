//
//  UIImage+CRImage.m
//  CarRental
//
//  Created by Codger on 15/12/21.
//  Copyright © 2015年 JieXing. All rights reserved.
//

#import "UIImage+CRImage.h"
#import "UIDevice+CurrentDevice.h"

@implementation UIImage (CRImage)

+ (UIImage *)combine:(UIImage *)firstImage with:(UIImage *)secondImage{
    int imageSize;//记录图片的倍数，iphone4/4s是一倍，5/5s是2倍，6、6P是3倍
    if ([UIDevice iphoneModel] == iPhoneModelIPhone4) {
        imageSize = 2;
    }else if ([UIDevice iphoneModel] == iPhoneModelIPhone5){
        imageSize = 2.4;
    }else if ([UIDevice iphoneModel] == iPhoneModelIPhone6){
        imageSize = 2.7;
    }
    else{
        imageSize = 3;
    }
    NSLog(@"宽度：%f，高度：%f",firstImage.size.width,firstImage.size.height);
    CGFloat width = firstImage.size.width*37/51*imageSize;//此比例专用于本项目中站点💧背景和站点logo
    CGFloat height = width;
    CGSize offScreenSize = CGSizeMake(firstImage.size.width*imageSize, firstImage.size.height*imageSize);
    
    UIGraphicsBeginImageContext(offScreenSize);
    
    CGRect rect = CGRectMake(0, 0, firstImage.size.width*imageSize, firstImage.size.height*imageSize);
    [firstImage drawInRect:rect];
    
    CGFloat x = (firstImage.size.width - width/imageSize)/2;
    rect.origin.x += x*imageSize;
    rect.origin.y += x*imageSize;
    rect.size.width = width;
    rect.size.height = height;
    [secondImage drawInRect:rect];
    
    UIImage* imagez = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    NSLog(@"合成后的图片的宽度:%f,高度:%f",imagez.size.width,imagez.size.height);
    return imagez;
}


+ (UIImage *)combineImage:(UIImage *)image withAmount:(NSInteger)amount{
    int imageSize;//记录图片的倍数，iphone4/4s是一倍，5/5s是2倍，6、6P是3倍
    if ([UIDevice iphoneModel] == iPhoneModelIPhone4) {
        imageSize = 2;
    }else if ([UIDevice iphoneModel] == iPhoneModelIPhone5){
        imageSize = 2.4;
    }else if ([UIDevice iphoneModel] == iPhoneModelIPhone6){
        imageSize = 2.7;
    }
    else{
        imageSize = 3;
    }
    //CGFloat width = image.size.width*37/51*imageSize;//此比例专用于本项目中站点💧背景和站点logo
    //CGFloat height = width;
    
    //CGFloat width = image.size.width*64/136*imageSize;//放大镜图片专用
    //CGFloat height = image.size.width*87/141*imageSize;//放大镜图片专用
    
    CGFloat width = image.size.width*imageSize;//站点显示车辆数专用
    CGFloat height = image.size.width*imageSize;//站点显示车辆数专用
    
    CGSize offScreenSize = CGSizeMake(image.size.width*imageSize, image.size.height*imageSize);
    
    UIGraphicsBeginImageContext(offScreenSize);
    
    CGRect rect = CGRectMake(0, 0, image.size.width*imageSize, image.size.height*imageSize);
    [image drawInRect:rect];
    
    UILabel *amountLabel = [[UILabel alloc] init];
    [amountLabel makeCornerRadiusOfRadius:10 andBorderWidth:1 andBorderColor:[UIColor whiteColor]];
    
    //CGFloat x = (image.size.width - width/imageSize)/2;  //数字在图片正中央
    CGFloat x = (image.size.width - width/imageSize)*6/18; //根据放大镜图片站点位置得到的比例
    CGFloat y = (image.size.width - height/imageSize)*1/7;
    
    rect.origin.x += x*imageSize;
    //rect.origin.y += x*imageSize;
    rect.origin.y += y*imageSize;//放大镜图片专用
    rect.size.width = width;
    rect.size.height = height;
    amountLabel.text = [NSString stringWithFormat:@"%ld",(long)amount];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    //amountLabel.textColor = [UIColor lightGrayColor];
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.backgroundColor = [UIColor whiteColor];
    if (amount > 99) {
        amountLabel.text = [NSString stringWithFormat:@"∞"];
        amountLabel.font = [UIFont boldSystemFontOfSize:30];
    }else if (amount > 9){
        amountLabel.font = [UIFont boldSystemFontOfSize:25];
    }else{
        amountLabel.font = [UIFont boldSystemFontOfSize:30];
    }
    [amountLabel drawTextInRect:rect];
    
    UIImage *imagez = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return imagez;
}

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
	CGFloat width = CGImageGetWidth(self.CGImage);
	CGFloat height = CGImageGetHeight(self.CGImage);
	
	CGSize rotatedSize;
	
	rotatedSize.width = width;
	rotatedSize.height = height;
	
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}


@end
