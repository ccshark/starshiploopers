package  {
	
	//-----------------------------
	// Import
	//-----------------------------
	
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import flash.ui.Keyboard;
	import flash.events.Event;
	
	
	public class Steering extends MovieClip {
		
		//-----------------------------
		// Global Properties
		//-----------------------------
		
		/**
		* Holds boolean for key input
		*/
		public var keys:Dictionary = new Dictionary(); 
		
		/**
		* Declare variables for steering, value is set in vehicle 
		*/
		public var rotationSpeed:Number;
		public var accelerate:Number;
		public var deccelerate:Number;
		
		/** 
		* Parameters for steering. set to 0 at start 
		*/
		private var speedX:Number = 0;
		private var speedY:Number = 0;
		private var speed:Number = 0;
		public var maxSpeed:Number = 14;
		private var reverseMax:Number = -5;
		private var reverseSpeed:Number = 0;
		
		/** 
		* Link to ship object for animation, sent from vehicle 
		*/
		public var skin:MovieClip;
		
		/** 
		* ==Constructor==
		* Start initStageBox to set parameters for stage.
		*/
		public function Steering() {
			initStageBox();
		}
		
		/** 
		* Starts from Vehicle class. addEventListener to get access to stage 
		*/
		public function addToStage():void {
			addEventListener(Event.ADDED_TO_STAGE, initSteering);
		}
		
		/** 
		* addEventListeners for key input and frame 
		*/
		private function initSteering(event:Event):void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN, pressedKey);
			stage.addEventListener(KeyboardEvent.KEY_UP, releasedKey);
			stage.addEventListener(Event.ENTER_FRAME, navigation);
		}
		
		/** 
		* function to get access to the ship object frames 
		*/
		public function setSkin(skin:MovieClip):void {
			this.skin = skin;
			addChild(skin);
		}
		
		/**
		* Check if key is pressed 
		*/
		private function pressedKey(event:KeyboardEvent):void {
			keys[event.keyCode] = true;
			
		}
		
		/** 
		* Check if key is released 
		*/
		private function releasedKey(event:KeyboardEvent):void {
			keys[event.keyCode] = false;
		}
		
		/**
		* Change direction of shipe depending on which key that is pressed.
		* The key is stored in directory keyboard.ui holds the value on Keyboard.KEY.
		* Start moving-animation if up-key is pressed, and start idle-animation no key is presed.
		*/
		private function navigation(event:Event):void {
			if (keys[Keyboard.LEFT]) {
				this.rotation -= rotationSpeed;
			}
			if (keys[Keyboard.RIGHT]) {
				this.rotation += rotationSpeed;
			}
			if (keys[Keyboard.UP]) {
				skin.gotoAndStop(2); //When key up is pressed, change ship animation to frame 2
				if (speed < maxSpeed) {
					speed += accelerate;
				}
				else if (speed > maxSpeed) {
					speed = maxSpeed;
				}
				
				//The math below is copied, calculates direction depending on objects rotation position
				//http://www.freeactionscript.com/2010/06/as3-car-movement-acceleration-turning-braking/.
				speedX = speed * Math.sin(this.rotation * (Math.PI / 180));
				speedY = speed * Math.cos(this.rotation * (Math.PI / 180));
			}
			
			else if (keys[Keyboard.DOWN]){
				if (speed > reverseMax) {
					speed -= accelerate;
				}
				else if (speed < reverseMax) {
					speed = reverseMax;
				}
				
				speedX = speed * Math.sin(this.rotation * (Math.PI / 180));
				speedY = speed * Math.cos(this.rotation * (Math.PI / 180));
			}
			
			else {
				speedX *= deccelerate;
				speedY *= deccelerate;
				speed *= deccelerate;
				skin.gotoAndStop(1); //Animation for idle ship
			}
			// Move ship based on calculations above
			this.y -= speedY;
			this.x += speedX;
		}
		
		/**
		* Add frame event for stageBox 
		*/
		private function initStageBox():void {
			this.addEventListener(Event.ENTER_FRAME, stageBox);
		}
		
		/**
		* Stage control.
		* The ship is teleported to the oposit side when it hits max X or Y 
		*/
		private function stageBox(event:Event):void {
			var stageMaxX:Number = 1024;
			var stageMinX:Number = 0;
			var stageMaxY:Number = 600;
			var stageMinY:Number = 0;
			
			if (this.x > stageMaxX) {
				this.x = stageMinX;
			}
			if (this.x < stageMinX) {
				this.x = stageMaxX; 
			}
			if (this.y > stageMaxY) {
				this.y = stageMinY; 
			}
			if (this.y < stageMinY) {
				this.y = stageMaxY;
			}
		}
	}
	
}
