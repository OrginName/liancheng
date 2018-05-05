//
//  SRDownloadManager.h
//  dumbbell
//
//  Created by JYS on 17/3/16.
//  Copyright © 2017年 insaiapp. All rights reserved.
//

#import "SRDownloadModel.h"

@implementation SRDownloadModel

- (void)openOutputStream {
    
    if (_outputStream) {
        [_outputStream open];
    }
}

- (void)closeOutputStream {
    
    if (_outputStream) {
        [_outputStream close];
        _outputStream = nil;
    }
}

@end
