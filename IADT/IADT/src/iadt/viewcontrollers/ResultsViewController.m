//
// Created by dpostigo on 12/18/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ResultsViewController.h"
#import "Model.h"


@implementation ResultsViewController {
}


- (void) loadView {
    [super loadView];

}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];

    NSString *string = [[_model.scores allValues] componentsJoinedByString: @", "];
    resultTextField.text = string;
}

@end