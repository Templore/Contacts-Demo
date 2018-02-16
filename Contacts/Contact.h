
#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, copy)   NSString *name;
@property (nonatomic, strong) NSArray  *phoneNumbers;
@property (nonatomic, strong) NSArray  *emails;

@end