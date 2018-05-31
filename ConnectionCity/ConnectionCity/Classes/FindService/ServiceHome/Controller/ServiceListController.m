//
//  ServiceListController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/5/31.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "ServiceListController.h"
#import "ServiceListCell.h"
@interface ServiceListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_Bottom;

@end

@implementation ServiceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceListCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
@end
