//
//  Torch.m
//

#import "Torch.h"
#import "iOSLuaHelpers.h"

@implementation Torch

- (void)doFileInBundle:(NSString *)file
{
    int ret = luaL_dofile(L, [[[NSBundle mainBundle] pathForResource:file ofType:@"lua"] UTF8String]);
    if (ret == 1) {
        NSLog(@"could not load invalid lua resource: %@\n", file);
    }
}

- (void)doFileAtPath:(NSString *)path
{
    const char *fpath_cstring = [path UTF8String];
    int ret = luaL_dofile(L, fpath_cstring);
    if (ret == 1) {
        NSLog(@"could not load invalid lua resource: %@\n", path);
    }
}

- (void)requireLib:(NSString *)libName inState:(lua_State *)l
{
    NSString *libPath = [[self getLuaPath] stringByAppendingPathComponent:libName];
    NSString *initFilePath = [self luaInitFileAtPath:libPath];
    lua_path_ios(l, [initFilePath stringByDeletingLastPathComponent]);
    [self doFileAtPath:initFilePath];
}

- (NSString *)luaInitFileAtPath:(NSString *)libpath
{
    __block NSString *initFilePath = nil;
    NSArray *filesInLib = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:libpath error:nil];
    [filesInLib enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([[obj pathExtension] isEqualToString:@"lua"] && [obj containsString:@"init"])
         {
             initFilePath = [libpath stringByAppendingPathComponent:obj];
             *stop = YES;
         }
     }];
    return initFilePath;
}

- (NSString *)getLuaPath
{
    NSURL *lpath = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"torchdata"];
    return [lpath path];
}

- (void)initialize
{
    // initialize Lua stack
    lua_executable_dir("./");
    L = lua_open();
    luaL_openlibs(L);
    
    // load Torch
    luaopen_libtorch(L);
//    [self requireLib:@"torch" inState:L];

    // load dok
//    [self requireLib:@"dok" inState:L];
    
    // load nn
    luaopen_libnn(L);
//    [self requireLib:@"nn" inState:L];

    // load nnx
    luaopen_libnnx(L);
//    [self requireLib:@"nnx" inState:L];

    // load image
    luaopen_libimage(L);
//    [self requireLib:@"image" inState:L];

    // run user code
    lua_path_ios2(L, [[self getLuaPath] stringByAppendingPathComponent:@"lua"]);
    [self doFileAtPath:[[self getLuaPath] stringByAppendingPathComponent:@"main.lua"]];
//    lua_getfield(L, LUA_GLOBALSINDEX, "initialize");
//    lua_call(L, 0, 0);
    
    // done
    return;
}

@end
