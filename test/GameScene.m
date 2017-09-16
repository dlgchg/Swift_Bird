//
//  GameScene.m
//  test
//
//  Created by 曹修远 on 07/09/2017.
//  Copyright © 2017 曹修远. All rights reserved.
//

// Degrees to radians
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#import "GameScene.h"
//typedef enum _myCoverage{
//    myBackGround,
//    myObstacle,
//    myFrontGround,
//    myGameCharacter
//    myGameCharacterHat,
//}myCoverage;

//struct myPhysics {
//    UInt32 physicsNone;
//    UInt32 physicsGameCharacter;
//    UInt32 physicsObstacle;
//    UInt32 physicsFrontGround;

//};


@implementation GameScene {
    SKNode *myWorldNode;
    CGFloat myGameStartPoint;
    CGFloat myGameRegionHeight;
    SKSpriteNode *myGameCharacter;
    SKSpriteNode *myGameCharacterHat;
    SKSpriteNode *myTutorialNode;
    
    //开始界面按钮
    SKSpriteNode *myClassicalBtn;
//    SKSpriteNode *myPlayBtnPNG;
    SKLabelNode *myClassicalBtnLabel;
    
    SKSpriteNode *myTrainBtn;
    SKLabelNode *myTrainBtnLabel;
    
    SKSpriteNode *myInsaneBtn;
    SKLabelNode *myInsaneBtnLabel;
    
    SKSpriteNode *myARBtn;
    SKLabelNode *myARBtnLabel;
    
    SKSpriteNode *myRankingBtn;
    SKLabelNode *myRankingBtnLabel;
    
    SKSpriteNode *mySettingBtn;
    SKLabelNode *mySettingBtnLabel;
    
    //时间相关
    NSTimeInterval myLastUpdateTime;
    NSTimeInterval myElapsedTime;
    NSTimeInterval myCurrentTime;
    
    
    CGFloat myGravity;//重力
    CGFloat myFly;//点击之后上飞
    CGPoint myVelocity;//速度
    
    CGFloat myFrontGroundTotal;
    CGFloat myFrontGroundVelocity;
    
    SKSpriteNode *myBackGround;
    SKSpriteNode *myFrontGround;
    SKSpriteNode *myObstacle;
    
    //障碍物的最大最小范围
    CGFloat myMinimumCoefficient;
    CGFloat myMaximumCoefficient;
    
    //缺口系数
    CGFloat myGapCoefficient;
    
    //生成障碍延迟时间
    NSTimeInterval myFirstTimeGenerateObstacle;
    NSTimeInterval myTimeGenerateObstacle;
    
    //physics
    UInt32 physicsNone;
    UInt32 physicsGameCharacter;
    UInt32 physicsObstacle;
    UInt32 physicsFrontGround;
    
    //BOOL
    BOOL myHitFrontGround;
    BOOL myHitObstacle;
    
    //游戏状态
    int myMainMenu;
    int myTutorial;
    int myGame;
    int myFall;
    int myDisplayScore;
    int myEndGame;
    
    int myCurrentGameState;
    
    //游戏音效（待添加）
    SKAction *mySoundFall;
    SKAction *mySoundFly;
    SKAction *mySoundGetPoint;
    SKAction *mySoundHitFrontGround;
    SKAction *mySoundPop;
    SKAction *mySoundWhack;

    
    //顶部分数
    CGFloat myTopBlank;
    NSString *myTopBlankTypeface;
    SKLabelNode *myScoreLabelNode;
    int myCurrentScore;
    
    //游戏模式
    int myClassicalMode;
    int myTrainMode;
    int myInsaneMode;
    int myARMode;
    int myRankingMode;
    int mySettingMode;
    
    int myCurrentGameMode;
//    NSString *myCurrentGameModeString;
    
    //游戏主题
    int myNomalTheme;
    int myCowboyTheme;
    
    int myCurrentGameTheme;
    
    //人物贴图组
    int myGameCharacterNumberOfFrames;
    
    //图片元素
    SKSpriteNode *myFeedbackPNG;
    SKSpriteNode *myWebPNG;
    SKSpriteNode *myAboutPNG;
}


- (void)didMoveToView:(SKView *)view {
    //关闭重力
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    //代理
    self.physicsWorld.contactDelegate = self;
    
    
    // Setup scene 设置场景
    myWorldNode = [[SKNode alloc]init];
    [self addChild:myWorldNode];
    
    myGravity = -400;
    myFly = 200;
    myVelocity = CGPointZero;
    
    myFrontGroundTotal = 2;// 地面的数量
    myFrontGroundVelocity = -150;
    
    //障碍物的最大最小范围
    myMinimumCoefficient = 0.1;
    myMaximumCoefficient = 0.6;
    
    myGapCoefficient = 3.5;
    
    //生成障碍延迟时间
    myFirstTimeGenerateObstacle = 1.65;
    myTimeGenerateObstacle = 1.75;
    
    //physics
    physicsNone = 0;                //0
    physicsGameCharacter = 0b1;     //1
    physicsObstacle = 0b10;         //2
    physicsFrontGround = 0b100;     //4
    
    myHitFrontGround = NO;
    myHitObstacle = NO;
    
    //游戏状态
    myMainMenu = 0;
    myTutorial = 1;
    myGame = 2;
    myFall = 3;
    myDisplayScore =4;
    myEndGame = 5;
    
    myCurrentGameState = 0;
    
    //游戏音效
    mySoundFall = [SKAction playSoundFileNamed:@"falling.wav" waitForCompletion:NO];
    mySoundFly = [SKAction playSoundFileNamed:@"flapping.wav" waitForCompletion:NO];
    mySoundGetPoint = [SKAction playSoundFileNamed:@"coin.wav" waitForCompletion:NO];
    mySoundHitFrontGround = [SKAction playSoundFileNamed:@"hitGround.wav" waitForCompletion:NO];
    mySoundPop = [SKAction playSoundFileNamed:@"pop.wav" waitForCompletion:NO];
    mySoundWhack = [SKAction playSoundFileNamed:@"whack.wav" waitForCompletion:NO];
    
//    [self runAction:[SKAction sequence:@[mySoundFall,mySoundFly,mySoundGetPoint,mySoundHitFrontGround,mySoundPop,mySoundWhack]]];

    //顶部分数
    myTopBlank = 20.0;
    myTopBlankTypeface = @"AmericanTypewriter-Bold";
    myCurrentScore = 0;
    
    //游戏模式
    myClassicalMode = 0;
    myTrainMode = 1;
    myInsaneMode = 2;
    myARMode = 3;
    myRankingMode = 4;
    mySettingMode =5;
    
    myCurrentGameMode = 0;
//    myCurrentGameModeString = @"";
    
    //游戏主题
    myNomalTheme = 0;
    myCowboyTheme = 1;
    
    myCurrentGameTheme = 0;
    
    //人物贴图组
    myGameCharacterNumberOfFrames = 4;
    
    SKTexture *tmp = [SKTexture textureWithImageNamed:@"Mail"];
    //初始化图片元素
//    myFeedbackPNG = [[SKSpriteNode alloc]initWithImageNamed:@"Mail"];

    myFeedbackPNG = [[SKSpriteNode alloc]initWithTexture:tmp];
    myWebPNG = [[SKSpriteNode alloc]initWithImageNamed:@"Safari"];
    myAboutPNG = [[SKSpriteNode alloc]initWithImageNamed:@"About"];
    
    
    [self mySwitchToMainMenu];
    
}

#pragma mark 设置的相关方法
-(void)mySetMainMenu{
    
    //经典模式按钮
    myClassicalBtn = [[SKSpriteNode alloc]initWithImageNamed:@"ButtonLeft"];
    myClassicalBtn.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.7);
    NSLog(@"##myPlayBtn.position:%f,%f",myClassicalBtn.position.x,myClassicalBtn.position.y);
    myClassicalBtn.name = @"主菜单／经典";
    myClassicalBtn.zPosition = 6;
    [myWorldNode addChild:myClassicalBtn];
    
//    myPlayBtnPNG = [[SKSpriteNode alloc]initWithImageNamed:@"Play"];
//    myPlayBtnPNG.position =CGPointZero;
//    [myPlayBtn addChild:myPlayBtnPNG];
    
    myClassicalBtnLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
    [myClassicalBtnLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
    myClassicalBtnLabel.position = CGPointMake(CGPointZero.x, CGPointZero.y + myClassicalBtn.size.height/4);
    NSLog(@"##myPlayBtnLabel.position:%f,%f",myClassicalBtnLabel.position.x,myClassicalBtnLabel.position.y);
    [myClassicalBtnLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    myClassicalBtnLabel.text = @"经典";
    myClassicalBtnLabel.zPosition = 6;
    myClassicalBtnLabel.name = @"主菜单／经典";
    [myClassicalBtn addChild:myClassicalBtnLabel];
    
    //训练模式按钮
    myTrainBtn = [[SKSpriteNode alloc]initWithImageNamed:@"ButtonLeft"];
    myTrainBtn.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.6);
    myTrainBtn.name = @"主菜单／训练";
    myTrainBtn.zPosition = 6;
    [myWorldNode addChild:myTrainBtn];
    
    myTrainBtnLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
    [myTrainBtnLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
    myTrainBtnLabel.position = CGPointMake(CGPointZero.x, CGPointZero.y + myClassicalBtn.size.height/4);
    [myTrainBtnLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    myTrainBtnLabel.text = @"训练";
    myTrainBtnLabel.zPosition = 6;
    myTrainBtnLabel.name = @"主菜单／训练";
    [myTrainBtn addChild:myTrainBtnLabel];
    
    //疯狂模式按钮
    myInsaneBtn = [[SKSpriteNode alloc]initWithImageNamed:@"ButtonLeft"];
    myInsaneBtn.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
    myInsaneBtn.name = @"主菜单／疯狂";
    myInsaneBtn.zPosition = 6;
    [myWorldNode addChild:myInsaneBtn];
    
    myInsaneBtnLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
    [myInsaneBtnLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
    myInsaneBtnLabel.position = CGPointMake(CGPointZero.x, CGPointZero.y + myClassicalBtn.size.height/4);
    [myInsaneBtnLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    myInsaneBtnLabel.text = @"疯狂";
    myInsaneBtnLabel.zPosition = 6;
    myInsaneBtnLabel.name = @"主菜单／疯狂";
    [myInsaneBtn addChild:myInsaneBtnLabel];
    
    //AR模式按钮
    myARBtn = [[SKSpriteNode alloc]initWithImageNamed:@"ButtonLeft"];
    myARBtn.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.4);
    myARBtn.name = @"主菜单／AR";
    myARBtn.zPosition = 6;
    [myWorldNode addChild:myARBtn];
    
    myARBtnLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
    [myARBtnLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
    myARBtnLabel.position = CGPointMake(CGPointZero.x, CGPointZero.y + myClassicalBtn.size.height/4);
    [myARBtnLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    myARBtnLabel.text = @"AR";
    myARBtnLabel.zPosition = 6;
    myARBtnLabel.name = @"主菜单／AR";
    [myARBtn addChild:myARBtnLabel];
    
    //排行按钮
    myRankingBtn = [[SKSpriteNode alloc]initWithImageNamed:@"ButtonLeft"];
    myRankingBtn.position = CGPointMake(self.size.width * 0.25, self.size.height * 0.2);
    myRankingBtn.name = @"主菜单／排行";
    myRankingBtn.zPosition = 6;
    [myWorldNode addChild:myRankingBtn];
    
    myRankingBtnLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
    [myRankingBtnLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
    myRankingBtnLabel.position = CGPointMake(CGPointZero.x, CGPointZero.y + myClassicalBtn.size.height/4);
    [myRankingBtnLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    myRankingBtnLabel.text = @"排行";
    myRankingBtnLabel.zPosition = 6;
    myRankingBtnLabel.name = @"主菜单／排行";
    [myRankingBtn addChild:myRankingBtnLabel];
    
    //设置按钮
    mySettingBtn = [[SKSpriteNode alloc]initWithImageNamed:@"ButtonLeft"];
    mySettingBtn.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.2);
    mySettingBtn.name = @"主菜单／设置";
    mySettingBtn.zPosition = 6;
    [myWorldNode addChild:mySettingBtn];
    
    mySettingBtnLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
    [mySettingBtnLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
    mySettingBtnLabel.position = CGPointMake(CGPointZero.x, CGPointZero.y + myClassicalBtn.size.height/4);
    [mySettingBtnLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    mySettingBtnLabel.text = @"设置";
    mySettingBtnLabel.zPosition = 6;
    mySettingBtnLabel.name = @"主菜单／设置";
    [mySettingBtn addChild:mySettingBtnLabel];
}

- (void)mySetSetting{
    
    
    SKSpriteNode *mySettingUI = [[SKSpriteNode alloc]initWithImageNamed:@"Scorecard"];
    mySettingUI.position = CGPointMake(self.size.width*0.5, self.size.height*0.5);
    mySettingUI.size = CGSizeMake(self.size.width*0.8, self.size.height*0.7);
    mySettingUI.zPosition = 6;
    [myWorldNode addChild:mySettingUI];
    
    //目前得分
//    SKLabelNode *myScoreCurrentLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
//    [myScoreCurrentLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
//    myScoreCurrentLabel.position = CGPointMake(-myScorecard.size.width/4, -myScorecard.size.height/6);
//    [myScoreCurrentLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
//    myScoreCurrentLabel.text = [NSString stringWithFormat:@"%d",myCurrentScore];
//    myScoreCurrentLabel.zPosition = 6;
//    [myScorecard addChild:myScoreCurrentLabel];
//    
//    SKLabelNode *myScoreCurrent = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
//    myScoreCurrent = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
//    [myScoreCurrent setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
//    myScoreCurrent.position = CGPointMake(-myScorecard.size.width/4, myScorecard.size.height/4);
//    [myScoreCurrent setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
//    myScoreCurrent.text = @"得分";
//    myScoreCurrent.zPosition = 6;
//    [myScorecard addChild:myScoreCurrent];
    
    //OK
    SKSpriteNode *myOKBtn = [[SKSpriteNode alloc]initWithImageNamed:@"ButtonLeft"];
    myOKBtn.position = CGPointMake(self.size.width*0.5, self.size.height/2 - mySettingUI.size.height/2 - myTopBlank - myOKBtn.size.height/2);
    myOKBtn.zPosition = 6;
    myOKBtn.name = @"设置／返回";
    [myWorldNode addChild:myOKBtn];
    
    SKLabelNode *myOKBtnLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
    myOKBtnLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
    [myOKBtnLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
    myOKBtnLabel.position = CGPointMake(CGPointZero.x, CGPointZero.y + myClassicalBtn.size.height/4);
    [myOKBtnLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    myOKBtnLabel.text = @"返回";
    myOKBtnLabel.zPosition = 6;
    myOKBtnLabel.name = @"设置／返回";
    [myOKBtn addChild:myOKBtnLabel];
    
    //主题
    SKLabelNode *myThemeLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
    [myThemeLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
    myThemeLabel.position = CGPointMake(CGPointZero.x, mySettingUI.frame.origin.y + mySettingUI.size.height * 0.2 );
    [myThemeLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    myThemeLabel.text = @"主题";
    myThemeLabel.zPosition = 6;
    [mySettingUI addChild:myThemeLabel];
    
    //反馈
    SKLabelNode *myFeedbackLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
    [myFeedbackLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
    myFeedbackLabel.position = CGPointMake(CGPointZero.x - mySettingUI.frame.size.width *0.1, mySettingUI.frame.origin.y - mySettingUI.size.height * 0.1);
    [myFeedbackLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    myFeedbackLabel.text = @"反馈";
    myFeedbackLabel.zPosition = 6;
    [mySettingUI addChild:myFeedbackLabel];
    
    myFeedbackPNG.position = CGPointMake(mySettingUI.frame.origin.x, myFeedbackLabel.frame.origin.y + myFeedbackLabel.frame.size.height/2);
    [mySettingUI addChild:myFeedbackPNG];
    
    //访问网站
    SKLabelNode *myWebLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
    [myWebLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
    myWebLabel.position = CGPointMake(CGPointZero.x - mySettingUI.frame.size.width *0.1, mySettingUI.frame.origin.y - mySettingUI.size.height * 0.3);
    [myWebLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    myWebLabel.text = @"网站";
    myWebLabel.zPosition = 6;
    [mySettingUI addChild:myWebLabel];
    
    myWebPNG.position = CGPointMake(mySettingUI.frame.origin.x, myWebLabel.frame.origin.y + myWebLabel.frame.size.height/2);
    [mySettingUI addChild:myWebPNG];
    
    //关于
    SKLabelNode *myAboutLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
    [myAboutLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
    myAboutLabel.position = CGPointMake(CGPointZero.x - mySettingUI.frame.size.width *0.1, mySettingUI.frame.origin.y - mySettingUI.size.height * 0.5);
    [myAboutLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
    myAboutLabel.text = @"关于";
    myAboutLabel.zPosition = 6;
    [mySettingUI addChild:myAboutLabel];
    
    myAboutPNG.position = CGPointMake(mySettingUI.frame.origin.x, myAboutLabel.frame.origin.y + myAboutLabel.frame.size.height/2);
    [mySettingUI addChild:myAboutPNG];
    
//    [self runAction:[SKAction waitForDuration:0.5]];
}
- (void)mySetTutorial{
    myTutorialNode = [[SKSpriteNode alloc]initWithImageNamed:@"Tutorial"];
    myTutorialNode.position = CGPointMake(self.size.width/2, myGameRegionHeight *0.4 + myGameStartPoint);
    myTutorialNode.name =@"教程";
    myTutorialNode.zPosition = 6;
    [myWorldNode addChild:myTutorialNode];
    
    //人物煽动翅膀
    NSMutableArray *myGameCharacterTextureArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < myGameCharacterNumberOfFrames ; i ++) {
        NSString *tmp = [NSString stringWithFormat:@"Bird%d",i];
        [myGameCharacterTextureArray addObject:[SKTexture textureWithImageNamed:tmp]];
    }
//    for (int i = myGameCharacterNumberOfFrames - 1; i >= 0 ; i --) {
//        [myGameCharacterTextureArray addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Bird%d",i]]];
//    }
    
    SKAction *myGameCharacterWingAnimation = [SKAction animateWithTextures:myGameCharacterTextureArray timePerFrame:0.07];
    [myGameCharacter runAction:[SKAction repeatActionForever:myGameCharacterWingAnimation]];
    
    
}
- (void)mySetBackGround{
    
    myBackGround = [[SKSpriteNode alloc]initWithImageNamed:@"Background"];
    
    myBackGround.anchorPoint = CGPointMake(0.5, 1.0);
    myBackGround.position = CGPointMake(self.size.width/2, self.size.height);
    myBackGround.zPosition = 0;
    myBackGround.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*0.7);
    
    [myWorldNode addChild:myBackGround];
    
    myGameStartPoint = self.view.frame.size.height - myBackGround.size.height;
    myGameRegionHeight = myBackGround.size.height;
    
    CGPoint myLeftX = CGPointMake(0, myGameStartPoint);
    CGPoint myRightX = CGPointMake(self.size.width, myGameStartPoint);
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:myLeftX toPoint:myRightX];
    self.physicsBody.categoryBitMask = physicsFrontGround;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = physicsGameCharacter;
    
}

- (void)mySetFrontGround{

    for (int i = 0; i < myFrontGroundTotal; i++) {
        myFrontGround = [[SKSpriteNode alloc]initWithImageNamed:@"Ground"];
        
        myFrontGround.anchorPoint = CGPointMake(0, 1.0);
//        myFrontGround.position = CGPointMake((CGFloat)i * myFrontGround.size.width, myGameStartPoint);
        myFrontGround.position = CGPointMake((CGFloat)i * self.view.frame.size.width, myGameStartPoint);
        myFrontGround.zPosition = 2;
        myFrontGround.size = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*0.3);
        myFrontGround.name = @"前地面";
        [myWorldNode addChild:myFrontGround];
        NSLog(@"第%d个前地面Set",i);
    }

}

- (void)mySetGameCharacter{
    myGameCharacter = [[SKSpriteNode alloc]initWithImageNamed:@"Bird0"];
    myGameCharacter.position = CGPointMake(self.view.frame.size.width*0.2, myGameRegionHeight*0.4 + myGameStartPoint);
    myGameCharacter.zPosition = 3;
    
    //
    CGFloat offsetX = myGameCharacter.frame.size.width * myGameCharacter.anchorPoint.x;
    CGFloat offsetY = myGameCharacter.frame.size.height * myGameCharacter.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 3 - offsetX, 16 - offsetY);
    CGPathAddLineToPoint(path, NULL, 19 - offsetX, 24 - offsetY);
    CGPathAddLineToPoint(path, NULL, 38 - offsetX, 26 - offsetY);
    CGPathAddLineToPoint(path, NULL, 37 - offsetX, 25 - offsetY);
    CGPathAddLineToPoint(path, NULL, 38 - offsetX, 20 - offsetY);
    CGPathAddLineToPoint(path, NULL, 38 - offsetX, 15 - offsetY);
    CGPathAddLineToPoint(path, NULL, 39 - offsetX, 10 - offsetY);
    CGPathAddLineToPoint(path, NULL, 38 - offsetX, 6 - offsetY);
    CGPathAddLineToPoint(path, NULL, 36 - offsetX, 3 - offsetY);
    CGPathAddLineToPoint(path, NULL, 30 - offsetX, 1 - offsetY);
    CGPathAddLineToPoint(path, NULL, 21 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 15 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 9 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 5 - offsetX, 0 - offsetY);
    CGPathAddLineToPoint(path, NULL, 2 - offsetX, 2 - offsetY);
    CGPathAddLineToPoint(path, NULL, 2 - offsetX, 7 - offsetY);
    CGPathAddLineToPoint(path, NULL, 1 - offsetX, 11 - offsetY);
    CGPathAddLineToPoint(path, NULL, 2 - offsetX, 14 - offsetY);
    CGPathAddLineToPoint(path, NULL, 27 - offsetX, 28 - offsetY);
    
    CGPathCloseSubpath(path);
    
    myGameCharacter.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    myGameCharacter.physicsBody.categoryBitMask = physicsGameCharacter;
    myGameCharacter.physicsBody.collisionBitMask = 0;
    myGameCharacter.physicsBody.contactTestBitMask = physicsObstacle | physicsFrontGround;
    
    myGameCharacter.name = @"游戏角色";
    [myWorldNode addChild:myGameCharacter];
    
}

- (void)mySetGameCharacterHat{
    myGameCharacterHat = [[SKSpriteNode alloc]initWithImageNamed:@"Hat"];
    myGameCharacterHat.position = CGPointMake(myGameCharacter.size.width/4, myGameCharacter.size.height/2);
    myGameCharacterHat.zPosition = 3;
    [myGameCharacter addChild:myGameCharacterHat];
}

- (void)mySetScoreLabel{
    //经典模式和疯狂模式需要设置分数Label
    if (myCurrentGameMode == 0 || myCurrentGameMode == 2) {
        myScoreLabelNode = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
        [myScoreLabelNode setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
        myScoreLabelNode.position = CGPointMake(self.size.width/2, self.size.height - myTopBlank);
        [myScoreLabelNode setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
        myScoreLabelNode.text = @"0";
        myScoreLabelNode.zPosition = 5;
        [myWorldNode addChild:myScoreLabelNode];
    }
}

- (void)mySetScorecard{
    //经典模式和疯狂模式需要记分板
    if (myCurrentGameMode == 0 || myCurrentGameMode == 2 ) {
        if (myCurrentScore > [self myBest]) {
            [self mySetBest:myCurrentScore];
        }
        
        SKSpriteNode *myScorecard = [[SKSpriteNode alloc]initWithImageNamed:@"Scorecard"];
        myScorecard.position = CGPointMake(self.size.width/2, self.size.height/2);
        myScorecard.zPosition = 6;
        [myWorldNode addChild:myScorecard];
        
        //目前得分
        SKLabelNode *myScoreCurrentLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
        [myScoreCurrentLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
        myScoreCurrentLabel.position = CGPointMake(-myScorecard.size.width/4, -myScorecard.size.height/6);
        [myScoreCurrentLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
        myScoreCurrentLabel.text = [NSString stringWithFormat:@"%d",myCurrentScore];
        myScoreCurrentLabel.zPosition = 6;
        [myScorecard addChild:myScoreCurrentLabel];
        
        SKLabelNode *myScoreCurrent = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
        myScoreCurrent = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
        [myScoreCurrent setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
        myScoreCurrent.position = CGPointMake(-myScorecard.size.width/4, myScorecard.size.height/4);
        [myScoreCurrent setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
        myScoreCurrent.text = @"得分";
        myScoreCurrent.zPosition = 6;
        [myScorecard addChild:myScoreCurrent];
        
        
        //最高分
        SKLabelNode *myScoreBestLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
        [myScoreBestLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
        myScoreBestLabel.position = CGPointMake(myScorecard.size.width/4, -myScorecard.size.height/6);
        [myScoreBestLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
        myScoreBestLabel.text = [NSString stringWithFormat:@"%ld",(long)[self myBest]];
        myScoreBestLabel.zPosition = 6;
        [myScorecard addChild:myScoreBestLabel];
        
        SKLabelNode *myScoreBest = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
        myScoreBest = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
        [myScoreBest setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
        myScoreBest.position = CGPointMake(myScorecard.size.width/4, myScorecard.size.height/4);
        [myScoreBest setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
        myScoreBest.text = @"最高分";
        myScoreBest.zPosition = 6;
        [myScorecard addChild:myScoreBest];
        
        //OK
        SKSpriteNode *myOKBtn = [[SKSpriteNode alloc]initWithImageNamed:@"ButtonLeft"];
        myOKBtn.position = CGPointMake(self.size.width*0.3, self.size.height/2 - myScorecard.size.height/2 - myTopBlank - myOKBtn.size.height/2);
        myOKBtn.zPosition = 6;
        [myWorldNode addChild:myOKBtn];
        
        SKLabelNode *myOKBtnLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
        myOKBtnLabel = [[SKLabelNode alloc]initWithFontNamed:myTopBlankTypeface];
        [myOKBtnLabel setFontColor:[UIColor colorWithRed:101.0/255.0 green:71.0/255.0 blue:73.0/255.0 alpha:1.0]];
        myOKBtnLabel.position = CGPointMake(CGPointZero.x, CGPointZero.y + myClassicalBtn.size.height/4);
        [myOKBtnLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeTop];
        myOKBtnLabel.text = @"返回";
        myOKBtnLabel.zPosition = 6;
        [myOKBtn addChild:myOKBtnLabel];
        
        
        
        //右边的按钮
        SKSpriteNode *myRightBtn = [[SKSpriteNode alloc]initWithImageNamed:@"ButtonRight"];
        myRightBtn.position = CGPointMake(self.size.width*0.7, self.size.height/2 - myScorecard.size.height/2 - myTopBlank - myOKBtn.size.height/2);
        myRightBtn.zPosition = 6;
        [myWorldNode addChild:myRightBtn];
        
        
        
        
        //添加记分板动画组

    }
    
}
#pragma mark 游戏事件
//创建障碍物
- (SKSpriteNode *)myCreateObstacle:(NSString *)myPNG{
    myObstacle = [[SKSpriteNode alloc]initWithImageNamed:myPNG];
    myObstacle.zPosition = 1;
    myObstacle.userData = [[NSMutableDictionary alloc]init];
    
    CGFloat offsetX = myObstacle.frame.size.width * myObstacle.anchorPoint.x;
    CGFloat offsetY = myObstacle.frame.size.height * myObstacle.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 1 - offsetX, 1 - offsetY);
    CGPathAddLineToPoint(path, NULL, 3 - offsetX, 312 - offsetY);
    CGPathAddLineToPoint(path, NULL, 9 - offsetX, 314 - offsetY);
    CGPathAddLineToPoint(path, NULL, 25 - offsetX, 314 - offsetY);
    CGPathAddLineToPoint(path, NULL, 37 - offsetX, 314 - offsetY);
    CGPathAddLineToPoint(path, NULL, 45 - offsetX, 313 - offsetY);
    CGPathAddLineToPoint(path, NULL, 49 - offsetX, 310 - offsetY);
    CGPathAddLineToPoint(path, NULL, 50 - offsetX, 307 - offsetY);
    CGPathAddLineToPoint(path, NULL, 50 - offsetX, 1 - offsetY);
    
    CGPathCloseSubpath(path);
    
    myObstacle.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    myObstacle.physicsBody.categoryBitMask = physicsObstacle;
    myObstacle.physicsBody.collisionBitMask = 0;
    myObstacle.physicsBody.contactTestBitMask = physicsGameCharacter;
    return myObstacle;
}

//顶部和底部障碍生成
- (void)myGenerateObstacle{
    
    //Bottom
    SKSpriteNode *myBottom = [self myCreateObstacle:@"Bottom"];
//    CGFloat myStartXCoordinate = self.size.width/2;
    CGFloat myStartXCoordinate = self.size.width + myBottom.size.width/2;
    
    int myRandomValue = arc4random()% 6 + 1; //取随机数
    float myCoefficient = 0.0;
    switch (myRandomValue) {
        case 1:
            myCoefficient = 0.2;
            break;
        case 2:
            myCoefficient = 0.25;
            break;
        case 3:
            myCoefficient = 0.3;
            break;
        case 4:
            myCoefficient = 0.4;
            break;
        case 5:
            myCoefficient = 0.5;
            break;
        case 6:
            myCoefficient = 0.6;
            break;
            
        default:
            
            break;
    }
//    CGFloat myYMin = myGameStartPoint - myBottom.size.height/2 + myGameRegionHeight * myMinimumCoefficient;
//    CGFloat myYMax = myGameStartPoint - myBottom.size.height/2 + myGameRegionHeight * myMaximumCoefficient;
    CGFloat myY = myGameStartPoint - myBottom.size.height/2 + myGameRegionHeight * myCoefficient;
    myBottom.position = CGPointMake(myStartXCoordinate, myY);
    myBottom.name = @"底部障碍";
    [myWorldNode addChild:myBottom];
    
    
    //Top
    SKSpriteNode *myTop = [self myCreateObstacle:@"Top"];
    myTop.zRotation = DEGREES_TO_RADIANS(180);
    myTop.position = CGPointMake(myStartXCoordinate, myBottom.position.y + myBottom.size.height/2 + myTop.size.height/2 + myGameCharacter.size.height * myGapCoefficient);
    myTop.name = @"顶部障碍";
    [myWorldNode addChild:myTop];
    
    //Move
    CGFloat myXCoordinateMoveDistance = -(self.size.width + myBottom.size.width);
    CGFloat myMoveTime = myXCoordinateMoveDistance / myFrontGroundVelocity;
    
    
    SKAction *myMoveAction1 = [SKAction moveByX:myXCoordinateMoveDistance y:0 duration:myMoveTime];
    SKAction *myMoveAction2 = [SKAction removeFromParent];
    SKAction *myMoveAction = [SKAction sequence:@[myMoveAction1,myMoveAction2]];
    
    [myBottom runAction:myMoveAction];

    [myTop runAction:myMoveAction];
    
    
}

//无限生成障碍
- (void)myInfiniteGenerateObstacle{
    SKAction *myFirst = [SKAction waitForDuration:myFirstTimeGenerateObstacle];
    SKAction *myRegenerateObstacle = [SKAction runBlock:^{
        [self myGenerateObstacle];
    }];
    SKAction *myGenerateObstacleTimeGap = [SKAction waitForDuration:myTimeGenerateObstacle];
    SKAction *myRegenerateObstacleSequence = [SKAction sequence:@[myRegenerateObstacle,myGenerateObstacleTimeGap]];
    SKAction *myInfiniteGenerate = [SKAction repeatActionForever:myRegenerateObstacleSequence];
    SKAction *myAllGenerateObstacleSequence = [SKAction sequence:@[myFirst,myInfiniteGenerate]];
    
    [self runAction:myAllGenerateObstacleSequence withKey:@"重生"];
}

- (void)myStopGenerateObstacle{
    [self removeActionForKey:@"重生"];
    
    [myWorldNode enumerateChildNodesWithName:@"底部障碍" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeAllActions];
    }];
    
    [myWorldNode enumerateChildNodesWithName:@"顶部障碍" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeAllActions];
    }];
    
    
}

//myGameCharacter & myGameCharacterHat 飞一下效果
- (void)myGameCharacterFly{
    
    myVelocity = CGPointMake(0, myFly);
    [myGameCharacter runAction:mySoundFly];
    //帽子飞一下的效果
    [self myGameCharacterHatFly];
    
}
//帽子飞一下
- (void)myGameCharacterHatFly{
    
    SKAction *myUpMove = [SKAction moveByX:0 y:18 duration:0.15];
    [myUpMove setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction *myDownMove = [myUpMove reversedAction];
    SKAction *myAllHatFly = [SKAction sequence:@[myUpMove, myDownMove]];
    
    [myGameCharacterHat runAction:myAllHatFly];
    
}
#pragma mark 触摸事件
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
//    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    
    
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
//    NSLog(@"point: %f,%f",point.x,point.y);
//    NSLog(@"myCurrentGameState:%d",myCurrentGameState);
    //根据游戏Status
    switch (myCurrentGameState) {
        case 0:                 //myMainMenu
            if ([node.name isEqualToString:@"主菜单／经典"]) {
                [self gameClassicalMode];
            } else if ([node.name isEqualToString:@"主菜单／训练"]){
                [self gameTrainMode];
            } else if ([node.name isEqualToString:@"主菜单／疯狂"]){
                [self gameInsaneMode];
            } else if ([node.name isEqualToString:@"主菜单／AR"]){
                [self gameARMode];
            } else if ([node.name isEqualToString:@"主菜单／排行"]){
                [self gameRankingMode];
            } else if ([node.name isEqualToString:@"主菜单／设置"]){
                [self gameSettingMode];
            }
            if ([node.name isEqualToString:@"设置／返回"]) {
                [self mySwitchToNewGame];
            }
            
            break;
        case 1:                 //myTutorial
            [self mySwitchToGame];
            break;
        case 2:                 //myGame
            //点击屏幕，GameCharacter向上飞
            [self myGameCharacterFly];
            break;
        case 3:                 //myFall
            break;
        case 4:                 //myDisplayScore
            if (myCurrentGameMode != 1) {
                [self mySwitchToEndGame];
            } else if (myCurrentGameMode == 1){
                [self mySwitchToNewGame];
            }
            
            break;
        case 5:                 //myEndGame
            [self mySwitchToNewGame];
            break;
            
        default:
            break;
    }
}
#pragma mark 游戏模式(按钮)
- (void)gameClassicalMode{
    myCurrentGameMode = 0;
    [self mySwitchToTutorial];
    
}
- (void)gameTrainMode{
    myCurrentGameMode = 1;
    myTimeGenerateObstacle = 3;
    myGravity = -400;
    myFly = 200;
    [self mySwitchToTutorial];
    
}
- (void)gameInsaneMode{
    myCurrentGameMode = 2;
    myTimeGenerateObstacle = 1;
    myGravity = -600;
    myFly = 300;
    [self mySwitchToTutorial];
}
- (void)gameARMode{
    myCurrentGameMode = 3;
    NSLog(@"AR模式");
}
- (void)gameRankingMode{
    myCurrentGameMode = 4;
    NSLog(@"排行");
}
- (void)gameSettingMode{
    myCurrentGameMode = 5;
    NSLog(@"设置");
    
    //动作组
    SKAction *tmp1 = [SKAction fadeOutWithDuration:0.05];
    SKAction *tmp2 = [SKAction removeFromParent];;
    SKAction *tmp = [SKAction sequence:@[tmp1,tmp2]];
    
    //清楚界面元素
    [myWorldNode enumerateChildNodesWithName:@"主菜单／经典" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:tmp];
    }];
    [myWorldNode enumerateChildNodesWithName:@"主菜单／训练" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:tmp];
    }];
    [myWorldNode enumerateChildNodesWithName:@"主菜单／疯狂" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:tmp];
    }];
    [myWorldNode enumerateChildNodesWithName:@"主菜单／AR" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:tmp];
    }];
    [myWorldNode enumerateChildNodesWithName:@"主菜单／排行" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:tmp];
    }];
    [myWorldNode enumerateChildNodesWithName:@"主菜单／设置" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:tmp];
    }];
    
    [myWorldNode enumerateChildNodesWithName:@"游戏角色" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:tmp];
    }];
    
    
    //设置 设置界面的UI
    [self mySetSetting];
    
}

#pragma mark 更新的相关方法

-(void)update:(CFTimeInterval)currentTime {
    myCurrentTime = currentTime;//给updateScore用
    // Called before each frame is rendered
    if (myLastUpdateTime > 0) {
        myElapsedTime = currentTime - myLastUpdateTime;
    } else {
        myElapsedTime = 0;
    }
    myLastUpdateTime = currentTime;
    
    switch (myCurrentGameState) {
        case 0:                 //myMainMenu
            
            break;
        case 1:                 //myTutorial
            
            break;
        case 2:                 //myGame
            [self myUpdateGameCharacter];
            [self myUpdateFrontGround];
            [self myHitObstacleCheck];
            [self myHitFrontGroundCheck];
            [self myUpdateScore];
            break;
        case 3:                 //myFall
            [self myUpdateGameCharacter];
            [self myHitFrontGroundCheck];
            break;
        case 4:                 //myDisplayScore
            break;
        case 5:                 //myEndGame
            break;
            
        default:
            break;
    }
    

}
-(void)myUpdateGameCharacter{
    CGPoint kAcceleratedVelocity = CGPointMake(0, myGravity);
    myVelocity = CGPointMake(myVelocity.x + kAcceleratedVelocity.x * (CGFloat) myElapsedTime, myVelocity.y + kAcceleratedVelocity.y * (CGFloat) myElapsedTime);
    
    myGameCharacter.position = CGPointMake(myGameCharacter.position.x + myVelocity.x * (CGFloat) myElapsedTime, myGameCharacter.position.y + myVelocity.y * (CGFloat) myElapsedTime);
    
    //Ground
    if (myGameCharacter.position.y - myGameCharacter.size.height/2 < myGameStartPoint) {
        myGameCharacter.position = CGPointMake(myGameCharacter.position.x, myGameStartPoint + myGameCharacter.size.height/2);
    }
    
}
-(void)myUpdateFrontGround{
    
    [myWorldNode enumerateChildNodesWithName:@"前地面" usingBlock:^(SKNode *node, BOOL *stop) {
        
        if ([node.name isEqual: @"前地面"]) {
            CGPoint myNewFrontGroundVelocity = CGPointMake(myFrontGroundVelocity, 0);
            node.position = CGPointMake(node.position.x + myNewFrontGroundVelocity.x * (CGFloat)myElapsedTime, node.position.y + myNewFrontGroundVelocity.y * (CGFloat)myElapsedTime);
            if (node.position.x < - myFrontGround.size.width) {
                node.position = CGPointMake(node.position.x + myFrontGround.size.width * myFrontGroundTotal, node.position.y + 0);
            }
            
        }
     
    }];
}
- (void)myHitObstacleCheck{
    if (myHitObstacle == YES) {
        myHitObstacle = NO;
        [self runAction:mySoundWhack];
        //切换到跌落状态
        [self mySwitchToFall];
    
    }
}
- (void)myHitFrontGroundCheck{
    if (myHitFrontGround) {
        myHitFrontGround = NO;
        myVelocity = CGPointZero;
        myGameCharacter.zRotation = DEGREES_TO_RADIANS(-90);
        myGameCharacter.position = CGPointMake(myGameCharacter.position.x, myGameStartPoint + myGameCharacter.size.width/2);
        
        [self runAction:mySoundHitFrontGround];
        [self mySwitchToDisplayScore];
        
    }
}
- (void)myUpdateScore{
    
    [myWorldNode enumerateChildNodesWithName:@"顶部障碍" usingBlock:^(SKNode *node, BOOL *stop) {
        NSString *passObstacle = @"已通过";
        

        if ([[node.userData objectForKey:@"通过与否"] isEqual: passObstacle]) {
            
//            NSLog(@"已经加了分数");
            
        } else if (myGameCharacter.position.x > node.position.x + myObstacle.size.width/2) {
            myCurrentScore ++;
            NSLog(@"分数++");
            myScoreLabelNode.text = [NSString stringWithFormat:@"%d",myCurrentScore];
            [node.userData setValue:passObstacle forKey:@"通过与否"];
            NSLog(@"node.userData:%@", node.userData);
            
            //音效
            [self runAction:mySoundGetPoint];
        }
        
    }];
}

#pragma mark 游戏状态
- (void)mySwitchToMainMenu{
    
    if (myCurrentGameMode == 1) {
        myCurrentGameState = myGame;
        [self mySetBackGround];
        [self mySetFrontGround];
        [self mySetGameCharacter];
        [self mySetGameCharacterHat];
        
    } else{
        myCurrentGameState = myMainMenu;
        [self mySetBackGround];
        [self mySetFrontGround];
        [self mySetGameCharacter];
        [self mySetGameCharacterHat];
        [self mySetMainMenu];
    }
    
    
}
- (void)mySwitchToTutorial{
    myCurrentGameState = myTutorial;
    
    //动作组
    SKAction *tmp1 = [SKAction fadeOutWithDuration:0.05];
    SKAction *tmp2 = [SKAction removeFromParent];;
    SKAction *tmp = [SKAction sequence:@[tmp1,tmp2]];
    
    [myWorldNode enumerateChildNodesWithName:@"主菜单／经典" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:tmp];
    }];
    [myWorldNode enumerateChildNodesWithName:@"主菜单／训练" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:tmp];
    }];
    [myWorldNode enumerateChildNodesWithName:@"主菜单／疯狂" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:tmp];
    }];
    [myWorldNode enumerateChildNodesWithName:@"主菜单／AR" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:tmp];
    }];
    [myWorldNode enumerateChildNodesWithName:@"主菜单／排行" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:tmp];
    }];
    [myWorldNode enumerateChildNodesWithName:@"主菜单／设置" usingBlock:^(SKNode *node, BOOL *stop) {
        [node runAction:tmp];
    }];
    
    
    
    [self mySetScoreLabel];
    [self mySetTutorial];
    
}
- (void)mySwitchToGame{
    myCurrentGameState = myGame;
    [myWorldNode enumerateChildNodesWithName:@"教程" usingBlock:^(SKNode *node, BOOL *stop) {
        SKAction *tmp1 = [SKAction fadeOutWithDuration:0.05];
        SKAction *tmp2 = [SKAction removeFromParent];;
        SKAction *tmp = [SKAction sequence:@[tmp1,tmp2]];
        [node runAction:tmp];
    }];
    [self myInfiniteGenerateObstacle];
    [self myGameCharacterFly];
}
- (void)mySwitchToFall{
    
    myCurrentGameState = myFall;
    SKAction *myWait = [SKAction waitForDuration:0.1];
    SKAction *myFallSequence = [SKAction sequence:@[mySoundFall,myWait]];
    [myGameCharacter runAction:myFallSequence];
    [myGameCharacter removeAllActions];
    //音效
    [self runAction:mySoundFall];
    
    [self myStopGenerateObstacle];
    
//    [self mySwitchToDisplayScore];
    
}
- (void)mySwitchToDisplayScore{
    myCurrentGameState = myDisplayScore;
    [myGameCharacter removeAllActions];
    [self myStopGenerateObstacle];
    [self mySetScorecard];
}
- (void)mySwitchToNewGame{
    //添加音效
    
    //
    GameScene *myNewGame = [[GameScene alloc]initWithSize:self.size];
    SKTransition *mySwitchToNewGameEffects = [SKTransition fadeWithColor:[SKColor blackColor] duration:0.3];
    [self.view presentScene:myNewGame transition:mySwitchToNewGameEffects];
    
}

- (void)mySwitchToEndGame{
    myCurrentGameState = myEndGame;
    
}

#pragma mark 持久化存储
//分数
- (NSInteger)myBest{
    return [NSUserDefaults.standardUserDefaults integerForKey:@"最高分"];
}
- (void)mySetBest:(NSInteger)myBest{
    [NSUserDefaults.standardUserDefaults setInteger:myBest forKey:@"最高分"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

//物体碰撞
- (void)didBeginContact:(SKPhysicsContact *)contact{
    
    SKPhysicsBody *myBeHitObj = [[SKPhysicsBody alloc]init];
    
//    NSLog(@"contact.bodyA.contactTestBitMask:%u",contact.bodyA.contactTestBitMask);
//    NSLog(@"contact.bodyB.contactTestBitMask:%u",contact.bodyB.contactTestBitMask);
//    
//    NSLog(@"contact.bodyA.categoryBitMask:%u",contact.bodyA.categoryBitMask);
//    NSLog(@"contact.bodyB.categoryBitMask:%u",contact.bodyB.categoryBitMask);
    
    if (contact.bodyA.contactTestBitMask == physicsGameCharacter) {
        myBeHitObj =  contact.bodyA;
        
    } else {
        myBeHitObj =  contact.bodyB;
    }
//    NSLog(@"myBeHitObj.categoryBitMask:%u",myBeHitObj.categoryBitMask);
    if (myBeHitObj.categoryBitMask == physicsFrontGround) {
        myHitFrontGround = YES;
        NSLog(@"撞击地面");
    }
    if (myBeHitObj.categoryBitMask == physicsObstacle) {
        myHitObstacle = YES;
        NSLog(@"撞击障碍");
    }

    
}
@end
