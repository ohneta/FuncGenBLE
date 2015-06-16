//
//  BLEPeripheralAccess.m
//

#import "BLEPeripheralAccess.h"

@interface BLEPeripheralAccess() <CBPeripheralDelegate>
@end


@implementation BLEPeripheralAccess

-(id)initWithPeripheral:(CBPeripheral *)peripheral
{
	self = [super init];
	{
		[peripheral setDelegate:self];

		_state = disconnected;
		_peripheral = peripheral;
		//_characteristic = nil;
		_characteristicUUIDs = [NSMutableArray array];
	}
	return self;
}

//----------------------------------------------------------------

-(void)discoverServices
{
	[_peripheral discoverServices:nil];
}

//----------------------------------------------------------------
// for CBPeripheralDelegate
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
	_peripheral = peripheral;

	for (CBService *service in _peripheral.services) {
		NSLog(@"service: %@", service.description);
		NSLog(@"service.characteristics: %@", service.characteristics.description);
		[_peripheral discoverCharacteristics:nil forService:service];
	}

}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
	NSLog(@"service: %@", service.description);
	
	NSString *s_uuid = @"A000";		// サービスUUID

	if ([service.UUID isEqual:[CBUUID UUIDWithString:s_uuid]]) {
		NSLog(@"%@", service.characteristics.description);

		for (CBCharacteristic *characteristic in service.characteristics) {
			NSLog(@"characteristic: %@", characteristic.description);
			
			for (NSString *c_uuid in _characteristicUUIDs) {
				if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:c_uuid]]) {
					NSLog(@"find it!!!");
					if ([_delegate respondsToSelector:@selector(didFindCharacteristic:c_uuid:)]) {
						[_delegate didFindCharacteristic:characteristic c_uuid:c_uuid];
					}
	
				}
			}
		}
	}
}

//----------------------------------------------------------------
//----------------------------------------------------------------

- (BOOL)writeWithResponse:(CBCharacteristic*)characteristic value:(NSData*)data
{
	if (characteristic)	{
		[_peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
		return YES;
	}
	return NO;
}

- (BOOL)writeWithoutResponse:(CBCharacteristic*)characteristic value:(NSData*)data
{
	if (characteristic)	{
		[_peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
		return YES;
	}
	return NO;
}

- (BOOL)readRequest:(CBCharacteristic*)characteristic
{
	if (characteristic)	{
		[_peripheral readValueForCharacteristic:characteristic];
		return YES;
	}
	return NO;
}

- (BOOL)notifyRequest:(CBCharacteristic*)characteristic
{
	if (characteristic)	{
		[_peripheral setNotifyValue:TRUE forCharacteristic:characteristic];
		return YES;
	}
	return NO;
}

// for CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
	if ([_delegate respondsToSelector:@selector(didUpdateValueForCharacteristic:)]) {
		[_delegate didUpdateValueForCharacteristic:characteristic];
	}
}

//----------------------------------------------------------------

@end

