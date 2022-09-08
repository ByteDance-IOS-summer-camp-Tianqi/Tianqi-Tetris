//
//  ViewController.m
//  Tetris
//
//  Created by Xiaojian Chen on 8/15/22.
//

#import "ViewController.h"
#import "../ViewModels/TetrisGameViewModel.h"
#import "../Views/Neumophic.h"

@interface ViewController ()

@property (strong, nonatomic) UIView *safeArea;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) NeumophicInnerView *scoreBox;
@property (strong, nonatomic) UIView *leftControlBox;
@property (strong, nonatomic) NeumButton *upButton;
@property (strong, nonatomic) NeumButton *downButton;
@property (strong, nonatomic) NeumButton *leftButton;
@property (strong, nonatomic) NeumButton *rightButton;
@property (strong, nonatomic) UIView *rightControlBox;
@property (strong, nonatomic) NeumButton *playButton;
@property (strong, nonatomic) NeumophicInnerView *gameBoard;
@property (strong, nonatomic) UIView *innerGameBoard;
@property (strong, nonatomic) UIImageView *btnImageView;
@property (strong, nonatomic) UILabel *scoreLabel;
@property (strong, nonatomic) NSMutableArray *squareBoard;
- (void)setupView;
- (void)SetButtonImage:(NSString *)image button:(UIView *)btn cons:(CGFloat)cons;
- (void)setupButtonAction;

- (void)upPressed;
- (void)downPressed;
- (void)leftPressed;
- (void)rightPressed;
- (void)playPressed;
@property AVAudioPlayer * tetrisAudioPlayer;
@property (nonatomic, retain) TetrisGameViewModel *tetrisGameViewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    int columns = 12;
    int rows = 20;
    self.squareBoard = [NSMutableArray array];
    for (int col = 0 ; col < columns ; col++){
        NSMutableArray *colArray = [NSMutableArray array];
        for (int row = 0; row < rows; row++){
            UIView *block = [[UIView alloc] init];
            block.translatesAutoresizingMaskIntoConstraints = NO;
            block.layer.cornerRadius = 5;
            block.hidden = false;
            [colArray addObject:block];
        }
        [self.squareBoard addObject:colArray];
    }
    
    [self setupView];
    [self setupButtonAction];
    
    self.tetrisGameViewModel = [[TetrisGameViewModel alloc] initGameViewModelwithGameBoardView:self.squareBoard ScoreText:self.scoreLabel];
    [self.tetrisGameViewModel.tetrisGameModel addObserver:self forKeyPath:@"gameState" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    //创建并注册AudioPlayer
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tetris" ofType:@"mp3"];
    NSURL *url = [NSURL URLWithString:path];
    self.tetrisAudioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:NULL];
    self.tetrisAudioPlayer.numberOfLoops = -1; //无限循环
    
    [self.tetrisAudioPlayer play]; //app启动时播放音乐
    [self.tetrisAudioPlayer play]; //app启动时播放音乐
    
}
- (void)setupButtonAction{
    [self.upButton addTarget:self action:@selector(upPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.downButton addTarget:self action:@selector(downPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton addTarget:self action:@selector(leftPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(rightPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton addTarget:self action:@selector(playPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)upPressed{
//    NSLog(@"Up Pressed");
    [self.tetrisGameViewModel ClockwiseButtonClick];
}
- (void)downPressed{
//    NSLog(@"Down Pressed");
    [self.tetrisGameViewModel DownButtonClick];
}
- (void)leftPressed{
//    NSLog(@"Left Pressed");
    [self.tetrisGameViewModel LeftButtonClick];
}
- (void)rightPressed{
//    NSLog(@"Right Pressed");
    [self.tetrisGameViewModel RightButtonClick];
}
- (void)playPressed{
//    NSLog(@"Play Pressed");
    [self.tetrisGameViewModel PlayAndPauseButtonClick];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"gameState"]) {
        switch(self.tetrisGameViewModel.tetrisGameModel.gameState){
            case Over:
                self.btnImageView.image = [UIImage systemImageNamed:@"goforward"];
                break;
            case Pause:
                [self.tetrisAudioPlayer pause]; //游戏暂停时暂停音乐
                self.btnImageView.image = [UIImage systemImageNamed:@"play"];
                break;
            case Running:
                [self.tetrisAudioPlayer play]; //游戏运行时播放音乐
                self.btnImageView.image = [UIImage systemImageNamed:@"pause"];
                break;
                
        }
    }
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    // Block
    int columns = 12;
    int rows = 20;
    [self.innerGameBoard layoutIfNeeded];
    CGFloat gameBoardWidth = self.innerGameBoard.frame.size.width;
    CGFloat gameBoardHight = self.innerGameBoard.frame.size.height;
    CGFloat blocksize = MIN(gameBoardWidth/columns, gameBoardHight/rows);
    CGFloat xOffset = (gameBoardWidth - blocksize*columns)/2;
    CGFloat yOfsset = (gameBoardHight - blocksize*rows)/2;
    for (int col = 0 ; col < columns ; col++){
        for (int row = 0; row < rows; row++){
            CGFloat x = xOffset + blocksize * col;
            CGFloat y = gameBoardHight - yOfsset - blocksize * (row+1);
            UIView * square = [[UIView alloc] initWithFrame:CGRectMake(x, y, blocksize, blocksize)];
            square.backgroundColor = [UIColor colorNamed:@"backgroundColor"];
            [self.innerGameBoard addSubview:square];
            
            UIView * Dot = [[UIView alloc] init];
            Dot.translatesAutoresizingMaskIntoConstraints = NO;
            Dot.backgroundColor = [UIColor colorNamed:@"DotColor"];
            Dot.layer.cornerRadius = 1;
            [square addSubview:Dot];
            [Dot.centerYAnchor constraintEqualToAnchor:square.centerYAnchor].active = YES;
            [Dot.centerXAnchor constraintEqualToAnchor:square.centerXAnchor].active = YES;
            [Dot.widthAnchor constraintEqualToConstant:3].active = YES;
            [Dot.heightAnchor constraintEqualToConstant:3].active = YES;
            
            UIView *block = self.squareBoard[col][row];
            [square addSubview:block];
            [block.topAnchor constraintEqualToAnchor:square.topAnchor constant:2].active = YES;
            [block.bottomAnchor constraintEqualToAnchor:square.bottomAnchor constant:-2].active = YES;
            [block.leftAnchor constraintEqualToAnchor:square.leftAnchor constant:2].active = YES;
            [block.rightAnchor constraintEqualToAnchor:square.rightAnchor constant:-2].active = YES;
        }
    }
}



- (void)setupView{
    self.view.backgroundColor = [UIColor colorNamed:@"backgroundColor"];
    // Safe Area
    UILayoutGuide *margin = self.view.layoutMarginsGuide;
    self.safeArea = [[UIView alloc] init];
    self.safeArea.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.safeArea];
    [self.safeArea.topAnchor constraintEqualToAnchor:margin.topAnchor].active = true;
    [self.safeArea.bottomAnchor constraintEqualToAnchor:margin.bottomAnchor].active = true;
    [self.safeArea.leftAnchor constraintEqualToAnchor:margin.leftAnchor].active = true;
    [self.safeArea.rightAnchor constraintEqualToAnchor:margin.rightAnchor].active = true;
    self.safeArea.backgroundColor = [UIColor colorNamed:@"backgroundColor"];
    
    // Label
    self.label = [[UILabel alloc] init];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.label setText:@"SCORE"];
    [self.label setTextColor:[UIColor colorNamed:@"SystemTextColor"]];
    [self.safeArea addSubview:self.label];
    [self.label.topAnchor constraintEqualToAnchor:self.safeArea.topAnchor].active = YES;
    [self.label.centerXAnchor constraintEqualToAnchor:self.safeArea.centerXAnchor].active = YES;
    
    // Score
    self.scoreBox = [[NeumophicInnerView alloc] init];
    self.scoreBox.translatesAutoresizingMaskIntoConstraints = NO;
    [self.safeArea addSubview:self.scoreBox];
    [self.scoreBox.topAnchor constraintEqualToAnchor:self.label.bottomAnchor constant:10].active = YES;
    [self.scoreBox.centerXAnchor constraintEqualToAnchor:self.safeArea.centerXAnchor].active = YES;
    [self.scoreBox.widthAnchor constraintEqualToConstant:160].active = YES;
    [self.scoreBox.heightAnchor constraintEqualToConstant:50].active = YES;
    
    // Score Label
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scoreLabel setText:@"0"];
    [self.scoreLabel setFont:[UIFont systemFontOfSize:28]];
    [self.scoreLabel setTextColor:[UIColor colorNamed:@"SystemTextColor"]];
    [self.scoreBox addSubview:self.scoreLabel];
    [self.scoreLabel.centerXAnchor constraintEqualToAnchor:self.scoreBox.centerXAnchor].active = YES;
    [self.scoreLabel.centerYAnchor constraintEqualToAnchor:self.scoreBox.centerYAnchor].active = YES;
    
    
    // Control Button
    // Left Control - Up, Down, Left, Right
    self.leftControlBox = [[UIView alloc] init];
    self.leftControlBox.translatesAutoresizingMaskIntoConstraints = NO;
    [self.safeArea addSubview:self.leftControlBox];
    [self.leftControlBox.widthAnchor constraintEqualToAnchor:self.safeArea.widthAnchor multiplier:0.4].active = YES;
    [self.leftControlBox.heightAnchor constraintEqualToAnchor:self.safeArea.widthAnchor multiplier:0.4].active = YES;
    [self.leftControlBox.bottomAnchor constraintEqualToAnchor:self.safeArea.bottomAnchor].active = YES;
    [self.leftControlBox.leftAnchor constraintEqualToAnchor:self.safeArea.leftAnchor constant:10].active = YES;
    // Up
    self.upButton = [[NeumButton alloc] init];
    self.upButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self SetButtonImage:@"chevron.up" button:self.upButton cons:7];
    [self.leftControlBox addSubview:self.upButton];
    [self.upButton.widthAnchor constraintEqualToAnchor:self.leftControlBox.widthAnchor multiplier:0.32].active = YES;
    [self.upButton.heightAnchor constraintEqualToAnchor:self.leftControlBox.widthAnchor multiplier:0.32].active = YES;
    [self.upButton.centerXAnchor constraintEqualToAnchor:self.leftControlBox.centerXAnchor].active = YES;
    [self.upButton.topAnchor constraintEqualToAnchor:self.leftControlBox.topAnchor].active = YES;
    // Down
    self.downButton = [[NeumButton alloc] init];
    self.downButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self SetButtonImage:@"chevron.down" button:self.downButton cons:7];
    [self.leftControlBox addSubview:self.downButton];
    [self.downButton.widthAnchor constraintEqualToAnchor:self.leftControlBox.widthAnchor multiplier:0.32].active = YES;
    [self.downButton.heightAnchor constraintEqualToAnchor:self.leftControlBox.widthAnchor multiplier:0.32].active = YES;
    [self.downButton.centerXAnchor constraintEqualToAnchor:self.leftControlBox.centerXAnchor].active = YES;
    [self.downButton.bottomAnchor constraintEqualToAnchor:self.leftControlBox.bottomAnchor].active = YES;
    // Left
    self.leftButton = [[NeumButton alloc] init];
    self.leftButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self SetButtonImage:@"chevron.left" button:self.leftButton cons:7];
    [self.leftControlBox addSubview:self.leftButton];
    [self.leftButton.widthAnchor constraintEqualToAnchor:self.leftControlBox.widthAnchor multiplier:0.32].active = YES;
    [self.leftButton.heightAnchor constraintEqualToAnchor:self.leftControlBox.widthAnchor multiplier:0.32].active = YES;
    [self.leftButton.centerYAnchor constraintEqualToAnchor:self.leftControlBox.centerYAnchor].active = YES;
    [self.leftButton.leftAnchor constraintEqualToAnchor:self.leftControlBox.leftAnchor].active = YES;
    // Right
    self.rightButton = [[NeumButton alloc] init];
    self.rightButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self SetButtonImage:@"chevron.right" button:self.rightButton cons:7];
    [self.leftControlBox addSubview:self.rightButton];
    [self.rightButton.widthAnchor constraintEqualToAnchor:self.leftControlBox.widthAnchor multiplier:0.32].active = YES;
    [self.rightButton.heightAnchor constraintEqualToAnchor:self.leftControlBox.widthAnchor multiplier:0.32].active = YES;
    [self.rightButton.centerYAnchor constraintEqualToAnchor:self.leftControlBox.centerYAnchor].active = YES;
    [self.rightButton.rightAnchor constraintEqualToAnchor:self.leftControlBox.rightAnchor].active = YES;
    
    // Right Control - Play And Pause
    self.rightControlBox = [[UIView alloc] init];
    self.rightControlBox.translatesAutoresizingMaskIntoConstraints = NO;
    [self.safeArea addSubview:self.rightControlBox];
    [self.rightControlBox.widthAnchor constraintEqualToAnchor:self.safeArea.widthAnchor multiplier:0.40].active = YES;
    [self.rightControlBox.heightAnchor constraintEqualToAnchor:self.safeArea.widthAnchor multiplier:0.40].active = YES;
    [self.rightControlBox.bottomAnchor constraintEqualToAnchor:self.safeArea.bottomAnchor].active = YES;
    [self.rightControlBox.rightAnchor constraintEqualToAnchor:self.safeArea.rightAnchor constant:10].active = YES;
    // Play And Pause Button
    self.playButton = [[NeumButton alloc] init];
    self.playButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.rightControlBox addSubview:self.playButton];
    [self.playButton.widthAnchor constraintEqualToAnchor:self.rightControlBox.widthAnchor multiplier:0.55].active = YES;
    [self.playButton.heightAnchor constraintEqualToAnchor:self.rightControlBox.widthAnchor multiplier:0.55].active = YES;
    [self.playButton.centerXAnchor constraintEqualToAnchor:self.rightControlBox.centerXAnchor].active = YES;
    [self.playButton.centerYAnchor constraintEqualToAnchor:self.rightControlBox.centerYAnchor].active = YES;
    // Play And Pause Button Image
    self.btnImageView = [[UIImageView alloc] init];
    self.btnImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.btnImageView.image = [UIImage systemImageNamed:@"pause"];
    self.btnImageView.image = [self.btnImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.btnImageView setTintColor:[UIColor colorNamed:@"ControlColor"]];
    self.btnImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.playButton addSubview:self.btnImageView];
    int btnImageCons = 25;
    [self.btnImageView.topAnchor constraintEqualToAnchor:self.playButton.topAnchor constant:btnImageCons].active = YES;
    [self.btnImageView.bottomAnchor constraintEqualToAnchor:self.playButton.bottomAnchor constant:-btnImageCons].active = YES;
    [self.btnImageView.leftAnchor constraintEqualToAnchor:self.playButton.leftAnchor constant:btnImageCons].active = YES;
    [self.btnImageView.rightAnchor constraintEqualToAnchor:self.playButton.rightAnchor constant:-btnImageCons].active = YES;

    // Game Board
    self.gameBoard = [[NeumophicInnerView alloc] init];
    self.gameBoard.translatesAutoresizingMaskIntoConstraints = NO;
    [self.safeArea addSubview:self.gameBoard];
    [self.gameBoard.topAnchor constraintEqualToAnchor:self.scoreBox.bottomAnchor constant:10].active = YES;
    [self.gameBoard.bottomAnchor constraintEqualToAnchor:self.rightControlBox.topAnchor constant:-10].active = YES;
    [self.gameBoard.leftAnchor constraintEqualToAnchor:self.safeArea.leftAnchor constant:10].active = YES;
    [self.gameBoard.rightAnchor constraintEqualToAnchor:self.safeArea.rightAnchor constant:-10].active = YES;
    
    // Inner Game Board
    self.innerGameBoard = [[UIView alloc] init];
    self.innerGameBoard.translatesAutoresizingMaskIntoConstraints = NO;
    [self.gameBoard addSubview:self.innerGameBoard];
    [self.innerGameBoard.topAnchor constraintEqualToAnchor:self.gameBoard.topAnchor constant:10].active = YES;
    [self.innerGameBoard.bottomAnchor constraintEqualToAnchor:self.gameBoard.bottomAnchor constant:-10].active = YES;
    [self.innerGameBoard.leftAnchor constraintEqualToAnchor:self.gameBoard.leftAnchor constant:10].active = YES;
    [self.innerGameBoard.rightAnchor constraintEqualToAnchor:self.gameBoard.rightAnchor constant:-10].active = YES;
    self.innerGameBoard.backgroundColor = [UIColor colorNamed:@"backgroundColor"];
}

- (void)SetButtonImage:(NSString *)image button:(UIView *)btn cons:(CGFloat)cons{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.image = [UIImage systemImageNamed:image];
    imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imageView setTintColor:[UIColor colorNamed:@"ControlColor"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [btn addSubview:imageView];
    [imageView.topAnchor constraintEqualToAnchor:btn.topAnchor constant:cons].active = YES;
    [imageView.bottomAnchor constraintEqualToAnchor:btn.bottomAnchor constant:-cons].active = YES;
    [imageView.leftAnchor constraintEqualToAnchor:btn.leftAnchor constant:cons].active = YES;
    [imageView.rightAnchor constraintEqualToAnchor:btn.rightAnchor constant:-cons].active = YES;
    [self.tetrisGameViewModel PlayAndPauseButtonClick];
}

@end
