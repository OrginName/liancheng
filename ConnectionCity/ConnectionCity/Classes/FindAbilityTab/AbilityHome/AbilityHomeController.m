//
//  AbilityHomeController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/9.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "AbilityHomeController.h"
#import "CustomMap.h"
#import "CustomLocatiom.h"
@interface AbilityHomeController ()<CustomLocationDelegate>
@property (weak, nonatomic) IBOutlet UIView *view_Map;
@property (nonatomic,strong) CustomMap *cusMap;
@property (nonatomic,strong) CustomLocatiom * location;
@end

@implementation AbilityHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
//    self.location = [[CustomLocatiom alloc] init];
//    _location.delegate = self;
    
}
-(void)back{
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}
-(void)setUI{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"arraw-right" title:@"" EdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.cusMap = [[CustomMap alloc] initWithFrame:CGRectMake(0, 0, self.view_Map.width, self.view_Map.height) withControl:self];
//    self.cusMap.mapView.delegate = self;
    [self.view_Map addSubview:self.cusMap];

    
}
- (void)currentLocation:(NSDictionary *)locationDictionary{
    NSLog(@"5555555555555555");
}
 


@end
