//
// Created by dpostigo on 12/17/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "BasicGameViewController.h"
#import "Model.h"
#import "PuttyView.h"
#import "Draggable.h"
#import "NSString+Utils.h"
#import "DebugLog.h"
#import "LogValidItem.h"


#define ITEM_TAG 10
#define BUTTON_TAG 20
#define DRAGGABLE_TAG 40
#define VALID_SUCCESS_TAG 99
#define DegreesToRadians(x) ((x) * M_PI / 180.0)


@interface BasicGameViewController () <DraggableDelegate> {
}


@end


@implementation BasicGameViewController {
    NSMutableArray *selectedTags;
    UILabel *instructionLabel;
    NSMutableArray *validTags;
}


@synthesize introView;
@synthesize draggables;
@synthesize isDummyGame;

int rand_range(int min_n, int max_n) {
    return arc4random() % (max_n - min_n + 1) + min_n;
}
- (void) loadView {
    [super loadView];

   successButtons = [successButtons sortedArrayUsingComparator:^NSComparisonResult(id button1, id button2) {
        if ([button1 frame].origin.x < [button2 frame].origin.x) return NSOrderedAscending;
        else if ([button1 frame].origin.x > [button2 frame].origin.x) return NSOrderedDescending;
        else return NSOrderedSame;
    }];

    selectedTags = [[NSMutableArray alloc] init];
    validTags = [[NSMutableArray alloc] init];
    [self disableNextButton];
    [self setupIntroView];
    [self setupInstructionText];

    draggables = [[NSMutableArray alloc] init];

    for (int j = 0; j < 6; j++) {
        NSInteger tag = j + 1;
        UIImageView *view = (UIImageView *) [self.view viewWithTag: tag];
        if (view) {

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
                draggable.circleRadius = 30;
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

                draggable.snapsToContainer = YES;
                draggable.maskEnabled = YES;
                draggable.circleRadius = 30;
            }

            else if (self.isContainerGame) {
                draggable.circleRadius = 30;
            }

            if ([self.restorationIdentifier isEqualToString: @"Games"]) {
                draggable.maskEnabled = YES;
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


- (void) viewDidDisappear: (BOOL) animated {
    [super viewDidDisappear: animated];
    [self saveScore];
    [self reset: self];
}


- (void) saveScore {
    if (!self.isDummyGame) {
        [self calculateScoreByTags];
    }

    NSLog(@"_model.scores = %@", _model.scores);
}


- (void) calculateScoreByTags {

    if (validTags.count > 0) {
        NSArray *items = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Items"];
        NSArray *truncTags = [NSArray arrayWithObject: [validTags objectAtIndex: 0]];
        CGFloat score = 0;
        for (NSNumber *number in truncTags) {

            NSString *string = [items objectAtIndex: (NSUInteger) [number integerValue] - 1];
            string = [string stringByReplacingOccurrencesOfString: @"-icon.png" withString: @""];
            string = [string stringByReplacingOccurrencesOfString: @".png" withString: @""];

            [_model.itemScores setObject: [string capitalizedString] forKey: self.restorationIdentifier];

            NSInteger index = [number integerValue] - 1;
            CGFloat midpoint = [items count] / 2;
            CGFloat thisScore = ((CGFloat) index) + ((midpoint * -1) + (index >= midpoint ? 1: 0));
            score += thisScore;
        }

        CGFloat numericResult = score / [truncTags count];
        NSString *stringResult = [[self dnaTypes] objectAtIndex: (numericResult > 0) ? 1 : 0];
        NSString *scoringMode = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Scoring Mode"];
        CGPoint pointScore = CGPointMake(0, 0);

        if ([scoringMode isEqualToString: @"None"]) {
            return;

        } else if ([scoringMode isEqualToString: @"Vertical"]) {
            pointScore = CGPointMake(0, numericResult);

        } else if ([scoringMode isEqualToString: @"Horizontal"]) {
            pointScore = CGPointMake(numericResult, 0);

        } else if ([scoringMode isEqualToString: @"Diagonal Top"]) {
            pointScore = CGPointMake(numericResult, numericResult * -1);

        } else if ([scoringMode isEqualToString: @"Diagonal Bottom"]) {
            pointScore = CGPointMake(numericResult, numericResult);
        }


        NSLog(@"Coordinate Score: %@", NSStringFromCGPoint(pointScore));
        NSLog(@"stringResult = %@", stringResult);

        [_model.scores setObject: stringResult forKey: self.restorationIdentifier];
        [_model.pointScores setObject: [NSValue valueWithCGPoint: pointScore] forKey: self.restorationIdentifier];


    }
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


- (IBAction) reset: (id) sender {

    [selectedTags removeAllObjects];
    [validTags removeAllObjects];
    itemCount = 0;
    [self resetDraggables];
    [self resetSuccessViews];
    instructionLabel.alpha = 0;

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
        draggable.transform = CGAffineTransformIdentity;
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
    [self.view bringSubviewToFront: draggable];
    [self toggleOtherDraggables: draggable enabled: NO];
}


- (void) draggableDidNotDrop: (Draggable *) draggable {
    [self updateScore];
    [self handleToggleNextButton];
}


- (void) draggableWillDrop: (Draggable *) draggable {
    UIImageView *item = (UIImageView *) draggable.contentView;
    itemCount++;
    [self handleSuccess: draggable];
    [self updateScore];
    [self handleLimit: draggable];
    [self handleToggleNextButton];
}


- (void) draggableDidFinishDragging: (Draggable *) draggable {
    [self toggleOtherDraggables: draggable enabled: YES];

    [self logTags];
    [self updateScore];
}


- (void) updateScore {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (!self.isDummyGame) {
        [selectedTags removeAllObjects];
        for (Draggable *draggable in draggables) {
            if (draggable.isPlaced) {
                UIImageView *item = (UIImageView *) draggable.contentView;
                [selectedTags addObject: [NSNumber numberWithInteger: item.tag]];
            }
        }
    }

    [validTags removeAllObjects];

    if (self.isContainerGame) {
        if (validSuccessButton.tag > 0) {
            [validTags addObject: [NSNumber numberWithInteger: validSuccessButton.tag - BUTTON_TAG]];
        }
    }

    else if (self.isSortingGame) {
        for (Draggable *draggable in draggables) {
            if (draggable.isPlaced) {
                if (draggable.currentDrop.tag == VALID_SUCCESS_TAG) {
                    UIImageView *item = (UIImageView *) draggable.contentView;
                    [validTags addObject: [NSNumber numberWithInteger: item.tag]];
                }
            }
        }
    }

    if (DEBUG && !self.isDummyGame) {
        [self calculateScoreByTags];
    }
}


- (void) logTags {
    NSArray *items = [[_model.scoreData objectForKey: self.restorationIdentifier] objectForKey: @"Items"];
    NSMutableArray *strings = [[NSMutableArray alloc] init];

    for (NSNumber *number in selectedTags) {
        NSString *string = [items objectAtIndex: (NSUInteger) [number integerValue] - 1];
        string = [string stringByReplacingOccurrencesOfString: @"-icon.png" withString: @""];
        [strings addObject: [string capitalizedString]];
    }

    [_queue addOperation: [[LogValidItem alloc] initWithValidTags: validTags restorationIdentifier: self.restorationIdentifier]];
}


- (void) handleLimit: (Draggable *) draggable {
    if (self.isContainerGame) {
        for (Draggable *d in draggables) {
            d.droppingDisabled = [selectedTags count] == 3;
        }
    }
}


- (void) handleSuccess: (Draggable *) draggable {
    NSLog(@"%s", __PRETTY_FUNCTION__);
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

                button.transform = CGAffineTransformIdentity;

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
        if ([selectedTags count] == 3) {
            [self enableNextButton];
        } else {
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
    [self handleLimit: draggable];
}


- (void) revertSuccessButton: (UIButton *) button {
    [UIView animateWithDuration: 0.25 delay: 0.0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
        button.alpha = 0;
    }                completion: nil];
}


- (void) gameIntroViewWillDismiss: (GameIntroView *) gameIntroView {
    CGFloat textDelay = 0.5;
    if (self.isDummyGame) {

        textDelay = 0.7;
        Draggable *draggable = [draggables objectAtIndex: 0];

        [UIView animateWithDuration: 0.15 delay: 0.15 options: UIViewAnimationOptionCurveEaseOut animations: ^{
            //            draggable.transform = CGAffineTransformIdentity;

            draggable.transform = CGAffineTransformScale(draggable.transform, 1.1, 1.1);
        }                completion: ^(BOOL completion) {
            [UIView animateWithDuration: 0.15 delay: 0.15 options: UIViewAnimationOptionCurveEaseInOut animations: ^{
                draggable.transform = CGAffineTransformIdentity;
            }                completion: nil];
        }];
    }

    [UIView animateWithDuration: 0.5 delay: textDelay options: UIViewAnimationOptionCurveEaseOut animations: ^{

        instructionLabel.alpha = 1;
    }                completion: nil];
}

@end