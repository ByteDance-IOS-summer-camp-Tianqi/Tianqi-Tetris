//
//  TetrominoModel.m
//  Tetris
//
//  Created by Mingyu Liu on 2022-08-16.
//

#import <Foundation/Foundation.h>
#import "TetrominoModel.h"

@implementation TetrominoModel

-(id)initWithOrigin:(BlockLocation *)origin withType:(BlockType)type withRotation:(int)rotation {
    self.origin = origin;
    self.blockType = type;
    self.rotation = rotation;
    
    return self;
}

-(NSArray<BlockLocation *> *)blocks {
    return [TetrominoModel getBlocksWithBlockType:_blockType andWithRotation:_rotation];
}

-(TetrominoModel *)moveByRow:(int)row andByColumn:(int)col {
    BlockLocation *newOrigin = [[BlockLocation alloc] initWithRow:_origin.row + row andCol:_origin.column + col];
    return [[TetrominoModel alloc] initWithOrigin:newOrigin withType:_blockType withRotation:_rotation];
}

-(TetrominoModel *)rotateByClockwise:(Boolean)isClockwise {
    return [[TetrominoModel alloc] initWithOrigin:_origin withType:_blockType withRotation:_rotation + (isClockwise ? 1 : -1)];
}

-(NSArray<BlockLocation *> *)getKicksByClockwise:(Boolean)isClockwise {
    return [TetrominoModel getKicksByBlockType:_blockType andByRotation:_rotation lastlyByClockwise:isClockwise];
}

+(NSArray<BlockLocation *> *)getBlocksWithBlockType:(BlockType)blockType andWithRotation:(int)rotation {
    NSArray<NSArray<BlockLocation *> *> *allCells = [TetrominoModel getAllBlocksByBlockType:blockType];
    
    int index = rotation % allCells.count;
    if (index < 0) {
        index += rotation % allCells.count;
    }
    
    return allCells[index];
}

+(NSArray<NSArray<BlockLocation *> *> *)getAllBlocksByBlockType:(BlockType)cellType {
    switch (cellType) {
        case i:
            return @[@[[[BlockLocation alloc] initWithRow:0 andCol:-1], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:0 andCol:1], [[BlockLocation alloc] initWithRow:0 andCol:2]],
                      @[[[BlockLocation alloc] initWithRow:-1 andCol:1], [[BlockLocation alloc] initWithRow:0 andCol:1],
                       [[BlockLocation alloc] initWithRow:1 andCol:1], [[BlockLocation alloc] initWithRow:-2 andCol:1]],
                      @[[[BlockLocation alloc] initWithRow:-1 andCol:-1], [[BlockLocation alloc] initWithRow:-1 andCol:0],
                       [[BlockLocation alloc] initWithRow:-1 andCol:1], [[BlockLocation alloc] initWithRow:-1 andCol:2]],
                      @[[[BlockLocation alloc] initWithRow:-1 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:1 andCol:0], [[BlockLocation alloc] initWithRow:-2 andCol:0]]];
        case o:
            return @[@[[[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:1],
                       [[BlockLocation alloc] initWithRow:1 andCol:1], [[BlockLocation alloc] initWithRow:1 andCol:0]]];
        case t:
            return @[@[[[BlockLocation alloc] initWithRow:0 andCol:-1], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:0 andCol:1], [[BlockLocation alloc] initWithRow:1 andCol:0]],
                     @[[[BlockLocation alloc] initWithRow:-1 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:0 andCol:1], [[BlockLocation alloc] initWithRow:1 andCol:0]],
                     @[[[BlockLocation alloc] initWithRow:0 andCol:-1], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:0 andCol:1], [[BlockLocation alloc] initWithRow:-1 andCol:0]],
                     @[[[BlockLocation alloc] initWithRow:0 andCol:-1], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:1 andCol:0], [[BlockLocation alloc] initWithRow:-1 andCol:0]]];
        case j:
            return @[@[[[BlockLocation alloc] initWithRow:1 andCol:-1], [[BlockLocation alloc] initWithRow:0 andCol:-1],
                       [[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:1]],
                     @[[[BlockLocation alloc] initWithRow:1 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:-1 andCol:0], [[BlockLocation alloc] initWithRow:1 andCol:1]],
                     @[[[BlockLocation alloc] initWithRow:-1 andCol:1], [[BlockLocation alloc] initWithRow:0 andCol:-1],
                       [[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:1]],
                     @[[[BlockLocation alloc] initWithRow:1 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:-1 andCol:0], [[BlockLocation alloc] initWithRow:-1 andCol:-1]]];
        case l:
            return @[@[[[BlockLocation alloc] initWithRow:0 andCol:-1], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:0 andCol:1], [[BlockLocation alloc] initWithRow:1 andCol:1]],
                     @[[[BlockLocation alloc] initWithRow:1 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:-1 andCol:0], [[BlockLocation alloc] initWithRow:-1 andCol:1]],
                     @[[[BlockLocation alloc] initWithRow:0 andCol:-1], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:0 andCol:1], [[BlockLocation alloc] initWithRow:-1 andCol:-1]],
                     @[[[BlockLocation alloc] initWithRow:1 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:-1 andCol:0], [[BlockLocation alloc] initWithRow:1 andCol:-1]]];
        case s:
            return @[@[[[BlockLocation alloc] initWithRow:0 andCol:-1], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:1 andCol:0], [[BlockLocation alloc] initWithRow:1 andCol:1]],
                     @[[[BlockLocation alloc] initWithRow:1 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:0 andCol:1], [[BlockLocation alloc] initWithRow:-1 andCol:1]],
                     @[[[BlockLocation alloc] initWithRow:0 andCol:1], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:-1 andCol:0], [[BlockLocation alloc] initWithRow:-1 andCol:-1]],
                     @[[[BlockLocation alloc] initWithRow:1 andCol:-1], [[BlockLocation alloc] initWithRow:0 andCol:-1],
                       [[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:-1 andCol:0]]];
        case z:
            return @[@[[[BlockLocation alloc] initWithRow:1 andCol:-1], [[BlockLocation alloc] initWithRow:1 andCol:0],
                       [[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:1]],
                     @[[[BlockLocation alloc] initWithRow:1 andCol:1], [[BlockLocation alloc] initWithRow:0 andCol:1],
                       [[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:-1 andCol:0]],
                     @[[[BlockLocation alloc] initWithRow:0 andCol:-1], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:-1 andCol:0], [[BlockLocation alloc] initWithRow:-1 andCol:1]],
                     @[[[BlockLocation alloc] initWithRow:1 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:0],
                       [[BlockLocation alloc] initWithRow:0 andCol:-1], [[BlockLocation alloc] initWithRow:-1 andCol:-1]]];
    }
}

+(TetrominoModel *)createNewTetrominoBy:(int)numRows andBy:(int)numCols {
    BlockType randomType = (BlockType) (arc4random() % (int)z);
    
    int maxRow = 0;
    for (BlockLocation *cell in [TetrominoModel getBlocksWithBlockType:randomType andWithRotation:0]) {
        maxRow = MAX(maxRow, cell.row);
    }
    
    BlockLocation *origin = [[BlockLocation alloc] initWithRow:numRows - 1 - maxRow andCol:(numCols - 1) / 2];
    return [[TetrominoModel alloc] initWithOrigin:origin withType:randomType withRotation:0];
}

+(NSArray<BlockLocation *> *)getKicksByBlockType:(BlockType)cellType andByRotation:(int)rotation lastlyByClockwise:(Boolean)isClockwise {
    int rotationCount = (int)[TetrominoModel getAllKicksByBlockType:cellType].count;
    
    int index = rotation % rotationCount;
    if (index < 0) {
        index += rotationCount;
    }
    
    NSArray<BlockLocation *> *kicks = [TetrominoModel getAllKicksByBlockType:cellType][index];
    if (!isClockwise) {
        NSMutableArray<BlockLocation *> *counterKicks = [NSMutableArray array];
        for (BlockLocation *kick in kicks) {
            [counterKicks addObject:[[BlockLocation alloc] initWithRow:-1 * kick.row andCol:-1 * kick.column]];
        }
        kicks = counterKicks;
    }
    
    return kicks;
}

+(NSArray<NSArray<BlockLocation *> *> *)getAllKicksByBlockType:(BlockType)cellType; {
    switch (cellType) {
        case o:
            return @[@[[[BlockLocation alloc] initWithRow:0 andCol:0]]];
        case i:
            return @[@[[[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:-2],
                       [[BlockLocation alloc] initWithRow:0 andCol:1], [[BlockLocation alloc] initWithRow:-1 andCol:-2],
                       [[BlockLocation alloc] initWithRow:2 andCol:-1]],
                     @[[[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:-1],
                       [[BlockLocation alloc] initWithRow:0 andCol:2], [[BlockLocation alloc] initWithRow:2 andCol:-1],
                       [[BlockLocation alloc] initWithRow:-1 andCol:2]],
                     @[[[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:2],
                       [[BlockLocation alloc] initWithRow:0 andCol:-1], [[BlockLocation alloc] initWithRow:1 andCol:2],
                       [[BlockLocation alloc] initWithRow:-2 andCol:-1]],
                     @[[[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:1],
                       [[BlockLocation alloc] initWithRow:0 andCol:-2], [[BlockLocation alloc] initWithRow:-2 andCol:1],
                       [[BlockLocation alloc] initWithRow:1 andCol:-2]]];
        default:
            return @[@[[[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:-1],
                       [[BlockLocation alloc] initWithRow:1 andCol:-1], [[BlockLocation alloc] initWithRow:0 andCol:-2],
                       [[BlockLocation alloc] initWithRow:-2 andCol:-1]],
                     @[[[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:1],
                       [[BlockLocation alloc] initWithRow:-1 andCol:1], [[BlockLocation alloc] initWithRow:2 andCol:0],
                       [[BlockLocation alloc] initWithRow:1 andCol:2]],
                     @[[[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:1],
                       [[BlockLocation alloc] initWithRow:1 andCol:1], [[BlockLocation alloc] initWithRow:-2 andCol:0],
                       [[BlockLocation alloc] initWithRow:-2 andCol:1]],
                     @[[[BlockLocation alloc] initWithRow:0 andCol:0], [[BlockLocation alloc] initWithRow:0 andCol:-1],
                       [[BlockLocation alloc] initWithRow:-1 andCol:-1], [[BlockLocation alloc] initWithRow:2 andCol:0],
                       [[BlockLocation alloc] initWithRow:2 andCol:-1]]];
    }
}

+ (NSString *)getBlockTypeBy:(BlockType)blocktype{
    NSArray * types = @[@"i",@"t",@"o", @"j", @"l", @"s", @"z"];
    return types[blocktype];
}

@end
