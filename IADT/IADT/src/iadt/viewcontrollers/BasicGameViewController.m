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
@synthesize startPositions;


- (void) loadView {
    [super loadView];

    introView = [[[NSBundle mainBundle] loadNibNamed: @"GameIntroView" owner: introView options: nil] objectAtIndex: 0];
    [self.view addSubview: introView];

    introView.textLabel.text = [[_model.gamesData objectForKey: self.restorationIdentifier] objectForKey: @"Title"];
    introView.textLabel.text = [introView.textLabel.text stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
    introView.detailTextLabel.text = [[[_model.gamesData objectForKey: self.restorationIdentifier] objectForKey: @"Detail"] uppercaseString];
}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    introView.frame = self.view.bounds;

    NSLog(@"%s", __PRETTY_FUNCTION__);

    startPositions = [[NSMutableArray alloc] init];
    for (int j = 0; j < 6; j++) {

        NSInteger tag = j + 1;
        UIView *view = [self.view viewWithTag: tag];
        if (view) {

            CGPoint point = view.origin;

            [startPositions addObject: [NSValue valueWithCGPoint: point]];
            [view addGestureRecognizer: [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(dragItem:)]];
        }
    }
}


- (void) viewDidLoad {
    [super viewDidLoad];
}


- (IBAction) reset: (id) sender {

    for (int j = 0; j < 6; j++) {
        NSInteger tag = j + 1;
        UIView *view = [self.view viewWithTag: tag];
        if (view) {
            CGPoint point = [[startPositions objectAtIndex: j] CGPointValue];
            view.left = point.x;
            view.top = point.y;

            //            if (view.hidden) {

            view.alpha = 0;
            view.hidden = NO;
            [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{

                view.alpha = 1;
            }                completion: nil];
            //            }
        }
    }
}


- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesBegan: touches withEvent: event];

    UITouch *touch = [[touches allObjects] objectAtIndex: 0];
    NSArray *array = [touches allObjects];

    for (UITouch *touch in array) {
        if (touch.view.tag != 0) {
            [UIView animateWithDuration: 0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{

                touch.view.alpha = 0.5;
                touch.view.transform = CGAffineTransformScale(touch.view.transform, 1.15, 1.15);
            }                completion: ^(BOOL completion) {
            }];
        }
    }
}


- (void) dragItem: (UIPanGestureRecognizer *) recognizer {

    CGPoint translation = [recognizer translationInView: self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
            recognizer.view.center.y + translation.y);
    [recognizer setTranslation: CGPointMake(0, 0) inView: self.view];

    if (containerView != nil) {
        BOOL intersecting = CGRectIntersectsRect(containerView.frame, recognizer.view.frame);
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            [UIView animateWithDuration: 0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
                containerView.alpha = intersecting ? 0.8: 1.0;
            }                completion: nil];
        }
        else if (recognizer.state == UIGestureRecognizerStateEnded) {

            [UIView animateWithDuration: 0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{

                if (intersecting) {

                    NSLog(@"intersecting = %d", intersecting);

                    recognizer.view.alpha = (containerView != backgroundView);
                    recognizer.view.transform = CGAffineTransformIdentity;
                }
                else {

                    recognizer.view.alpha = 1.0;
                    recognizer.view.transform = CGAffineTransformIdentity;
                }
            }                completion: ^(BOOL completion) {

                if (intersecting) {
                    recognizer.view.hidden = (containerView != backgroundView);
                    recognizer.view.transform = CGAffineTransformIdentity;
                }
            }];
        }
        return;
    }

    else if (containerViews != nil && [containerViews count] > 0) {

        NSLog(@"Checking container views.");

        for (UIView *aView in containerViews) {
            BOOL intersecting = CGRectIntersectsRect(aView.frame, recognizer.view.frame);
            if (recognizer.state == UIGestureRecognizerStateChanged) {
                [UIView animateWithDuration: 0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
                    aView.alpha = intersecting ? 0.8: 1.0;
                }                completion: nil];
            }
            else if (recognizer.state == UIGestureRecognizerStateEnded) {

                [UIView animateWithDuration: 0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{

                    if (intersecting) {
                        NSLog(@"Intersects");
                        //recognizer.view.alpha = 0;
                        //recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, 0, 0);
                        recognizer.view.transform = CGAffineTransformIdentity;
                    }
                    else {

                        recognizer.view.alpha = 1.0;
                        recognizer.view.transform = CGAffineTransformIdentity;
                    }
                }                completion: ^(BOOL completion) {

                    if (intersecting) {
                        NSLog(@"Removed from superview");
                        //                        recognizer.view.hidden = YES;
                        recognizer.view.transform = CGAffineTransformIdentity;
                    }
                }];
            }
        }
    }
}

@end