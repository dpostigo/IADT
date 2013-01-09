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
#import "UIImage+Grayscale.h"


#define GHOST_IMAGE_ALPHA 0.4


@interface BasicGameViewController () <DraggableDelegate> {

    NSMutableArray *selectedImages;
}


@end


@implementation BasicGameViewController {
    NSMutableArray *selectedTags;
}


@synthesize introView;
@synthesize draggables;
@synthesize isDummyGame;


- (void) loadView {
    [super loadView];

    NSLog(@"isDummyGame = %d", isDummyGame);

    [self disableNextButton];

    if (DEBUG) {
        nextButton.userInteractionEnabled = YES;
    }

    selectedImages = [[NSMutableArray alloc] init];
    selectedTags = [[NSMutableArray alloc] init];
    introView = [[[NSBundle mainBundle] loadNibNamed: @"GameIntroView" owner: introView options: nil] objectAtIndex: 0];

    [self.view addSubview: introView];
    [self.view insertSubview: introView belowSubview: navigationBarView];

    introView.textLabel.text = [[_model.gamesData objectForKey: self.restorationIdentifier] objectForKey: @"Title"];
    introView.textLabel.text = [introView.textLabel.text stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
    introView.detailTextLabel.text = [[[_model.gamesData objectForKey: self.restorationIdentifier] objectForKey: @"Detail"] uppercaseString];

    NSLog(@"self.restorationIdentifier = %@", self.restorationIdentifier);
    NSLog(@"self.isDummyGame = %d", self.isDummyGame);
    draggables = [[NSMutableArray alloc] init];
    for (int j = 0; j < 6; j++) {
        NSInteger tag = j + 1;
        UIImageView *view = (UIImageView *) [self.view viewWithTag: tag];
        if (view) {

            if (!self.isDummyGame || self.isSortingGame) {
                UIImageView *ghost = [[UIImageView alloc] initWithFrame: view.frame];
                ghost.image = view.image;
                ghost.alpha = GHOST_IMAGE_ALPHA;
                [self.view insertSubview: ghost belowSubview: view];
            }

            Draggable *draggable = [[Draggable alloc] initWithFrame: view.frame];
            draggable.delegate = self;
            [self.view insertSubview: draggable belowSubview: view];
            draggable.contentView = view;
            draggable.droppable = containerView;
            draggable.droppables = [NSMutableArray arrayWithArray: containerViews];

            [draggables addObject: draggable];

            if (self.isDummyGame) {
                draggable.shouldFade = NO;
                draggable.reverseScale = YES;
                draggable.draggingMode = DraggingModeIntersects;
                [draggable reset];
            }

            else if (self.isSortingGame) {
                draggable.shouldFade = NO;
            }


            if (containerView == nil) {
                draggable.snapsToContainer = YES;
                draggable.maskEnabled = YES;
                draggable.circleRadius = 30;
            }

            else {
                draggable.circleRadius = 30;
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
    if (!self.isDummyGame) {
        [self calculateScoreByTags];
        //    [self calculateScoreByImageViews];
    }

    NSLog(@"_model.scores = %@", _model.scores);
}


- (void) calculateScoreByImageViews {


    NSArray *items = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Items"];
    NSString *scoringMode = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Scoring Mode"];
    if ([scoringMode isEqualToString: @"None"]) {
        return;
    }

    CGFloat score = 0;
    for (UIImageView *imageView in selectedImages) {
        NSInteger index = imageView.tag - 1;
        CGFloat midpoint = [items count] / 2;
        CGFloat thisScore = ((CGFloat) index) + ((midpoint * -1) + 1);
        score += thisScore;
    }

    CGFloat numericResult = score / [selectedImages count];
    NSString *stringResult = [[self dnaTypes] objectAtIndex: (numericResult > 0) ? 1: 0];
    [_model.scores setObject: stringResult forKey: self.restorationIdentifier];

    NSLog(@"numericResult = %f", numericResult);
    NSLog(@"stringResult = %@", stringResult);
}


- (void) calculateScoreByTags {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    NSArray *items = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Items"];
    CGFloat score = 0;
    for (NSNumber *number in selectedTags) {
        NSInteger index = [number integerValue] - 1;
        CGFloat midpoint = [items count] / 2;
        CGFloat thisScore = ((CGFloat) index) + ((midpoint * -1) + 1);
        score += thisScore;
    }

    CGFloat numericResult = score / [selectedTags count];
    NSUInteger resultIndex = (numericResult > 0) ? 1: 0;
    NSString *stringResult = [[self dnaTypes] objectAtIndex: resultIndex];


    //    NSLog(@"numericResult = %f", numericResult);
    //    NSLog(@"stringResult = %@", stringResult);

    NSString *scoringMode = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Scoring Mode"];
    CGPoint pointScore = CGPointMake(0, 0);
    if ([scoringMode isEqualToString: @"None"]) {
        return;
    } else if ([scoringMode isEqualToString: @"Vertical"]) {
        pointScore = CGPointMake(0, numericResult);
    } else if ([scoringMode isEqualToString: @"Horizontal"]) {
        pointScore = CGPointMake(numericResult, 0);
    } else if ([scoringMode isEqualToString: @"Digital"]) {
        pointScore = CGPointMake(numericResult, numericResult * -1);
    }

    [_model.scores setObject: stringResult forKey: self.restorationIdentifier];
    [_model.pointScores setObject: [NSValue valueWithCGPoint: pointScore] forKey: self.restorationIdentifier];
}


- (NSArray *) dnaTypes {
    NSString *range = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Range"];
    NSArray *options = [range componentsSeparatedByString: @", "];
    return options;
}


- (CGFloat) calculateScoreForImage: (UIImageView *) imageView {

    NSInteger index = imageView.tag - 1;
    NSArray *items = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Items"];
    CGFloat midpoint = [items count] / 2;
    CGFloat score = ((CGFloat) index) + ((midpoint * -1) + 1);

    return score;
}


- (void) viewDidDisappear: (BOOL) animated {
    [super viewDidDisappear: animated];

    [self saveScore];
    [self reset: self];
}


- (IBAction) reset: (id) sender {

    itemCount = 0;
    [self resetDraggables];
    [self clearResults];
    [self resetSuccessViews];

    for (UIView *c in containerViews) {
        c.userInteractionEnabled = YES;
    }


    [self disableNextButton];
}


- (void) resetDraggables {
    for (Draggable *d in draggables) {
        for (UIView *droppable in d.droppables) {
            droppable.userInteractionEnabled = YES;
        }
        [d reset];
    }
}


- (void) clearResults {
    [selectedImages removeAllObjects];
}
int rand_range(int min_n, int max_n) {
    return arc4random() % (max_n - min_n + 1) + min_n;
}
- (void) resetSuccessViews {
    for (UIView *view in successViews) {
        view.alpha = 0;
        view.userInteractionEnabled = NO;
    }

    if (labels) {
        for (UILabel *label in labels) {

            [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
                label.alpha = 1.0;
            }                completion: ^(BOOL completion) {
            }];
        }
    }
}

#pragma mark DraggableDelegate


- (void) draggableBeganDrop: (Draggable *) draggable {

    UIImageView *item = (UIImageView *) draggable.contentView;
    UILabel *label = (UILabel *) [self.view viewWithTag: item.tag + 10];
    if (label) {
        [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
            label.alpha = GHOST_IMAGE_ALPHA;
        }                completion: ^(BOOL completion) {
        }];
    }
}


- (void) draggableDidNotDrop: (Draggable *) draggable {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    UIImageView *item = (UIImageView *) draggable.contentView;
    UILabel *label = (UILabel *) [self.view viewWithTag: item.tag + 10];
    if (label) {
        [UIView animateWithDuration: 0.5 animations: ^{
            label.alpha = 1.0;
        }];
    }

    [self updateScore];
    [self handleToggleNextButton];
}


- (void) draggableDidDrop: (Draggable *) draggable {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    UIImageView *item = (UIImageView *) draggable.contentView;

    itemCount++;
    [self updateScore];
    [self handleLimit: draggable];
    [self handleSuccess: draggable];
    [self handleToggleNextButton];
}


- (void) updateScore {
    if (!self.isDummyGame) {

        [selectedImages removeAllObjects];
        [selectedTags removeAllObjects];

        for (Draggable *draggable in draggables) {
            if (draggable.isPlaced) {
                UIImageView *item = (UIImageView *) draggable.contentView;
                [selectedImages addObject: item];
                [selectedTags addObject: [NSNumber numberWithInteger: item.tag]];
            }
        }

        [self logTags];
    }
}


- (void) logTags {
    NSArray *items = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Items"];
    NSMutableArray *strings = [[NSMutableArray alloc] init];

    for (NSNumber *number in selectedTags) {
        NSString *string = [items objectAtIndex: (NSUInteger) [number integerValue] - 1];
        string = [string stringByReplacingOccurrencesOfString: @".png" withString: @""];
        [strings addObject: [string capitalizedString]];
    }
}


- (void) handleLimit: (Draggable *) draggable {
    if (self.isContainerGame && itemCount == 3) {
        NSLog(@"Handling limit");
        for (Draggable *d in draggables) {
            d.droppingDisabled = YES;
        }
    }
}


- (void) handleSuccess: (Draggable *) draggable {
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


- (void) handleSingleContainer {
}


- (void) handleToggleNextButton {
    if (self.isContainerGame && itemCount == 3) {
        [self enableNextButton];
    }

    else if (self.isSortingGame && [selectedTags count] == 3) {
        [self enableNextButton];
    }

    else if (self.isDummyGame) {
        Draggable *draggable = [draggables objectAtIndex: 0];
        if (draggable.currentDrop != nil) [self enableNextButton];
        else {
            [self disableNextButton];
        }
    }
}


- (void) enableNextButton {
    nextButton.userInteractionEnabled = YES;
    [UIView animateWithDuration: 0.25 animations: ^{
        nextButton.alpha = 1;
    }];
}


- (void) disableNextButton {
    nextButton.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.25 animations: ^{
        nextButton.alpha = GHOST_IMAGE_ALPHA;
    }];
}


- (BOOL) isSortingGame {
    return (containerViews != nil && [containerViews count] > 0);
}


- (BOOL) isContainerGame {
    return (containerView != nil && !self.isDummyGame);
}


@end