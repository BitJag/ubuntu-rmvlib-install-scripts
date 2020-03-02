#include "./genericExample.h"

int main () {
  
    long joy1;
    joypad_state *j_state = malloc(sizeof(joypad_state));
  
    TOMREGS->vmode = RGB16|CSYNC|BGEN|PWIDTH4|VIDEN;

    init_interrupts();
    init_display_driver();
  
    display *d = new_display(0);
        d-> x = 19;
        d-> y = 7;
        
    void *gpu_addr = &_GPU_FREE_RAM;
    init_lz77(gpu_addr);
    
    int freq = 16000;
    freq = init_sound_driver(freq);
    
    FILE *console = open_console(d,8,16,0);
    
    show_display(d);
    
    object *ball = initObject(8, 8, d);
    fprintf(console, "VelInt:                  \n");
    fprintf(console, "VelFloat:                \n\n");
    fprintf(console, "   16-bit        8-bit        4-bit\n");
    
    int magnitude = 13;
    
    //load color palette
    memcpy((void *)TOMREGS->clut1, &color_palette, 256*sizeof(uint16_t));
    
    //load 16bit sprite
    sprite *gfx16bitSprite = new_sprite(96, 145, 8, 54, DEPTH16, &gfx16bit);
    attach_sprite_to_display_at_layer(gfx16bitSprite, d, 1);
/*  
    */
    //load 8bit sprite
    phrase *gfx8bitData = malloc(96*145);
    lz77_unpack(&gfx8bit, (uint8_t*)gfx8bitData);
    sprite *gfx8bitsprite = new_sprite(96, 145, 112, 54, DEPTH8, gfx8bitData);
    attach_sprite_to_display_at_layer(gfx8bitsprite, d, 1);
    
    //load 4bit sprite
    phrase *gfx4bitData = malloc((96/2)*145);
    lz77_unpack(&gfx4bit, (uint8_t*)gfx4bitData);
    sprite *gfx4bitsprite = new_sprite(96, 145, 216, 54, DEPTH4, gfx4bitData);
    attach_sprite_to_display_at_layer(gfx4bitsprite, d, 1);
    /*
    */
    //load music
    char *songData = malloc(sizeof(char)*109578);
    lz77_unpack(&song, (uint8_t*)songData);
    
    
    //start music
    init_module(songData,1);
    vblQueue[0] = play_module;
    
          
//     TOMREGS->bg = 0xFF00;
    
    while (1) {
      
        read_joypad_state(j_state);
        joy1 = j_state->j1;
        vsync();
        wallObjectCollisionCheck(ball);
        moveObject(ball);
        ballControl(joy1, ball, magnitude);
        
        console->seek(console, 7, SEEK_SET);
        fprintf(console,"X %d  ", ball->velocity[0]);
        console->seek(console, 12, SEEK_SET);
        fprintf(console,"Y %d  ", ball->velocity[1]);
        
        console->seek(console, 1*40+9, SEEK_SET);
        fprintf(console,"X %d    ", ball->velocityFloat[0]);
        console->seek(console, 1*40+16, SEEK_SET);
        fprintf(console,"Y %d    ", ball->velocityFloat[1]);
/*        
      */
    }
  
};

object *initObject(int xSize, int ySize, display *d){
    
    object *o = malloc(sizeof(object));
    o->dimensions[0] = xSize;
    o->dimensions[1] = ySize;
    o->position[0] = 160;
    o->position[1] = 110;
    o->sides[0][0] = -1 * (ySize/2);
    o->sides[0][1] = 1 * (xSize/2);
    o->sides[0][2] = 1 * (ySize/2);
    o->sides[0][3] = -1 * (xSize/2);
    o->sides[1][0] = o->position[1] + o->sides[0][0];
    o->sides[1][1] = o->position[0] + o->sides[0][1];
    o->sides[1][2] = o->position[1]+ o->sides[0][2];
    o->sides[1][3] = o->position[0] + o->sides[0][3];
    o->velocityFloat[0] = 0;
    o->velocityFloat[1] = 1;
    o->velocity[0] = o->velocityFloat[0] >> 6;
    o->velocity[1] = o->velocityFloat[1] >> 6;
    o->magnitude = 13;
    o->velocityMax = 3;
    
    o->oScreen = new_screen();
    alloc_simple_screen(DEPTH8, xSize, ySize, o->oScreen);
    memset(o->oScreen->data, 0x71, xSize*ySize);
    
    o->oSprite = sprite_of_screen(o->position[0], o->position[1], o->oScreen);
    o->oSprite->use_hotspot = 1;
    o->oSprite->hx = xSize/2;
    o->oSprite->hy = ySize/2;
    attach_sprite_to_display_at_layer(o->oSprite, d, 1);
    
    return o;
    
    
};

void moveObject(object *o){
    
    int i = 0;
    
    o->velocity[0] = (o->velocityFloat[0] >> 6);
    o->velocity[1] = (o->velocityFloat[1] >> 6);
    
    for(i = 0; i != 2; i++){
    
        if(o->velocity[i] > o->velocityMax){
            o->velocity[i] = o->velocityMax;
        }
        
        if(o->velocity[i] < (o->velocityMax * -1)){
            o->velocity[i] = (o->velocityMax * -1);
        }
    
    }
        
    o->position[0] += o->velocity[0];
    o->position[1] += o->velocity[1];
    o->oSprite->x = o->position[0];
    o->oSprite->y = o->position[1];
    
};

void callculateObjectCollisionBox(object *o){
    //top
    o->sides[1][0] = o->oSprite->y + o->sides[0][0];
    
    //right
    o->sides[1][1] = o->oSprite->y + o->sides[0][1];
    
    //bottom
    o->sides[1][2] = o->oSprite->y + o->sides[0][2];
    
    //left
    o->sides[1][3] = o->oSprite->y + o->sides[0][3];  
};

void wallObjectCollisionCheck(object *o){
    
    //top boundry
    if(o->position[1] < 8){
        
        o->position[1] = 9;
        o->velocityFloat[1] *= -1;
        o->velocityFloat[1] /= 2;
        
    }
    
    //right boundry
    else if(o->position[0] > 312){
        
        o->position[0] = 311;
        o->velocityFloat[0] *= -1;
        o->velocityFloat[0] /= 2;
        
    }
    
    //bottom boundry
    else if(o->position[1] > 224){
        
        o->position[1] = 223;
        o->velocityFloat[1] *= -1;
        o->velocityFloat[1] /= 2;
        
    }
    
    //left boundry
    else if(o->position[0] < 8){
        
        o->position[0] = 9;
        o->velocityFloat[0] *= -1;
        o->velocityFloat[0] /= 2;
        
    }
    
    
};

void ballControl(long joy, object *ball, int magnitude){
    
    if(joy & JOYPAD_DOWN){
        
        if(ball->velocityFloat[1] < 255){
            ball->velocityFloat[1] += magnitude;
        }
        
        else{
            ball->velocityFloat[1] = 255;
        }
        
    }
    
    else if(joy & JOYPAD_UP){
        
        if(ball->velocityFloat[1] > -255){
            ball->velocityFloat[1] -= magnitude;
        }
        
        else{
            ball->velocityFloat[1] = -255;
        }
        
    }
    
    else{
        
        if(ball->velocityFloat[1] != 0){
            
            if(ball->velocityFloat[1] > 0){
                ball->velocityFloat[1] -= magnitude/2;
                
                if(ball->velocityFloat[1] < 0){
                    ball->velocityFloat[1] = 0;
                }
                
            }
            
            else if(ball->velocityFloat[1] < 0){
                ball->velocityFloat[1] += magnitude/2;
                
                if(ball->velocityFloat[1] > 0){
                    ball->velocityFloat[1] = 0;
                }
                
            }
            
        }
        
    }
    
    if(joy & JOYPAD_RIGHT){
        
        if(ball->velocityFloat[0] < 255){
            ball->velocityFloat[0] += magnitude;
        }
        
        else{
            ball->velocityFloat[0] = 255;
        }
        
    }
    
    else if(joy & JOYPAD_LEFT){
        
        if(ball->velocityFloat[0] > -255){
            ball->velocityFloat[0] -= magnitude;
        }
        
        else{
            ball->velocityFloat[0] = -255;
        }
        
    }
    
    else{
        
        if(ball->velocityFloat[0] != 0){
            
            if(ball->velocityFloat[0] > 0){
                ball->velocityFloat[0] -= magnitude/2;
                
                if(ball->velocityFloat[0] < 0){
                    ball->velocityFloat[0] = 0;
                }
                
            }
            
            else if(ball->velocityFloat[0] < 0){
                ball->velocityFloat[0] += magnitude/2;
                
                if(ball->velocityFloat[0] > 0){
                    ball->velocityFloat[0] = 0;
                }
                
            }
            
        }
        
    }
    
};

