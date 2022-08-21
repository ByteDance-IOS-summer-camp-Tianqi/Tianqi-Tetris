//
//  CellStructures.m
//  Tetris
//
//  Created by Mingyu Liu on 2022-08-16.
//

#import <Foundation/Foundation.h>
#import "BlockStructures.h"



@implementation TetrisGameSquare

- (id)initWithColor:(UIColor *)color empty:(BOOL)empty{
    self = [super init];
    self.color = color;
    self.isEmpty = empty;
    return self;
}

@end

@implementation BlockLocation

- (id)initWithRow:(int)row andCol:(int)column {
    self.row = row;
    self.column = column;
    
    return self;
}

@end
