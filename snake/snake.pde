import processing.sound.*;

final int SIZE = 20;
float STEP = 2;

final int BUTTON_SLOW     = 2;
final int BUTTON_FAST     = 3;
final int BUTTON_VERYFAST = 4;

class Cell {
  float x;
  float y;
  color c;
  boolean farFromHead;
  boolean farFromNeighbor;

  float lastdx;
  float lastdy;

  Cell(float x, float y, color c) {
    this.x = x;
    this.y = y;
    this.c = c;
  }

  void display() {

    fill(c);

    ellipse(x, y, SIZE, SIZE);


  }

  void step(float dx, float dy) {
    x += dx;
    y += dy;
  }

  void stepTo(float targetX, float targetY, boolean head) {
      float distX = x - targetX;
      float distY = y - targetY;
      float dist = sqrt(distX*distX + distY*distY);

      if ((!head) && (dist < SIZE*0.5)) {
        farFromHead = true;
        return;
      }
      if (!head) {
        farFromNeighbor = true;
      }

      step(-distX/dist*STEP, -distY/dist*STEP);
  }

  void moveTo(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class Button {
    int x;
    int y;
    String text;
    int type;
    int width;

    Button(int x, int y, int type, String text) {
        this.x = x;
        this.y = y;
        this.type = type;
        this.text = text;
    }

    boolean mouseOver() {
        if (mouseX > x && mouseX < x + width && mouseY > y - 30 && mouseY < y + 15) {
            return true;
        }
        return false;
    }

    void display() {
        textSize(36);
        fill(255);
        stroke(255);
        width = text.length() * 23;
        if (mouseOver()) {
            fill(200);
            stroke(200);
        }
        rect(x, y - 30, width, 30);
        fill(228, 135, 135);
        text(text, x, y);
    }
}

ArrayList<Cell> snake = new ArrayList<Cell>();
float direction = 0;
boolean gameOver;

color body;

Cell food;

SoundFile dieSound;
SoundFile eatSound;

boolean choosingSpeed;

Button btnSlow;
Button btnFast;
Button btnVeryFast;

void setup() {
  size(1245, 750);
  surface.setTitle("ЧЕРВЯК");
  surface.setResizable(false);
  surface.setLocation(5, 5);

  body = color(150, 150, 0);

  dieSound = new SoundFile(this, "die.wav");
  eatSound = new SoundFile(this, "eat.wav");

  for (int i = 0; i < 5; i++) {
    snake.add(new Cell(275, 300, color(150, 150, 0)));
  }
  food = new Cell(random(30, 1200), random(30, 700), color(28, 155, 52));

  choosingSpeed = true;
}

float distance(float x1, float y1, float x2, float y2) {
  float distX = x1 - x2;
  float distY = y1 - y2;
  return sqrt(distX*distX + distY*distY);
}

void draw() {
  background(122, 216, 164);

  if (choosingSpeed) {

    btnSlow = new Button(500, 300, BUTTON_SLOW, "медленный");
    btnFast = new Button(500, 400, BUTTON_FAST, "быстрый");
    btnVeryFast = new Button(500, 500, BUTTON_VERYFAST, "очень быстрый");
    btnSlow.display();
    btnFast.display();
    btnVeryFast.display();
    fill(255, 128, 128);
    textSize(36);
    text("Скорость червяка", 450, 200);

  } else {
      snake.get(0).stepTo(mouseX, mouseY, true);
      for (int i = snake.size() - 1; i >= 1; i--) {
        snake.get(i).stepTo(snake.get(i-1).x, snake.get(i-1).y, false);
      }

      noStroke();
      food.display();
      for (int i = 0; i < snake.size(); i++) {
        snake.get(i).display();
      }

      if (keyPressed) {
        if (key == 'a') {
          direction -= 0.1;
        }
        if (key == 'd') {
          direction += 0.1;
        }
      }

      if (snake.get(0).x < 0 || snake.get(0).y < 0 || snake.get(0).x > 1245 || snake.get(0).y > 750) {
        gameOver();
      }

      for (int i = 0; i < snake.size(); i++) {
        if (i != 0 && i != 1) {
          if ((distance(snake.get(0).x, snake.get(0).y, snake.get(i).x, snake.get(i).y) < SIZE*0.5) &&
              snake.get(i).farFromHead &&
              snake.get(i).farFromNeighbor) {
            gameOver();
          }
        }
      }

      if (distance(snake.get(0).x, snake.get(0).y, mouseX, mouseY) < SIZE*0.5) {
        gameOver();
      }



      if (distance(snake.get(0).x, snake.get(0).y, food.x, food.y) < SIZE) {
        for (int i = 0; i < 5; i++) {
          if ((snake.size() >= 25) && (snake.size() < 55))
            body = color(234, 108, 76);
          if ((snake.size() >= 55) && (snake.size() < 100))
            body = color(161, 232, 70);
          if ((snake.size() >= 100) && (snake.size() < 150))
            body = color(70, 232, 98);
          if ((snake.size() >= 150) && (snake.size() < 200))
            body = color(191, 83, 173);
          if ((snake.size() >= 200) && (snake.size() < 250))
            body = color(113, 76, 227);
          if ((snake.size() >= 250) && (snake.size() < 300))
            body = color(214, 171, 84);
          if (snake.size() >= 300 && snake.size() < 350)
            body = color(63, 197, 232);
          if (snake.size() >= 350 && snake.size() < 400)
            body = color(255, 153, 153);
          if (snake.size() >= 400 && snake.size() < 450)
            body = color(102, 0, 204);
          if (snake.size() >= 450 && snake.size() < 500)
            body = color(153, 0, 76);
          if (snake.size() >= 500 && snake.size() < 550)
            body = color(255, 102, 102);
          if (snake.size() >= 550 && snake.size() < 600)
            body = color(0, 255, 255);
          if (snake.size() >= 600)
            body = color(181, 243, 255);

          snake.add(new Cell(snake.get(snake.size()-1).x, snake.get(snake.size()-1).y, body));
        }
        food.moveTo(random(30, 1200), random(30, 700));
        eatSound.play();
      }
  }
}

void gameOver() {
  dieSound.play();
  gameOver = true;
  fill(255, 0, 0);
  textSize(36);
  text("ЧЕРВЯК", 600, 120);
  textSize(80);
  text("ВРЕЗАЛСЯ!", 460, 200);
  textSize(18);
  text("Нажми любую кнопку", 565, 500);
  noLoop();
}

void keyPressed() {
  if (!gameOver) {
    loop();
  } else {
    gameOver = false;
    snake = new ArrayList<Cell>();
    for (int i = 0; i < 5; i++) {
      snake.add(new Cell(275, 300, color(139, 112, 69)));
    }
    body = color(139, 112, 69);
    food.moveTo(random(30, 770), random(30, 570));
    loop();
  }
}

void mousePressed() {
  if (choosingSpeed) {
    if (btnSlow.mouseOver()) {
        STEP = BUTTON_SLOW;
    }
    if (btnFast.mouseOver()) {
        STEP = BUTTON_FAST;
    }
    if (btnVeryFast.mouseOver()) {
        STEP = BUTTON_VERYFAST;
    }
    choosingSpeed = false;
  }
  if (!gameOver) {
  } else {
    gameOver = false;
    snake = new ArrayList<Cell>();
    for (int i = 0; i < 5; i++) {
      snake.add(new Cell(275, 300, color(139, 112, 69)));
    }
    body = color(139, 112, 69);
    food.moveTo(random(30, 770), random(30, 570));
    loop();
  }
}
