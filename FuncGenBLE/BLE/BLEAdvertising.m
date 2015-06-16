//
//  BLEAdvertising.m
//

#import "BLEAdvertising.h"

//----------------------------------------------------------------

@interface BLEAdvertising() <CBCentralManagerDelegate>
@end


//----------------------------------------------------------------

@implementation BLEAdvertising

- (id)init
{
    self = [super init];
	{
		_isScanning = NO;
		_peripherals = [NSMutableArray new];

		_centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
		while ([_centralManager state] == CBCentralManagerStateUnknown)	{
			//　CBCentralManagerが動き出すまで待つ
			[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
		}
	}
	
    return self;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
}

//----------------------------------------------------------------
// 強制切断
- (void)forceDisconnect
{
	for (CBPeripheral *peripheral in _peripherals) {
		if (peripheral.state != CBPeripheralStateDisconnected) {
			[_centralManager cancelPeripheralConnection:peripheral];
		}
	}
}

//----------------------------------------------------------------
//----------------------------------------------------------------
/**
 * ペリフェラルのスキャン開始
 */
- (BOOL)scanStart
{
	_isScanning = YES;
	NSLog(@"scanStart _centralManager:state %d", [_centralManager state]);

	if ([_centralManager state] != CBCentralManagerStatePoweredOn)
		return NO;

	// 探索対象のデバイスが持つサービスを指定
	//NSArray *services = [NSArray arrayWithObjects:[CBUUID UUIDWithString:@"FFFF"], nil];

	// 単一デバイスの発見イベントを重複して発行させない
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
														forKey:CBCentralManagerScanOptionAllowDuplicatesKey];

	// ペリフェラルのスキャンを始める
	[_centralManager scanForPeripheralsWithServices:nil options:options];

	return YES;
}

/**
 * ペリフェラルのスキャン停止
 */
- (void)scanStop
{
	_isScanning = NO;

	if ([_centralManager state] == CBCentralManagerStatePoweredOn)	{
		[_centralManager stopScan];
	}
}

//---------------------------
// CBCentralManagerDelegate
/**
 * ペリフェラルスキャンの結果通知
 */

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
	 advertisementData:(NSDictionary *)advertisementData
				  RSSI:(NSNumber *)RSSI
{
	NSArray *serviceUUIDs = [advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];	// UUIDの一覧取得
	NSLog(@"serviceUUIDs: %@", serviceUUIDs.description);

	NSString *my_service_uuid = @"FFFF";	// for DEBUG SERVICE UUID
	if ([serviceUUIDs containsObject:[CBUUID UUIDWithString:my_service_uuid]]) {
		// 対象とするサービスが含まれている!!

		// ペリフェラルに接続を試みる
		{
			[_peripherals addObject:peripheral];
			[_centralManager connectPeripheral:peripheral options:nil];	// 接続try
		}
	}
}

//---------------------------
// CBCentralManagerDelegate
// 接続成功通知
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	NSLog(@"接続成功");
	[self scanStop];

	if ([_delegate respondsToSelector:@selector(didConnectPeripheral:)]) {
		[_delegate didConnectPeripheral:peripheral];
	}
}

// 接続失敗通知
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	NSLog(@"接続失敗");

	//[self scanStart];
}

// 切断通知
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	NSLog(@"切断");
	if ([_delegate respondsToSelector:@selector(didDisconnectPeripheral:)]) {
		[_delegate didDisconnectPeripheral:peripheral];
	}

	//[self scanStart];
}

//----------------------------------------------------------------

@end