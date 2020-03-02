#ifndef GENERICEXAMPLE
#define GENERICEXAMPLE

#include <jagdefs.h>
#include <jagtypes.h>
#include <stdlib.h>
#include <interrupt.h>
#include <display.h>
#include <sprite.h>
#include <collision.h>
#include <joypad.h>
#include <screen.h>
#include <blit.h>
#include <console.h>
#include <fb2d.h>
#include <lz77.h>
#include <sound.h>

//structure definitions
typedef struct{
    
    int dimensions[2];
    int sides[2][4]; //[local (relative to origin),global (relative to origin's global position)][top,right,bottom,left]
    int position[2];
    int velocityFloat[2];
    int velocity[2];
    int magnitude;
    int velocityMax;
    screen *oScreen;
    sprite *oSprite;
    
}object;

//function declarations
object *initObject(int xSize, int ySize, display *d);

void moveObject(object *o);

void wallObjectCollisionCheck(object *o);

void ballControl(long joy, object *ball, int magnitude);

//external asset declarations
//palettes
extern phrase color_palette;
//GFX
extern phrase gfx16bit;
extern uint8_t gfx8bit;
extern uint8_t gfx4bit;

//SFX
extern uint8_t song;


#endif  
