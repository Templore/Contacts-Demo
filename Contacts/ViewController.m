
#import "ViewController.h"
#import "TableViewController.h"
#import "Contact.h"
#import "Utils.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel  *result;
@property (weak, nonatomic) IBOutlet UILabel  *message;
@property (weak, nonatomic) IBOutlet UIButton *see;

@property (nonatomic, strong) NSMutableArray  *contacts;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /* If you want to change the value of 'accessGranted' in a block, '__block' is necessary! */
    __block BOOL accessGranted = NO;
    
    /* The options argument is reserved for future use. Currently it will always be NULL */
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        /* The user has not yet made a choice regarding whether this app can access the contacts */
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
            
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        /* This application is authorized to access the contacts */
        accessGranted = YES;
        self.message.text = @"This application is authorized to access the contacts";
    }
    else
    {
        /* This application is not authorized to access the contacts */
        accessGranted = NO;
        self.message.text = @"This application is not authorized to access the contacts";
    }
    
    if (accessGranted)
    {
        self.result.hidden  = NO;
        self.see.hidden     = NO;
        
        /* All contacts */
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
        self.result.text = [NSString stringWithFormat:@"You have %ld contacts", CFArrayGetCount(allPeople)];
        
        self.contacts = [NSMutableArray array];
        for (int i = 0; i < CFArrayGetCount(allPeople); i++)
        {
            ABRecordRef aPeople = CFArrayGetValueAtIndex(allPeople, i);
            Contact *contact = [Utils getContactByContact:aPeople];
            [self.contacts addObject:contact];
        }
    }
    else
    {
        self.result.hidden  = YES;
        self.see.hidden     = YES;
    }
}

- (IBAction)click:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"detail" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TableViewController *destinationTableViewController = segue.destinationViewController;
    destinationTableViewController.contacts = self.contacts;
}

@end