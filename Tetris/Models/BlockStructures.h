//
//  CellStructures.h
//  Tianqi_Group_Project
//
//  Created by Mingyu Liu on 2022-08-16.
//

#ifndef CellStructures_h
#define CellStructures_h
#import <UIKit/UIKit.h>

@interface TetrisGameSquare : NSObject

@property UIColor *color;
@property BOOL isEmpty;
- (id)initWithColor:(UIColor *)color empty:(BOOL)empty;
//- (id)initWithColor:(UIColor *)color;

@end

@interface BlockLocation : NSObject

@property (nonatomic, assign) int row;
@property (nonatomic, assign) int column;

- (id)initWithRow:(int)row andCol:(int)column;

@end

typedef enum {
    i , t, o, j, l, s, z
} BlockType;

#endif /* CellStructures_h */
