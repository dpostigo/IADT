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


#define ITEM_TAG 10
#define BUTTON_TAG 20
#define DRAGGABLE_TAG 40
#define DegreesToRadians(x) ((x) * M_PI / 180.0)


@interface BasicGameViewController () <DraggableDelegate> {
}


@end


@implementation BasicGameViewController {
    NSMutableArray *selectedTags;
    UILabel *instructionLabel;
}


@synthesize introView;
@synthesize draggables;
@synthesize isDummyGame;

int rand_range(int min_n, int max_n) {
    return arc4random() % (max_n - min_n + 1) + min_n;
}
- (void) loadView {
    [super loadView];

    selectedTags = [[NSMutableArray alloc] init];
    [self disableNextButton];
    [self setupIntroView];
    [self setupInstructionText];

    draggables = [[NSMutableArray alloc] init];

    for (int j = 0; j < 6; j++) {
        NSInteger tag = j + 1;
        UIImageView *view = (UIImageView *) [self.view viewWithTag: tag];
        if (view) {

            NSLog(@"view = %@", view);

            [self handleGhostImage: view];

            Draggable *draggable = [[Draggable alloc] initWithFrame: view.frame];
            draggable.delegate = self;
            [self.view insertSubview: draggable belowSubview: view];
            draggable.contentView = view;
            draggable.droppable = containerView;
            draggable.tag = DRAGGABLE_TAG + view.tag;
            draggable.associatedLabel = (UILabel *) [self.view viewWithTag: view.tag + ITEM_TAG];

            [draggables addObject: draggable];

            if (self.isDummyGame) {
                draggable.shouldFade = NO;
                draggable.draggingMode = DraggingModeContains;
                draggable.maskType = DraggableMaskTypeCustom;
                draggable.maskView.frame = CGRectMake(0, 0, 3, 3);
                draggable.maskView.left = view.width / 2 - draggable.maskView.width / 2;
                draggable.maskView.top = view.height / 2 - draggable.maskView.height / 2;

                [draggable reset];
            }

            else if (self.isSortingGame) {
                draggable.shouldFade = NO;
                draggable.droppables = [NSMutableArray arrayWithArray: containerViews];
            }

            else if (self.isContainerGame) {
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


- (void) handleGhostImage: (UIImageView *) view {

    if (!self.isDummyGame) {
        UIImageView *ghost = [[UIImageView alloc] initWithFrame: view.frame];
        ghost.image = view.image;
        ghost.alpha = GHOST_IMAGE_ALPHA;
        [self.view insertSubview: ghost belowSubview: view];
    }
}


- (void) setupInstructionText {
    instructionLabel = [[UILabel alloc] initWithFrame: CGRectMake(90, 128, 600, 21)];
    instructionLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 18.0];
    instructionLabel.text = introView.detailTextLabel.text;
    instructionLabel.backgroundColor = [UIColor clearColor];
    instructionLabel.alpha = 0;
    [self.view insertSubview: instructionLabel belowSubview: introView];
    
}
- (void) setupIntroView {
    introView = [[[NSBundle mainBundle] loadNibNamed: @"GameIntroView" owner: introView options: nil] objectAtIndex: 0];
    introView.delegate = self;
    [self.view insertSubview: introView belowSubview: navigationBarView];
    introView.textLabel.text = [[_model.gamesData objectForKey: self.restorationIdentifier] objectForKey: @"Title"];
    introView.textLabel.text = [introView.textLabel.text stringByReplacingOccurrencesOfString: @"\\n" withString: @"\n"];
    introView.detailTextLabel.text = [[[_model.gamesData objectForKey: self.restorationIdentifier] objectForKey: @"Detail"] uppercaseString];
}


- (void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
    introView.frame = self.view.bounds;
}


- (void) saveScore {
    if (!self.isDummyGame) {
        [self calculateScoreByTags];
    }

    NSLog(@"_model.scores = %@", _model.scores);
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
    [self resetSuccessViews];

    for (UIView *c in containerViews) {
        c.userInteractionEnabled = YES;
    }

    [self disableNextButton];
    [introView show: self.view];
}


- (void) resetDraggables {
    for (Draggable *d in draggables) {
        [d reset: NO];
    }
}


- (void) resetSuccessViews {

    if (self.isDummyGame) {

        Draggable *draggable = [draggables objectAtIndex: 0];

        draggable.transform = CGAffineTransformScale(draggable.transform, 1.15, 1.15);
    }
    for (UIView *view in successViews) {
        view.alpha = 0;
        view.userInteractionEnabled = NO;
    }

    for (UIButton *button in successButtons) {
        button.alpha = 0;
    }
}



- (void) toggleOtherDraggables: (Draggable *) draggable enabled: (BOOL) isEnabled {
    for (Draggable *aDraggable in draggables) {
        if (aDraggable != draggable) {
            aDraggable.userInteractionEnabled = isEnabled;
        }
    }
}

#pragma mark DraggableDelegate



- (void) draggableBeganDragging: (Draggable *) draggable {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [self.view bringSubviewToFront: draggable];

    [self toggleOtherDraggables: draggable enabled: NO];

}


- (void) draggableDidNotDrop: (Draggable *) draggable {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [self updateScore];
    [self handleToggleNextButton];
}


- (void) draggableWillDrop: (Draggable *) draggable {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    UIImageView *item = (UIImageView *) draggable.contentView;

    itemCount++;
    [self updateScore];
    [self handleLimit: draggable];
    [self handleSuccess: draggable];
    [self handleToggleNextButton];

}


- (void) draggableDidFinishDragging: (Draggable *) draggable {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self toggleOtherDraggables: draggable enabled: YES];
}


- (void) updateScore {
    if (!self.isDummyGame) {

        [selectedTags removeAllObjects];

        for (Draggable *draggable in draggables) {
            if (draggable.isPlaced) {
                UIImageView *item = (UIImageView *) draggable.contentView;
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

    else if (successButtons) {
        for (UIButton *button in successButtons) {

            if (button.alpha == 0) {
                UIImage *image = ((UIImageView *) draggable.contentView).image;
                [button setImage: image forState: UIControlStateNormal];
                button.top += 10;
                button.tag = BUTTON_TAG + draggable.contentView.tag;

                NSInteger index = [successButtons indexOfObject: button];
                CGFloat degrees = 10;
                if (index == 0) degrees = -10;
                else if (index == 2) degrees = 10;

                NSLog(@"degrees = %f", degrees);

                button.transform = CGAffineTransformIdentity;
                //                button.transform = CGAffineTransformRotate(button.transform, DegreesToRadians(degrees));

                [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
                    button.alpha = 1;
                    button.top -= 10;
                }                completion: ^(BOOL completion) {
                    //                    draggable.left = button.left;
                    //                    draggable.top = button.top;
                }];

                return;
            }
        }
    }
}


- (void) handleSingleContainer {
}


- (void) handleToggleNextButton {
    if (self.isContainerGame || self.isSortingGame) {

        NSLog(@"selectedTags = %@", selectedTags);

        if ([selectedTags count] == 3) {
            [self enableNextButton];
        }

        else {
            [self disableNextButton];
        }
    }

    else if (self.isDummyGame) {
        Draggable *draggable = [draggables objectAtIndex: 0];
        if (draggable.isPlaced) [self enableNextButton];
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

    if (DEBUG) {
        nextButton.userInteractionEnabled = YES;
    }
}


- (BOOL) isSortingGame {
    return (containerViews != nil && [containerViews count] > 0);
}


- (BOOL) isContainerGame {
    return (containerView != nil && !self.isDummyGame);
}


- (void) handleContainerTapped: (id) sender {
    for (UIButton *button in successButtons) {
        if (button.alpha == 1) {
        }
    }
}


- (IBAction) handleSuccessButtonTapped: (id) sender {
    [self revertSuccessButton: sender];

    Draggable *draggable = (Draggable *) [self.view viewWithTag: [sender tag] - 20 + DRAGGABLE_TAG];
    [draggable reset];

    [self updateScore];
    [self handleToggleNextButton];
}


- (void) revertSuccessButton: (UIButton *) button {
    [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
        button.alpha = 0;
    }                completion: nil];
}


- (void) gameIntroViewWillDismiss: (GameIntroView *) gameIntroView {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    CGFloat textDelay = 0.5;

    if (self.isDummyGame) {

        textDelay = 0.7;
        Draggable *draggable = [draggables objectAtIndex: 0];
        [UIView animateWithDuration: 0.15 delay: 0.15 options: UIViewAnimationOptionCurveEaseInOut animations: ^{

            draggable.transform = CGAffineTransformIdentity;
        }                completion: nil];
    }

    [UIView animateWithDuration: 0.5 delay: textDelay options: UIViewAnimationOptionCurveEaseOut animations: ^{

    instructionLabel.alpha = 1;
        } completion: nil];
}

@end