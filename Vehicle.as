package  {
	
	//-----------------------------
	// Import
	//-----------------------------
	
	import flash.display.MovieClip;
	
	/**
	* Sets the movement parameters for the ship. Vehicle is a child class to Steering,
	* so they can be accessed from the Steering-class.
	* When the ship is added to the stage, run addToStage in the Steering-class.
	*/
	public class Vehicle extends Steering {
		
		public function Vehicle() {
			rotationSpeed = 9;
			accelerate = 0.9;
			deccelerate = 0.9;
			getVehicle();
			super.addToStage();
		}
		
		/**
		* Imports the ship object and adds the skin atribute of the ship for the inimation.
		*/
		private function getVehicle():void {
			var myVehicle:Ship = new Ship();
			setSkin(myVehicle);
		}
	}
}
