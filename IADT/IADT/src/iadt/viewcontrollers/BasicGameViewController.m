//
// Created by dpostigo on 12/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicGameViewController.h"
#import "GameIntroView.h"
#import "Model.h"
#import "PuttyView.h"
#import "Draggable.h"


@interface BasicGameViewController () <DraggableDelegate>


@end


@implementation BasicGameViewController {
}


@synthesize introView;
@synthesize draggables;


- (void) loadView {
    [super loadView];

    introView = [[[NSBundle mainBundle] loadNibNamed: @"GameIntroView" owner: introView options: nil] objectAtIndex: 0];
    [self.view addSubview: introView];
    [self.view insertSubview: introView belowSubview: navigationBarView];

    introView.textLabel.text = [[_model.gamesData objectForKey: self.restorationIdentifier] objectForKey: @"Title"];
    introView.textLabel.text = [introView.textLabel.text stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
    introView.detailTextLabel.text = [[[_model.gamesData objectForKey: self.restorationIdentifier] objectForKey: @"Detail"] uppercaseString];

    draggables = [[NSMutableArray alloc] init];
    for (int j = 0; j < 6; j++) {
        NSInteger tag = j + 1;
        UIView *view = [self.view viewWithTag: tag];
        if (view) {
            Draggable *draggable = [[Draggable alloc] initWithFrame: view.frame];
            draggable.delegate = self;
            [self.view insertSubview: draggable belowSubview: view];
            draggable.contentView = view;
            draggable.droppable = containerView;
            draggable.droppables = [NSMutableArray arrayWithArray:  containerViews];

            [draggables addObject: draggable];

            if (containerView == backgroundView || containerViews != nil) draggable.shouldFade = NO;
            if (containerView == nil) {
                draggable.snapsToContainer = YES;
                draggable.maskEnabled = YES;
                draggable.circleRadius = 50;
            }
        }
    }

    [self resetSuccessViews];
}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    introView.frame = self.view.bounds;
}


- (void) saveScore {

    NSString *scoringMode = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Scoring Mode"];
    if ([scoringMode isEqualToString: @"None"]) {
        return;
    }

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

    NSLog(@"_model.scores = %@", _model.scores);
}


- (CGPoint) calculatePoint: (UIImageView *) imageView {

    NSString *scoringMode = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Scoring Mode"];
    CGFloat score = [self calculateScore: imageView];
    CGPoint point = CGPointZero;

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

    NSInteger index = imageView.tag;

    NSLog(@"index = %i", index);

    NSArray *items = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Items"];
    NSUInteger midpoint = [items count] / 2;
    CGFloat score = index + ((midpoint * -1) + 1);

    return score;
}


- (void) viewDidDisappear: (BOOL) animated {
    [super viewDidDisappear: animated];

    [self saveScore];
    [self reset: self];
}


- (IBAction) reset: (id) sender {
    for (Draggable *d in draggables) [d reset];
    itemCount = 0;

    [self resetSuccessViews];

    for (UIView *c in containerViews) {
        c.userInteractionEnabled = YES;
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
    for (UIView *view in successViews) {
        view.alpha = 0;
        view.userInteractionEnabled = NO;
    }
}


- (void) draggableDidDrop: (Draggable *) draggable {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    itemCount++;

    if (itemCount == 3) {
        for (Draggable *d in draggables) d.droppingDisabled = YES;

    }


    if (draggable.snapsToContainer) {
    }

    else if (successViews) {
        for (UIImageView *imageView in successViews) {
            if (imageView.alpha == 0) {

                imageView.image = ((UIImageView *) draggable.contentView).image;
                imageView.top += 10;

                [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{

                    imageView.alpha = 1;
                    imageView.top -= 10;
                }                completion: ^(BOOL completion) {
                }];

                return;
            }
        }
    }
}

@end