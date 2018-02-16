
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@class Contact;

@interface Utils : NSObject

+ (Contact *)getContactByContact:(ABRecordRef)aContact;

@end