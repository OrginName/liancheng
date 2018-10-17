//
//  MyOrderController.m
//  ConnectionCity
//
//  Created by umbrella on 2018/10/17.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "MyOrderController.h"

@interface MyOrderController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab_bottom;

@end

@implementation MyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark ------UITableViewDelegate------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = KString(@"%ld", (long)indexPath.row);
    return cell;
}
@end
