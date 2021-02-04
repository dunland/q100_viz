int selectedID = 0; // is changed with UDP message

class CO2_plot
{
// ---------------------------------- data
float x_max, x_min, y_max, y_min;
float y2_max = 0, y2_min = 0;
int axis_width; // visual dimensions, should not be changed
int axis_height;
PVector position;
int number_of_xticks = 10;
int number_of_yticks = 5;
String x_label = "", y_label = "";
String title = "";
String[] x_tick_labels, y_tick_labels;
String[] y2_tick_labels;

boolean selected = false;

ArrayList<PVector> values = new ArrayList<PVector>();
ArrayList<PVector> values2 = new ArrayList<PVector>(); // TODO: conclude all values in one list of lists

// ----------------------------------- style
// determines style of graph display
int LINES = 0, POINTS = 1, BARPLOT = 2;
int drawMode = BARPLOT;

color axisColor = color(255, 255, 255);
color pointsColor = color(47, 169, 222);

// create plot with values only
CO2_plot(float x_min_in, float x_max_in, float y_min_in, float y_max_in)
{
        x_max = x_max_in;
        x_min = x_min_in;
        y_max = y_max_in;
        y_min = y_min_in;

        println(y_max);

}

// create plots with values and dimensions
CO2_plot(float x_min_in, float x_max_in, float y_min_in, float y_max_in, int axis_width_in, int axis_height_in)
{
        x_max = x_max_in;
        x_min = x_min_in;
        y_max = y_max_in;
        y_min = y_min_in;

        axis_width = axis_width_in;
        axis_height = axis_height_in;

        println(y_max);

}

void draw(int x, int y)
/* x and y are upper left boundary,
 * axis_width and axis_height are lower right graph boundary
 */
{
        float x_tick_spacer = axis_width / float(number_of_xticks);
        float y_tick_spacer = axis_height / float(number_of_yticks);
        // ---------------------------------- box around graph if selected
        if (selected)
        {
                stroke(150);
                noFill();
                rectMode(CORNER);
                rect(x - 35, y-10, axis_width + 70, axis_height + 70);
        }
        /* -------------------------- DRAW VALUES --------------------------- */
        // fill(255,0,0); // displays x and y untranslated
        // ellipse(x,y,20,20); // displays x and y untranslated
        pushMatrix();
        translate(x, y);
        // ellipse(this.axis_width, this.axis_height, 10, 10); // displays lower right boundaries
        try {
                if (drawMode == POINTS) {
                        for (PVector value : values)
                        {
                                fill(pointsColor);
                                noStroke();
                                ellipse(value.x * x_tick_spacer, axis_height - value.y * axis_height, 5, 5);
                        }
                }

                else if (drawMode == LINES)
                {
                        for (int i = 1; i<values.size(); i++)
                        {
                                stroke(pointsColor);
                                line(values.get(i).x * x_tick_spacer, axis_height - values.get(i).y * (axis_height / y_max), values.get(i-1).x * x_tick_spacer, axis_height - values.get(i-1).y * (axis_height / y_max));
                        }
                }

                else if (drawMode == BARPLOT)
                {
                        for (int i = 1; i<values.size(); i++)
                        {
                                stroke(150);
                                fill(pointsColor);
                                rectMode(CORNERS);
                                rect(values.get(i-1).x * x_tick_spacer, axis_height - values.get(i-1).y * (axis_height / y_max), values.get(i).x * x_tick_spacer, axis_height);
                        }
                }
                // connections TODO: make this more general (2nd axis plot)
                for (int i = 1; i<values.size(); i++)
                {
                        strokeWeight(3);
                        stroke(219, 117, 22);
                        line(values2.get(i).x * x_tick_spacer, axis_height - values2.get(i).y * (axis_height / y_max), values2.get(i-1).x * x_tick_spacer, axis_height - values2.get(i-1).y * (axis_height / y_max));
                        strokeWeight(1);
                }

        } catch(Exception e) {
                println(e + ".. probably no values in graph.");
        }
        popMatrix();
        // ---------------------------------- axes
        stroke(axisColor);
        line(x, y, x, y+axis_height); // left y-axis
        line(x, y+axis_height, x+axis_width, y+axis_height); // lower x-axis

        /* ---------------------------- TICKS --------------------------------*/
        // ------------------------------ ticks:
        for (int i = 0; i<number_of_xticks; i++)
        {
                float tickx = x + i * x_tick_spacer;
                float ticky = y+axis_height;
                stroke(axisColor);
                if (i > 0) line(tickx, ticky+2, tickx, ticky-2);

                // ------------------------------- tick labels:
                pushMatrix();
                translate(tickx, ticky);
                rotate(radians(90));
                textAlign(LEFT, CENTER);
                textSize(11);
                try {
                        fill(245);
                        text(x_tick_labels[i], 10, 0);
                } catch(Exception e) {
                        println("could not display ticks:\n" + e + "\n Probably amount of ticks and labels are not equal..");
                }
                popMatrix();
        }

        // ----------------------------- y-ticks
        for (int i = 0; i<number_of_yticks; i++)
        {
                float tickx = x;
                float ticky = y + axis_height - i * y_tick_spacer;
                stroke(axisColor);
                if (i > 0) line(tickx-2, ticky, tickx+2, ticky);

                // ------------------------------- tick labels:
                textAlign(RIGHT, CENTER);
                textSize(11);
                try {
                        text(y_tick_labels[i], tickx - 5, ticky);
                } catch(Exception e) {
                        println("could not display ticks:\n" + e + "\n Probably amount of ticks and labels are not equal..");
                }
        }

        /* -------------------------- AXIS LABELS --------------------------- */
        textAlign(CENTER,BOTTOM);
        text(x_label, x + axis_width/2, y + axis_height + 50);
        textAlign(RIGHT,CENTER);
        pushMatrix();
        translate(x - 40, y + axis_height / 2);
        rotate(radians(270));
        // text(y_label, x - 10, y + axis_height / 2);
        text(y_label, 0, 0);
        popMatrix();

        /* ---------------------------- TITLE ------------------------------- */
        pushMatrix();
        translate(x, y);
        textAlign(CENTER,CENTER);
        text(title, axis_width / 2, axis_height + 50);
        popMatrix();
}

void set_ticks(int number_of_xticks_in, int number_of_yticks_in)
{
        number_of_xticks = number_of_xticks_in;
        number_of_yticks = number_of_yticks_in;
}

void set_x_tick_labels(String[] x_tick_labels_in)
{
        x_tick_labels = x_tick_labels_in;
        number_of_xticks = x_tick_labels.length;
}

void set_y_tick_labels(String[] y_tick_labels_in)
{
        y_tick_labels = y_tick_labels_in;
        number_of_yticks = y_tick_labels.length;
}

void set_x_label(String x_label_in)
{
        x_label = x_label_in;
}

void set_y_label(String y_label_in)
{
        y_label = y_label_in;
}

void add_values(float x_value, float y_value)
{
        values.add(new PVector(x_value, y_value));
        println(" added value " + values.get(values.size() - 1).x + " " + values.get(values.size() - 1).y);
        if (y_value > y_max)
        {
                y_max = y_value;
                println("new y_max = " + y_max);
                update_tick_labels();
        }
        // if (x_value > x_max)
        // {
        //   x_max = x_value;
        //   // println("new x_max = " + x_max);
        //   update_tick_labels();
        // }
}

void add_values2(float x_value, float y_value)
{
        values2.add(new PVector(x_value, y_value));
        println(" added value " + values2.get(values2.size() - 1).x + " " + values2.get(values2.size() - 1).y);
        if (y_value > y2_max)
        {
                y2_max = y_value;
                println("new y_max = " + y2_max);
                update_tick_labels2();
        }
        // if (x_value > x_max)
        // {
        //   x_max = x_value;
        //   // println("new x_max = " + x_max);
        //   update_tick_labels();
        // }
}

void update_tick_labels()
{
        for (int tick_pos = 0; tick_pos < y_tick_labels.length; tick_pos++)
        {
                float tick_as_float = (y_max / axis_height) * number_of_yticks * tick_pos;
                // println("y: tick_as_float = " + tick_as_float);
                y_tick_labels[tick_pos] = nf(tick_as_float, 0, 2);
        }
        // for (int tick_pos = 0; tick_pos < x_tick_labels.length; tick_pos++)
        // {
        //   float tick_as_float = ((x_max/axis_height) / number_of_xticks) * tick_pos;
        //   println("x: tick_as_float = " + tick_as_float);
        //   x_tick_labels[tick_pos] = str(tick_as_float);
        // }
}

void update_tick_labels2() // TODO: make this more general for second axis
{
        for (int tick_pos = 0; tick_pos < y2_tick_labels.length; tick_pos++)
        {
                float tick_as_float = (y2_max / axis_height) * number_of_yticks * tick_pos;
                // println("y: tick_as_float = " + tick_as_float);
                y2_tick_labels[tick_pos] = nf(tick_as_float, 0, 2);
        }
        // for (int tick_pos = 0; tick_pos < x_tick_labels.length; tick_pos++)
        // {
        //   float tick_as_float = ((x_max/axis_height) / number_of_xticks) * tick_pos;
        //   println("x: tick_as_float = " + tick_as_float);
        //   x_tick_labels[tick_pos] = str(tick_as_float);
        // }
}

void set_title(String title_in)
{
        title = title_in;
}

} // plot class end
