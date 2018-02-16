
#import "Utils.h"
#import "Contact.h"

@implementation Utils

+ (Contact *)getContactByContact:(ABRecordRef)aContact
{
    Contact *contact = [[Contact alloc] init];
    
    NSMutableArray *names        = [NSMutableArray array];
    NSMutableArray *phoneNumbers = [NSMutableArray array];
    NSMutableArray *emails       = [NSMutableArray array];
    
    /* Use '__bridge' to convert  */
    
    NSString *prefix = (__bridge NSString *)(ABRecordCopyValue(aContact, kABPersonPrefixProperty));
    if (![self isBlankString:prefix]) [names addObject:prefix];
    
    NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(aContact, kABPersonFirstNameProperty));
    if (![self isBlankString:firstName]) [names addObject:firstName];
    
    NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(aContact, kABPersonLastNameProperty));
    if (![self isBlankString:lastName]) [names addObject:lastName];
    
    NSString *suffix = (__bridge NSString *)(ABRecordCopyValue(aContact, kABPersonSuffixProperty));
    if (![self isBlankString:suffix]) [names addObject:suffix];
    
    NSString *fullName       = [names componentsJoinedByString:@" "];
    NSString *nickName       = (__bridge NSString *)(ABRecordCopyValue(aContact, kABPersonNicknameProperty));
    NSString *organization   = (__bridge NSString *)(ABRecordCopyValue(aContact, kABPersonOrganizationProperty));
    NSString *department     = (__bridge NSString *)(ABRecordCopyValue(aContact, kABPersonDepartmentProperty));
    NSString *jobTitle       = (__bridge NSString *)(ABRecordCopyValue(aContact, kABPersonJobTitleProperty));
    
    /* Name */
    if (![self isBlankString:fullName]) contact.name = fullName;
    else
    {
        if (![self isBlankString:nickName]) contact.name = nickName;
        else
        {
            if (![self isBlankString:organization]) contact.name = organization;
            else
            {
                if (![self isBlankString:department]) contact.name = department;
                else
                {
                    if (![self isBlankString:jobTitle]) contact.name = jobTitle;
                    else contact.name = @"Anonymous contact";
                }
            }
        }
    }
    
    /* Phone-numbers */
    ABMultiValueRef phone = ABRecordCopyValue(aContact, kABPersonPhoneProperty);
    for (int i = 0; i < ABMultiValueGetCount(phone); i++)
    {
        NSString *aPhone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phone, i));
        [phoneNumbers addObject:aPhone];
    }
    contact.phoneNumbers = phoneNumbers;
    
    /* Emails */
    ABMultiValueRef email = ABRecordCopyValue(aContact, kABPersonEmailProperty);
    for (int i = 0; i < ABMultiValueGetCount(email); i++)
    {
        NSString *aEmail = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(email, i));
        [emails addObject:aEmail];
    }
    contact.emails = emails;
    
    return contact;
}

+ (BOOL)isBlankString:(NSString *)aString
{
    if (aString == nil)                             return YES;
    if (aString == NULL)                            return YES;
    if ([aString isKindOfClass:[NSNull class]])     return YES;
    if ([aString isEqualToString:@" "])             return YES;
    if ([aString isEqualToString:@""])              return YES;
    
    return NO;
}

@end