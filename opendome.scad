$fn = 100;
cap_type = "dome"; //"flat"

leg_height = 40;
leg_diameter = 10;
tail_height = 4;

base_diameter = 21;
base_height = 2;

sphere_radius = 20;
sphere_sector_height = 3;

grove_strafe = -19 + 0.7;
grove_widths = [3.0, 2.0, 1.5, 1.25, 1.0, 0.75, 0.5, 0.35];
//grove_widths = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9];

printer_center_y = 50;
printer_center_x = 50;

module domed_cap(){
    translate([0, 0, -2*(sphere_radius) + sphere_sector_height]){
        difference(){
            translate([0,0,sphere_radius]){
                sphere(r=sphere_radius);
            }
            cylinder(h=2*sphere_radius - sphere_sector_height, d=2*4*sphere_radius);
        }
    }
}
module flat_cap(){
    cylinder(d=base_diameter, h=sphere_sector_height);
}

module cap_base(){
    translate([0,0, leg_height,]){
        cylinder(h=base_height, d=base_diameter);
    }
}
module leg(){
    cylinder(h=leg_height, d=leg_diameter);
}

module hexagon(){
    translate([0, 0, leg_height - tail_height/2]){
        cylinder(h=tail_height,
                 d=leg_diameter*1.5,
                 center=true,
                 $fn=6);
        }
    }

module groves(grove_width=3){
    for(i=[1 : 40/grove_width]){
        translate([0, grove_strafe + i*grove_width*2, (leg_height + base_height + sphere_sector_height)/2]){
            cube([sphere_radius*1.5, grove_width, (leg_height + base_height + sphere_sector_height)*1.5], center=true);
        }
    }
}

module label(grove_width){
    color("red"){
        mirror([1, 1, 0]){
            translate([0, 0, -1]){
                linear_extrude(height=2) {
                   text(text=str(grove_width), size=2.5,
                        font="Courier New:style=Bold",
                        valign="center", halign="center");
                }
            }
        }
    }
}

module opendome(grove_width){
    difference(){
        leg();
        label(grove_width);
    }
    hexagon();
    cap_base();

    difference(){
        translate([0, 0, leg_height + base_height]){
            if (cap_type=="dome"){
                domed_cap();
            }
            else if (cap_type=="flat"){
                flat_cap();
            }
        }
        groves(grove_width=grove_width);
    }
}



for (i = [0 : len(grove_widths) - 1]){
    translate([base_diameter*1.5*(i%4) - printer_center_x,
               base_diameter*0.5*(i) - printer_center_y, 0]){
        opendome(grove_width=grove_widths[i]);
        //echo(grove_widths[i]);
    }
}
