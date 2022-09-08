//
//  TetrisGameViewModel.m
//  Tetris
//
//  Created by 刘峥炫 on 2022/8/18.
//

#import "TetrisGameViewModel.h"
#import "../Views/Neumophic.h"


@interface TetrisGameViewModel ()

- (TetrisGameSquare *)convertToSquare:(TetrisGameBlock *)block;

@end

@implementation TetrisGameViewModel

- (id)initGameViewModelwithGameBoardView:(NSMutableArray *)gameBoardView ScoreText:(UILabel *)scoreText{
//- (id)initGameViewModelwithGameBoardView:(UIView *)gameBoardView ScoreText:(UILabel *)scoreText PauseButton:(UIImageView *)pauseButton {
    self = [super init];
    self.tetrisGameModel = [[TetrisGameModel alloc] initGameModel];
    
    //用来更新UI
    self.gameBoardView = gameBoardView;
    self.scoreText = scoreText;
//    self.pauseButton = pauseButton;
    
    
    // 行列
    self.numRows = self.tetrisGameModel.numRows;
    self.numColumns = self.tetrisGameModel.numColumns;
    // 初始化游戏盘 - 全背景色正方块
    self.gameBoardSquares = [NSMutableArray array];
    
    for (int col = 0; col < self.numColumns; col++){
        NSMutableArray *colArray = [NSMutableArray array];
        for (int row = 0; row < self.numRows; row++)
            [colArray addObject:[[TetrisGameSquare alloc] initWithColor:[UIColor colorNamed:@"backgroundColor"] empty:true]];
        [self.gameBoardSquares addObject: colArray];
    }
    
    [self.tetrisGameModel addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
    [self.tetrisGameModel addObserver:self forKeyPath:@"score" options:NSKeyValueObservingOptionNew context:NULL];
    
    //绘制游戏盘
    [self drawBoardwithGameBoardSquares:self.gameBoardSquares];
    // TODO: Combine - AnyCancellable
    
    return self;
}


- (void) drawBoardwithGameBoardSquares: (NSMutableArray<NSMutableArray<TetrisGameSquare *>* >*) gameBoardSquares{
    dispatch_queue_t  mainQueue = dispatch_get_main_queue();
    dispatch_async(mainQueue, ^{
        int columns = self.numColumns;
        int rows = self.numRows;
        for (int col = 0 ; col < columns ; col++){
            for (int row = 0; row < rows; row++){
//                NeumophicView *TestBlock = self.gameBoardView[col][row];
                UIView *TestBlock = self.gameBoardView[col][row];
                if(!gameBoardSquares[col][row].isEmpty){
//                    [TestBlock setNewBgColor:gameBoardSquares[col][row].color vis:false];
                    TestBlock.hidden = false;
                    TestBlock.backgroundColor = gameBoardSquares[col][row].color;
                }else{
                    TestBlock.hidden = true;
                }
            }
        }
    });
    
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        [self UpdateGameBoard];
        //[self.collectionView reloadData];
    } else if ([keyPath isEqualToString:@"score"]) {
        self.scoreText.text = [NSString stringWithFormat:@"%d", self.tetrisGameModel.score];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)UpdateGameBoard{
    //游戏盘背景和已经被锁定的方块
    for(int i = 0; i < self.numColumns; i++){
        for (int j = 0; j < self.numRows; j++){
            self.gameBoardSquares[i][j] = [self convertToSquare:self.tetrisGameModel.gameBoard[i][j]];
        }
    }
    
    //正在移动的方块
    if(self.tetrisGameModel.tetromino != nil){
        BlockType tetrominoBlockType = self.tetrisGameModel.tetromino.blockType;
        int tetrominoOriginX = self.tetrisGameModel.tetromino.origin.row;
        int tetrominoOriginY = self.tetrisGameModel.tetromino.origin.column;
        NSArray<BlockLocation *> *relativeLocation = [self.tetrisGameModel.tetromino blocks];
        for(int i = 0; i < 4; i++){
            self.gameBoardSquares[tetrominoOriginY+relativeLocation[i].column][tetrominoOriginX+relativeLocation[i].row] = [[TetrisGameSquare alloc] initWithColor:[self getColor:tetrominoBlockType] empty:false];
        }
    }
    //绘制游戏盘
    [self drawBoardwithGameBoardSquares: self.gameBoardSquares];
    
}
// 将blcok转化为GameBoard方块(有颜色)
- (TetrisGameSquare *)convertToSquare:(TetrisGameBlock *)block{
    // 判断blcok是否是TetrisGameBlock的实例化对象, block可能为空
    if([block isKindOfClass:[TetrisGameBlock class]]){
        return [[TetrisGameSquare alloc] initWithColor:[self getColor:block.blockType] empty:false];
    }else{
        return [[TetrisGameSquare alloc] initWithColor:[UIColor colorNamed:@"GameBoardColor"] empty:true];
    }
}

// 获取俄罗斯方块的颜色
- (UIColor *)getColor:(BlockType)blockType{
    UIColor *color = nil;
    switch(blockType){
        case i:
            color = [UIColor colorNamed:@"IColor"];
            break;
        case t:
            color = [UIColor colorNamed:@"TColor"];
            break;
        case o:
            color = [UIColor colorNamed:@"OColor"];
            break;
        case j:
            color = [UIColor colorNamed:@"JColor"];
            break;
        case l:
            color = [UIColor colorNamed:@"LColor"];
            break;
        case s:
            color = [UIColor colorNamed:@"SColor"];
            break;
        case z:
            color = [UIColor colorNamed:@"ZColor"];
            break;
    }
    return color;
}

- (void)RightButtonClick{
    self.tetrisGameModel.movement = Right;
}

- (void)LeftButtonClick{
    self.tetrisGameModel.movement = Left;
}

- (void)DownButtonClick{
    self.tetrisGameModel.movement = Drop;
}

- (void)UpButtonClick{
    self.tetrisGameModel.movement = RotateClockwise;
}

- (void)ClockwiseButtonClick{
    self.tetrisGameModel.movement = RotateClockwise;
}

- (void)AntiClockwiseButtonClick{
    self.tetrisGameModel.movement = RotateCounterClockwise;
}

- (void)PlayAndPauseButtonClick{
    switch(self.tetrisGameModel.gameState){
        case Over:
            [self.tetrisGameModel newGame];
            break;
        case Pause:
//            NSLog(@"%@", self.gameBoardView[0][0]);
            [self.tetrisGameModel resumeGame];
            break;
        case Running:
            [self.tetrisGameModel pauseGame];
            [self UpdateGameBoard];
            break;
    }
}

@end
