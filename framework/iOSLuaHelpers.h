//
//  iOSLuaHelpers.h
//
//  Created by Kurt Jacobs on 2015/03/23.
//  Copyright (c) 2015 Kurt Jacobs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Torch.h"

extern int lua_path_ios(lua_State* L, NSString* path);

@interface iOSLuaHelpers : NSObject

@end
