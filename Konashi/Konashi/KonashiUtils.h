#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

extern NSString *NSStringFromCBCentralManagerState(CBCentralManagerState);
extern NSString *NSStringFromCBCharacteristicProperty(CBCharacteristicProperties);
extern NSString *NSStringFromCFUUIDRef(CFUUIDRef);
extern CBUUID *kns_CreateUUIDFromString(NSString *, CBUUID *);
