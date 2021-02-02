package fr.bento8.to8.build;

public class Act{

	public String name = "";
	public String screenBorder;
	public String bgColorIndex;
	public String bgFileName;
	public String objPlacementFileName;
	public String paletteName;
	public String paletteFileName;	
	
	public Act(String name) throws Exception {
		this.name = name;
	}

	public void setProperty(String name, String[] values) {
		switch(name) {
			case "screenBorder":
				this.screenBorder = values[0];
				break;		
			case "backgroundSolid":
				this.bgColorIndex = values[0];
				break;
			case "backgroundImage":
				this.bgFileName = values[0];
				break;
			case "objectPlacement":
				this.objPlacementFileName = values[0];
				break;
			case "palette":
				this.paletteName = values[0];
				this.paletteFileName = values[1];
				break;
			default:
		}
	}	
}