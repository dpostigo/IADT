//
// Created by dpostigo on 12/5/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicTableViewController.h"

@implementation BasicTableViewController {
}

@synthesize table;
@synthesize dataSource;


- (void) viewDidLoad {
    [super viewDidLoad];

    if (table.style == UITableViewStyleGrouped) {
        table.backgroundView = [[UIView alloc] init];
    }
    table.delegate = self;
    table.dataSource = self;
    [self prepareDataSource];

    [self registerExternalNibs];
}


- (void) prepareDataSource {


}

- (void) viewDidAppear: (BOOL) animated {
    [super viewDidAppear: animated];
    [table deselectRowAtIndexPath: [table indexPathForSelectedRow] animated: YES];
}

- (void) registerExternalNibs {

}

@end