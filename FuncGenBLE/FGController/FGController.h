//
//  FGController.h
//  FunctionGenBLE
//
//  Created by Takehisa Oneta on 2015/05/20.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEAdvertising.h"
#import "BLEPeripheralAccess.h"

//----------------------------------------------------------------
#define	WAVE_BUFFER_SIZE		360
	// 内部波形バッファのサイズ
#define WAVEFORM_BUFFER_SIZE	360
	// FuncGenモジュールへの転送用波形バッファのサイズ
//----------------------------------------------------------------

#define FGC_BUFFERTRANSFER_MAX  16

typedef enum {
	// commands
	FGCommand_Non = 0x00,
	FGCommand_Device,				// 出力デバイス選択
	FGCommand_Output,				// 出力 ON/OFF
	FGCommand_Frequency,			// 周波数設定
	FGCommand_WaveformInfo,			// 波形転送情報
	FGCommand_WaveformBlock,		// 波形転送ブロック
	FGCommand_WaveformToBuffer,		// 波形転送完了
	
	// status
	FGStatus_Device    = 0x80 | FGCommand_Device,		// 出力デバイス取得
	FGStatus_Output    = 0x80 | FGCommand_Output,		// 出力状態取得
	FGStatus_Frequency = 0x80 | FGCommand_Frequency,	// 出力周波数取得
	
	// special
	FGCommand_Reset = 0xff,			// デバイスリセット
	
} enumFGCommand;


// Characteristics
#define	CHARACTERISTICS_UUID_RESET				@"A100"
#define	CHARACTERISTICS_UUID_DEVICE				@"A101"
#define	CHARACTERISTICS_UUID_OUTPUT				@"A102"
#define	CHARACTERISTICS_UUID_FREQUENCY			@"A103"
#define	CHARACTERISTICS_UUID_WAVEFORMINFO		@"A110"
#define	CHARACTERISTICS_UUID_WAVEFORMBLOCK		@"A111"
#define	CHARACTERISTICS_UUID_WAVEFORMTOBUFFER	@"A112"


//---------------------------------------------------------
#pragma pack(1)

// for BLE waveform transfer format

typedef struct {
	uint16_t    waveSize;       // Waveform全体のデータ長(byte)  = blockSize * blockMaxNum
	uint8_t     bitPerData;     // 1データあたりのbit数 (8, 10, 12 or 16bit)
	
	uint8_t     blockSize;      // 1ブロックあたりのデータ転送サイズ(byte) (通常16bytes)
	uint8_t     blockMaxNum;    // ブロックの最大数  = (waveSize + 1) / blockSize
} WaveformInfo, FGCommandWaveformInfo;

typedef struct {
	uint16_t   blockNo;     // ブロックNo. 0 〜 (WaveformInfo.blockSize - 1)
	uint8_t    length;      // WaveformBlock.bufferの有効な長さ
	uint8_t    buffer[FGC_BUFFERTRANSFER_MAX];  // 実際のデータ
} WaveformBlock, FGCommandWaveformBlock;

//---------------------------------------------------------
// for I2C packet format

// header
typedef struct {
	uint8_t     command;
	uint8_t     length;
} FGHeader;

// command bodys
typedef struct {
	uint8_t    device;
} FGCommandDevice;

typedef struct {
	uint8_t    on;
} FGCommandOutput;

typedef struct {
	uint32_t   frequency;
} FGCommandFrequency;

//#define FGCommandWaveformInfo  WaveformInfo
//#define FGCommandWaveformBlock WaveformInfoBlock

typedef struct {
} FGCommandWaveformToBuffer;

typedef struct {
} FGCommandReset;

// status bodys
typedef struct {
	uint8_t    device;
} FGStatusDevice;

typedef struct {
	uint8_t    xxx;
} FGStatusOutput;

typedef struct {
	uint8_t    xxx;
} FGStatusFrequency;


// command Packet format
typedef struct {
	FGHeader    header;
	union {
		FGCommandDevice             commandDevice;
		FGCommandOutput             commandOutput;
		FGCommandFrequency          commandFrequency;
		FGCommandWaveformInfo       commandWaveformInfo;
		FGCommandWaveformBlock      commandWaveformBlock;
		FGCommandWaveformToBuffer   commandWaveformToBuffer;
		
		FGCommandReset           commandReset;
		
		FGStatusDevice           statusDevice;
		FGStatusOutput           statusOutput;
		FGStatusFrequency        statusFrequency;
	} body;
} FGPacket;

#pragma pack()


//----------------------------------------------------------------

@protocol FGControllerDelegate <NSObject>
- (void)didFGConnect;
- (void)didFGDisconnect;

- (void)didFGBeginCommandSend;
- (void)didFGEndCommandSend;
@end


@interface FGController : NSObject <BLEAdvertisingDelegate, BLEPeripheralAccessDelegate>
{
	BLEAdvertising		*bleAdvertising;
	BLEPeripheralAccess	*blePeripheralAccess;

}
@property (nonatomic, assign) id<FGControllerDelegate> delegate;

@property (strong)	NSMutableDictionary		*characteristicDic;		// value=CBCharacteristic


//- (void)init;
- (void)initializeContoller;

- (void)peripheralScanStart;
- (void)peripheralScanStop;

- (void)forceDisconnect;
- (BOOL)isConnected;

//- (void)setWaveForm:(double *)waveBuffer;
//- (double *)getWaveForm;

- (void)beginCommand;
- (void)endCommand;

- (void)setDevice:(int)deviceId;
- (void)setOutput:(BOOL)using;

- (void)transferWaveBuffer;
- (void)setFrequencey:(uint32_t)freq;
- (void)reset;

- (int)getDevice;
- (BOOL)getOutput;
- (UInt32)getFrequencey;

@end
