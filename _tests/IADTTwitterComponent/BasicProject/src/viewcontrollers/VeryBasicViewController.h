//
// Created by dpostigo on 9/20/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "TextFieldController.h"

@class Model;

@interface VeryBasicViewController : UIViewController <UITextFieldDelegate, TextFieldController> {

    __unsafe_unretained id delegate;
    __unsafe_unretained Model *_model;
    NSOperationQueue *_queue;

    NSMutableArray *delegates;
    NSMutableArray *textFields;


}

@property(nonatomic, assign) Model *_model;
@property(nonatomic, assign) id delegate;
@property(nonatomic, strong) NSOperationQueue *queue;
@property(nonatomic, strong) NSMutableArray *delegates;
@property(nonatomic, strong) NSMutableArray *textFields;

- (IBAction) dismissModal;

- (void) subscribeTextField: (UITextField *) aTextField;
- (void) unsubscribeTextField: (UITextField *) aTextField;
- (void) textFieldDidReturn: (UITextField *) aTextField;

@end