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
    [self.view insertSubview: introView belowSubview: navigationBarView];

    introView.textLabel.text = [[_model.gamesData objectForKey: self.restorationIdentifier] objectForKey: @"Title"];
    introView.textLabel.text = [introView.textLabel.text stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
    introView.detailTextLabel.text = [[[_model.gamesData objectForKey: self.restorationIdentifier] objectForKey: @"Detail"] uppercaseString];
}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    introView.frame = self.view.bounds;

    startPositions = [[NSMutableArray alloc] init];
    for (int j = 0; j < 6; j++) {

        NSInteger tag = j + 1;
        UIView *view = [self.view viewWithTag: tag];
        if (view) {

            CGPoint point = view.origin;

            [startPositions addObject: [NSValue valueWithCGPoint: point]];
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(dragItem:)];
            panGesture.cancelsTouchesInView = NO;
            panGesture.delaysTouchesBegan = NO;
            [view addGestureRecognizer: panGesture];
        }
    }

    [self resetSuccessViews];
}


- (void) saveScore {

    NSArray *selectedImages;
    NSMutableArray *points = [[NSMutableArray alloc] init];
    CGFloat xValue = 0;
    CGFloat yValue = 0;
    CGFloat score = 0;
    for (UIImageView *imageView in selectedImages) {

        //        CGPoint point = [self calculatePoint: imageView];
        //        xValue = point.x;
        //        yValue = point.y;

        score += [self calculateScore: imageView];
    }

    score = score / [selectedImages count];
    NSString *range = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Range"];
    NSArray *options = [range componentsSeparatedByString: @", "];
    NSUInteger resultIndex = (score > 0) ? 1: 0;
    NSString *result = [options objectAtIndex: resultIndex];
    [_model.scores setObject: result forKey: self.restorationIdentifier];
}


- (CGPoint) calculatePoint: (UIImageView *) imageView {

    CGFloat score = [self calculateScore: imageView];
    CGPoint point = CGPointZero;
    NSString *scoringMode = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Scoring Mode"];
    if ([scoringMode isEqualToString: @"Horizontal"]) {
        point = CGPointMake(score, 0);
    }
    else if ([scoringMode isEqualToString: @"Vertical"]) {
        point = CGPointMake(0, score);
    }
    else if ([scoringMode isEqualToString: @"Diagonal Top"]) {
        point = CGPointMake(score, score * -1);
    }

    else if ([scoringMode isEqualToString: @"Diagonal Bottom"]) {
        point = CGPointMake(score, score);
    }
}


- (CGFloat) calculateScore: (UIImageView *) imageView {

    NSString *imageString = @"knife-icon.png";
    NSArray *items = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Items"];
    NSUInteger midpoint = [items count] / 2;
    NSUInteger index = [items indexOfObject: imageString];
    CGFloat score = index + ((midpoint * -1) + 1);

    return score;
}


- (void) viewDidDisappear: (BOOL) animated {
    [super viewDidDisappear: animated];
    [self reset: self];
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

    NSArray *array = [touches allObjects];

    NSLog(@"%s", __PRETTY_FUNCTION__);

    for (UITouch *touch in array) {
        if (touch.view.tag != 0) {
            [UIView animateWithDuration: 0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{

                touch.view.transform = CGAffineTransformScale(touch.view.transform, 1.15, 1.15);
            }                completion: ^(BOOL completion) {
            }];
        }
    }
}


- (void) touchesCancelled: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesCancelled: touches withEvent: event];

    NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event {
    [super touchesEnded: touches withEvent: event];

    UITouch *touch = [[touches allObjects] objectAtIndex: 0];
    NSArray *array = [touches allObjects];

    for (UITouch *touch in array) {
        if (touch.view.tag != 0) {
            [UIView animateWithDuration: 0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{

                //                touch.view.alpha = 1.0;

                touch.view.transform = CGAffineTransformIdentity;
            }                completion: ^(BOOL completion) {

                //                [self itemDropped: touch.view];
            }];
        }
    }
}


- (void) dragItem: (UIPanGestureRecognizer *) recognizer {

    NSLog(@"%s", __PRETTY_FUNCTION__);
    CGPoint translation = [recognizer translationInView: self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
            recognizer.view.center.y + translation.y);
    [recognizer setTranslation: CGPointMake(0, 0) inView: self.view];

    if (containerView != nil) {

        BOOL intersecting = CGRectIntersectsRect(containerView.frame, recognizer.view.frame);
        if (recognizer.state == UIGestureRecognizerStateChanged) {
            [UIView animateWithDuration: 0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
                if (containerView != backgroundView) containerView.alpha = intersecting ? 0.8: 1.0;
            }

                             completion: nil];
        }
        else if (recognizer.state == UIGestureRecognizerStateEnded) {

            [UIView animateWithDuration: 0.2 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{

                if (intersecting) {

                    NSLog(@"intersecting = %d", intersecting);

                    recognizer.view.alpha = (containerView == backgroundView);
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
                        //                        [self itemDropped: recognizer.view];
                        recognizer.view.transform = CGAffineTransformIdentity;
                    }
                }];
            }
        }
    }
}
int rand_range(int min_n, int max_n) {
    return arc4random() % (max_n - min_n + 1) + min_n;
}
- (void) itemDropped: (UIView *) item {

    if (successView) {
        UIView *view = [successView viewWithTag: item.tag * 10];
        [UIView animateWithDuration: 0.25 animations: ^{
            view.alpha = 1;

            view.transform = CGAffineTransformRotate(view.transform, 1);
        }];
    }
}


- (void) resetSuccessViews {
    for (UIView *view in successView.subviews) {

        view.alpha = 0;
        view.userInteractionEnabled = NO;
    }
}

@end