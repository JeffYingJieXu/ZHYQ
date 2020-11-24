//
//  MainTabBarController.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "MainTabBarController.h"
#import "RootNavigationController.h"
#import "WorkViewController.h"
#import "MineViewController.h"
#import "UITabBar+CustomBadge.h"
#import "XYTabBar.h"

@interface MainTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic,strong) NSMutableArray * VCS;//tabbar root VC

@end

@implementation MainTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    //初始化tabbar
    [self setUpTabBar];
    //添加子控制器
    [self setUpAllChildViewController];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark ————— 初始化TabBar —————
-(void)setUpTabBar{
        if (@available(iOS 13.0,*)) {
    //        UITabBarAppearance *appear = [UITabBarAppearance new];
    //        UIImage *whiteback = [UIImage imageWithColor:KWhiteColor];
    //        appear.shadowImage = whiteback;
    //        appear.shadowColor = KWhiteColor;
    //        appear.backgroundColor = KWhiteColor;
    ////        appear.backgroundEffect = nil;
    //        appear.backgroundImage = whiteback;
    //        self.tabBar.standardAppearance = appear;
            
            UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
            [tabBarAppearance configureWithDefaultBackground];
            tabBarAppearance.shadowColor = [UIColor clearColor];
            tabBarAppearance.backgroundColor = [UIColor whiteColor];
            UITabBar.appearance.standardAppearance = tabBarAppearance;
            self.tabBar.standardAppearance = tabBarAppearance;
            
        }else
        {
    //        UIImage *whiteLine = [UIImage imageWithColor:KWhiteColor];
            //设置背景色 去掉分割线

            [self.tabBar setBackgroundColor:[UIColor whiteColor]];
            [self.tabBar setBackgroundImage:[UIImage new]];
            //通过这两个参数来调整badge位置
            //    [self setValue:[XYTabBar new] forKey:@"tabBar"];
            //    [self.tabBar setTabIconWidth:29];
            //    [self.tabBar setBadgeTop:9];
        }
}

#pragma mark - ——————— 初始化VC ————————
-(void)setUpAllChildViewController{
    _VCS = @[].mutableCopy;

//    PersonListViewController *homeVC = [[PersonListViewController alloc]init];
//    [self setupChildViewController:homeVC title:@"首页" imageName:@"icon_tabbar_homepage" seleceImageName:@"icon_tabbar_homepage_selected"];

    
    WorkViewController *Work = WorkViewController.new;
    [self setupChildViewController:Work title:@"巡检任务" imageName:@"homeN" seleceImageName:@"homeH"];
    
    UIViewController *Phone = UIViewController.new;
    [self setupChildViewController:Phone title:@"统计查询" imageName:@"searchN" seleceImageName:@"searchH"];
    
    MineViewController *Mine = MineViewController.new;
    [self setupChildViewController:Mine title:@"个人中心" imageName:@"mineN" seleceImageName:@"mineH"];
    
    self.viewControllers = _VCS;
}

-(void)setupChildViewController:(UIViewController*)controller title:(NSString *)title imageName:(NSString *)imageName seleceImageName:(NSString *)selectImageName{
    controller.title = title;
    controller.tabBarItem.title = title;//跟上面一样效果
    controller.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [UITabBarAppearance new];
        // 设置未被选中的颜色
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],NSFontAttributeName:SYSTEMFONT(12.0f)};
        // 设置被选中时的颜色
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = @{NSForegroundColorAttributeName:CThemeColor,NSFontAttributeName:SYSTEMFONT(12.0f)};
        
        controller.tabBarItem.standardAppearance = appearance;
    }else{
        //未选中字体颜色
        [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"999999"],NSFontAttributeName:SYSTEMFONT(12.0f)} forState:UIControlStateNormal];
        
        //选中字体颜色
        [controller.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:CThemeColor,NSFontAttributeName:SYSTEMFONT(12.0f)} forState:UIControlStateSelected];
    }    //包装导航控制器
    RootNavigationController *nav = [[RootNavigationController alloc]initWithRootViewController:controller];
    
//    [self addChildViewController:nav];
    [_VCS addObject:nav];
    
}


-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //    NSLog(@"选中 %ld",tabBarController.selectedIndex);
    
}

-(void)setRedDotWithIndex:(NSInteger)index isShow:(BOOL)isShow{
    if (isShow) {
        [self.tabBar setBadgeStyle:kCustomBadgeStyleRedDot value:0 atIndex:index];
    }else{
        [self.tabBar setBadgeStyle:kCustomBadgeStyleNone value:0 atIndex:index];
    }
    
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
