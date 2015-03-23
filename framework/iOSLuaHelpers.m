//
//  iOSLuaHelpers.m
//
//  Created by Kurt Jacobs on 2015/03/23.
//  Copyright (c) 2015 Kurt Jacobs. All rights reserved.
//

#import "iOSLuaHelpers.h"

int lua_path_ios(lua_State* L, NSString* path)
{
    lua_getglobal(L,"package");
    lua_getfield(L,-1,"path");
    NSString *current_path = [NSString stringWithUTF8String:lua_tostring(L,-1)];
    current_path = [NSString stringWithFormat:@"%@;%@/?.lua",current_path,path];
    lua_pop(L,1);
    lua_pushstring(L, [current_path UTF8String]);
    lua_setfield(L,-2,"path");
    lua_pop(L,1);
    return 0;
}

@implementation iOSLuaHelpers

@end
