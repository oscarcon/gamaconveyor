/***
* Name: conveyor
* Author: huy
* Description: 
* Tags: Tag1, Tag2, TagN
***/

model conveyor

global {
	init {
		
	}
}
species conveyor {
	
}
species coal {
	
}
species motor {
	
}
species cam {
	
}
species terminal {
	
}
experiment sim type:gui {
	output {
		display default type:opengl background:#grey {
			species conveyor;
			species coal;
			species motor;
			species cam;
			species terminal;
		}
	}
}


