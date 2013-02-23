//
// Created by dpostigo on 1/15/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CalculateFinalScore.h"


@implementation CalculateFinalScore {
}


- (void) main {
    [super main];

    NSString *debugString = @"Scores:";
    NSLog(@"FINAL SCORES");
    NSArray *points = [_model.pointScores allValues];
    CGPoint monsterPoint = CGPointMake(0, 0);
    NSArray *keys = [_model.pointScores allKeys];

    for (NSString *key in keys) {
        NSValue *value = [_model.pointScores objectForKey: key];
        CGPoint point = [value CGPointValue];
        monsterPoint.x += point.x;
        monsterPoint.y += point.y;

        NSString *itemString = [_model.itemScores objectForKey: key];
        NSString *thisString = [NSString stringWithFormat: @"   %@", NSStringFromCGPoint(point)];
        thisString = [NSString stringWithFormat: @"%@ (%@) %@", key, itemString, thisString];
        debugString = [NSString stringWithFormat: @"%@\n%@", debugString, thisString];
    }

    for (NSValue *value in points) {
    }

    NSUInteger numGames = [[_model.pointScores allKeys] count];
    CGPoint resultPoint = CGPointMake(monsterPoint.x / numGames, monsterPoint.y / numGames);

    debugString = [debugString stringByAppendingString: @"\n---------------"];
    debugString = [debugString stringByAppendingString: [NSString stringWithFormat: @"\n%@", NSStringFromCGPoint(monsterPoint)]];
    debugString = [debugString stringByAppendingString: [NSString stringWithFormat: @" / %u", numGames]];
    debugString = [debugString stringByAppendingString: [NSString stringWithFormat: @" = %@", NSStringFromCGPoint(resultPoint)]];

    NSLog(@"NSStringFromCGPoint(resultPoint) = %@", NSStringFromCGPoint(resultPoint));
    NSInteger quadrant = [self getQuadrantForPoint: resultPoint];
    BOOL closerToX = [self closerToX: resultPoint];



    debugString = [debugString stringByAppendingString: [NSString stringWithFormat: @"\nQuadrant: %i", quadrant] ];
    debugString = [debugString stringByAppendingString: [NSString stringWithFormat: @"\nCloser to X: %@", (closerToX ? @"YES" : @"NO")] ];


    _model.badgeName = [NSString stringWithFormat: @"badge-quad%i-%@", quadrant, (closerToX ? @"x" : @"y")];
    [_model notifyDelegates: @selector(finalScoreDidUpdate) object: nil];
    [_model notifyDelegates: @selector(finalScoreDidUpdateWithDebugString:) object: debugString];
}


- (NSInteger) getQuadrantForPoint: (CGPoint) point {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"NSStringFromCGPoint(point) = %@", NSStringFromCGPoint(point));

    if (point.x >= 0 && point.y >= 0) {
        //quadrant I
        return 2;
    } else if (point.x < 0 && point.y >= 0) {
        //quadrant II
        return 1;
    } else if (point.x < 0 && point.y < 0) {
        //quadrant III
        return 4;
    } else if (point.x >= 0 && point.y < 0) {
        //quadrant IV
        return 3;
    }
    return 0;
}

- (BOOL) closerToX: (CGPoint) point {

    double doubleAbsoluteX = fabs(point.x);
    double doubleAbsoluteY = fabs(point.y);

    if (doubleAbsoluteX >= doubleAbsoluteY) {
        return YES;
    }
    else {
        return NO;
    }
}


@end