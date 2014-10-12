//
//  BLEConnect.m
//  xprize
//
//  Created by Kartik Thapar on 11/7/13.
//  Modified by Sihao Lu on 10/12/14.
//  Copyright (c) 2013 Kartik Thapar. All rights reserved.
//
#import "BLEConnect.h"

@interface BLEConnect ()

@property (strong, nonatomic) void (^successHandler)(NSString *response);

@property (strong, nonatomic) void (^failureHandler)();

@property (strong, nonatomic) void (^connectionHandler)();

@property (strong, nonatomic) void (^disconnectHandler)();

@property (strong, nonatomic) NSInvocation *scanner;

@property BOOL isScanning;

@end

@implementation BLEConnect

@synthesize ble;

+ (instancetype)sharedBLE {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        ble = [[BLE alloc] init];
        ble.delegate = self;
        _isScanning = NO;
        [ble controlSetup];
    }
    return self;
}

- (id)initWithBLEDelegate:(id)theBleDelegate
{
    self = [super init];
    if (!self)
        return nil;
    
    // initialize BLE
    ble = [[BLE alloc] init];
//    [ble controlSetup];
    ble.delegate = self;
    
    return self;
}

- (void)setDisconnectHandler:(void (^)())handler {
    _disconnectHandler = handler;
}

- (void)sendData:(NSData *)data success:(void (^)(NSString *response))successHandler failure:(void (^)())failureHandler {
    if (![self.ble activePeripheral]) {
        failureHandler();
        return;
    }
    _successHandler = successHandler;
    _failureHandler = failureHandler;
    [self.ble write:data];
}

- (void)scanForPeripheralsAndConnectWithTimeOut:(NSTimeInterval)timeOut didConnect:(void (^)())connectionHandler timedOut:(void (^)())timeOutHandler {
    
    if (_isScanning) return;
    _isScanning = YES;
    
    if (self.ble.CM.state != CBCentralManagerStatePoweredOn) {
        NSLog(@"Not powered on, saved for later.");
        
        // Try turn it on
        [ble controlSetup];
        
        NSMethodSignature *signature = [BLEConnect instanceMethodSignatureForSelector:_cmd];
        _scanner = [NSInvocation invocationWithMethodSignature:signature];
        [_scanner setTarget:self];
        [_scanner setSelector:_cmd];
        [_scanner setArgument:&timeOut atIndex:2];
        [_scanner setArgument:&connectionHandler atIndex:3];
        [_scanner setArgument:&timeOutHandler atIndex:4];
        [_scanner retainArguments];
        
        _isScanning = NO;
        return;
    }

    _connectionHandler = connectionHandler;
    
    if (self.ble.activePeripheral)
    {
        if([self.ble.activePeripheral state] == CBPeripheralStateConnected)
        {
            [[self.ble CM] cancelPeripheralConnection:[self.ble activePeripheral]];
            _connectionHandler = nil;
            _isScanning = NO;
            return;
        }
    }
    
    if (self.ble.peripherals)
        self.ble.peripherals = nil;
    
    [self.ble findBLEPeripheralsWithTimeout:timeOut];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeOut * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        _isScanning = NO;
        
        CBPeripheral *lastUsedLabBoxPeripheral = [self lastUsedLabBoxPeripheral];
        if (lastUsedLabBoxPeripheral != nil)
        {
            [self.ble connectPeripheral:lastUsedLabBoxPeripheral];
            return;
        }
        else
        {
            if (self.ble.peripherals.count > 0)
            {
                [self.ble connectPeripheral:self.ble.peripherals[0]];
            } else {
                _connectionHandler = nil;
                timeOutHandler();
            }
        }
    });
}

- (CBPeripheral *)lastUsedLabBoxPeripheral
{
    bool deviceExists = [self checkIfPeripheralExists];
    if (deviceExists == false || self.ble.peripherals.count <= 0)
        return nil;
    
    NSString *labBoxStringId = [self labBoxPeripherStringId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier.UUIDString == %@", labBoxStringId];
    NSArray *filteredArray = [self.ble.peripherals filteredArrayUsingPredicate:predicate];

    return filteredArray.count > 0 ? filteredArray[0] : nil;
}

- (BOOL)checkIfPeripheralExists
{
    NSString *deviceId = [[NSUserDefaults standardUserDefaults] stringForKey:@"LabTestDeviceBLEId"];
    return (deviceId == NULL) ? YES : NO;
}

- (NSString *)labBoxPeripherStringId
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"LabTestDeviceBLEId"];
}

#pragma mark - BLEDelegate
- (void)bleChipDidPowerOn:(BOOL)isOn
{
    NSLog(@"BLE power on");
    if (_scanner && isOn) {
        [_scanner invoke];
        _scanner = nil;
    }
}

- (void)bleDidDisconnect
{
    NSLog(@"BLE disconnected.");
    if (_disconnectHandler) _disconnectHandler();
}

- (void)bleDidConnect
{
    NSLog(@"BLE connected.");
    _connectionHandler();
}

- (void)bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSString *resultString = [[NSString alloc] initWithData:[NSData dataWithBytes:data length:length] encoding:NSUTF8StringEncoding];
    _successHandler(resultString);
}

@end
