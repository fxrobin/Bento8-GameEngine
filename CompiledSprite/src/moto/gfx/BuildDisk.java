package moto.gfx;

public class BuildDisk
{
	static ReadProperties confProperties;
	
  public static void main(String[] args)
  {
	  confProperties = new ReadProperties();
	  
	  for (String[] i : confProperties.animationImages.values()) {
	    System.out.println(i[3]);
	  }
  }
}
