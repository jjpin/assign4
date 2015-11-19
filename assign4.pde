final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
int gameState;

final int C = 0;
final int B = 1;
final int A = 2;
int enemyState;

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;
float fighterX;
float fighterY;
float speed = 3;

int hpX = 40;
int enemyX = -30;
int enemyY = floor(random(30,440));
int enemySpeed = 3;
int[] enemyPositionX = new int[8];
int[] enemyPositionY = new int[8];
boolean[] enemy_crush = new boolean[8];
int spacingX = 70;
int spacingY = 45;
int treasureX = floor(random(40,580));
int treasureY = floor(random(40,380));
int bgX = 0;

PImage fighter;
PImage hp;
PImage enemy;
PImage treasure;
PImage bg1;
PImage bg2;
PImage end1;
PImage end2;
PImage start1;
PImage start2;
PImage[] flame = new PImage[5];



//var for flame animate
int crushX = 10000;
int crushY = 10000;
int flame_time= 0;
int sec=0;

//var for bullet
boolean bulletPressed = false;
PImage bullet;
int[] bulletPositionX = new int[5];
int[] bulletPositionY = new int[5];
boolean[] bullet_appear = new boolean[5];
boolean[] bullet_crush = new boolean[5];
float bulletSpeed = 3;
int countBulletFrame = 0;
int ID_bullet= 0;
int num_bullet = 5;

void setup () {
  size(640, 480) ;
  fighterX = width/2;
  fighterY = height/2;
  
  fighter = loadImage("img/fighter.png");
  hp = loadImage("img/hp.png");
  enemy = loadImage("img/enemy.png");
  treasure = loadImage("img/treasure.png");
  bg1 = loadImage("img/bg1.png");
  bg2 = loadImage("img/bg2.png");
  start1 = loadImage("img/start1.png");
  start2 = loadImage("img/start2.png");
  end1 = loadImage("img/end1.png");
  end2 = loadImage("img/end2.png");
  flame[0] = loadImage("img/flame1.png");
  flame[1] = loadImage("img/flame2.png");
  flame[2] = loadImage("img/flame3.png");
  flame[3] = loadImage("img/flame4.png");
  flame[4] = loadImage("img/flame5.png");
  bullet = loadImage("img/shoot.png");
  
  gameState = GAME_START;
  
  for(int i=0; i<enemy_crush.length; i++){
         enemy_crush[i] = false;
  }
  for(int i=0; i<bullet_crush.length; i++){
         bullet_crush[i] = false;
  }
  for(int i=0; i<bullet_appear.length; i++){
         bullet_appear[i] = false;
  }
  
}

void draw() {
  switch(gameState){
    case GAME_START:
      imageMode(CENTER);
      image(start2, 320, 240);
      if(mouseX > 200 && mouseX < 440){
        if(mouseY > 360 && mouseY < 420){
          image(start1, 320, 240);
          if(mousePressed){
            gameState = GAME_RUN;
            enemyState = C;
          }
        }
      }
    break;
    
    case GAME_RUN: 
    println(num_bullet);
      //bg
      image(bg1, bgX+320, 240);
      image(bg2, bgX-320, 240);
      image(bg1, bgX-960, 240);
      bgX += 1;
      bgX = bgX % 1280;
      
      //fighter
      image(fighter, fighterX, fighterY);
      if(upPressed){
        fighterY -= speed;
      }
      if(downPressed){
        fighterY += speed;
      }
      if(leftPressed){
        fighterX -= speed;
      }
      if(rightPressed){
        fighterX += speed;
      }    
      //boundary detection
      if(fighterX > 615){
        fighterX = 615;
      }
      if(fighterX < 25){
        fighterX = 25;
      }
      if(fighterY > 445){
        fighterY = 445;
      }
      if(fighterY < 25){
        fighterY = 25;
      }
      
      //bullet
      if(bulletPressed){   
        for(int i=0; i<bulletPositionX.length; i++){
          bulletPositionX[i] -= 3;
          if(!bullet_crush[i]){
            image(bullet,bulletPositionX[i],bulletPositionY[i]);
          }
          if(bullet_crush[i]){
            image(bullet,bulletPositionX[i],100000);
          }

          if(bulletPositionX[i]<0){
            num_bullet --;
            bulletPositionX[i]=10000;         
          }         
          if(bulletPositionX[i]<0 || bullet_crush[i]){
            bulletPositionY[i]=10000;
            bullet_crush[i]=false;
            bullet_appear[i]=false;
          }
        }
      }
      countBulletFrame++;
      

      
      
      //enemy    
        switch(enemyState){
          case C:
            int enemylength_C = 5; 
            for(int i=0; i<enemylength_C; i++){            
              if(enemy_crush[i] == false){
                enemyPositionX[i] = enemyX-i*spacingX;
                enemyPositionY[i] = enemyY;           
              }
              if(enemy_crush[i]){
                enemyPositionX[i] = enemyX-i*spacingX;
                enemyPositionY[i] = 10000; 
              }
              image(enemy,enemyPositionX[i],enemyPositionY[i]);
            }
           
           enemyX += enemySpeed;
           if(enemyX>960){
             enemyState = B;
             enemyX = -30;
             for(int i =0;i<enemy_crush.length;i++){
               enemy_crush[i] = false;
             }
           }
           
           //hit
           for(int i=0;i<enemyPositionX.length;i++){
             if(enemyPositionX[i]+30 >= (int)fighterX-25 && enemyPositionX[i]-30 <= (int)fighterX+25){
               if(enemyPositionY[i]+30 >= (int)fighterY-25 && enemyPositionY[i]-30 <= (int)fighterY+25){
                 enemy_crush[i] = true;
                 hpX -= 40;
                 crushX = enemyPositionX[i]+30;
                 crushY = enemyPositionY[i]+30;
                 flame_time = 0;          
               }
             }
           }
           
           //bullet hit
           for(int i=0; i<enemyPositionX.length; i++){
             for(int j=0; j<bulletPositionX.length; j++){
               if(bullet_appear[j]){
                 if(!bullet_crush[j]){
                   if(enemyPositionX[i]+30 >= (int)bulletPositionX[j]-15 && enemyPositionX[i]-30 <= (int)bulletPositionX[j]+15){
                     if(enemyPositionY[i]+30 >= (int)bulletPositionY[j]-13 && enemyPositionY[i]-30 <= (int)bulletPositionY[j]+13){
                       crushX = enemyPositionX[i]+30;
                       crushY = enemyPositionY[i]+30;
                       enemy_crush[i] = true;
                       bullet_appear[j] = false;
                       bullet_crush[j] = true;
                       flame_time = 0;
                       //num_bullet --;
                     }
                   } 
                 }
               }
             }    
           }
           
           //flame animate
           image(flame[flame_time],crushX,crushY,60,60);
           
           sec++;
           if(sec>6){  
             flame_time++;
             sec=0;
           }
           if(flame_time>=flame.length){
             crushX=10000;
             crushY=10000;
             flame_time=0;
           }
      
          break;
          
          case B:
            if(enemyY > 190){
              enemyY = 190;
            }
            int enemylength_B = 5;
  
            for(int i=0;i<enemylength_B;i++){
              if(enemy_crush[i] == false){
                enemyPositionX[i] = enemyX-i*spacingX;
                enemyPositionY[i] = enemyY+i*spacingY;
              }
              if(enemy_crush[i]){
                enemyPositionX[i] = enemyX-i*spacingX;
                enemyPositionY[i] = 10000; 
              }
              image(enemy,enemyPositionX[i],enemyPositionY[i]);
            }
           
           //hit
           for(int i=0;i<enemyPositionX.length;i++){
             if(enemyPositionX[i]+30 >= (int)fighterX-25 && enemyPositionX[i]-30 <= (int)fighterX+25){
               if(enemyPositionY[i]+30 >= (int)fighterY-25 && enemyPositionY[i]-30 <= (int)fighterY+25){
                 enemy_crush[i] = true;
                 hpX -= 40;
                 crushX = enemyPositionX[i]+30;
                 crushY = enemyPositionY[i]+30;
                 flame_time = 0;
               }
             }
           }
      
           //bullet hit
           for(int i=0;i<enemyPositionX.length;i++){
             for(int j=0;j<bulletPositionX.length;j++){
               if(bullet_appear[j]){
                 if(!bullet_crush[j]){
                   if(enemyPositionX[i]+30 >= (int)bulletPositionX[j]-15 && enemyPositionX[i]-30 <= (int)bulletPositionX[j]+15){
                     if(enemyPositionY[i]+30 >= (int)bulletPositionY[j]-13 && enemyPositionY[i]-30 <= (int)bulletPositionY[j]+13){
                       crushX = enemyPositionX[i]+30;
                       crushY = enemyPositionY[i]+30;
                       enemy_crush[i] = true;
                       bullet_crush[j] = true;
                       bullet_appear[j] = false;
                       flame_time = 0;
                       //num_bullet --;
                     }
                   } 
                 }
               }
             }    
           }
            
            enemyX += enemySpeed;
            if(enemyX > 960){
              enemyState = A;
              enemyX = -30;
              for(int i =0;i<enemy_crush.length;i++){
               enemy_crush[i] = false;
             }
            }
            
            //flame animate
           image(flame[flame_time],crushX,crushY,60,60);
           
           sec++;
           if(sec>6){
              
             flame_time++;
             sec=0;
           }
           if(flame_time>=flame.length){
             crushX=10000;
             crushY=10000;
             flame_time=0;
           }

          break;
          
          case A:
            if(enemyY > 360){
              enemyY = 360;
            }
            if(enemyY < 120){
              enemyY = 120;
            }
            int enemylength_A = 5;
            
            for(int i=0; i<enemylength_A; i++){
              if(i==0){
                if(enemy_crush[i] == false){
                enemyPositionX[i] = enemyX;
                enemyPositionY[i] = enemyY;
                
                }
              if(enemy_crush[i]){
                enemyPositionX[i] = enemyX;
                enemyPositionY[i] = 10000;
                
                }
            }else if(i==1){
              if(enemy_crush[i] == false && enemy_crush[i+4] == false){
                enemyPositionX[i] = enemyX-spacingX;
                enemyPositionY[i] = enemyY-spacingY;
                enemyPositionX[i+4] = enemyX-spacingX;
                enemyPositionY[i+4] = enemyY+spacingY;
              }
              if(enemy_crush[i]){
                enemyPositionX[i] = enemyX-spacingX;
                enemyPositionY[i] = 10000;
                enemyPositionX[i+4] = enemyX-spacingX;
                enemyPositionY[i+4] = enemyY+spacingY;
              }
              if(enemy_crush[i+4]){
                enemyPositionX[i] = enemyX-spacingX;
                enemyPositionY[i] = enemyY-spacingY;
                enemyPositionX[i+4] = enemyX-spacingX;
                enemyPositionY[i+4] = 10000;                
              }
            }else if(i==2){
              if(enemy_crush[i] == false && enemy_crush[i+4] == false){
                enemyPositionX[i] = enemyX-i*spacingX;
                enemyPositionY[i] = enemyY-i*spacingY;
                enemyPositionX[i+4] = enemyX-i*spacingX;
                enemyPositionY[i+4] = enemyY+i*spacingY;
              }
              if(enemy_crush[i]){
                enemyPositionX[i] = enemyX-i*spacingX;
                enemyPositionY[i] = 10000;
                enemyPositionX[i+4] = enemyX-i*spacingX;
                enemyPositionY[i+4] = enemyY+i*spacingY;
              }
              if(enemy_crush[i+4]){
                enemyPositionX[i] = enemyX-i*spacingX;
                enemyPositionY[i] = enemyY-i*spacingY;
                enemyPositionX[i+4] = enemyX-i*spacingX;
                enemyPositionY[i+4] = 10000;                
              } 
            }else if(i==3){
              if(enemy_crush[i] == false && enemy_crush[i+4] == false){
                enemyPositionX[i] = enemyX-i*spacingX;
                enemyPositionY[i] = enemyY-spacingY;
                enemyPositionX[i+4] = enemyX-i*spacingX;
                enemyPositionY[i+4] = enemyY+spacingY;
              }
              if(enemy_crush[i]){
                enemyPositionX[i] = enemyX-i*spacingX;
                enemyPositionY[i] = 10000;
                enemyPositionX[i+4] = enemyX-i*spacingX;
                enemyPositionY[i+4] = enemyY+spacingY;
              }
              if(enemy_crush[i+4]){
                enemyPositionX[i] = enemyX-i*spacingX;
                enemyPositionY[i] = enemyY-spacingY;
                enemyPositionX[i+4] = enemyX-i*spacingX;
                enemyPositionY[i+4] = 10000;
              }
            }else if(i == 4){
               if(enemy_crush[i] == false){
                 enemyPositionX[i] = enemyX-i*spacingX;
                 enemyPositionY[i] = enemyY;                
               }
               if(enemy_crush[i]){
                 enemyPositionX[i] = enemyX-i*spacingX;
                 enemyPositionY[i] = 10000;                               
               }
             }
             
            }
            
            for(int i=0;i<enemyPositionX.length;i++){
              image(enemy,enemyPositionX[i],enemyPositionY[i]);
            }
        //hit
           for(int i=0;i<enemyPositionX.length;i++){
             if(enemyPositionX[i]+30 >= (int)fighterX-25 && enemyPositionX[i]-30 <= (int)fighterX+25){
               if(enemyPositionY[i]+30 >= (int)fighterY-25 && enemyPositionY[i]-30 <= (int)fighterY+25){
                 enemy_crush[i] = true;
                 hpX -= 40;
                 crushX = enemyPositionX[i]+30;
                 crushY = enemyPositionY[i]+30;
                 flame_time = 0;
               }
             }
           }
           
           //bullet hit
           for(int i=0;i<enemyPositionX.length;i++){
             for(int j=0;j<bulletPositionX.length;j++){
               if(bullet_appear[j]){
                 if(!bullet_crush[j]){
                   if(enemyPositionX[i]+30 >= (int)bulletPositionX[j]-15 && enemyPositionX[i]-30 <= (int)bulletPositionX[j]+15){
                     if(enemyPositionY[i]+30 >= (int)bulletPositionY[j]-13 && enemyPositionY[i]-30 <= (int)bulletPositionY[j]+13){
                       crushX = enemyPositionX[i]+30;
                       crushY = enemyPositionY[i]+30;
                       enemy_crush[i] = true;
                       bullet_crush[j] = true;
                       bullet_appear[j] = false;
                       flame_time = 0;
                       //num_bullet --;
                     }
                   } 
                 }
               }
             }    
           }
            enemyX += enemySpeed;
            if(enemyX > 960){
              enemyState = C;
              enemyX = -30;
              for(int i =0;i<enemy_crush.length;i++){
               enemy_crush[i] = false;
             }
            }
          
          //flame animate
           image(flame[flame_time],crushX,crushY,60,60);
           
           sec++;
           if(sec>6){
             
             flame_time++;
             sec=0;
           }
           if(flame_time>=flame.length){
             crushX=10000;
             crushY=10000;
             flame_time=0;
           }
          break;
        }      
      
      
      //treasure
      image(treasure ,treasureX, treasureY);
      //get treasure
      if((int)fighterX+25 >= treasureX-20 && (int)fighterX-25 <= treasureX+20){
        if((int)fighterY+25 >= treasureY-20 && (int)fighterY-25 <= treasureY+20){
          hpX += 20;
          treasureX = floor(random(40,580));
          treasureY = floor(random(40,380));
          if(hpX > 200){
            hpX = 200;
          }
        }
      }
      
      //hp
      fill(#FF0000);
      rect(9, 3, hpX, 20);
      image(hp, 105, 15);
      if(hpX <= 0){
        gameState = GAME_OVER;
      }
    break;
    
    case GAME_OVER:
      image(end2, 320, 240);
      if(mouseX > 200 && mouseX < 440){
        if(mouseY > 300 && mouseY < 360){
          image(end1, 320, 240);
          if(mousePressed){
            hpX = 40;
            enemyX = -30;
            enemyY = floor(random(60,400));
            fighterX = width/2;
            fighterY = height/2;
            gameState = GAME_RUN;
            enemyState = C;
          }
        }
      }
    break;
  }
}

void keyPressed(){
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = true;
      break;
      case DOWN:
        downPressed = true;
      break;
      case LEFT:
        leftPressed = true;
      break;
      case RIGHT:
        rightPressed = true;
      break;
    }
    if(keyCode ==' ' && countBulletFrame > 15 && num_bullet <= 5){
          bulletPressed = true;
            bulletPositionX[ID_bullet] = (int)fighterX;
            bulletPositionY[ID_bullet] = (int)fighterY;
            bullet_appear[ID_bullet] = true;
            countBulletFrame=0;
            ID_bullet++;
            num_bullet++;
            if(ID_bullet>=bulletPositionX.length){
              ID_bullet=0;
            }
      }
  }
}

void keyReleased(){
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
      break;
      case DOWN:
        downPressed = false;
      break;
      case LEFT:
        leftPressed = false;
      break;
      case RIGHT:
        rightPressed = false;
      break;
    }
  }
}
