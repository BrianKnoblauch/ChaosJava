package chaos;

import  java.awt.*;
import  java.awt.event.*;

public class Main extends Frame {
    public Main() {
        addWindowListener(new MyWindowAdapter());
    }
    @Override
    public void paint(Graphics g) {              
        Dimension d=this.getSize();        
        int x=(d.width-1)/2;
        int y=(d.height-1)/2;                
        int minx=this.getInsets().left;
        int maxx=d.width-this.getInsets().right-1;
        int miny=this.getInsets().top;
        int maxy=d.height-this.getInsets().bottom-1;        
        g.setColor(new Color(0,0,0));
        g.fillRect(minx,miny,maxx,maxy);
        for (int count=0; count <=500000; count++) {
            switch((int) Math.floor(Math.random()*3)) {
                case 0:
                    x=(x+((d.width-1)/2))/2;
                    y=(y+miny)/2;
                    g.setColor(new Color(255,0,0));
                    break;
                case 1:
                    x=(x+maxx)/2;
                    y=(y+maxy)/2;
                    g.setColor(new Color(0,255,0));
                    break;
                case 2:
                    x=(x+minx)/2;
                    y=(y+maxy)/2;
                    g.setColor(new Color(0,0,255));
                    break;
                /* case 3:
                    x=(x+((d.width-1)/2))/2;
                    y=(y+((d.height-1)/2))/2;
                    g.setColor(new Color(255,255,255));
                    break; */
            }
            g.drawLine(x,y,x,y);
        }
    }
    public static void main(String[] args) {
        Main output = new Main();
        output.setSize(new Dimension(800, 600));
        output.setResizable(false);
        output.setTitle("Chaos");        
        output.setVisible(true);
    }
}
    
class MyWindowAdapter extends WindowAdapter {
    @Override
    public void windowClosing(WindowEvent we) {
        System.exit(0);
    }
}