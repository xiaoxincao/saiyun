
//
//  VideoViewController.m
//  SaiyunVideo
//
//  Created by cying on 15/11/16.
//  Copyright (c) 2015年 cying. All rights reserved.


#import "VideoViewController.h"
#import "HVWLuckyWheelButton.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"

#import "CircleModel.h"
#import "ChaptersModel.h"
#import "CollectionModel.h"
#import "AnimationView.h"

#import "UIImageView+WebCache.h"
#import "UIImage+wiRoundedRectImage.h"

#import "Chaptertableview.h"
#import "CollectionViewController.h"
#import "WebViewController.h"
#import "Singleton.h"
#import "VideoView.h"
#import "ADView.h"
#import "CircleView.h"
#import "SSVideoPlaySlider.h"

#define WIDTH 150
#define CIRCLECOUNT 8
#define VolumeStep 0.06f
#define BrightnessStep 0.06f
#define kVideoHeight kScreenHeight/3
#define kVideoY kScreenHeight/4
#define kCircleWH kScreenWidth
typedef NS_ENUM(NSInteger, GestureType){
    GestureTypeOfNone = 0,
    GestureTypeOfVolume,
    GestureTypeOfBrightness,
};

@interface VideoViewController ()<UINavigationControllerDelegate
,UIAlertViewDelegate,VideoPlayerDelegate>
{
    AppDelegate * _applegate;
    BOOL _isCollection;       /**< 是否收藏 */
}

@property (nonatomic,strong) SSVideoPlaySlider *slider;
@property (nonatomic,assign) GestureType gestureType;/**< 手势操作类型 */
@property(nonatomic, strong) UIButton *selectedLuckyWheelButton;
@property(nonatomic, strong) CircleView *circleview;
@property(nonatomic, strong) UIView *blackview;
@property(nonatomic, strong) UIView *squareview;//旋转的方形view
@property(nonatomic, strong)UIView *adview;
@property(nonatomic, assign)BOOL hiddecircle;//上下两个view的隐藏
@property(nonatomic, strong)UILabel *subtitlesLabel;
@property(nonatomic, strong)UIButton *rightBtn;
@property(nonatomic, strong)UIImageView *centerimg;
@property(nonatomic, strong)UIButton *AgainwatchBtn;
@property(nonatomic, strong)UIButton *nextclassBtn;
@property(nonatomic, strong)UIButton *TestResultBtn;
@property(nonatomic, strong)UIButton *StarttestBtn;
@property(nonatomic, strong)UIButton *TestAgainBtn;


@property (nonatomic,strong)NSArray *circleArray;//圆盘数据列表返回的数组
@property (nonatomic,strong)NSMutableArray *resultArray;//存放模型的数组
@property (nonatomic,strong)NSMutableArray *valueArray;//存放Value模型的数组
@property (nonatomic,strong)NSMutableArray *circleBtnArray;//存放按钮的名称的数组
@property (nonatomic,strong)NSMutableArray *detailchapterArray;//获取的详细章节数组
@property (nonatomic,strong)NSMutableArray *AllChapterArray;
@property (nonatomic,strong)NSMutableArray *courceTime;//存放课程时间的数组
@property (nonatomic,strong)NSMutableArray *collectionarray;


@property (nonatomic,strong)CircleModel *circlemodel;
@property (nonatomic,strong)Chaptertableview *chaptertableview;
@property (nonatomic,strong)HVWLuckyWheelButton *circleBtn;
@property (nonatomic,strong)UILabel *circleLabel;
@property (nonatomic,strong)NSMutableArray *subtitlesarray;
@property (nonatomic,strong)NSMutableArray *begintimearray;
@property (nonatomic,strong)NSMutableArray *endtimearray;
@property (nonatomic,strong)NSString *courceid;
@property (nonatomic,strong)NSString *courcewareid;
@property (nonatomic, strong)MBProgressHUD *hud;
@property (nonatomic, strong)MBProgressHUD *mbhud;
//标识
@property (nonatomic,strong)NSString *isPass;
@property (nonatomic,assign)NSInteger isTest;
@property (nonatomic,assign)BOOL first;
@property (nonatomic,assign)BOOL on;
@property (nonatomic,assign)BOOL isnotice;
@property (nonatomic,assign)int isplaying;
@property (nonatomic,assign)BOOL isOther;
@property (nonatomic,assign)BOOL nextclass;


@end

@implementation VideoViewController

singleton_implementation(VideoViewController)


- (NSArray *)detailArr
{
    if (nil == self.detailchapterArray) {
        
        self.detailchapterArray = [NSMutableArray array];
    }
    
    return self.detailchapterArray;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear！");
    [self.player playInContainer:self.videoview];
    
    
    self.isOther = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.delegate = self;
    self.first = NO;
    
    
    //如果收藏列表加载是成功的则走下面的步骤
    [[NetworkSingleton sharedManager]getResultWithParameter:nil url:MyCollection_List successBlock:^(id responseBody) {
        //每次页面出现都加载圆环按钮数据和加载圆环
        [self loadDataWithCompletionHandle:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self drawMyLayer];
                //NSLog(@"界面出现时调用隐藏圆环");
                [self performSelector:@selector(HiddenCircle:) withObject:nil afterDelay:3];
            });
        }];
        
    } failureBlock:^(NSString *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.hud.hidden = YES;
        [[Tool SharedInstance]showtoast:@"请稍后再试"];
    }];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //只有此界面可以侧滑
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ISNOTICE"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    BOOL isWillLogin = [[NSUserDefaults standardUserDefaults]boolForKey:@"ISNOLOGIN"];
    //如果取出来为yes ，没登陆的状态
    if (isWillLogin) {
        //改为no，为登录状态
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ISNOLOGIN"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        [self.player pause];
        NSLog(@"输出1");
    }
    //如果为no，登录的状态
    else{
        NSLog(@"输出2");
         [self.player pause];
        //[self.player replaceCurrentItemWithPlayerItem:nil];
        self.player = nil;
        
        if (self.timer) {
            [self.timer invalidate];
        }
        if (self.hiddentimer) {
            [self.hiddentimer invalidate];
        }
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        BOOL loginsuccess = [userdefault boolForKey:LogSuccess];
        
        if (loginsuccess) {
            //界面消失时上传播放信息
            NSInteger playtime = CMTimeGetSeconds(self.player.playerItem.currentTime);
            NSInteger totaltime = CMTimeGetSeconds(self.player.playerItem.duration);
            NSString *playtimestr = [NSString stringWithFormat:@"%ld",(long)playtime];
            NSString *totaltimestr = [NSString stringWithFormat:@"%ld",(long)totaltime];
            //播放时间是秒
            //判断有视频播放时再上传
            if (![playtimestr isEqualToString:@"0"]&&playtimestr != nil) {
                if (self.courcewareid != nil) {
                    NSDictionary *dict = @{@"coursewareId":self.courcewareid,@"studyTime":playtimestr,@"totalTime":totaltimestr};
                    
                    [self poststudyTimeDict:dict Url:String_Save_Video_Exit_Info];
                    
                }else
                {
                    NSDictionary *dict = @{@"coursewareId":self.valuemodel.id,@"studyTime":playtimestr,@"totalTime":totaltimestr};
                    [self poststudyTimeDict:dict Url:String_Save_Video_Exit_Info];
                }
            }
        }
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NetworkViaWWAN object:nil];
    //界面消失时移除对视频的监听
    //[self removeOBserverFromPlayer:self.player];
    NSLog(@"viewWillDisappear");
    self.isOther = YES;
     //[self.player pause];
    //取消，释放未请求完成的视频对象
//    [self.player.currentItem cancelPendingSeeks];
//    [self.player.currentItem.asset cancelLoading];
    
     self.videoview.subtitlelabel.text = nil;
    [self.view removeFromSuperview];
    self.view = nil;
}


#pragma mark-
#pragma mark------------------三个通知-------------------------
#pragma mark-更新收藏列表传过来的数据通知
- (void)updatecollectiondata:(NSNotification *)dict
{
    NSDictionary *mdict = [dict userInfo];
    //NSLog(@"收藏传过来的--%@",mdict);
    _vamodel = [ValueModel mj_objectWithKeyValues:mdict];
    self.courceid = _vamodel.courseId;
}

#pragma mark-我的足迹中章节列表的通知
- (void)TraceNotice:(NSNotification *)dict
{
    NSDictionary *mdict = [dict userInfo];
    [self chaptercommonnotice:mdict];
}

#pragma mark-章节列表的点击通知
- (void)ChapterNotifition:(NSNotification *)dict
{
    //如果为黑色才可以点击，为灰色输出提示信息
    self.chaptertableview.hidden = YES;
    NSDictionary *mdict = [dict userInfo];
    [self chaptercommonnotice:mdict];
}

//章节列表和我的足迹中的章节列表共同接收通知执行的方法
- (void)chaptercommonnotice:(NSDictionary *)dict
{
    _vamodel = [ValueModel mj_objectWithKeyValues:dict];
    self.courceid = _vamodel.courseId;
    //播放视频
    NSString *appendstr = [Video_Path stringByAppendingString:_vamodel.fullFilePath];
    NSString *appendstr2 = [appendstr stringByAppendingString:@".m3u8"];
    NSString *vt = [Subtitle_Path stringByAppendingString:_vamodel.videoName];
    NSString *vtt = [vt stringByAppendingString:@".vtt"];
    [self setVideo:appendstr2];
    [self setSubstitle:vtt];
    //储存当前播放信息
    [[NSUserDefaults standardUserDefaults]setObject:appendstr2 forKey:Videourl];
    [[NSUserDefaults standardUserDefaults]setObject:_vamodel.courseName forKey:CourName];
    [[NSUserDefaults standardUserDefaults]setObject:_vamodel.name forKey:ChapterName];
    [[NSUserDefaults standardUserDefaults]setObject:_vamodel.teacherName forKey:TeachName];
    [[NSUserDefaults standardUserDefaults]setObject:_vamodel.preWareId forKey:Prewareid];
    [[NSUserDefaults standardUserDefaults]setObject:_vamodel.nextWareId forKey:Nextwareid];
    [[NSUserDefaults standardUserDefaults]synchronize];

    for (int i = 0; i<self.circleBtnArray.count; i++) {
        NSString *str = [NSString stringWithFormat:@"第%d章",i+1];
        NSString *str1 = [str stringByAppendingString:self.circleBtnArray[i] ];
        if( [self.circleBtnArray[i] isEqualToString:_vamodel.courseName]){
            self.CircleClassifyLabel.text = str1;
        }
    }
    NSString *chaptername = [_vamodel.sequence stringByAppendingString:@"-"];
    NSString *chapername = [chaptername stringByAppendingString:_vamodel.name];

    dispatch_async(dispatch_get_main_queue(), ^{
        //更新三个label
        //1.圆盘分类的名字2.章节名字3.老师简介
        self.ChapterNameLabel.text = chapername;
    });
}


#pragma mark-
#pragma mark-ViewDidload
- (void)viewDidLoad {
    NSLog(@"VIEWdidload");
    [super viewDidLoad];
    //页面加载时判断是否已经登录，没登陆跳到登录页面
    LogInViewController *log = [[LogInViewController alloc]init];
    if(![[NSUserDefaults standardUserDefaults]boolForKey:LogSuccess]){
        [self presentViewController:log animated:YES completion:nil];
    }
    //章节点击的通知接收
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(ChapterNotifition:) name:@"ChapterNotice"  object:nil];
    //收藏传过来的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updatecollectiondata:) name:@"UpdateColloctionData" object:nil];
    //足迹列表
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(TraceNotice:) name:@"TraceNotice" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Alert) name: NetworkViaWWAN object:nil];
    
    
    _applegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //打开用户交互
    self.BGimageView.userInteractionEnabled = YES;
    self.videoview.userInteractionEnabled = YES;
    
    //设置导航栏
    [self setVideoNavigation];
    //初始化VideoView
    [self setVideoViewFrame];
    [self setadview];
    //初始化进度条的UI
    //[self initProgressUI];
    //点击屏幕显示圆环
    [self Gesture];
    
    [self creatchaptertableview];
    
    [self createprogress];
    //每次进入此页面都将isnotice字段赋值为no
    self.isnotice = NO;
    
    [self.playproperty setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self.playproperty setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
}

#pragma mark -
#pragma mark 设置导航栏
- (void)setVideoNavigation
{
    self.navigationController.navigationBar.translucent  =  NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"mainbg"]forBarMetrics:UIBarMetricsDefault];
    
    //侧栏按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"Menuicons@3x"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(clickleftButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    //收藏按钮
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nocollect@3x"] forState:UIControlStateNormal];
    self.rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [self.rightBtn addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rigthitem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rigthitem;
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}

#pragma mark-开启侧栏按钮
- (void)clickleftButton
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark-收藏的方法
- (void)collection:(UIButton *)rightButton
{
    rightButton.selected = YES;
    //如果被收藏了，则发起网络请求，并改变收藏按钮样式
    
    //_isCollection = !_isCollection;
    
    if (_isCollection) {
        NSDictionary *dict = @{@"courseId":self.courceid};
        [[NetworkSingleton sharedManager]postResultWithParameter:dict url:Save_MyCourse successBlock:^(id responseBody) {
            NSLog(@"收藏成功--%@",responseBody[@"result"]);
            [[Tool SharedInstance]showtoast:responseBody[@"result"]];
            [rightButton setBackgroundImage:[UIImage imageNamed:@"collect@3x"] forState:UIControlStateSelected];
        } failureBlock:^(NSString *error) {
            //未登录时点击收藏跳到登录界面
            [[Tool SharedInstance]showtoast:@"收藏失败，亲可能未登录噢~"];
            NSLog(@"收藏失败");
        }];
    }
    else
    {
        [[Tool SharedInstance]showtoast:@"当前课程已被收藏"];
        return;
    }
    _isCollection = !_isCollection;
    
}

//切换视频判断当前课程是否包含在收藏列表里，改变按钮样式
- (void)loadCollectionDataWithCompletionHandle:(NSString *)currentbtntitle
{
    self.collectionarray = [NSMutableArray array];
    [[NetworkSingleton sharedManager]getResultWithParameter:nil url:MyCollection_List successBlock:^(id responseBody) {
        NSMutableArray *resultarr = [responseBody objectForKey:@"result"];
        if ([responseBody[@"success"] isEqual:@1]) {
            for (int i = 0; i<resultarr.count; i++) {
                NSDictionary *dict = resultarr[i];
                CollectionModel *collection = [CollectionModel mj_objectWithKeyValues:dict];
                //判断收藏列表模型数组里是否包含当前的按钮标题
                [self.collectionarray addObject:collection.courseName];
                if ([self.collectionarray containsObject:currentbtntitle])
                {
                    _isCollection = NO;
                    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"collect@3x"] forState:UIControlStateNormal];
                }else
                {
                    _isCollection = YES;
                    self.rightBtn.selected = NO;
                    //NSLog(@"当前课程不在收藏列表里");
                    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nocollect@3x"] forState:UIControlStateNormal];
                }
            }
            if (resultarr.count == 0) {
                //[[Tool SharedInstance]showtoast:@"暂无收藏课程"];
                _isCollection = YES;
                self.rightBtn.selected = NO;
                //NSLog(@"当前课程不在收藏列表里");
                [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nocollect@3x"] forState:UIControlStateNormal];
            }
        }
        else
        {
            [[Tool SharedInstance]showtoast:responseBody[@"result"]];
        }
    } failureBlock:^(NSString *error) {
        NSLog(@"收藏errors--%@",error);
    }];
}


#pragma mark-
#pragma mark---- 初始化videoframe
- (void)setVideoViewFrame{
    
    CGFloat X = 0;
    CGFloat Y = kVideoY;
    CGFloat Width = kScreenWidth;
    CGFloat Height = kVideoHeight;
    self.BGimageView.backgroundColor = [UIColor blackColor];
    self.BGimageView.contentMode = UIViewContentModeScaleAspectFill;
    self.videoview = [[VideoView alloc]initWithFrame:CGRectMake(X, Y, Width, Height)];
    [self.BGimageView addSubview:self.videoview];
}

#pragma mark----初始化video下面的view
- (void)setadview
{
    CGFloat X = 0;
    CGFloat Y = kVideoY;
    CGFloat Width = kScreenWidth;
    CGFloat Height = 40;
    //透明度0.5的黑色view
    self.adview = [[UIView alloc]initWithFrame:CGRectMake(X, (Y+kVideoHeight), Width, Height)];
    self.adview.backgroundColor = [UIColor grayColor];
    self.adview.alpha = 0.5;
    //clear色的view后添加,上面放的控件
    self.clearview = [[ADView alloc]initWithFrame:CGRectMake(X, (Y+kVideoHeight), Width, Height)];
    [self.clearview enterbtnaddTarget:self action:@selector(enterbtn) forControlEvents:UIControlEventTouchUpInside];
    [self.clearview exitbtnaddTarget:self action:@selector(hiddeview) forControlEvents:UIControlEventTouchUpInside];
    [_BGimageView addSubview:self.adview];
    [_BGimageView addSubview:self.clearview];
}

#pragma mark----初始化章节tableview
- (void)creatchaptertableview
{
    self.chaptertableview = [[Chaptertableview alloc]init];
    [self.view addSubview:self.chaptertableview];
    
    [self.chaptertableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //上，左，下，右
        make.right.offset(-20);
        make.left.offset(20);
        make.bottom.offset(-53);
        make.height.offset(150);
    }];
    self.chaptertableview.hidden = YES;
}

- (void)enterbtn
{
    WebViewController *web = [[WebViewController alloc]init];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)hiddeview
{
    self.adview.hidden = YES;
    self.clearview.hidden = YES;
}

#pragma mark -
#pragma mark -运营商网下发出的通知方法
- (void)Alert{
    //当开关没打开时弹框，打开时不执行操作
    self.on = [[NSUserDefaults standardUserDefaults]boolForKey:ON];
    if (!self.on) {
        UIAlertView *setinter = [[UIAlertView alloc]initWithTitle:@"亲，非wifi条件下播放视频很费流量喔~" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"去设置", @"只在WI-FI下播放",nil];
        [setinter show];
    }else
    {
        
    }
}

#pragma mark -AlertView的点击事件跳到设置开启开关
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            SettingTableViewController *setvc = [[SettingTableViewController alloc]init];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"set"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.navigationController pushViewController:setvc animated:YES];
        }
            break;
        case 1:
        {
            //如果选择了只在wifi播放就隐藏了加载视频的提示框
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"onlywifi"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark ---- 圆环控件的创建
- (void)drawMyLayer
{
    //黑色阴影view
    _blackview = [[UIView alloc]initWithFrame:CGRectMake(0, kVideoY-50,kCircleWH , kCircleWH)];
    _blackview.backgroundColor = [UIColor blackColor];
    _blackview.alpha = 0.5;
    _blackview.layer.cornerRadius = kCircleWH/2;
    
    //clear颜色的view
    _circleview = [[CircleView alloc]initWithFrame:CGRectMake(0, kVideoY-50,kCircleWH , kCircleWH)];
    _circleview.backgroundColor = [UIColor clearColor];
    _circleview.layer.cornerRadius = kCircleWH/2;
    
    _circleview.center = self.videoview.center;
    _blackview.center = self.videoview.center;
    _BGimageView.userInteractionEnabled = YES;
    _circleview.userInteractionEnabled = YES;//用户交互设置为YES
    
    [self creatBtn:_circleBtnArray];
    
    //圆盘添加到视频播放器上
    [_BGimageView addSubview:_blackview];
    [_BGimageView addSubview:_circleview];
}

- (void)creatBtn:(NSMutableArray *)array
{
    for (NSInteger i = 0; i<array.count; i++) {
        //旋转的view
        _squareview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, kCircleWH/2-8)];
        _squareview.layer.anchorPoint = CGPointMake(0.5, 1);
        _squareview.layer.position = CGPointMake(kCircleWH/2, kCircleWH/2);
        _squareview.transform = CGAffineTransformMakeRotation(M_PI*2*i/array.count);
        
        //按钮
        self.circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.circleBtn.frame = CGRectMake(0, 0, 120, 25);
        [self.circleBtn setTitle:array[i] forState:UIControlStateNormal];
        self.circleBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.f];
        [self.circleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.circleBtn setTitleColor:NavColor forState:UIControlStateSelected];
        [self.circleBtn addTarget:self action:@selector(conButtonClicked:) forControlEvents:UIControlEventTouchDown];
        //如果按钮的标题跟当前播放的视频名称一样，则将这个按钮设为被点击状态
        //如果当前没播放视频则默认点击第一个按钮播放视频
        if (_vamodel.courseName == nil)
        {
            NSLog(@"传值coursename为空");
            //如果点击是下一课件则不执行操作
            //NSLog(@"eniyo---%hhd",self.nextclass);
            if (self.nextclass == NO) {
                //如果没有上一次的记录则默认第一个按钮被点击
                if (0 == i) {
                    [self conButtonClicked:self.circleBtn];
                }
            }
            else {
                self.nextclass = NO;
            }
        }else if([_vamodel.courseName isEqualToString:self.circleBtn.titleLabel.text])
        {
            NSLog(@"收藏足迹模型传值了");
            [self conButtonClicked:self.circleBtn];
        }
        else
        {
            NSLog(@"圆环不隐藏的情况？？？？？");
        }
        //如果点击下一课件！（）
        
        //按钮点击事件
        self.circleBtn.tag = i;
        // 默认选中第一个按钮
        //按钮添加到旋转的view上
        [_squareview addSubview:self.circleBtn];
        //旋转的view添加到圆盘上
        [_circleview addSubview:_squareview];
    }
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"nextclass"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark---- 添加点击显示圆环的手势
- (void)Gesture{
    [self.videoview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showcircleview:)]];
}

#pragma mark---- 显示圆环
- (void)showcircleview:(UITapGestureRecognizer *)sender{

    self.circleview.hidden = NO;
    self.blackview.hidden = NO;
    
    [self performSelector:@selector(HiddenCircle:) withObject:nil afterDelay:3];
}

#pragma mark---- 隐藏圆环
- (void)HiddenCircle:(NSTimer *)sender{
    [self.hiddentimer invalidate];
    self.circleview.hidden = YES;
    self.blackview.hidden = YES;
    NSLog(@"隐藏！！！！！！！！！！！！！！！！！！！");
}


#pragma mark-
#pragma mark---------------圆盘按钮的点击事件
- (void)conButtonClicked:(HVWLuckyWheelButton *) button {
    //NSLog(@"执行");
    NSLog(@"tag-----%ld",(long)button.tag);
    //1.先将之前选中的按钮设置为未选中
    self.selectedLuckyWheelButton.selected = NO;
    //2.再将当前按钮设置为选中
    button.selected = YES;
    //3.最后把当前按钮赋值为之前选中的按钮
    self.selectedLuckyWheelButton = button;
    self.circleBtn = button;
    [self ClickBtn:self.resultArray andBtn:button];
}

- (void)ClickBtn:(NSMutableArray *)array andBtn:(UIButton *)button
{
    [self loadCollectionDataWithCompletionHandle:button.currentTitle];
    
    
    for (ValueModel *model in array)
    {
        //如果当前播放的课程名字和被点击按钮不同的话，
        //执行点击按钮播放第一个视频的方法，
        //调节从其他页面跳转回来，切换圆环按钮不反应的bug
        NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"CName"];
        if (![str isEqual:button.currentTitle]) {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ISNOTICE"];
        }
        
        
        
        if ([model.name isEqualToString:button.currentTitle]) {
            self.isnotice = [[NSUserDefaults standardUserDefaults]boolForKey:@"ISNOTICE"];
            for (int i = 0; i<self.circleBtnArray.count; i++) {
                NSString *str = [NSString stringWithFormat:@"第%d章",i+1];
                NSString *str1 = [str stringByAppendingString:self.circleBtnArray[i]];
                if( [self.circleBtnArray[i] isEqualToString:model.name]){
                    self.CircleClassifyLabel.text = str1;
                }
            }
            //如果不是别的界面过来的执行下面，
            if (self.isnotice == 0) {
                //更新三个label
                self.TeacherDetailLabel.text = model.teacherName;
                //更新中间圆环图片
                NSString *str = model.imagePath;
                NSMutableString *str1 = [NSMutableString stringWithString:str];
                NSString *str2 = [Port stringByAppendingString:str1];
                NSURL *url = [NSURL URLWithString:str2];
                self.circleview.centerimg.layer.cornerRadius = (kCircleWH-60)/2;
                self.circleview.centerimg.layer.masksToBounds=YES;
                [self.circleview.centerimg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"yun"]];
            }
            self.courceid = model.id;
            self.courcewareid = model.coursewareId;
            NSLog(@"章节id---%@",model.coursewareId);
            //如果传章节id过来，则播放对应的章节视频，没有章节id则播放第一个视频
            if(model.coursewareId != nil){
                
            [self loadplayinfo:model.coursewareId];
                
            }else
            {
                //如果没有课程id时，执行此方法，才会给self.valuemodel赋值
                [self loadCapter:self.courceid];
            }            
        }
    }
}
//这里给self.valuemodel赋值的
- (void)ChangeVideo
{
    //点击圆盘按钮时默认播放第一个视频
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    BOOL loginsuccess = [userdefault boolForKey:LogSuccess];
    if (loginsuccess) {
        //first = no如果不是第一次播放的话就上传播放信息
        if (self.first) {
            
            NSInteger playtime = CMTimeGetSeconds(self.player.playerItem.currentTime);
            NSInteger totaltime = CMTimeGetSeconds(self.player.playerItem.duration);
            NSString *playtimestr = [NSString stringWithFormat:@"%ld",(long)playtime];
            NSString *totaltimestr = [NSString stringWithFormat:@"%ld",(long)totaltime];
            if (![playtimestr isEqualToString:@"0"]&&playtimestr != nil){
            //播放时间是秒
            NSDictionary *dict = @{@"coursewareId":self.valuemodel.id,@"studyTime":playtimestr,@"totalTime":totaltimestr};
            [self poststudyTimeDict:dict Url:String_Save_Video_Exit_Info];
             
        }
        }
        self.first = YES;
    }
    
    self.valuemodel = [ValueModel mj_objectWithKeyValues:self.valueArray[0]];
    //取出本地存的isnotice
    self.isnotice = [[NSUserDefaults standardUserDefaults]boolForKey:@"ISNOTICE"];
    //当isnotice字段为no时，执行播放第一个视频的方法，不是从其他界面点击过来的
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isnotice == 0) {
            NSLog(@"执行播放第一个视频方法---%@",self.valuemodel.id);
            [[NSUserDefaults standardUserDefaults]setObject:self.valuemodel.id forKey:@"valuemodelid"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self loadplayinfo:self.valuemodel.id];
        }
    });
     
}

- (void)loadCapter:(NSString *)mycourseid
{
    //根据id加载章节列表取出来第一个课程
    NSString *chapterstr = [NSString stringWithFormat:Video_Chapter_List,mycourseid];
    [[NetworkSingleton sharedManager]postResultWithParameter:nil url:chapterstr successBlock:^(id responseBody) {
        self.detailchapterArray = [responseBody objectForKey:@"result"];
        if (self.detailchapterArray) {
            for (NSDictionary *dict in self.detailchapterArray){
                self.valueArray = [NSMutableArray array];
                ChaptersModel *chaptermodel = [ChaptersModel mj_objectWithKeyValues:dict];
                self.valueArray = (NSMutableArray *)chaptermodel.value;
            }
            //播放默认的第一个视频
            [self ChangeVideo];
        }
    } failureBlock:^(NSString *error) {
    }];
    
}

#pragma mark-
#pragma mark----加载圆环的按钮数据
- (void)loadDataWithCompletionHandle:(void (^)( ))successBlock
{
    [[NetworkSingleton sharedManager]postResultWithParameter:nil url:Course_List successBlock:^(id responseBody) {
        _circleArray = [responseBody objectForKey:@"result"];
        //存放全部数据模型的数组
        self.resultArray = [NSMutableArray array];
        //存放圆环按钮圆环按钮name的模型数组
        self.circleBtnArray = [NSMutableArray array];
        for (int i = 0; i<self.circleArray.count; i++) {
            NSDictionary *dict = self.circleArray[i];
            self.vvmodel = [ValueModel mj_objectWithKeyValues:dict];
            [self.resultArray addObject:self.vvmodel];
            [self.circleBtnArray addObject:self.vvmodel.name];
        }
        if (successBlock) {
            successBlock();
        }
    } failureBlock:^(NSString *error) {
        [[Tool SharedInstance]showtoast:@"圆环：与服务器失去连接"];
    }];
}

#pragma mark---- 加载章节信息
- (void)loadChapterDataWithCompletionHandle:(NSString *)mycourseid{
    NSString *chapterstr = [NSString stringWithFormat:Video_Chapter_List,mycourseid];
    [[NetworkSingleton sharedManager]postResultWithParameter:nil url:chapterstr successBlock:^(id responseBody) {
        self.detailchapterArray = [responseBody objectForKey:@"result"];
        if (self.detailchapterArray) {
            //存放value数据的模型数组
            for (NSDictionary *dict in self.detailchapterArray)
            {
                self.valueArray = [NSMutableArray array];
                self.AllChapterArray = [[NSMutableArray alloc]init];
                ChaptersModel *chaptermodel = [ChaptersModel mj_objectWithKeyValues:dict];
                self.valueArray = (NSMutableArray *)chaptermodel.value;
                NSMutableArray *array = [NSMutableArray array];
                for (int j = 0; j<self.valueArray.count; j++) {
                    NSDictionary *dict = self.valueArray[j];
                    ValueModel *valuemodel = [ValueModel mj_objectWithKeyValues:dict];
                    [array addObject:valuemodel];
                }
                chaptermodel.value = array;
                [self.AllChapterArray addObject:chaptermodel];
            }
            //初始化一个章节列表tableview
            //[self creatchaptertableview];
            
            //传courseid参数过去，
            self.chaptertableview.courseId = self.courceid;
            //章节的信息数组传过去
            self.chaptertableview.dataarray = self.AllChapterArray;
            //刷新章节table
            [self.chaptertableview reloadData];
        }
        else{
            NSLog(@"加载章节列表失败");
        }
    } failureBlock:^(NSString *error) {
    }];
}
- (void)loadplayinfo:(NSString *)coursewarrid
{
    NSString *appendstr = [NSString stringWithFormat:Video_Chapter_Play,self.courceid,coursewarrid];
    [self PLayVideoInfo:appendstr];
}

- (void)PLayVideoInfo:(NSString *)appendstr
{
    [[NetworkSingleton sharedManager]postResultWithParameter:nil url:appendstr successBlock:^(id responseBody) {
        NSDictionary *dict = responseBody[@"result"];
        //NSLog(@"有没有——--%@",dict);
        ValueModel *valuemodel = [ValueModel mj_objectWithKeyValues:dict];
        
        if (valuemodel.fullFilePath) {
            //播放视频
            NSString *appendstr = [Video_Path stringByAppendingString:valuemodel.fullFilePath];
            NSString *appendstr2 = [appendstr stringByAppendingString:@".m3u8"];
            NSString *vt = [Subtitle_Path stringByAppendingString:valuemodel.videoName];
            NSString *vtt = [vt stringByAppendingString:@".vtt"];
            NSLog(@"2222222222视频url----%@",appendstr2);
            [self setVideo:appendstr2];
            [self setSubstitle:vtt];
            
            
            //储存当前播放信息
            [[NSUserDefaults standardUserDefaults]setObject:appendstr2 forKey:Videourl];
            [[NSUserDefaults standardUserDefaults]setObject:valuemodel.courseName forKey:CourName];
            [[NSUserDefaults standardUserDefaults]setObject:valuemodel.name forKey:ChapterName];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:valuemodel.preWareId forKey:Prewareid];
            [[NSUserDefaults standardUserDefaults]setObject:valuemodel.nextWareId forKey:Nextwareid];
            [[NSUserDefaults standardUserDefaults]setObject:_valuemodel.courseName forKey:@"CName"];
            for (int i = 0; i<self.circleBtnArray.count; i++) {
                NSString *str = [NSString stringWithFormat:@"第%d章",i+1];
                NSString *str1 = [str stringByAppendingString:self.circleBtnArray[i] ];
                
                if( [self.circleBtnArray[i] isEqualToString:valuemodel.courseName]){
                    self.CircleClassifyLabel.text = str1;
                }
            }
            NSString *chaptername = [valuemodel.sequence stringByAppendingString:@"-"];
            NSString *chapername = [chaptername stringByAppendingString:valuemodel.name];
            dispatch_async(dispatch_get_main_queue(), ^{
                //1.圆盘分类的名字2.章节名字3.老师简介
                self.ChapterNameLabel.text = chapername;
            });
        }
        else{
            [[Tool SharedInstance]showtoast:dict[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
    
}
#pragma mark----上传播放时间的代码
- (void)poststudyTimeDict:(NSDictionary *)dict Url:(NSString *)urlstr
{
    [[NetworkSingleton sharedManager]getResultWithParameter:dict url:urlstr successBlock:^(id responseBody) {
        NSLog(@"上传播放时间成功---%@--%@",responseBody[@"result" ],responseBody[@"msg"]);
    } failureBlock:^(NSString *error) {
        NSLog(@"上传播放时间失败");
    }];
}

#pragma mark-
#pragma mark---------------以下全是播放器的代码
#pragma mark--传url播放视频之前判断网络状况
- (void)setVideo:(NSString *)videoStr{
    BOOL is4g = [[NSUserDefaults standardUserDefaults]boolForKey:Flow];
    if (is4g) {
        self.on = [[NSUserDefaults standardUserDefaults]boolForKey:ON];
        if (!self.on) {
            [[Tool SharedInstance]showtoast:@"数据流量下打开设置里的开关方可播放视频喔"];

            NSLog(@"开关没开");
        }
        else
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self playVideoWithPath:videoStr];
        }
    }else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self playVideoWithPath:videoStr];
    }
}


- (VideoPlayer *)player
{
    if (_player == nil) {
        _player = [[VideoPlayer alloc]init];
        _player.delegate = self;
    }
    return  _player;
}


//传urlstr
- (void)playVideoWithPath:(NSString *)path
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.player.path = path;
    });
    __weak VideoViewController *weakSelf = self;
    _player.bufferProgressBlock = ^(float f) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.slider.bufferValue = f;
        });
    };
    _player.progressBlock = ^(float f) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!weakSelf.slider.slide) {
                weakSelf.slider.value = f;
            }
        });
    };
    
}

#pragma mark - VideoPlayerDelegate
//监听toplay时 ，准备播放视频
- (void)videoPlayerDidReadyPlay:(VideoPlayer *)videoPlayer {
    [self.player play];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.playproperty.selected = NO;
}

- (void)videoPlayerDidBeginPlay:(VideoPlayer *)videoPlayer {
    self.playproperty.selected = NO;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)videoPlayerDidEndPlay:(VideoPlayer *)videoPlayer {
    self.playproperty.selected = YES;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)videoPlayerDidSwitchPlay:(VideoPlayer *)videoPlayer {
    
}

- (void)videoPlayerDidFailedPlay:(VideoPlayer *)videoPlayer {
    
    [[[UIAlertView alloc]initWithTitle:@"该视频无法播放" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
#pragma mark - 创建进度条
- (void)createprogress
{
    self.slider = [[SSVideoPlaySlider alloc]initWithFrame:CGRectMake(50, 8, [UIScreen mainScreen].bounds.size.width-120, 20)];
    self.slider.thumbImage = [UIImage imageNamed:@"player_slider"];
    [self.slider addTarget:self action:@selector(playProgressChange:) forControlEvents:UIControlEventValueChanged];
    [self.progressSliderView addSubview:self.slider];
    
}
#pragma mark - 进度条的方法
- (void)playProgressChange:(SSVideoPlaySlider *)slider {
    [self.player moveTo:slider.value];
    if (!self.playproperty.selected) {
        [self.player play];
    }
}

#pragma mark----设置字幕数组
- (void)setSubstitle:(NSString *)vttstr
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:vttstr]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            // GBK编码
            //NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            // 解码
            NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            //按行分割存放到数组中
            NSArray *singlearray = [string componentsSeparatedByString:@"\n"];
            
            
            _subtitlesarray = [NSMutableArray array];
            _begintimearray = [NSMutableArray array];
            _endtimearray = [NSMutableArray array];
            
            //遍历存放所有行的数组
            for (NSString *ss in singlearray) {
                
                //NSRange range = [ss rangeOfString:@"{\\a3}"];
                
                NSRange range2 = [ss rangeOfString:@" --> "];
                
                if (range2.location != NSNotFound) {
                    
                    NSString *beginstr = [ss substringToIndex:range2.location];
                    NSString *endstr = [ss substringFromIndex:range2.location+range2.length];
                    
                    NSArray * arr = [beginstr componentsSeparatedByString:@":"];
                    NSArray * arr1 = [arr[2] componentsSeparatedByString:@","];
                    
                    //将开始时间数组中的时间换化成秒为单位的
                    float teim=[arr[0] floatValue] * 60*60 + [arr[1] floatValue]*60 + [arr1[0] floatValue] + [arr1[1] floatValue]/1000;
                    //将float类型转化成NSNumber类型才能存入数组
                    NSNumber *beginnum = [NSNumber numberWithFloat:teim];
                    [_begintimearray addObject:beginnum];
                    
                    NSArray * array = [endstr componentsSeparatedByString:@":"];
                    NSArray * arr2 = [array[2] componentsSeparatedByString:@","];
                    
                    //将结束时间数组中的时间换化成秒为单位的
                    float fl=[array[0] floatValue] * 60*60 + [array[1] floatValue]*60 + [arr2[0] floatValue] + [arr2[1] floatValue]/1000;
                    NSNumber *endnum = [NSNumber numberWithFloat:fl];
                    [_endtimearray addObject:endnum];
                }
            }
            for (int i = 0; i<singlearray.count; i++) {
                if (i != 0) {
                    if(4*i<singlearray.count){
                        [_subtitlesarray addObject:singlearray[4*i]];
                    }
                }else{
                    
                }
            }
        }else{
            NSLog(@"error  is  %@",error.localizedDescription);
        }
    }];
    [dataTask resume];
}


#pragma mark --播放结束的方法
- (void)playbackFinished
{
    //播放结束时进入下一个课程
    NSLog(@"视频播放完成");
    self.subtitlesLabel.text = nil;
    [[Tool SharedInstance]showtoast:@"正在跳转下一个课程，请耐心等待喔~"];
    NSInteger playtime = CMTimeGetSeconds(self.player.playerItem.currentTime);
    NSString *playtimestr = [NSString stringWithFormat:@"%ld",(long)playtime];
    NSString *totalstr = [[NSUserDefaults standardUserDefaults]objectForKey:TotalTime];
    if (self.courcewareid != nil) {
        NSDictionary *dict = @{@"coursewareId":self.courcewareid,@"studyTime":playtimestr,@"totalTime":totalstr};
        
        [self poststudyTimeDict:dict Url:String_Save_Video_Exit_Info];
        
    }else
    {
        NSDictionary *dict = @{@"coursewareId":self.valuemodel.id,@"studyTime":playtimestr,@"totalTime":totalstr};
        
        [self poststudyTimeDict:dict Url:String_Save_Video_Exit_Info];
        
    }
    
    [self performSelector:@selector(loadnextvideo) withObject:nil afterDelay:0.5];
    
}

#pragma mark --加载下一课程
- (void)loadnextvideo
{
    NSString *nextid = [[NSUserDefaults standardUserDefaults]objectForKey:Nextwareid];
    NSLog(@"下一视频课件--%@",nextid);
    if (![nextid isEqualToString:@"0"]) {
        self.subtitlesLabel.text = nil;
        [self performSelector:@selector(loadnextplay) withObject:nil afterDelay:5];
    }else
    {
        [[Tool SharedInstance]showtoast:@"亲，这已经是最后一章节了哟~"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
    
}


- (void)loadnextplay{
    NSString *nextid = [[NSUserDefaults standardUserDefaults]objectForKey:Nextwareid];
    [self loadplayinfo:nextid];
}

#pragma mark--计算当前视频缓冲进度
- (NSTimeInterval)availableDuration {
    
    NSArray *loadedTimeRanges = [[self.player playerItem] loadedTimeRanges];
    
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    
    NSInteger startSeconds = CMTimeGetSeconds(timeRange.start);
    
    NSInteger durationSeconds = CMTimeGetSeconds(timeRange.duration);
    
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    
    return result;
}
 
#pragma mark---- 进度条的改变,同步字幕 保存当前播放信息
//进度条的定时器执行的方法
- (void)timeAction
{
    if (self.playproperty.selected)
    {
        return;
    }
    
    //判断4g网络下，且开关没打开的时候，暂停视频播放，如果开关打开了，就不用管了
    BOOL is4g = [[NSUserDefaults standardUserDefaults]boolForKey:Flow];
    if (is4g) {
        self.on = [[NSUserDefaults standardUserDefaults]boolForKey:ON];
        //4g网络下,开关没打开
        if (!self.on) {
            [self.player pause];
            //[self updateUI];
            [_playproperty setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        }
        //4g网络下，开关打开时，继续播放，什么处理都不做？
        else
        {
            
        }
    }else
    {
        
    }

    NSInteger currentSecond = CMTimeGetSeconds(_player.playerItem.currentTime);
    NSInteger duration  = CMTimeGetSeconds(self.player.playerItem.duration);
    self.progressSliderView.minLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",((int)currentSecond) / 3600,((int)currentSecond) / 60, ((int)currentSecond) % 60 ];
    self.progressSliderView.maxLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",((int)duration) / 3600,((int)duration) / 60, ((int)duration) % 60 ];
    BOOL notreachable = [[NSUserDefaults standardUserDefaults]boolForKey:@"noreachable"];
    if ((long)[self availableDuration] <= (long)currentSecond) {
        if (notreachable){
        }
        else
        {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
    }else{

    }
    //判断当前时间在字幕开始时间和结束时间之间，则赋值给字幕label以字幕
    if (_subtitlesarray.count != 0) {
        for (int i = 0; i<_begintimearray.count ; i++) {
            NSInteger beginarr =  [_begintimearray[i] integerValue];
            NSInteger endarr = [_endtimearray[i]integerValue];
            if (currentSecond > beginarr && currentSecond< endarr) {
                //同步字幕
                self.videoview.subtitlelabel.text = _subtitlesarray[i];
            }
        }
    }
    
    if (currentSecond == (int)CMTimeGetSeconds(self.player.playerItem.duration)) {
        //当当前时间和总时间相等时，且总时间不为0时，就是播放结束时，执行播放结束的方法
        if ((int)CMTimeGetSeconds(self.player.playerItem.duration) != 0) {
            [self playbackFinished];
        }
        [self.player pause];
        self.playproperty.selected = YES;
    }
}

#pragma mark-
#pragma mark---------------四个按钮的方法
#pragma mark--章节按钮
- (IBAction)chapterBtn:(id)sender {
    [self loadChapterDataWithCompletionHandle:self.courceid];
    self.chaptertableview.hidden = !self.chaptertableview.hidden;
}

#pragma mark--上一个
- (IBAction)lastBtn:(id)sender {
    NSString *preid = [[NSUserDefaults standardUserDefaults]objectForKey:Prewareid];
    if (![preid isKindOfClass:NULL]) {
        [self loadplayinfo:preid];
    }
    else
    {
        [[Tool SharedInstance]showtoast:@"亲，这已经是第一个章节了~"];
    }
}

#pragma mark--播放
- (IBAction)playBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player pause];
    }
    else {
        [self.player play];
    }
}

#pragma mark--下一个
- (IBAction)nextBtn:(id)sender {
    NSString *nextid = [[NSUserDefaults standardUserDefaults]objectForKey:Nextwareid];
    if (![nextid isKindOfClass:NULL]) {
        [self loadplayinfo:nextid];
    }else
    {
        [[Tool SharedInstance]showtoast:@"亲，这已经是最后一章节了哟~"];
    }
}


#pragma mark - 创建手势-音量和亮度
- (void)createGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.videoview addGestureRecognizer:tap];
    //获取系统音量
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    volumeView.frame = CGRectMake(-1000, -100, 100, 100);
    volumeView.hidden = NO;
    _volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    _systemVolume = _volumeViewSlider.value;
}
- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSLog( @"音量调节");
    [_volumeViewSlider setValue:0.0f animated:NO];
    [_volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)changeVolumn
{
    NSError *error;
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}

- (void)volumeChanged:(NSNotification *)notification
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"开始移动");
    _originalLocation = CGPointZero;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"移动中");
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self.videoview];
    CGFloat offset_x = currentLocation.x - _originalLocation.x;
    CGFloat offset_y = currentLocation.y - _originalLocation.y;
    //求2点间距离
    CGFloat l = sqrt(offset_x*offset_x+offset_y*offset_y);
    //防止轻击手势干扰滑动手势
    if (l<10) {
        return;
    }
    if (CGPointEqualToPoint(_originalLocation,CGPointZero)) {
        _originalLocation = currentLocation;
        return;
    }
    _originalLocation = currentLocation;
    CGRect frame = [UIScreen mainScreen].bounds;
    if (_gestureType == GestureTypeOfNone) {
        //判断x轴和y轴偏移量来判断是横向还是竖向
        if ((currentLocation.x > frame.size.width*0.5) && (ABS(offset_x) <= ABS(offset_y))){
            NSLog(@"GestureTypeOfVolume");
            _gestureType = GestureTypeOfVolume;
        }else if ((currentLocation.x < frame.size.width*0.5) && (ABS(offset_x) <= ABS(offset_y))){
            _gestureType = GestureTypeOfBrightness;
            NSLog(@"GestureTypeOfBrightness");
        }
        
    }
    else if ((_gestureType == GestureTypeOfVolume) && (currentLocation.x > frame.size.width*0.5) && (ABS(offset_x) <= ABS(offset_y))){
        NSLog(@"音量！！");
        if (offset_y > 0){
            [self volumeAdd:-VolumeStep];
        }else{
            [self volumeAdd:VolumeStep];
        }
    }else if ((_gestureType == GestureTypeOfBrightness) && (currentLocation.x < frame.size.width*0.5) && (ABS(offset_x) <= ABS(offset_y))){
        NSLog(@"亮度");
        if (offset_y > 0) {
            self.brightnessView.alpha = 1;
            [self brightnessAdd:-BrightnessStep];
        }else{
            self.brightnessView.alpha = 1;
            [self brightnessAdd:BrightnessStep];
        }
    }
}


//轻击手势不走end
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"移动结束");
    if (_gestureType == GestureTypeOfNone) {
        
    }else{
        _gestureType = GestureTypeOfNone;
        if (_brightnessView.alpha) {
            [UIView animateWithDuration:1 animations:^{
                _brightnessView.alpha = 0;
            }];
        }
    }
}

//亮度增加
- (void)brightnessAdd:(CGFloat)step{
    [UIScreen mainScreen].brightness += step;
    _brightnessProgress.progress = [UIScreen mainScreen].brightness;
}
//声音增加
- (void)volumeAdd:(CGFloat)step{
    [MPMusicPlayerController applicationMusicPlayer].volume += step;
}
//创建亮度显示的view
- (void)createBrightnessView
{
    _brightnessView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    _brightnessView.center = CGPointMake(self.videoview.bounds.size.width * 0.5, self.videoview.bounds.size.height * 0.5);
    _brightnessView.image = [UIImage imageNamed:@"person"];
    _brightnessProgress = [[UIProgressView alloc]initWithFrame:CGRectMake(_brightnessView.frame.size.width/2-40, _brightnessView.frame.size.height-30, 80, 10)];
    _brightnessProgress.progressTintColor = [UIColor whiteColor];
    _brightnessProgress.trackTintColor = [UIColor colorWithRed:0.49f green:0.48f blue:0.49f alpha:1.00f];
    _brightnessProgress.progress = [UIScreen mainScreen].brightness;
    [_brightnessView addSubview:_brightnessProgress];
    [self.videoview addSubview:_brightnessView];
    _brightnessView.alpha = 0;
}

- (void)dealloc
{
    NSLog(@"dealloc-----------------");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //界面消失时移除对视频的监听
    //[self removeOBserverFromPlayer:self.player];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil)// 是否是正在使用的视图
    {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}

@end
