void canvas() {
size(800, 600); //canvas size
background(247, 216, 131); //background color (yellow)
stroke(170, 170, 170);
}
/* 
void coordGrid() {
line(100,0,100,600); 
line(200,0,200,600);
line(300,0,300,600);
line(400,0,400,600);
line(500,0,500,600);
line(600,0,600,600);
line(700,0,700,600);
line(0,100,800,100);
line(0,200,800,200);
line(0,300,800,300);
line(0,400,800,400);
line(0,500,800,500);
}
*/

void head(){
strokeWeight(0);
stroke(89, 67, 48);
fill(89, 67, 48);
circle(450,240,80); //top part of hair
rect(412,230,75,100); //bottom of hair
fill(232, 212, 188);
rect(435,280,30,40); //neck
ellipse(450,250,65,75); //head
fill(66, 55, 40);
circle(433,245,10); //(viewers) left eye
circle(465,245,10); //(viewers) right eye
strokeWeight(1);
stroke(66, 55, 40);
line(424,240,435,243); //eyelashes
line(474,240,463,243); //eyelashes
}

void body(){
strokeWeight(0);
fill(255, 128, 102);
rect(395, 295, 110, 130, 35, 35, 0, 0); //curved shoulders + torso (upper body)
}

void chair() {
fill(235, 227, 213);
ellipse(450,550,120,45); //bottom of chair
fill(173, 147, 123);
rect(440,440,17,110,0,0,5,5); //leg
fill(235, 227, 213);
ellipse(450,445,150,50); //seat
}

void deskLegs(){
fill(242, 238, 235);
strokeWeight(1);
stroke(209, 204, 201);
rect(610,400,20,160); //desk's leg (top right)
rect(170,400,20,160); //desk's leg (top left)
rect(120,450,20,160); //desk's leg (bottom left)
rect(560,450,20,160); //desk's leg (bottom right)
}

void deskTop(){
quad(150, 380, 650, 380, 600, 430, 100, 430); //desk's top
rect(100,430,500,20); //front (thin) part of desk
quad(600, 430, 600, 450, 650, 400, 650, 380); //slanted (thin) portion of desk
}

void laptop(){
strokeWeight(0.8);
fill(222, 222, 222);
quad(345,385,415,385,395,415,325,415); //bottom of laptop
rect(315,355,80,60); //top of laptop
fill(245, 245, 245);
circle(355,385,15); //logo
}

void stationery(){
strokeWeight(.4);
fill(61, 62, 64);
rect(540, 385, 4, 35, 10, 10, 10, 10); 
fill(191, 191, 191);
rect(520, 383, 4, 35, 10, 10, 10, 10); 
rect(527, 388, 4, 35, 10, 10, 10, 10); 
strokeWeight(4);
line(551, 389, 537, 424);
stroke(245, 169, 169);
line(515, 387, 510, 420);
stroke(247, 191, 131);
line(505, 390, 506, 423);
stroke(143, 126, 107);
line(490, 388, 497, 421);
stroke(170, 217, 230);
line(484, 387, 484, 420);
}
