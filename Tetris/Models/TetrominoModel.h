//
//  TetrominoModel.h
//  Tianqi_Group_Project
//
//  Created by Mingyu Liu on 2022-08-16.
//

#ifndef TetrominoModel_h
#define TetrominoModel_h

#import "BlockStructures.h"

@interface TetrominoModel: NSObject

@property (nonatomic) BlockLocation *origin;
@property (nonatomic, assign) BlockType blockType;
@property (nonatomic, assign) int rotation;

-(id)initWithOrigin:(BlockLocation *)origin withType:(BlockType)type withRotation:(int)rotation; // Object constructor
-(NSArray<BlockLocation *> *)blocks; // Return an array of all cells of the current Tetromino
-(TetrominoModel *)moveByRow:(int)row andByColumn:(int)col; // Move current Tetromino by specified number of [row]s and [col]s
-(TetrominoModel *)rotateByClockwise:(Boolean)isClockwise; // Rotate current Tetromino based on [isClockwise]
-(NSArray<BlockLocation *> *)getKicksByClockwise:(Boolean)isClockwise; // Return an array of cells where the current Tetromino will kick the wall


+(NSArray<BlockLocation *> *)getBlocksWithBlockType:(BlockType)blockType andWithRotation:(int)rotation; // Return an array of cells of any Tetromino based on its [blockType] and [rotation]
+(NSArray<NSArray<BlockLocation *> *> *)getAllBlocksByBlockType:(BlockType)blockType; // Return a 4*4 array of all possible combinations of cells of any Tetromino based on [blockType]
+(TetrominoModel *)createNewTetrominoBy:(int)numRows andBy:(int)numCols; // Create and return a new Tetromino located based on specified [numRows] and [numCols]
+(NSArray<BlockLocation *> *)getKicksByBlockType:(BlockType)blockType andByRotation:(int)rotation lastlyByClockwise:(Boolean)isClockwise; // Return an array of cells where a Tetromino of [blockType], [rotation] and [isClockwise]
+(NSArray<NSArray<BlockLocation *> *> *)getAllKicksByBlockType:(BlockType)blockType; // Returns a 2D array of all possible kicks of any Tetromino based on its [blockType]

+(NSString *)getBlockTypeBy:(BlockType) blocktype;

@end

#endif /* TetrominoModel_h */
