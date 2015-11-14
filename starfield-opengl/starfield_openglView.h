//
//  starfield_openglView.h
//  starfield-opengl
//

#import <ScreenSaver/ScreenSaver.h>

#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import "FixedGLView.h"

#define STAR_COUNT 1500
#define STAR_RAND_GRANULARITY 10000
#define STAR_SPREAD_Z 3

typedef struct {
    double x, y, z;
    double speed;
    double fadeIn;
} star;

void resetStar(star *s);
void updateStar(star *s);
double randomDouble();

@interface starfield_openglView : ScreenSaverView {
    NSOpenGLView *glView;
    star stars[STAR_COUNT];
}

- (void)setUpOpenGL;

@end
