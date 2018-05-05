//
//  UIAlertView+Blocks.h
//  UIKitCategoryAdditions
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^DismissBlock)(long buttonIndex);
typedef void (^CancelBlock)();


@interface UIAlertView (Blocks) <UIAlertViewDelegate> 

+ (UIAlertView*) showAlertViewWithTitle:(NSString*) title                    
                                message:(NSString*) message 
                      cancelButtonTitle:(NSString*) cancelButtonTitle
                      otherButtonTitles:(NSArray*) otherButtons
                              onDismiss:(DismissBlock) dismissed                   
                               onCancel:(CancelBlock) cancelled;

@end
