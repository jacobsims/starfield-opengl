//
//  starfield_openglView.m
//  starfield-opengl
//
//  Created by Jacob Sims on 2015-11-14.
//  Copyright © 2015 Jacob Sims. All rights reserved.
//

#import "starfield_openglView.h"

double randomDouble() {
    return (double)arc4random_uniform(STAR_RAND_GRANULARITY) / STAR_RAND_GRANULARITY;
}

void resetStar(star *s) {
    double screenx = 2 * (randomDouble() - 0.5);
    double screeny = 2 * (randomDouble() - 0.5);
    double z = STAR_SPREAD_Z * randomDouble();
    if (z < 0.0001) {
        z = 0.0001;
    }
    s->x = screenx * z;
    s->y = screeny * z;
    s->z = z;
    s->fadeIn = 0.0;
    s->speed = 0.005;
}

void updateStar(star *s) {
    s->z -= s->speed;
    s->fadeIn += 0.1;
    if (s->fadeIn > 1) {
        s->fadeIn = 1;
    }
    
    if (s->x > 1 || s->x < -1 || s->y > 1 || s->y < -1 || s->z <= 0) {
        resetStar(s);
    }
}

@implementation starfield_openglView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        NSOpenGLPixelFormatAttribute attributes[] = {
            NSOpenGLPFAAccelerated,
            NSOpenGLPFADepthSize, 16,
            NSOpenGLPFAMinimumPolicy,
            NSOpenGLPFAClosestPolicy,
            0
        };
        NSOpenGLPixelFormat *format = [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
        glView = [[FixedGLView alloc] initWithFrame:NSZeroRect pixelFormat:format];
        if (!glView) {
            NSLog(@"OpenGL couldn't initialize for starfield-opengl screensaver.");
            return nil;
        }
        [self addSubview:glView];
        [self setUpOpenGL];
        
        for (int i=0; i<STAR_COUNT; i++) {
            resetStar(&(stars[i]));
        }
        
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)setUpOpenGL {
    [[glView openGLContext] makeCurrentContext];
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
    
    glClearColor(0, 0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glPointSize(1.0);
    glBegin(GL_POINTS);
    {
        for (int i=0; i<STAR_COUNT; i++) {
            glColor3f(stars[i].fadeIn, stars[i].fadeIn, stars[i].fadeIn);
            double glStarXPos = (stars[i].x / stars[i].z);
            double glStarYPos = (stars[i].y / stars[i].z);
            
            glVertex2d(glStarXPos, glStarYPos);
        }
    }
    glEnd();
    glFlush();
}

- (void)animateOneFrame
{
    for (int i=0; i<STAR_COUNT; i++) {
        updateStar(&(stars[i]));
    }
    [self setNeedsDisplay:YES];
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

- (void)setFrameSize:(NSSize)newSize {
    [super setFrameSize:newSize];
    [glView setFrameSize:newSize];
    [[glView openGLContext] makeCurrentContext];
    glViewport(0, 0, newSize.width, newSize.height);
}

@end
