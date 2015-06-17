//
//  Defines.h
//  FunctionGenBLE
//
//  Created by Takehisa Oneta on 2015/05/26.
//  Copyright (c) 2015年 Takehisa Oneta. All rights reserved.
//

#ifndef FunctionGenBLE_Defines_h
#define FunctionGenBLE_Defines_h

//---------------------------------------------------------
// BLE service info.
#define	BLE_MY_SERVICE_UUID		@"FFFF"
#define	BLE_MY_SERVICE_NAME		@"mbedFuncGen 0.01"

//---------------------------------------------------------

typedef enum WaveKind {
	WaveKind_None = 0,
	WaveKind_Sine = 1,
	WaveKind_Square,
	WaveKind_Triangle,
	WaveKind_Sawtooth,
	WaveKind_Freehand,
} WaveKind;

//---------------------------------------------------------

#endif
