//
//  Torch.h
//

#import <UIKit/UIKit.h>

#import <Torch/Torch.h>

int luaopen_libtorch(lua_State *L);
int luaopen_libnn(lua_State *L);
int luaopen_libnnx(lua_State *L);
int luaopen_libimage(lua_State *L);

@interface Torch : NSObject
{
    lua_State *L;
}

- (void)doFileInBundle:(NSString *)file;
- (void)doFileAtPath:(NSString *)path;
- (void)initialize;

@end
