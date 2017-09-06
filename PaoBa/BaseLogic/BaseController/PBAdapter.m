//
//  PBAdapter.m
//  PaoBa
//
//  Created by wujian on 2017/8/18.
//  Copyright © 2017年 wujian. All rights reserved.
//

#import "PBAdapter.h"

@interface PBAdapter ()

@property (nonatomic, strong)   NSMutableArray* arr;

@end

@implementation PBAdapter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _arr = [NSMutableArray new];
    }
    return self;
}

- (NSArray*)getAdapterArray
{
    return _arr;
}

- (void)setAdapterArray:(NSArray*)arr
{
    [_arr removeAllObjects];
    [_arr addObjectsFromArray:arr];
}

#pragma mark    UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //检测数组越界
    if (indexPath.row > self.getAdapterArray.count-1) {
        return [UITableViewCell new];
    }
    
    id cellData = [self.arr objectAtIndex:indexPath.row];
    
    UITableViewCell* cell = NULL;
    PBSuppressPerformSelectorLeakWarning(
                                         cell = [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"tableView:cellFor%@:", [cellData class]]) withObject:tableView withObject:cellData];);
    
    return cell;
}

#pragma mark    UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.getAdapterArray.count-1) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    
    id cellData = [self.arr objectAtIndex:indexPath.row];
    if (self.adapterDelegate) {
        if ([_adapterDelegate respondsToSelector:@selector(didSelectCellData:)]) {
            [_adapterDelegate didSelectCellData:cellData];
        }
        
        if ([_adapterDelegate respondsToSelector:@selector(didSelectCellData:indexPath:)]) {
            [_adapterDelegate didSelectCellData:cellData indexPath:indexPath];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > self.getAdapterArray.count-1) {
        return;
    }
    
}

@end
