/***
* Name: conveyor
* Author: huy
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model conveyor

global {
	file coal_shapefile <- file("../includes/coal.shp");
	file rotate_animation <- file("../includes/rotate_animation.shp");
	list<geometry> coal_shapes;
	point o <- {100,100,0};
	int conveyor_length <- 250;
	int conveyor_width;
	int conveyor_depth;
	//geometry shape <- envelope(coal_shapefile) * 100;
	geometry shape <- cube(400);
	init {
		create conveyor {
			color <- #grey;
			shape <-box(conveyor_length,40,1);
			location <- {o.x-10+conveyor_length/2,100,40};
			num_motors <- (conveyor_length - 40) div 50;
			distance_between_motors <- (conveyor_length - 40) / num_motors;
		}
		create terminal number:2 {
			color <- #blue;
			shape <- box(20,50,50);
		}
		terminal[0].location <- {o.x,o.y,0};
		terminal[1].location <- {o.x-20+conveyor_length,o.y,0};
		create motor number:conveyor[0].num_motors-1 {
			color <- #yellow;
			shape <- cylinder(5,40);
			theta <- 0;
		}
		motor[0].location <- {130,100,35};
		motor[1].location <- {170,100,35};
		float x_motor <- o.x + 10 + conveyor[0].distance_between_motors;
		loop i from:0 to:conveyor[0].num_motors-2 {
			motor[i].location <- {x_motor,80,35};
			x_motor <- x_motor + conveyor[0].distance_between_motors;
		}
		create motor_animation from:rotate_animation with:[str_color::string(get("color"))] {
			if (str_color = "yellow") {
				color <- #yellow;
			}
			else {
				color <- #black;
			}
			shape <- rotated_by(shape,-90,{1,0,0});
			location <- {0,0,0};
			
		}
		create coal_shape from:coal_shapefile;
		create coal number:10 {
			shape <- coal_shape[rnd(6)].shape;
			color <- #black;
			location <- any_location_in(intersection(terminal[0],conveyor[0]));
			location <- {location.x, location.y, location.z +42};
			heading <- 0.0;
			pitch <- 0.0;
			roll <- 0.0;
			speed <- 1.0;
			
		}
		create cam number:4 {
			color <- #red;
		}
		// init camera no.A
		cam[0].rotate_para <- 0::{0,0,0};
		cam[0].shape <- box(5,5,10);
		cam[0].location <- {o.x+conveyor_length-50,o.y,60};
		// init camera no.B
		cam[1].rotate_para <- -30::{1,0,0};
		cam[1].shape <- box(5,10,5);
		cam[1].location <- {o.x+conveyor_length-50,o.y-35,50};
		// init camera no.C
		cam[2].rotate_para <- 30::{1,0,0};
		cam[2].shape <- box(5,10,5);
		cam[2].location <- {o.x+conveyor_length-50,o.y+35,50};
		// init camera no.D
		cam[3].rotate_para <- 45::{0,1,0};
		cam[3].shape <- box(10,5,5);
		cam[3].location <- {o.x+conveyor_length-30,o.y,55};
	}
	reflex update when:every(3#cycle) {
		create coal number:10 {
			shape <- coal_shape[rnd(6)].shape;
			color <- #black;
			location <- any_location_in(intersection(terminal[0],conveyor[0]));
			location <- {location.x, location.y, location.z +42};
			heading <- 0.0;
			pitch <- 0.0;
			roll <- 0.0;
			speed <- 1.0;
			
		}
	}
}
species coal_shape {
}
species motor_animation {
	string str_color;
	rgb color;
	aspect default {
		draw shape color:color size:20;
	}
}

species conveyor skills:[moving3D] {
	int num_motors;	
	float distance_between_motors;
	rgb color;
	aspect default {
		draw shape color:color;
	}
}
species coal skills:[moving3D] {
	rgb color;
	
	reflex update {
		if (location.x > o.x + conveyor_length - 20) {
			do die;
		}
	}
	reflex moving {
		do move;
	}
	aspect default {
		draw shape size:5 depth:4 color:color;
	}	
}
species motor skills:[moving3D] {
	rgb color;
	int theta;
	reflex moving when:every(1 #cycle){
		theta <- theta + 10;
		if (theta >= 360) {
			theta <- 0;
		}
	}
	aspect default {
		draw shape color:color rotate:-90::{1,0,0};
		draw motor_animation[0].shape size:10 color:motor_animation[0].color rotate:-theta::{0,1,0} at: {location.x,location.y+40.2,location.z};
		draw motor_animation[1].shape size:10 color:motor_animation[1].color rotate:-theta::{0,1,0} at: {location.x,location.y+40.2,location.z};
	}
}
species terminal {
	rgb color;
	aspect default {
		draw shape color:color;
	}
}
species cam {
	rgb color;
	pair<float,point> rotate_para;
	aspect default {
		draw shape color:color rotate:rotate_para;
	}
}

experiment sim type:gui {
	output {
		display default type:opengl background:#grey {
			graphics "env" {
				//draw polygon([{0,0}, {0,10}, {10,10}, {10,0}]) depth:5;
				//draw box(20,50,50);
			}
			species conveyor;
			species coal;
			species motor;
			species cam;
			species terminal;
			species motor_animation;
		}
	}
}


