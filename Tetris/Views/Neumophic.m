//
//  Neumophic.m
//  Tetris
//
//  Created by 刘峥炫 on 2022/8/21.
//

#import "Neumophic.h"

// MARK: - NeumophicView Class Implementation
@implementation NeumophicView

- (id)init{
    self = [super init];
    self.cornerRadiusValue = 15;
    self.bgColor = [UIColor colorNamed:@"backgroundColor"];
    [self initNeumophicShadow];
    return self;
}

- (id)initWithValue:(UIColor *)bgcolor cRadius:(CGFloat)cornerRadius{
    self = [super init];
    self.cornerRadiusValue = cornerRadius;
    self.bgColor = bgcolor;
    [self initNeumophicShadow];
    return self;
}

- (void)initNeumophicShadow{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.darkShadow = [[CALayer alloc] init];
    self.darkShadow.shadowOffset = CGSizeMake(10, 10);
    self.darkShadow.shadowOpacity = 1;
    self.darkShadow.shadowRadius = 15;
    self.darkShadow.cornerRadius = self.cornerRadiusValue;
    
    self.lightShadow = [[CALayer alloc] init];
    self.lightShadow.shadowOffset = CGSizeMake(-10, -10);
    self.lightShadow.shadowOpacity = 1;
    self.lightShadow.shadowRadius = 15;
    self.lightShadow.cornerRadius = self.cornerRadiusValue;
    [self setupView];
}

- (void)setupView{
    self.layer.backgroundColor = self.bgColor.CGColor;
    self.layer.cornerRadius = self.cornerRadiusValue;
    [self.layer insertSublayer:self.darkShadow atIndex:0];
    [self.layer insertSublayer:self.lightShadow atIndex:0];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.darkShadow.frame = self.bounds;
    self.darkShadow.backgroundColor = self.bgColor.CGColor;
    self.darkShadow.shadowColor = [[UIColor colorNamed:@"darkShadow"] colorWithAlphaComponent:0.5].CGColor;
    
    self.lightShadow.frame = self.bounds;
    self.lightShadow.backgroundColor = self.bgColor.CGColor;
    self.lightShadow.shadowColor = [[UIColor colorNamed:@"lightShadow"] colorWithAlphaComponent:0.9].CGColor;
}

- (void)setNewBgColor:(UIColor *)bgColor vis:(BOOL)visable{
    self.bgColor = bgColor;
    self.darkShadow.backgroundColor = bgColor.CGColor;
    self.lightShadow.backgroundColor = bgColor.CGColor;
    self.layer.backgroundColor = bgColor.CGColor;
    self.hidden = visable;
}

@end


// MARK: - NeumophicView Class Implementation
@implementation NeumophicInnerView

- (id)init{
    self = [super init];
    self.cornerRadiusValue = 15;
    self.bgColor = [UIColor colorNamed:@"backgroundColor"];
    [self initNeumophicShadow];
    return self;
}

- (id)initWithValue:(UIColor *)bgcolor cRadius:(CGFloat)cornerRadius{
    self = [super init];
    self.cornerRadiusValue = cornerRadius;
    self.bgColor = bgcolor;
    [self initNeumophicShadow];
    return self;
}

- (void)initNeumophicShadow{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.darkShadow = [[CALayer alloc] init];
    self.darkShadow.shadowOffset = CGSizeMake(5, 5);
    self.darkShadow.shadowOpacity = 1;
    self.darkShadow.shadowRadius = 3;
    self.darkShadow.cornerRadius = self.cornerRadiusValue;
    
    self.lightShadow = [[CALayer alloc] init];
    self.lightShadow.shadowOffset = CGSizeMake(-5, -5);
    self.lightShadow.shadowOpacity = 1;
    self.lightShadow.shadowRadius = 3;
    self.lightShadow.cornerRadius = self.cornerRadiusValue;
    [self setupView];
}

- (void)setupView{
    self.backgroundColor = self.bgColor;
    self.layer.cornerRadius = self.cornerRadiusValue;
    self.layer.masksToBounds = true;
    [self.layer addSublayer:self.darkShadow];
    [self.layer addSublayer:self.lightShadow];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.darkShadow.frame = self.bounds;
    self.lightShadow.frame = self.bounds;
    self.darkShadow.shadowColor = [UIColor colorNamed:@"darkShadow"].CGColor;
    self.lightShadow.shadowColor = [UIColor colorNamed:@"lightShadow"].CGColor;
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(-3, -3, 3, 3)) cornerRadius:self.cornerRadiusValue];
    UIBezierPath *cutout = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadiusValue];
    [path appendPath:[cutout bezierPathByReversingPath]];
    self.darkShadow.shadowPath = path.CGPath;
    self.lightShadow.shadowPath = path.CGPath;
}
@end


// MARK: - NeumophicView Class Implementation
@implementation NeumButton


- (id)init{
    self = [super init];
    self.cornerRadiusValue = 15;
    self.bgColor = [UIColor colorNamed:@"backgroundColor"];
    [self initNeumophicShadow];
    return self;
}

- (id)initWithValue:(UIColor *)bgcolor cRadius:(CGFloat)cornerRadius{
    self = [super init];
    self.cornerRadiusValue = cornerRadius;
    self.bgColor = bgcolor;
    [self initNeumophicShadow];
    return self;
}

- (void)initNeumophicShadow{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.neumophicView = [[NeumophicView alloc] initWithValue:self.bgColor cRadius:self.cornerRadiusValue];
    self.neumophicView.userInteractionEnabled = false;
    
    self.neumophicInnerView = [[NeumophicInnerView alloc] initWithValue:self.bgColor cRadius:self.cornerRadiusValue];
    self.neumophicInnerView.userInteractionEnabled = false;
    [self setupView];
}

- (void)setupView{
    [self addSubview:self.neumophicView];
    [self.neumophicView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.neumophicView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.neumophicView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.neumophicView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    [self addSubview:self.neumophicInnerView];
    [self.neumophicInnerView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.neumophicInnerView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
    [self.neumophicInnerView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
    [self.neumophicInnerView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    
    self.neumophicInnerView.hidden = true;
    
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if(highlighted){
        self.neumophicView.hidden = true;
        self.neumophicInnerView.hidden = false;
    }else{
        self.neumophicView.hidden = false;
        self.neumophicInnerView.hidden = true;
    }
}
@end

