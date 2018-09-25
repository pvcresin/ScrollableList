class ScrollableList {
  boolean 
    vertical = false, 
    pressed = false;

  PGraphics pg;
  float x, y, w, h;
  float pos = 0, speed = 0.01, decreaseRate = 0.9;

  // items
  ArrayList<String> items = new ArrayList<String>();
  int itemLength = 30;
  int startIndex, endIndex;

  // scrollbar
  int scrollbarWeight = 4;
  int scrollbarLengthMin = scrollbarWeight * 3;
  float scrollbarLength;

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

  void updatePos(float diff) {
    pg.beginDraw();
    pg.background(255);

    if (items.size() != 0) {
      pg.pushMatrix();
      if (vertical) pg.translate(0, -pos);
      else pg.translate(-pos, 0);

      int totalLength = itemLength * items.size();

      float maxpos = vertical 
        ? max(0, totalLength - h) 
        : max(0, totalLength - w);

      pos = constrain(pos - diff, 0, maxpos);

      int itemNumInArea = vertical
        ? ceil(h / float(itemLength))
        : ceil(w / float(itemLength));

      startIndex = max(0, floor(
        map(pos, 0, totalLength, 0, items.size())
        ) - itemNumInArea);

      endIndex = vertical
        ?
        min(floor(
        map(pos + h, 0, totalLength, 0, items.size())
        ) + itemNumInArea, items.size() - 1)
        : 
        min(floor(
        map(pos + w, 0, totalLength, 0, items.size())
        ) + itemNumInArea, items.size() - 1);

      pg.textAlign(LEFT, TOP);

      // render items only needed ( height + 2 * margin( = height) )
      if (vertical) pg.translate(0, startIndex * itemLength);
      else pg.translate(startIndex * itemLength, 0);

      for (int i = startIndex; i <= endIndex; i++) {
        drawItem(items.get(i));
        if (vertical) pg.translate(0, itemLength);
        else pg.translate(itemLength, 0);
      }

      pg.popMatrix();

      // scrollbar
      drawScrollbar();
    }

    pg.endDraw();
  }

  void drawItem(String item) {
    pg.fill(80);
    pg.stroke(0);
    if (vertical) pg.rect(0, 0, w, itemLength);
    else pg.rect(0, 0, itemLength, h);
    pg.fill(0);
    pg.text(item, 0, 0);
  }

  void drawScrollbar() {
    int totalLength = itemLength * items.size();

    if (vertical && totalLength < h) return;
    if (!vertical && totalLength < w) return;

    float maxpos = vertical
      ? max(0, totalLength - h)
      : max(0, totalLength - w);

    pg.noStroke();
    pg.fill(200, 200);

    float idealScrollbarLength = vertical
      ? h * (h / float(totalLength))
      : w * (w / float(totalLength));

    scrollbarLength = max(scrollbarLengthMin, idealScrollbarLength);
    float scrollPos = vertical
      ? (h - scrollbarLength) * (pos / maxpos)
      : (w - scrollbarLength) * (pos / maxpos);

    if (vertical) pg.translate(0, scrollPos);
    else pg.translate(scrollPos, 0);

    if (vertical) {
      pg.rect(w - scrollbarWeight, 0, scrollbarWeight, scrollbarLength);
    } else { 
      pg.rect(0, h - scrollbarWeight, scrollbarLength, scrollbarWeight);
    }
  }

  void clicked() {
    if (!(0 < mouseX && mouseX < w && 0 < mouseY && mouseY < h)) return;

    int index = vertical
      ? floor(
      map(mouseY - y + pos, 0, itemLength * items.size(), 0, items.size())
      )
      : floor(
      map(mouseX - x + pos, 0, itemLength * items.size(), 0, items.size())
      );

    if (index < 0 || items.size() - 1 < index) {  // out
      println("out of list");
    } else {
      println("clicked: " + items.get(index));
    }
  }

  void pressed() {
    if (x < mouseX && mouseX < x + w && y < mouseY && mouseY < y + h) pressed = true;
    else pressed = false;
  }
  void dragged() {    
    if (!pressed) return;

    if (vertical) updatePos(mouseY - pmouseY);
    else updatePos(mouseX - pmouseX);
  }
  void released() {
    if (!pressed) return;
    else pressed = false;

    speed = vertical ? mouseY - pmouseY : mouseX - pmouseX;
  }
}