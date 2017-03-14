//
//  UserLogicServiceProtocol.h
//  PaoBa
//
//  Created by wujian on 4/18/16.
//  Copyright © 2016 wesk痕. All rights reserved.
//

#ifndef UserLogicServiceProtocol_h
#define UserLogicServiceProtocol_h

@protocol UserLogicServiceProtocol <NSObject>

- (void)getUserProfileFromServerWithUserId:(NSNumber *)userId;

@end
#endif /* UserLogicServiceProtocol_h */
