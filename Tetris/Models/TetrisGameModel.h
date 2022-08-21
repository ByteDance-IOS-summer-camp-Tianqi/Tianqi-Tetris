//
//  TetrisGameModel.h
//  Tetris
//
//  Created by 刘峥炫 on 2022/8/18.
//

#import <Foundation/Foundation.h>
#import "BlockStructures.h"
#import "TetrominoModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    Pause,
    Running,
    Over
} GameState;

@interface TetrisGameModel : NSObject

@property (nonatomic, assign) int numRows;
@property (nonatomic, assign) int numColumns;
@property (nonatomic) NSMutableArray* gameBoard;
@property (nonatomic, nullable) TetrominoModel* tetromino;

@property (nonatomic, assign) int score;

@property (atomic, nullable) NSTimer *timer;
@property (nonatomic, assign) double speed;
@property (atomic, assign) GameState gameState;
@property (nonatomic, assign) int status;

- (id)initGameModel;
- (void) newGame;

- (void)resumeGame;
- (void)pauseGame;
- (void)runEngine;

- (void)dropTetromino;
- (Boolean)moveTetrominoRight;
- (Boolean)moveTetrominoLeft;
- (Boolean)moveTetrominoDown;
- (Boolean)moveTetrominoWithRowOffset:(int) rowOffset andColumnOffset:(int)colOffset;
- (void)rotateTetrominoWithClockwise:(Boolean) clockwise;

- (Boolean)isValidTetromino:(TetrominoModel *) tetromino;

- (void)placeTetromino; //lock the tetromino when it touch the tetromino stack
- (int)clearLines; //return the number of time that is cleared 用于计分




@end

@interface TetrisGameBlock : NSObject

@property BlockType blockType;

- (id)initWithType:(BlockType)blockType;

@end

NS_ASSUME_NONNULL_END
