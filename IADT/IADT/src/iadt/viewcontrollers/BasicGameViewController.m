//
// Created by dpostigo on 12/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicGameViewController.h"
#import "GameIntroView.h"
#import "Model.h"


@implementation BasicGameViewController {
}


@synthesize introView;
@synthesize titleText;
@synthesize detailTitleText;



- (void) loadView {
    [super loadView];

    NSLog(@"self.restorationIdentifier = %@", self.restorationIdentifier);

    introView = [[[NSBundle mainBundle] loadNibNamed: @"GameIntroView" owner: introView options: nil] objectAtIndex: 0];
    [self.view addSubview: introView];

    introView.textLabel.text = [[_model.gamesData objectForKey: self.restorationIdentifier] objectForKey: @"Title"];



    introView.textLabel.text = [introView.textLabel.text stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
    introView.detailTextLabel.text = [[_model.gamesData objectForKey: self.restorationIdentifier] objectForKey: @"Detail"];
}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    introView.frame = self.view.bounds;
}


- (IBAction) dragItem: (UIPanGestureRecognizer *) recognizer {

    NSLog(@"%s", __PRETTY_FUNCTION__);


    CGPoint translation = [recognizer translationInView: self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
            recognizer.view.center.y + translation.y);
    [recognizer setTranslation: CGPointMake(0, 0) inView: self.view];




    if (recognizer.state == UIGestureRecognizerStateEnded) {
        //        [_queue addOperation: [[SendOperation alloc] initWithVariables: [NSString stringWithFormat: @"kittyPosX=%f&kittyPosY=%f", kitty.left, kitty.top]]];
    }

}



@end