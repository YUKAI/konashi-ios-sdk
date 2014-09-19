#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

extern NSString *NSStringFromCBCentralManagerState(CBCentralManagerState);
extern NSString *NSStringFromCBCharacteristicProperty(CBCharacteristicProperties);
extern NSString *NSStringFromCFUUIDRef(CFUUIDRef);
extern UInt16 kns_swapUInt16(UInt16);
extern BOOL kns_compareCFUUIDRef(CFUUIDRef, CFUUIDRef);