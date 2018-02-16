
#import "TableViewController.h"
#import "TableViewCell.h"
#import "Contact.h"

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark ~ Table view data source ~

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Contact *contact = self.contacts[indexPath.row];
    
    cell.name.text          = contact.name;
    cell.phoneNumbers.text  = [contact.phoneNumbers componentsJoinedByString:@", "];
    cell.emails.text        = [contact.emails componentsJoinedByString:@", "];
    
    return cell;
}

@end