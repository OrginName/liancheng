//
//  EditProfileController.m
//  ConnectionCity
//
//  Created by YanShuang Jiang on 2018/6/3.
//  Copyright © 2018年 ConnectionCity. All rights reserved.
//

#import "EditProfileController.h"
#import "EditProfileCell.h"

@interface EditProfileController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EditProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Setup
- (void)setupTableView {
    [self registerCell];
}

- (void)registerCell {
    [self.tableView registerNib:[UINib nibWithNibName:@"EditProfileCell" bundle:nil] forCellReuseIdentifier:@"EditProfileCell"];
}
#pragma mark - setter and getter


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditProfileCell *editProfileCell = [tableView dequeueReusableCellWithIdentifier:@"EditProfileCell"];
    return editProfileCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
