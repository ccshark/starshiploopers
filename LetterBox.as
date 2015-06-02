package  {
	//-----------------------------
	// Import
	//-----------------------------
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Stage;
	import flash.media.Sound;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	public class LetterBox extends MovieClip {
		
		//-----------------------------
		// Global Arrays
		//-----------------------------
	
		private var wordList:Array = new Array(); //Holds original word.
		private var letters:Array = new Array(); //Holds each letter from the selected word.
		private var hitList:Array = new Array(); //Holds the TextField Object that are added to the stage.
		private var textForm:TextFormat = new TextFormat();//Holds visual parameters for the TextField Object.
		
		/**
		* Parameters for score handling.
		*/
		private var points:Number = 0;
		private var pointForm:TextFormat = new TextFormat();
		private var score:TextField = new TextField();
		
		
		
		private const gameHeight = 600;
		private const gameWidth = 1024;
		
		/**
		* Parameters for Flicker handling.
		*/
		private var img:ImgBox;
		private var myLoader:Loader;
		private var selectedWord:String;
		private var flickr:Flickr;
		private var imgArray:Array; //Holds data from Flickr-class
		
		
		/**
		* Import ship from Main-class
		*/
		private var ship:Vehicle;
		
		/**
		* ==Constructor==
		* Start the LetterBox with the Vehicle that is added to the stage in Main.
		* addEventListener to get access to the stage.
		*/
		public function LetterBox(newVehicle:Vehicle) {
			ship = newVehicle;
			this.addEventListener(Event.ADDED_TO_STAGE, initLetterBox);
		}
		
		/** 
		* Start functions  with access to the stage .
		*/
		private function initLetterBox(event:Event):void {
			scoreForm();
			wordForm();
			addWords();
			activeHit();
			updateScore();
		}

		/** 
		* Empty the wordList array and add new words to the wordList array.
		* This array will be used for Flickr search aswell.
		*/
		private function addWords():void {
			wordList = [];
			wordList = ["ROCKET", "SPACE", "PLANET", "ASTEROID", "MARS", "LUNA", "SATELLITE", "COMETH", "ANDROMEDA", "STARFALL"];
			getRandomWord();
		}
		
		/**
		* Style parameters for score output.
		*/
		private function scoreForm():void {
			pointForm.size = 40;
			pointForm.color = 0xFFFFFF;
		}
		
		/**
		* Uppdate score when a point is added or reduced.
		*/
		private function updateScore():void {
			var currentScore:Number = points;
			scoreScreen(currentScore);
		}
		
		/**
		* Set new TextField, parameters and adding the score to the stage.
		*/
		private function scoreScreen(currentScore:Number):void {
			score.defaultTextFormat = pointForm;
			score.setTextFormat(pointForm);
			score.text = "Score: " + String(currentScore);
			score.height = 50;
			score.width = 240;
			score.x = 50;
			score.y =  750;
			addChild(score);
		}
		
		/**
		* Select a random word from the wordList array.
		* Save the random word to selectedWord and store in global array, for use in Flickr-class.
		*/
		private function getRandomWord():void {
			var randomWord:int;
			randomWord = Math.random() * wordList.length;
			selectedWord = wordList[randomWord];
			updatePic();
			trace(selectedWord);
			splitWord();
		}
		
		/**
		* On-call function to run the Flickr-class and get a new picture.
		* check if the picture is placed or not.
		* if it is not placed, add the ImgBox, to hold the pictures from Flickr.
		* if it is placed, remove the previous picture and run flickr again.
		*/
		private function updatePic():void {
			if (img == null) {
				img = new ImgBox();
				img.y = stage.stageHeight * 0.865;
				img.x = 455;
				addChild(img);
				initFlickr();
			}
			else {
				initFlickr();
			}
		}
		/**
		* Start the initFlickrRequest in the Flickr-class and send with search parameter (selectedWord) and loadComplete function as callback function.
		* The callback function will return the url data to the loadComplete function.
		*/
		private function initFlickr():void {
			flickr = new Flickr();
			flickr.initFlickrRequest(selectedWord, loadComplete);
		}
		
		/**
		* loadComplete is started when the Flickr-class is finished and returns the url-data to loadComplete.
		* The data from Flickr is stored in imgArray.
		*/
		//http://www.danfergusdesign.com/classfiles/oldClasses/VCB331-richMedia1/exercises/loadingExternalFiles.php
		private function loadComplete(data:Array):void {
			imgArray = data;
			imgOnStage();
		}
		
		/**
		* Set the picture-link as URLRequest and add to loader variable.
		* Add the loaded URL to stage.
		* the picture is put on the ImgBox object.
		*/
		private function imgOnStage():void {
			myLoader = new Loader();
			var myRequest:URLRequest=new URLRequest(imgArray[0]);
			myLoader.load(myRequest);
			img.addChild(myLoader);
		}
		
		/** 
		* Split the random word into letters and store in the letters array 
		*/
		private function splitWord():void {
			letters = selectedWord.split("");
			addToStage();
		}
		
		/**
		* Set values for the TextField Object that are added to stage 
		*/
		private function wordForm():void {
				textForm.size = 30;
				textForm.color = 0XFFFFFF;
		}
		
		/**  
		* Clear the hitList array.
		* Create new variable to hold TextField and create style class for TextField.
		* Convert all letters in letters array to TextField Objects.
		* Send each word to putOnStage.
		*/
		public function addToStage():void {
			hitList=[];
			for (var i:int=0; i<letters.length; i++) {
				var word:TextField = new TextField();
				word.defaultTextFormat = textForm;
				word.setTextFormat(textForm);
				word.text = letters[i];
				word.border = true;
				word.borderColor = 0xFFFFFF;
				word.background = true;
				word.backgroundColor = 0x0000FF;
				word.height = 35;
				word.width = 30;
				putOnStage(word);
			}
		}
		
		/**
		* Set random position for each letter, then add letter to stage.
		* Add each TextField Object to the global hitList array.
		* Start activeHit.
		*/
		private function putOnStage(word:TextField):void {
			word.x = Math.random() * (gameWidth - word.width);
			word.y = Math.random() * (gameHeight - word.height);
			addChild(word);
			hitList.push(word);
		}
		
		/**
		* Start eventListener for every frame 
		*/
		public function activeHit():void {
			stage.addEventListener(Event.ENTER_FRAME, checkHit);
		}
		

		/**
		* Check if any object in the hitList array is hit by the ship.
		* if hit, stop frame-update and run registerHit.
		*/
		private function checkHit(event:Event):void {
			for (var i:int=0; i < hitList.length; i++) {
				if (ship.hitTestObject(hitList[i])) {
					registerHit(i);
				}
			}
		}
		
		/**
		* Check if hit-value is equal to the first object in the hitList array.
		* if true, run removeHit and addPoint.
		* else, run removePoint With index from the current object.
		*/
		private function registerHit(index:int):void {
			if (hitList[index].text == letters[0]) {
				addPoint();
				removeHit(index);
			}
			else {
				removePoint(index);
			}
		}
		
		/**
		* Remove the hit object depending on index from registerHit.
		* remove the first object in hitList array and the first value in letters array.
		* Check if the hitList array is empty, if true, run finish sound, and go back to getRandomWord.
		*/
		private function removeHit(index:int):void {
				removeChild(hitList[index]);
				hitList.splice(index, 1);
				letters.splice(0, 1);
			if (hitList.length == 0) {
				var lastWord:Sound = new LastSound();
				lastWord.play();
				getRandomWord();
			}
		}
		
		/**
		* Add 1 to curent point-score.
		* Play sound for hiting the right letter.
		* remove the current score object from the stage
		* and go to updateScore.
		*/
		private function addPoint():void {
			points = points + 1;
			var onMiss:Sound = new MissSound();
			onMiss.play();
			removeChild(score);
			updateScore();
			trace(points);
		}
		
		/**
		* Remove 1 point from curent point-score.
		* Play sound for hiting the wrong letter.
		* run randomLetter to change the position of the object.
		* remove score object from stage and run updateScore.
		*/
		private function removePoint(index:int):void {
			points = points - 1;
			var onHit:Sound = new HitSound();
			onHit.play();
			randomLetter(index);
			removeChild(score);
			updateScore();
			trace(points);
		}
		
		/**
		* If the wrong letter is hit, remove the curent object
		* and place at random position on stage.
		* run updatePic.
		*/
		private function randomLetter(index:int):void {
			removeChild(hitList[index]);
			var rand:TextField;
			rand = hitList[index];
			rand.x = Math.random() * gameWidth - rand.width;
			rand.y = Math.random() * gameHeight - rand.height;
			addChild(rand);
			updatePic();
		}
	}
}
