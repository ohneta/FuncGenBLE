//
//  BLEPeripheralAccess.h


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@protocol BLEPeripheralAccessDelegate <NSObject>
- (void)didFindCharacteristic:(CBCharacteristic *)characteristic c_uuid:(NSString *)c_uuid;
- (void)didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic;

@end



@interface BLEPeripheralAccess : NSObject

- (id)initWithPeripheral:(CBPeripheral *)peripheral;
-(void)discoverServices;

- (BOOL)writeWithResponse:(CBCharacteristic*)characteristic value:(NSData*)data;
- (BOOL)writeWithoutResponse:(CBCharacteristic*)characteristic value:(NSData*)data;
- (BOOL)readRequest:(CBCharacteristic*)characteristic;
- (BOOL)notifyRequest:(CBCharacteristic*)characteristic;


@property (nonatomic, assign) id<BLEPeripheralAccessDelegate> delegate;
@property (readwrite)	enum {disconnected, connected, other}	state;
@property (strong)		CBPeripheral		*peripheral;
@property (strong)		NSMutableArray	*characteristicUUIDs;	// value=NSString

@end
