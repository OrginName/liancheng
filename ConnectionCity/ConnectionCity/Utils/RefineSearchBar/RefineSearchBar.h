//
//  RefineSearchBar.h
//  RefineSearchBar
//
//  Created by qt on 16/8/17.
//  Copyright @ 2016年 qt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RefineSearchBar;
@protocol RefineSearchBarDelegate <UIBarPositioningDelegate>

@optional
-(BOOL)searchBarShouldBeginEditing:(RefineSearchBar *)searchBar;                      // return NO to not become first responder
- (void)searchBarTextDidBeginEditing:(RefineSearchBar *)searchBar;                     // called when text starts editing
- (BOOL)searchBarShouldEndEditing:(RefineSearchBar *)searchBar;                        // return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(RefineSearchBar *)searchBar;                       // called when text ends editing
- (void)searchBar:(RefineSearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)
- (BOOL)searchBar:(RefineSearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; // called before text changes

- (void)searchBarSearchButtonClicked:(RefineSearchBar *)searchBar searchText:(NSString *)searchText;                     // called when keyboard search button pressed
- (void)searchBarCancelButtonClicked:(RefineSearchBar *)searchBar;                     // called when cancel button pressed
// called when cancel button pressed
@end

@interface RefineSearchBar : UIView<UITextInputTraits>

@property(nullable,nonatomic,weak) id<RefineSearchBarDelegate> delegate; // default is nil. weak reference
@property(nullable,nonatomic,copy) NSString  *text;                  // current/starting search text
@property(nullable,nonatomic,copy) NSString  *placeholder;           // default is nil. string is drawn 70% gray
@property(nonatomic) BOOL  showsCancelButton;                        // default is yes
@property(nullable,nonatomic,strong) UIColor *textColor;             // default is nil. use opaque black
@property(nullable,nonatomic,strong) UIFont  *font;                  // default is nil. use system font 12 pt
@property(nullable,nonatomic,strong) UIColor *placeholderColor;      // default is drawn 70% gray
@property (nonatomic,strong) UIColor * BGColor;
/* Allow placement of an input accessory view to the keyboard for the search bar
 */
@property (nullable,nonatomic,readwrite,strong) UIView *inputAccessoryView;

- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
@end

NS_ASSUME_NONNULL_END
