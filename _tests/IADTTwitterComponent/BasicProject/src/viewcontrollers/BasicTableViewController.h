//
// Created by dpostigo on 12/5/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "BasicViewController.h"


@protocol BasicTableViewProtocol

@optional

- (void) prepareDataSource;

@end

@interface BasicTableViewController : BasicViewController {

    IBOutlet UITableView *table;

    NSMutableArray *dataSource;


}

@property(nonatomic, strong) IBOutlet UITableView *table;
@property(nonatomic, strong) NSMutableArray *dataSource;
- (void) prepareDataSource;
- (void) registerExternalNibs;

@end