PImage start2;
PImage start1;
PImage treasure; 
PImage fighter;
PImage enemy;
PImage end2;
PImage end1;
PImage bullet;
PImage bg1;
PImage bg2; 
PImage hp;
float scrollRight;

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
int gameState;

final int C = 0;
final int B = 1;
final int A = 2;
int enemyState;

int hpX;

PImage [] enemyPosition = new PImage [5];
float enemyC [][] = new float [5][2];       
float enemyB [][] = new float [5][2];
float enemyA [][] = new float [8][2];  
float spacingX;
float spacingY;

//flame
int flameNum;
int flameCurrent;
PImage [] hit = new PImage [5];
float hitPosition [][] = new float [5][2]; 

float treasureX;
float treasureY;
float fighterX;
float fighterY;
float enemyFlyY;
float [] bulletNumX = new float [5];
float [] bulletNumY = new float [5];

float fighterSpeed;
float enemySpeed;
int bulletNumSpeed;
float addSpeed ;

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

int bulletNum = 0;
boolean [] bulletNumLimit = new boolean[5];

void setup () {  
  
  size (640,480) ;
  frameRate(60);
    
  for ( int i = 0; i < 5; i++ ){
    hit[i] = loadImage ("img/flame" + (i+1) + ".png" );
  }
  
  start2 = loadImage ("img/start2.png");
  start1 = loadImage ("img/start1.png");  
  bg1 = loadImage ("img/bg1.png");
  bg2 = loadImage ("img/bg2.png");
  hp = loadImage ("img/hp.png");
  treasure = loadImage ("img/treasure.png");
  fighter = loadImage ("img/fighter.png");
  enemy = loadImage ("img/enemy.png");  
  end2 = loadImage ("img/end2.png");
  end1 = loadImage ("img/end1.png");
  bullet = loadImage ("img/shoot.png");
  
  gameState = 0;
  enemyState = 0;
  hpX = 40;
  
  treasureX = floor( random(50, width - 40) );
  treasureY = floor( random(50, height - 60) );
  fighterX = width - 65 ;
  fighterY = height / 2 ; 

  //speed
  fighterSpeed = 5 ;
  enemySpeed = 4 ;
  bulletNumSpeed = 3 ;
  addSpeed =0.02;
  
  //flame
  flameNum = 0;
  flameCurrent = 0;
  for ( int i = 0; i < hitPosition.length; i ++){
    hitPosition [i][0] = 1000;
    hitPosition [i][1] = 1000;
  }

  //no bullet
  for (int i =0; i < bulletNumLimit.length ; i ++){
    bulletNumLimit[i] = false;
  }

  //enemy line
  spacingX = 0;  
  spacingY = -60; 
  enemyFlyY = floor( random(80, 400) );   
  
  for (int i = 0; i < 5; i++){
   enemyPosition [i] = loadImage ("img/enemy.png");  
   enemyC [i][0] = spacingX;
   enemyC [i][1] = enemyFlyY; 
   spacingX -= 80;
  }

}

void draw() { 
  background(255) ;   
  
  switch (gameState) {
    case GAME_START:
      image (start2, 0, 0);
      
      if ( mouseX > 200 && mouseX < 460 
        && mouseY > 370 && mouseY < 420){
        image(start1, 0, 0);
      }
    break;  
    case GAME_RUN:
    
    //bg
      image (bg2, scrollRight, 0);
      image (bg1, scrollRight - width, 0);
      image (bg2, scrollRight - width * 2, 0); 
      
      scrollRight += 2;
      scrollRight %= width * 2;
      
    //treasure
      image (treasure, treasureX, treasureY);   
      
    //fighter
      image(fighter, fighterX, fighterY);
      
      if (upPressed && fighterY > 0) {
        fighterY -= fighterSpeed ;
      }
      if (downPressed && fighterY < height - 50) {
        fighterY += fighterSpeed ;
      }
      if (leftPressed && fighterX > 0) {
        fighterX -= fighterSpeed ;
      }
      if (rightPressed && fighterX < width - 50) {
        fighterX += fighterSpeed ;
      }  
        
    //flame
      image(hit[flameCurrent], hitPosition[flameCurrent][0], hitPosition[flameCurrent][1]);
      
      flameNum ++;
      if ( flameNum % (60/10) == 0){
        flameCurrent ++;
      } 
      if ( flameCurrent > 4){
        flameCurrent = 0;
      }
  
      if(flameNum > 31){
        for (int i = 0; i < 5; i ++){
          hitPosition [i][0] = 1000;
          hitPosition [i][1] = 1000;
        }
      }   
      
    //bullet
      for (int i = 0; i < 5; i ++){
        if (bulletNumLimit[i] == true){
          image (bullet, bulletNumX[i], bulletNumY[i]);
          bulletNumX[i] -= bulletNumSpeed;
        }
        if (bulletNumX[i] < - bullet.width){
          bulletNumLimit[i] = false;
        }
      }
    
      //enemy
      switch (enemyState) { 
        case C :        
        
          for ( int i = 0; i < 5; i++ ){
            image(enemyPosition[i], enemyC [i][0], enemyC [i][1]);
            
            for (int j = 0; j < 5; j++ ){
              if(bulletNumX[j] >= enemyC [i][0] - bullet.width 
                && bulletNumX[j] <= enemyC[i][0] + enemy.width 
                && bulletNumY[j] >= enemyC [i][1] - bullet.height 
                && bulletNumY[j] <= enemyC [i][1] + enemy.height
                && bulletNumLimit[j] == true){
                for (int k = 0;  k < 5; k++ ){
                  hitPosition [k][0] = enemyC [i][0];
                  hitPosition [k][1] = enemyC [i][1];
                }    
                enemyC [i][1] = -1000;
                enemyFlyY = floor( random(30,240) );
                bulletNumLimit[j] = false;
                flameNum = 0;     
              }
            }  
            
            if(fighterX >= enemyC [i][0] - fighter.width 
              && fighterX <= enemyC[i][0] + enemy.width 
              && fighterY >= enemyC [i][1] - fighter.height 
              && fighterY <= enemyC [i][1] + enemy.height){
              for (int j = 0;  j < 5; j++){
                hitPosition [j][0] = enemyC [i][0];
                hitPosition [j][1] = enemyC [i][1];
              }
              hpX -= 40;          
              enemyC [i][1] = -1000;
              enemyFlyY = floor( random(30,240) );
              flameNum = 0;  

            } else if (hpX <= 0) {
              gameState = 2 ;
              hpX = 40;
              fighterX = (width - 65);
              fighterY = height / 2 ;
            } else {
              enemyC [i][0] += enemySpeed;
              enemyC [i][0] %= width * 2;
            }      
          }
          
          if (enemyC [enemyC.length - 1][0] > width + 100 ) {        
            //enemyFlyX = -100 ;
            //enemyFlyX += enemySpeed ;
            enemyFlyY = floor( random(30,240) );
            
            spacingX = 0;  
            for (int i = 0; i < 5; i++){
              enemyB [i][0] = spacingX;
              enemyB[i][1] = enemyFlyY - spacingX / 2;
              spacingX -= 80;                 
            }
            enemyState = 1;
          }
        break ;             
        case B :

          for (int i = 0; i < 5; i++ ){
            image(enemyPosition[i], enemyB [i][0] , enemyB [i][1]);
            
            for(int j = 0; j < 5; j++){
              if ( bulletNumX[j] >= enemyB [i][0] - bullet.width 
                && bulletNumX[j] <= enemyB[i][0] + enemy.width 
                && bulletNumY[j] >= enemyB [i][1] - bullet.height 
                && bulletNumY[j] <= enemyB [i][1] + enemy.height
                && bulletNumLimit[j] == true){
                for(int k = 0;  k < 5; k++ ){
                  hitPosition [k][0] = enemyB [i][0];
                  hitPosition [k][1] = enemyB [i][1];
                }     
                enemyB [i][1] = -1000;
                enemyFlyY = floor( random(30,240) );
                bulletNumLimit[j] = false;
                flameNum = 0;
              }
            }   
            if ( fighterX >= enemyB [i][0] - fighter.width 
              && fighterX <= enemyB[i][0] + enemy.width 
              && fighterY >= enemyB [i][1] - fighter.height 
              && fighterY <= enemyB [i][1] + enemy.height){
              for (int j = 0;  j < 5; j++ ){
                 hitPosition [j][0] = enemyB [i][0];
                 hitPosition [j][1] = enemyB [i][1];
               }
              enemyB [i][1] = -1000;
              enemyFlyY = floor( random(200,280) );
              flameNum = 0; 
              hpX -= 40;
              //enemyFlyX = -100 ;
            } else if (hpX<= 0) {
              gameState = 2 ;
              hpX = 40;
              fighterX = (width - 65);
              fighterY = height / 2 ;
            } else {
              enemyB [i][0] += enemySpeed;
              enemyB [i][0] %= width * 2;
            }         
          }
          
          if (enemyB [4][0] > width + 100){
            enemyFlyY = floor( random(200,280) );
            enemyState = 2 ;
            
            spacingX = 0;  
            spacingY = -60; 
            for ( int i = 0; i < 8; i ++ ) {
              if ( i < 3 ) {
                enemyA [i][0] = spacingX;
                enemyA [i][1] = enemyFlyY - spacingX;
                spacingX -= 60;
              } else if ( i == 3 ){
                enemyA [i][0] = spacingX;
                enemyA [i][1] = enemyFlyY - spacingY;
                spacingX -= 60;
                spacingY += 60;
              } else if ( i > 3 && i <= 5 ){
                  enemyA [i][0] = spacingX;
                  enemyA [i][1] = enemyFlyY + spacingY;
                  spacingX += 60;
                  spacingY -= 60;
              } else {
                  enemyA [i][0] = spacingX;
                  enemyA [i][1] = enemyFlyY + spacingY;
                  spacingX += 60;
                  spacingY += 60;
              }            
            }     
          }
        break ;         
        case A :
        
          for( int i = 0; i < 8; i++ ){
            image(enemy, enemyA [i][0], enemyA [i][1]);     
                  
            for( int j = 0; j < 5; j++ ){
              if ( bulletNumX[j] >= enemyA [i][0] - bullet.width 
                && bulletNumX[j] <= enemyA [i][0] + enemy.width 
                && bulletNumY[j] >= enemyA [i][1] - bullet.height 
                && bulletNumY[j] <= enemyA [i][1] + enemy.height
                && bulletNumLimit[j] == true){
                for (int s = 0;  s < 5; s++){
                  hitPosition [s][0] = enemyA [i][0];
                  hitPosition [s][1] = enemyA [i][1];
                }
                enemyA [i][1] = -1000;
                enemyFlyY = floor( random(30,240) );
                bulletNumLimit[j] = false;
                flameNum = 0; 
              }
            }       
                
            if ( fighterX >= enemyA [i][0] - fighter.width 
              && fighterX <= enemyA[i][0] + enemy.width 
              && fighterY >= enemyA [i][1] - fighter.height  
              && fighterY <= enemyA [i][1] + enemy.height){
                
              for ( int j = 0;  j < 5; j++ ){
                hitPosition [j][0] = enemyA [i][0];
                hitPosition [j][1] = enemyA [i][1];
              }
                
              hpX -= 40;
              enemyA [i][1] = -1000;
              enemyFlyY = floor( random(50,420) );
              flameNum = 0; 
              
            } else if ( hpX <= 0 ) {
              gameState = 2 ;
              hpX = 40;
              fighterX = 575 ;
              fighterY = height/2 ;
            } else {
              enemyA [i][0] += enemySpeed;
              enemyA [i][0] %= width * 3;
            }     
          }
                
          if(enemyA [4][0] > width + 300 ){
            enemyFlyY = floor( random(80,400) );
            
            spacingX = 0;       
            for (int i = 0; i < 5; i++ ){
              enemyC [i][1] = enemyFlyY; 
              enemyC [i][0] = spacingX;
              spacingX -= 80;
            }
            
            enemyState = 0 ;            
          }  
          
        break ;
        default :
        break ;
      }

     //hp
      fill (#FF0000);
      rect (35, 15, hpX, 30);
      image(hp, 28, 15);
        if ( fighterX >= treasureX - fighter.width 
          && fighterX <= treasureX + treasure.width
          && fighterY >= treasureY - fighter.height
          && fighterY <= treasureY + treasure.height) {
            
          if (hpX < 200) {
            if (hpX < 200) {
              hpX += 20;
            }
            treasureX = floor( random(50,600) );         
            treasureY = floor( random(50,420) );
          }
        }    
    break ;     
    case GAME_OVER :
      image(end2, 0, 0);  
      
      if ( mouseX > 200 && mouseX < 470 
        && mouseY > 300 && mouseY < 350){
            image(end1, 0, 0);
      }
    break ;
    default :
    break ;
  }
  
}

void keyPressed (){
  if (key == CODED) {
    switch ( keyCode ) {
      case UP :
        upPressed = true ;
        break ;
      case DOWN :
        downPressed = true ;
        break ;
      case LEFT :
        leftPressed = true ;
        break ;
      case RIGHT :
        rightPressed = true ;
        break ;
    }
  }
}
  
void keyReleased () {
  if (key == CODED) {
    switch ( keyCode ) {
      case UP : 
        upPressed = false ;
        break ;
      case DOWN :
        downPressed = false ;
        break ;
      case LEFT :
        leftPressed = false ;
        break ;
      case RIGHT :
        rightPressed = false ;
        break ;
    }  
  }  
  if ( keyCode == ' ' ){
    if ( gameState ==  1 ){
      if ( bulletNumLimit[bulletNum] == false ) {
        bulletNumLimit[bulletNum] = true;
        bulletNumX[bulletNum] = fighterX - 10;
        bulletNumY[bulletNum] = fighterY + fighter.height/2;
        bulletNum ++;
      }   
      if ( bulletNum > 4 ) {
        bulletNum = 0;
      }
    }
  }
}

void mousePressed (){

  if ( gameState == 0 
    && mouseX > 200 && mouseX < 460 && mouseY > 370 && mouseY < 420){
    if ( mouseButton == LEFT) {
      gameState = 1;
      mouseButton = RIGHT;
    } 
  } else if ( gameState == 2
    && mouseX > 200 && mouseX < 470 && mouseY > 300 && mouseY < 350){
    if( mouseButton == LEFT ){
      treasureX = floor( random(50,600) );
      treasureY = floor( random(50,420) );
      
      enemyState = 0;      
      spacingX = 0;       
      for (int i = 0; i < 5; i++ ){
        hitPosition [i][0] = 1000;
        hitPosition [i][1] = 1000;
        bulletNumLimit[i] = false;
        enemyC [i][0] = spacingX;
        enemyC [i][1] = enemyFlyY; 
        spacingX -= 80;
      }
      gameState = 1 ; 
    }
  }
  
}
