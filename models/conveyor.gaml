/***
* Name: conveyor
* Author: huy
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model conveyor

global {
	geometry than <- image_file("../includes/polygon.png") as geometry;
	geometry shape <- cube(100);
	init {
		create coal number:1 {
			//shape <- obj_file("../includes/coal0.obj") as geometry;
			//location <- any_location_in(world.shape);
		}
		
	}
}
species conveyor skills:[moving3D] {
	aspect default {
	}
}
species coal skills:[moving3D] {
	aspect default {
		draw shape;
	}	
}
species motor skills:[moving3D] {
	
}
species cam {
	
}
species terminal {
	
}
experiment sim type:gui {
	output {
		display default type:opengl background:#grey {
			graphics "env" {
				draw polygon([{0,0}, {0,10}, {10,10}, {10,0}]) depth:5;
			}
			species conveyor;
			species coal aspect:default;
			species motor;
			species cam;
			species terminal;
		}
	}
}


