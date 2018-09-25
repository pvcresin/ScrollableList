ScrollableList list;

void setup() {
  size(600, 900);

  list = new ScrollableList();
  //list.vertical = true;
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
  list.pressed();
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

void keyPressed() {
 list.vertical = !list.vertical; 
}