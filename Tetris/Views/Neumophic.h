//
//  Neumophic.h
//  Tetris
//
//  Created by 刘峥炫 on 2022/8/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: - NeumophicView Class Interface
@interface NeumophicView : UIView

@property UIColor *bgColor;
@property CGFloat cornerRadiusValue;

- (id)init;
- (id)initWithValue:(UIColor *)bgcolor cRadius:(CGFloat)cornerRadius;
- (void)initNeumophicShadow;
@property CALayer *darkShadow;
@property CALayer *lightShadow;
- (void)setupView;
- (void)setNewBgColor:(UIColor *)bgColor vis:(BOOL)visable;

@end


// MARK: - NeumophicInnerView Class Interface
@interface NeumophicInnerView : UIView

@property UIColor *bgColor;
@property CGFloat cornerRadiusValue;
- (id)initWithValue:(UIColor *)bgcolor cRadius:(CGFloat)cornerRadius;
- (id)init;
@property CALayer *darkShadow;
@property CALayer *lightShadow;
- (void)setupView;

@end


// MARK: - NeumophicButton Class Interface
@interface NeumButton : UIButton
@property UIColor *bgColor;
@property CGFloat cornerRadiusValue;
- (id)init;
- (id)initWithValue:(UIColor *)bgcolor cRadius:(CGFloat)cornerRadius;
@property NeumophicView *neumophicView;
@property NeumophicInnerView *neumophicInnerView;
- (void)setupView;

@end


NS_ASSUME_NONNULL_END
