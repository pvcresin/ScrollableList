ScrollableList list;

void setup() {
  size(600, 900);

  list = new ScrollableList();
  list.setPos(100, 100, 400, 400);

  for (int i = 0; i < 60; i++) {
    list.addItem("" + i);
  }
}

void draw() {
  background(128);

  list.draw();
}


void mousePressed() {
  //list.addItem("" + list.items.size());
  //list.pressed();
}

void mouseClicked() {
  list.clicked();
}

void mouseDragged() {
  list.dragged();
}

void mouseReleased() {
  list.released();
}


class ScrollableList {
  PGraphics pg;
  float x, y, w, h;
  float posY = 0, speed = 0.01, decreaseRate = 0.9;

  // items
  ArrayList<String> items = new ArrayList<String>();
  int itemHeight = 30;
  int startIndex, endIndex;

  // scrollbar
  int scrollbarWidth = 4;
  int scrollbarHeightMin = scrollbarWidth * 3;
  float scrollbarHeight;

  ScrollableList() {
    pg = createGraphics(50, 50);
  }

  void addItem(String s) {
    items.add(s);
  }

  void setPos(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    pg.setSize((int)w, (int)h);
  }

  void draw() {
    if (speed != 0) {
      speed *= decreaseRate;
      if (abs(speed) < 0.01) speed = 0;
      updatePos(speed);
    }

    image(pg, x, y);
  }

  void updatePos(float dy) {
    pg.beginDraw();
    pg.background(255);

    if (items.size() != 0) {
      pg.pushMatrix();
      pg.translate(0, -posY);

      int totalHeight = itemHeight * items.size();
      float maxPosY = max(0, totalHeight - pg.height);
      posY = constrain(posY - dy, 0, maxPosY);

      startIndex = floor(
        map(posY, 0, totalHeight, 0, items.size())
        );
      endIndex = min(floor(
        map(posY + pg.height, 0, totalHeight, 0, items.size())
        ), items.size() - 1);

      pg.textAlign(LEFT, TOP);
      
      // render items only needed
      //pg.translate(0, startIndex * itemHeight);
      //for (int i = startIndex; i <= endIndex; i++) {
      //  drawItem(items.get(i));
      //  pg.translate(0, itemHeight);
      //}
      
      for (String item : items) {        
        drawItem(item);
        pg.translate(0, itemHeight);
      }

      pg.popMatrix();
      drawScrollbar();
    }

    pg.endDraw();
  }

  void drawItem(String item) {
    pg.fill(80);
    pg.stroke(0);
    pg.rect(0, 0, pg.width, itemHeight);
    pg.fill(0);
    pg.text(item, 0, 0);
  }

  void drawScrollbar() {
    int totalHeight = itemHeight * items.size();

    if (totalHeight < pg.height) return;

    float maxPosY = max(0, totalHeight - pg.height);

    pg.noStroke();
    pg.fill(200, 200);

    float idealScrollbarHeight = pg.height * (pg.height / float(totalHeight));

    scrollbarHeight = max(scrollbarHeightMin, idealScrollbarHeight);
    float sY = (pg.height - scrollbarHeight) * (posY / maxPosY);

    pg.translate(0, sY);
    pg.rect(pg.width - scrollbarWidth, 0, scrollbarWidth, scrollbarHeight);
  }

  void clicked() {
    int index = floor(
      map(mouseY - y + posY, 0, itemHeight * items.size(), 0, items.size())
      );

    if (index < 0 || items.size() <= index) {  // out
      println("out of list");
    } else {
      println("clicked: " + items.get(index));
    }
  }

  void pressed() {
  }
  void dragged() {
    updatePos(mouseY - pmouseY);
  }
  void released() {
    speed = mouseY - pmouseY;
  }
}