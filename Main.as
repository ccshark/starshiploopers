package  {
	
	//-----------------------------
	// Import
	//-----------------------------
	
	import flash.display.MovieClip;
	import flash.media.Sound;
	
	public class Main extends MovieClip {
		/** 
		* Start adding stars and the vehicle to the stage 
		*/
		public function Main() {
			initUI();
			initSound();
			initStar();
			addVehicle();
		}
		
		/**
		* Add the vehicle to the stage and set the properties for vehicle position.
		* When the vehicle is added to the stage, start the initWords function.
		*/
		private function initSound() {
			var intro:Sound = new StartSound();
			intro.play();
		}
		
		private function addVehicle():void {
			var newVehicle:Vehicle = new Vehicle();
			newVehicle.x = stage.stageWidth * 0.5;
			newVehicle.y = stage.stageHeight * 0.5;
			addChild(newVehicle);
			initWords(newVehicle);
		}
		/**
		* start the LetterBox class and send the vehicle to LetterBox on start.
		*/
		private function initWords(newVehicle):void {
			var words:LetterBox = new LetterBox(newVehicle);
			addChild(words);
		}
		/**
		* Start the StarHandeler to print out stars on the stage
		*/
		private function initStar():void {
			var newStar:StarHandler = new StarHandler();
			addChild(newStar);
		}
		
		/**
		* Adds the UI to the stage and set parameters for position.
		*/
		private function initUI():void {
			var ui:PanelUI = new PanelUI();
			ui.y = stage.stageHeight * 0.8;
			ui.x = 160;
			addChild(ui);
		}
	}
}
