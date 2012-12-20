//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ResultsViewController.h"
#import "Model.h"
#import "UpdateToDocuments.h"


@implementation ResultsViewController {
}


- (void) loadView {
    [super loadView];

}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    NSString *string = [[_model.scores allValues] componentsJoinedByString: @", "];

    NSLog(@"string = %@", string);
    resultLabel.text = string;

    [_queue addOperation: [[UpdateToDocuments alloc] initWithResult: string]];
}

@end