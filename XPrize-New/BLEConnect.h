//
//  BLEConnect.h
//  xprize
//
//  Created by Kartik Thapar on 11/7/13.
//  Modified by Sihao Lu on 10/12/14.
//  Copyright (c) 2013 Kartik Thapar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLE.h"

@interface BLEConnect : NSObject <BLEDelegate>

@property (nonatomic, strong) BLE *ble;

+ (instancetype)sharedBLE;
- (void)scanForPeripheralsAndConnectWithTimeOut:(NSTimeInterval)timeOut didConnect:(void (^)())connectionHandler timedOut:(void (^)())handler;
- (void)sendData:(NSData *)data success:(void (^)(NSString *response))successHandler failure:(void (^)())failureHandler;
- (void)setDisconnectHandler:(void (^)())handler;
@end
