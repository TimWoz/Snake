/*
*贪吃蛇游戏
*完成时间：6.27 10:20
*made by 吴智炜
*/
package
{
	//import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.engine.SpaceJustifier;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	
	public class Snake extends Sprite
	{
		private var snake:Array;//蛇身数组
		private var obstacle:Array;//障碍物数组
		private var diffButts:Array;//难度按钮数组
		private var diffTexts:Array;//难度按钮标签数组
		private var mapButts:Array;//地图按钮数组
		private var mapLables:Array;//地图按钮标签数组
		private var topNames:Array;//高分榜的玩家名
		private var topScores:Array;//高分榜的玩家分数
		
		private var pool:Sprite;//游戏的舞台
		private var gameEnd:Sprite;//游戏结束界面
		private var diffBar:Sprite;//难度选择条
		private var mapBar:Sprite;//地图选择条
		private var reGame:Sprite;//再来一局的按钮
		private var head:Sprite;//蛇头
		private var food:Sprite;//食物
		private var difficulty:Sprite;//选择难度按钮
		private var mapChange:Sprite;//选择地图按钮
		private var highScores:Sprite;//高分榜按钮
		private var inputDone:Sprite;//输入完毕按钮
		
		//private var startLable:TextField;
		private var deadNotice:TextField;//死亡提示文字
		private var timeDisplayer:TextField;//游戏时间
		private var reGameLable:TextField;//再来一局文字
		private var scoreBar:TextField;//得分榜
		private var declare:TextField;//游戏说明
		private var inputDoneLable:TextField;//输入完毕按钮标签
		private var diffText:TextField;//难度标签
		private var mapLable:TextField;//换图标签
		private var nameInput:TextField;//高分榜玩家名输入框
		private var topLable:TextField;//高分榜标签
		private var topInfo:TextField;//高分榜
		private var diffNowOn:TextField;//当前难度
		
		private var timer:Timer;//游戏计时器
		private var scoreTimer:Timer;//计分计时器
		private var rightTimer:Timer;//右移计时器
		private var leftTimer:Timer;//左
		private var upTimer:Timer;//上
		private var downTimer:Timer;//下
		
		private var live:Boolean;//是否存活
		private var isStarted:Boolean;//是否游戏开始
		private var isPaused:Boolean;//是否暂停
		//private var isTopShows:Boolean;
		
		private var mapNums:uint;//地图数目
		private var diffNums:uint;//难度等级数目
		private var diffDegree:uint;//目前难度等级
		private var minutes:uint;//计时分
		private var seconds:uint;//计时秒
		private var speed:uint;//速度，计时器的时延
		//private var snakeJoints:uint;
		private var score:uint;//得分
		
		private var direction:String;//暂存的方向
		private var gameTime:String;//游戏时间
		private var scoreDisplay:String;//游戏得分
		
		public function Snake()
		{
			factory();
			init();	
		}
		/*初始化*/
		public function factory():void
		{
			snake = new Array();
			obstacle = new Array();
			diffButts = new Array();
			diffTexts = new Array();
			mapButts = new Array();
			mapLables = new Array();
			pool = new Sprite();
			gameEnd = new Sprite();
			scoreBar = new TextField();
			head = new Sprite();
			deadNotice = new TextField();
			reGame = new Sprite();
			reGameLable = new TextField();
			nameInput = new TextField();
			timeDisplayer = new TextField();
			declare = new TextField();
			difficulty = new Sprite();
			diffText = new TextField();
			mapChange = new Sprite();
			mapLable = new TextField();
			highScores = new Sprite();
			topLable = new TextField();
			inputDone = new Sprite();
			inputDoneLable = new TextField();
			mapBar = new Sprite();
			diffBar = new Sprite();
			topInfo = new TextField();
			diffNowOn = new TextField();
			
			topNames = new Array();
			topScores = new Array();
			var i:uint;
			for(i = 0;i<3;i++)
			{
				topNames[i] = "null";
				topScores[i] = 0;	
			}
		}
		/*初始化*/
		public function init():void
		{	
			var i:int;
			isPaused = false;
			
			diffNums = 7;//7级难度
			mapNums = 5;//5张地图
			minutes = 0;//计时器为零
			seconds = 0;
			score = 0;//分数设为0
			speed = 120;//0.12秒刷新一次
			
			direction = "";//方向为空
			/*画出游戏背景*/
			pool.x = 0;
			pool.y = 0;
			pool.graphics.beginFill(0x4682B4);
			pool.graphics.drawRect(0,0,200,200);
			pool.graphics.endFill();

			scoreBar.x = 0;
			scoreBar.y = 200;
			scoreBar.text = "分数："+score;
			
			diffNowOn.x = 65;
			diffNowOn.y = 200;
			diffNowOn.text = "难度:"+4;
			
			gameEnd.x = 40;
			gameEnd.y = 40;
			gameEnd.graphics.beginFill(0xCDC9C9);
			gameEnd.graphics.drawRoundRect(0,0,120,120,10,10);
			gameEnd.graphics.endFill();
			
			deadNotice.x = 20;
			deadNotice.y = 20;
			deadNotice.width = 90;
			deadNotice.height = 18;
			deadNotice.text = "额……蛇死了！";
			
			reGame.buttonMode = true;
			reGame.x = 30;
			reGame.y = 45;
			reGame.graphics.beginFill(0x00FF00);
			reGame.graphics.drawRoundRect(0,0,60,18,7,7);
			reGame.graphics.endFill();
			
			reGameLable.x = 5;
			reGameLable.y = 3;
			reGameLable.height = 20;
			reGameLable.text = "再来一局";
			
			nameInput.background = true;
			nameInput.border = true;
			nameInput.x = 10;
			nameInput.y = 70;
			nameInput.height = 17;
			nameInput.type = TextFieldType.INPUT;
			nameInput.text = "输入昵称";
			
			inputDone.buttonMode = true;
			inputDone.x = 30;
			inputDone.y = 90;
			inputDone.graphics.beginFill(0x00FF00);
			inputDone.graphics.drawRoundRect(0,0,60,18,7,7);
			inputDone.graphics.endFill();
			
			inputDoneLable.x = 5;
			inputDoneLable.y = 3;
			inputDoneLable.height = 20;
			inputDoneLable.text = "输入完毕";
	
			timeDisplayer.x = 120;
			timeDisplayer.y = 200;
			gameTime = ("游戏时间:"+"0"+minutes+":"+"0"+seconds);
			timeDisplayer.text = gameTime;
			
			declare.x = 200;
			declare.y = 0;
			declare.width = 100;
			declare.height = 90;
			declare.text = ("游戏说明\n");
			declare.appendText("Enter键:\t开始游戏\n");
			declare.appendText("方向键:\t控制方向\n");
			declare.appendText("Esc键:\t暂停游戏\n");
			declare.appendText("空格键:\t恢复游戏\n");
			
			difficulty.buttonMode = true;
			difficulty.x = 280;
			difficulty.y = 90;
			difficulty.graphics.beginFill(0xFF2400);
			difficulty.graphics.drawCircle(0,9,10);
			difficulty.graphics.endFill();
			
			diffText.x = 200;
			diffText.y = 90;
			diffText.width = 55;
			diffText.height = 20;
			diffText.text = "难度选择:";
			
			mapChange.buttonMode = true;
			mapChange.x = 280;
			mapChange.y = 130;
			mapChange.graphics.beginFill(0x66FF00);
			mapChange.graphics.drawCircle(0,9,10);
			mapChange.graphics.endFill();
			
			mapLable.x = 200;
			mapLable.y = 130;
			mapLable.width = 55;
			mapLable.height = 20;
			mapLable.text = "地图选择:";
			
			highScores.buttonMode = true;
			highScores.x = 280;
			highScores.y = 170;
			highScores.graphics.beginFill(0x007FFF);
			highScores.graphics.drawCircle(0,9,10);
			highScores.graphics.endFill();
			
			topLable.x = 200;
			topLable.y = 170;
			topLable.width = 50;
			topLable.height = 20;
			topLable.text = "高分榜:";
			/*蛇头*/
			head.x = 100;
			head.y = 100;
			head.graphics.beginFill(0xfff000);
			head.graphics.drawRoundRect(0,0,10,10,10,10);
			head.graphics.endFill();
			snake.push(head);
			
			stage.addChild(pool);
			stage.addChild(diffNowOn);
			stage.addChild(scoreBar);
			stage.addChild(declare);
			stage.addChild(topLable);
			stage.addChild(timeDisplayer);
			stage.addChild(highScores);
			stage.addChild(mapLable);
			stage.addChild(mapChange);
			stage.addChild(diffText);
			stage.addChild(difficulty);
			pool.addChild(head);
			inputDone.addChild(inputDoneLable);
			reGame.addChild(reGameLable);
			
			gameEnd.addChild(deadNotice);
			gameEnd.addChild(reGame);
			
			deadNotice.visible = false;
			reGame.visible = false;
			
			timer = new Timer(1000);
			scoreTimer = new Timer(speed);
			leftTimer = new Timer(speed);
			rightTimer = new Timer(speed);
			upTimer = new Timer(speed);
			downTimer = new Timer(speed);
			/*侦听ENTER键是否按下，按下则游戏开始*/
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kStart);
			/*除非游戏结束，否则ENTER键被释放时，解除对ENTER键的侦听*/
			stage.addEventListener(KeyboardEvent.KEY_UP,kEnterUp);
			/*侦听难度按钮*/
			difficulty.addEventListener(MouseEvent.CLICK,setDiffDegree);
			/*侦听换图按钮*/
			mapChange.addEventListener(MouseEvent.CLICK,setMap);
			/*侦听高分榜按钮*/
			highScores.addEventListener(MouseEvent.CLICK,showTops);
		}
		/*开始游戏*/
		public function start():void
		{
			if(live == false) live = true;
			if(isStarted == false) isStarted = true;
			
			pool.addChild(generateFood());
			
			timer.start();
			scoreTimer.start();
			rightTimer.start();
			leftTimer.stop();
			upTimer.stop();
			downTimer.stop();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kPause);
			
			leftTimer.addEventListener(TimerEvent.TIMER,tLeft);
			rightTimer.addEventListener(TimerEvent.TIMER,tRight);
			upTimer.addEventListener(TimerEvent.TIMER,tUp);
			downTimer.addEventListener(TimerEvent.TIMER,tDown);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kDown);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kRight);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kLeft);
			
			timer.addEventListener(TimerEvent.TIMER,changeTime);
			scoreTimer.addEventListener(TimerEvent.TIMER,updateScore);
			
			inputDone.addEventListener(MouseEvent.CLICK,onNameInput);
			reGame.addEventListener(MouseEvent.CLICK,playAgain);
		}
		/*键盘ENTER触发游戏开始*/
		public function kStart(e:KeyboardEvent):void
		{
			if(e.keyCode == 0xD)
			{
				start();
			}
		}
		/*Enter被释放时解除对Enter的侦听*/
		public function kEnterUp(e:KeyboardEvent):void
		{
			if(e.keyCode == 0xD)
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kStart);
			}
		}
		/*更新分数*/
		public function updateScore(t:TimerEvent):void
		{
			scoreDisplay = "";
			scoreDisplay += ("分数："+score);
			scoreBar.text = scoreDisplay;
		}
		/*游戏计时*/
		public function changeTime(e:TimerEvent):void
		{
			gameTime = "";
			if(seconds<59&&seconds>=0)
			{
				seconds++;
			}
			else
			{
				seconds = 0;
				if(minutes<59&&minutes>=0)
				{
					minutes++;
				}
				else
				{
					trace("out of range!");
					return;
				}
			}
			//}
			gameTime += "游戏时间:";
			if(minutes<=9) gameTime += ("0"+minutes+":");
			else gameTime += (minutes+":");
			if(seconds<=9) gameTime += ("0"+seconds);
			else gameTime += seconds;
			timeDisplayer.text = gameTime;
		}
		/*输入玩家名*/
		public function onNameInput(e:MouseEvent):void
		{
			if(live == false)
			{
				topNames.push(nameInput.text);
				topScores.push(score);
				if(gameEnd.contains(nameInput)==true)gameEnd.removeChild(nameInput);
				if(gameEnd.contains(inputDone)==true)gameEnd.removeChild(inputDone);
			}
			else
			{
				topNames.push(nameInput.text);
				topScores.push(score);
				rePlay();
			}
		}
		/*高分榜显示*/
		public function showTops(e:MouseEvent):void
		{
			var i:uint;
			var j:uint;
			var max:int;
			var maxString:String;
			var mark:uint;
			var tempString:String;
			var tempScore:uint;
			topInfo.x = 300;
			topInfo.y = 120;
			topInfo.width = 150;
			topInfo.height = 100;
			topInfo.background = true;
			topInfo.backgroundColor = 0x007FFF;
			if(topScores.length >= 2)
			{
				for(i = 0;i<3;i++)
				{
					for(j = topScores.length-1;j>i;j--)
					{
						if(topScores[j]>topScores[j-1])
						{
							tempScore = topScores[j];
							tempString = topNames[j];
							topScores[j] = topScores[j-1];
							topNames[j] = topNames[j-1];
							topScores[j-1] = tempScore;
							topNames[j-1] = tempString;
						}
					}
				}
			}
			topInfo.text = ("排名\t\t"+"玩家\t"+"分数\n");
			topInfo.appendText("1st\t\t"+topNames[0]+"\t\t"+topScores[0]+"\n\n");
			topInfo.appendText("2nd\t\t"+topNames[1]+"\t\t"+topScores[1]+"\n\n");
			topInfo.appendText("3rd\t\t"+topNames[2]+"\t\t"+topScores[2]+"\n\n");
			(stage.contains(topInfo) == true) ? stage.removeChild(topInfo) : stage.addChild(topInfo);
			if(stage.contains(mapBar)) stage.removeChild(mapBar);
			if(stage.contains(diffBar)) stage.removeChild(diffBar);
		}
		/*换图*/
		public function setMap(e:MouseEvent):void
		{
			pause();
			var i:int;
			mapBar.x = 300;
			mapBar.y = 110;
			mapBar.graphics.beginFill(0x66FF00);
			mapBar.graphics.drawRoundRect(0,0,30,20*mapNums,8,8);
			mapBar.graphics.endFill();
			for(i=1;i<=mapNums;i++)
			{
				mapButts[i] = new Sprite();
				mapButts[i].buttonMode = true;
				mapLables[i] = new TextField();
				mapButts[i].x = 10;
				mapButts[i].y = -10+i*5;
				mapButts[i].graphics.beginFill(0xE0FFFF);
				mapButts[i].graphics.drawRect(0,i*12,12,12);
				mapButts[i].graphics.endFill();
				mapLables[i].x = -2;
				mapLables[i].y = -2+12*i;
				mapLables[i].width = 30;
				mapLables[i].text = " "+i+" ";
				mapButts[i].addChild(mapLables[i]);
				mapBar.addChild(mapButts[i]);
			}
			(stage.contains(mapBar) == true) ? stage.removeChild(mapBar) : stage.addChild(mapBar);
			if(stage.contains(diffBar)) stage.removeChild(diffBar);
			if(stage.contains(topInfo)) stage.removeChild(topInfo);
			for(i = 1;i<=mapNums;i++)
			{
				switch(i)
				{
					case 1:mapButts[i].addEventListener(MouseEvent.CLICK,m1);break;//默认无障碍
					case 2:mapButts[i].addEventListener(MouseEvent.CLICK,m2);break;//四壁为障碍
					case 3:mapButts[i].addEventListener(MouseEvent.CLICK,m3);break;//两道横障碍
					case 4:mapButts[i].addEventListener(MouseEvent.CLICK,m4);break;//四道杠
					case 5:mapButts[i].addEventListener(MouseEvent.CLICK,m5);break;
				}
			}
		}
		/*清除所有障碍物*/
		public function clearAllObst():void
		{
			var i:uint = obstacle.length;
			while(i>0)
			{
				pool.removeChild(obstacle.pop());
				i--;
			}
		}
		/*换图完后储存分数，并开始下一局*/
		public function afterMapSet():void
		{
			if(live == true&&score>0)
			{
				if(pool.contains(gameEnd)==false) pool.addChild(gameEnd);
				if(gameEnd.contains(nameInput)==false)gameEnd.addChild(nameInput);
				if(gameEnd.contains(inputDone)==false)gameEnd.addChild(inputDone);
				deadNotice.visible = false;
				reGame.visible = false;
			}
			if(score == 0)
			{
				rePlay();
			}
		}
		/*响应换图1*/
		public function m1(e:MouseEvent):void
		{
			clearAllObst();
			if(stage.contains(mapBar)) stage.removeChild(mapBar);
			afterMapSet();
		}
		/*响应换图2*/
		public function m2(e:MouseEvent):void
		{
			clearAllObst();
			if(stage.contains(mapBar)) stage.removeChild(mapBar);
			var i:uint;
			var j:uint;
			var k:uint = 0;
			for(i=0;i<200;i+=head.width)
			{
				obstacle.push(makeAnObstacle(i,0));
				pool.addChild(obstacle[k]);k++;
				obstacle.push(makeAnObstacle(i,200-head.height));
				pool.addChild(obstacle[k]);k++;
			}
			for(j=head.height;j<200-head.height;j+=head.height)
			{
				obstacle.push(makeAnObstacle(0,j));
				pool.addChild(obstacle[k]);k++;
				obstacle.push(makeAnObstacle(200-head.width,j));
				pool.addChild(obstacle[k]);k++;
			}
			afterMapSet();
		}
		/*响应换图3*/
		public function m3(e:MouseEvent):void
		{
			clearAllObst();
			if(stage.contains(mapBar)) stage.removeChild(mapBar);
			var i:uint;
			var j:uint;
			var k:uint = 0;
			for(i = 5*head.width;i<200-5*head.width;i+=head.width)
			{
				obstacle.push(makeAnObstacle(i,50));
				pool.addChild(obstacle[k]);k++;
				obstacle.push(makeAnObstacle(i,150));
				pool.addChild(obstacle[k]);k++;
			}
			afterMapSet();
		}
		/*响应换图4*/
		public function m4(e:MouseEvent):void
		{
			clearAllObst();
			if(stage.contains(mapBar)) stage.removeChild(mapBar);
			var i:uint;
			var k:uint = 0;
			for(i = 0;i<8*head.height;i+=head.height)
			{
				obstacle.push(makeAnObstacle(40,i));
				pool.addChild(obstacle[k]);k++;
				obstacle.push(makeAnObstacle(120,i));
				pool.addChild(obstacle[k]);k++;
			}
			for(i = 200-8*head.height;i<200;i+=head.height)
			{
				obstacle.push(makeAnObstacle(80,i));
				pool.addChild(obstacle[k]);k++;
				obstacle.push(makeAnObstacle(160,i));
				pool.addChild(obstacle[k]);k++;
			}
			afterMapSet();
		}
		/*响应换图5*/
		public function m5(e:MouseEvent):void
		{
			clearAllObst();
			if(stage.contains(mapBar)) stage.removeChild(mapBar);
			var i:uint;
			var k:uint = 0;
			for(i = 4*head.width;i<12*head.width;i+=head.width)
			{
				obstacle.push(makeAnObstacle(i,40));
				pool.addChild(obstacle[k]);k++;
				obstacle.push(makeAnObstacle(i,120));
				pool.addChild(obstacle[k]);k++;
			}
			for(i = 8*head.width;i<16*head.width;i+=head.width)
			{
				obstacle.push(makeAnObstacle(i,80));
				pool.addChild(obstacle[k]);k++;
				obstacle.push(makeAnObstacle(i,160));
				pool.addChild(obstacle[k]);k++;
			}
			afterMapSet();
		}
		/*产生障碍物*/
		public function makeAnObstacle(coordX:uint,coordY:uint):Sprite
		{
			var obst:Sprite = new Sprite();
			obst.x = coordX;
			obst.y = coordY;
			obst.graphics.beginFill(0x000000);
			obst.graphics.drawRoundRect(0,0,10,10,3,3);
			obst.graphics.endFill();
			return obst;
		}
		/*设置难度*/
		public function setDiffDegree(e:MouseEvent):void
		{
			pause();
			var i:int;
			diffBar.x = 300;
			diffBar.y = 60;
			diffBar.graphics.beginFill(0xFF2400);
			diffBar.graphics.drawRoundRect(0,0,30,125,10,10);
			diffBar.graphics.endFill();
			for(i=1;i<=diffNums;i++)
			{
				diffButts[i] = new Sprite();
				diffButts[i].buttonMode = true;
				diffTexts[i] = new TextField();
				diffButts[i].x = 10;
				diffButts[i].y = -10+i*5;
				diffButts[i].graphics.beginFill(0xE0FFFF);
				diffButts[i].graphics.drawRect(0,i*12,12,12);
				diffButts[i].graphics.endFill();
				diffTexts[i].x = -2;
				diffTexts[i].y = -2+12*i;
				diffTexts[i].width = 20;
				diffTexts[i].text = " "+i+" ";
				diffButts[i].addChild(diffTexts[i]);
				diffBar.addChild(diffButts[i]);
			}
			(stage.contains(diffBar) == true) ? stage.removeChild(diffBar) : stage.addChild(diffBar);
			if(stage.contains(mapBar)) stage.removeChild(mapBar);
			if(stage.contains(topInfo)) stage.removeChild(topInfo);
			for(i = 1;i<=diffNums;i++)
			{
				switch(i)
				{
					case 1:diffButts[i].addEventListener(MouseEvent.CLICK,d1);break;
					case 2:diffButts[i].addEventListener(MouseEvent.CLICK,d2);break;
					case 3:diffButts[i].addEventListener(MouseEvent.CLICK,d3);break;
					case 4:diffButts[i].addEventListener(MouseEvent.CLICK,d4);break;
					case 5:diffButts[i].addEventListener(MouseEvent.CLICK,d5);break;
					case 6:diffButts[i].addEventListener(MouseEvent.CLICK,d6);break;
					case 7:diffButts[i].addEventListener(MouseEvent.CLICK,d7);break;
				}
			}
		}
		/*d1到d7响应设置不同难度*/
		public function d1(e:MouseEvent):void
		{
			diffNowOn.text = "难度:1";
			scoreTimer.delay = leftTimer.delay = rightTimer.delay = upTimer.delay = downTimer.delay = speed = 250;
			stage.removeChild(diffBar);
			//resume();
		}
		public function d2(e:MouseEvent):void
		{
			diffNowOn.text = "难度:2";
			scoreTimer.delay = leftTimer.delay = rightTimer.delay = upTimer.delay = downTimer.delay = speed = 200;
			stage.removeChild(diffBar);
			//resume();
		}
		public function d3(e:MouseEvent):void
		{
			diffNowOn.text = "难度:3";
			scoreTimer.delay = leftTimer.delay = rightTimer.delay = upTimer.delay = downTimer.delay = speed = 160;
			stage.removeChild(diffBar);
			//resume();
		}
		public function d4(e:MouseEvent):void
		{
			diffNowOn.text = "难度:4";
			scoreTimer.delay = leftTimer.delay = rightTimer.delay = upTimer.delay = downTimer.delay = speed = 120;
			stage.removeChild(diffBar);
			//resume();
		}
		public function d5(e:MouseEvent):void
		{
			diffNowOn.text = "难度:5";
			scoreTimer.delay = leftTimer.delay = rightTimer.delay = upTimer.delay = downTimer.delay = speed = 80;
			stage.removeChild(diffBar);
			//resume();
		}
		public function d6(e:MouseEvent):void
		{
			diffNowOn.text = "难度:6";
			scoreTimer.delay = leftTimer.delay = rightTimer.delay = upTimer.delay = downTimer.delay = speed = 60;
			stage.removeChild(diffBar);
			//resume();
		}
		public function d7(e:MouseEvent):void
		{
			diffNowOn.text = "难度:7";
			scoreTimer.delay = leftTimer.delay = rightTimer.delay = upTimer.delay = downTimer.delay = speed = 40;
			stage.removeChild(diffBar);
			//resume();
		}
		/*死亡*/
		public function die():void
		{
			var i:uint;
			/*蛇吃到自己*/
			for(i = 1;i<snake.length;i++)
			{
				if(snake[0].x==snake[i].x && snake[0].y==snake[i].y)
				{
					live = false;
					break;
				}
			}
			/*蛇吃到障碍物*/
			for(i = 0;i<obstacle.length;i++)
			{
				if(snake[0].x==obstacle[i].x && snake[0].y==obstacle[i].y)
				{
					live = false;
					break;
				}
			}
			if(live == false)
			{
				i = snake.length;
				while(i>0)
				{
					pool.removeChild(snake.pop());
					i--;
				}
				if(food!=null && pool.contains(food)) pool.removeChild(food);
				
				leftTimer.stop();
				rightTimer.stop();
				upTimer.stop();
				downTimer.stop();
				//scoreTimer.stop();
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER,changeTime);
				leftTimer.removeEventListener(TimerEvent.TIMER,tLeft);
				rightTimer.removeEventListener(TimerEvent.TIMER,tRight);
				upTimer.removeEventListener(TimerEvent.TIMER,tUp);
				downTimer.removeEventListener(TimerEvent.TIMER,tDown);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kUp);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kDown);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kLeft);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kRight);
				
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kPause);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kResume);
				
				if(pool.contains(gameEnd)==false) pool.addChild(gameEnd);
				if(score>0)
				{
					if(gameEnd.contains(nameInput)==false)gameEnd.addChild(nameInput);
					if(gameEnd.contains(inputDone)==false)gameEnd.addChild(inputDone);
				}
				deadNotice.visible = true;
				reGame.visible = true;
				//nameInput.visible = true;
			}
		}
		/*在随机的位置产生食物*/
		public function generateFood():Sprite
		{
			food = new Sprite();
			var wNum:uint;
			var hNum:uint;
			var i:uint;
			var j:uint;
			var flag:Boolean;
			do{
				flag = false;
				wNum = 200/snake[0].width - 1;
				hNum = 200/snake[0].height - 1;
				if(wNum>0) food.x = Math.round(Math.random()*(wNum))*snake[0].width;
				if(hNum>0) food.y = Math.round(Math.random()*(hNum))*snake[0].height;
				if(food.x < 0 || food.y <0 || food.x >= 200 || food.y >= 200)
				{
					flag = true;
					//continue;
				}
				for(i = 0;i<snake.length;i++)
				{
					if(food.x==snake[i].x && food.y==snake[i].y)
					{
						flag = true;
						break;
					}
				}
				for(j=0;j<obstacle.length;j++)
				{
					if(food.x==obstacle[j].x && food.y==obstacle[j].y)
					{
						flag = true;
						break;
					}
				}
			}while(flag==true);
			food.graphics.beginFill(0x66FF00);
			//food.graphics.beginFill(0x012345);
			food.graphics.drawRect(0,0,snake[0].width,snake[0].height);
			food.graphics.endFill();
			return food;
		}
		/*生成蛇身上的一节*/
		public function generateASnakeKnot():Sprite
		{
			var knot:Sprite = new Sprite();
			knot.graphics.beginFill(0xfff000);
			knot.graphics.drawRoundRect(0,0,10,10,2,2);
			//knot.graphics.drawRect(0,0,10,10);
			knot.graphics.endFill();
			return knot;
		}
		/*蛇吃食物*/
		public function eat():void
		{
			if(food!=null && snake[0].x==food.x && snake[0].y == food.y)
			{
				pool.removeChild(food);
				score += (1000/speed);
				var knot:Sprite = generateASnakeKnot();
				//knot.x = snake[snake.length-1].x;
				//knot.y = snake[snake.length-1].y;
				knot.x = -10;
				knot.y = -10;
				snake.push(knot);
				pool.addChild(knot);
				pool.addChild(generateFood());
			}
		}
		/*暂停*/
		public function pause():void
		{
			isPaused = true;
			if(isPaused = true)
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kUp);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kDown);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kRight);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kLeft);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kResume);
			}
			if(upTimer.running == true)
			{
				direction = "up";
				upTimer.stop();
			}
			else if(downTimer.running == true)
			{
				direction = "down";
				downTimer.stop();
			}
			else if(leftTimer.running == true)
			{
				direction = "left";
				leftTimer.stop();
			}
			else if(rightTimer.running == true)
			{
				direction = "right";
				rightTimer.stop();
			}
			timer.stop();
		}
		/*按下Esc暂停游戏*/
		public function kPause(e:KeyboardEvent):void
		{
			if(e.keyCode == 0x1B)
			{
				pause();
			}
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kResume);
		}
		/*继续游戏*/
		public function resume():void
		{
			isPaused = false;
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kDown);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kRight);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,kLeft);
			if(direction == "up")
			{
				upTimer.start();
			}
			else if(direction == "down")
			{
				downTimer.start();
			}
			else if(direction == "left")
			{	
				leftTimer.start();
			}
			else if(direction == "right")
			{
				rightTimer.start();
			}
			if(isStarted == true)
			{
				timer.start();
			}
		}
		/*按下空格键则继续游戏*/
		public function kResume(e:KeyboardEvent):void
		{
			if(e.keyCode == 0x20)
			{
				if(isPaused == true)
				{
					resume();
				}
			}
		}
		/*空格键被放起则解除对空格键的侦听*/
		public function kSpaceUp(e:KeyboardEvent):void
		{
			if(e.keyCode == 0x20)
			{
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kResume);
			}
		}
		/*鼠标点击再来一局*/
		public function playAgain(e:MouseEvent):void
		{
			rePlay();
		}
		/*再来一局*/
		public function rePlay():void
		{
			isStarted = false;
			var i:uint = snake.length;
			while(i>0)
			{
				pool.removeChild(snake.pop());
				i--;
			}
			if(food!=null && pool.contains(food)) pool.removeChild(food);
			stage.removeChild(timeDisplayer);
			stage.removeChild(scoreBar);
			if(gameEnd.contains(nameInput)) gameEnd.removeChild(nameInput);
			if(gameEnd.contains(inputDone)) gameEnd.removeChild(inputDone);
			if(pool.contains(gameEnd)) pool.removeChild(gameEnd);
			deadNotice.visible = false;
			reGame.visible = false;
			init();
		}
		/*移动*/
		public function move():void
		{
			var i:uint;
			for(i = snake.length-1;i>0;i--)
			{
				snake[i].x = snake[i-1].x;
				snake[i].y = snake[i-1].y;
			}
		}
		/*键盘向上*/
		public function kUp(e:KeyboardEvent):void
		{
			if(e.keyCode == 0x26)
			{
				leftTimer.stop();
				rightTimer.stop();
				downTimer.stop();
				upTimer.start();
				
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kDown);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kRight);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kLeft);
				
				/*
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kRight);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kLeft);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kDown);
				*/
			}
			
		}
		/*蛇头向上移动*/
		public function tUp(e:TimerEvent):void
		{
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kUp);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kDown);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kRight);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kLeft);
			//trace("up"+pool.height+" "+pool.width);
			if(snake[0].y == 0)
			{
				move();
				snake[0].y = 200 - snake[0].height;
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kRight);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kLeft);
				
				eat();
				die();
				return;
			}
			
			if(snake[0].y<=(200-snake[0].height) && snake[0].y >0)
			{
				move();
				snake[0].y -= snake[0].height;
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kRight);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kLeft);
				
				eat();
				die();
				return;
			}
		}
		/*键盘向下*/
		public function kDown(e:KeyboardEvent):void
		{
			if(e.keyCode == 0x28)
			{
				leftTimer.stop();
				rightTimer.stop();
				upTimer.stop();
				downTimer.start();
				
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kUp);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kRight);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kLeft);
				/*
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kUp);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kRight);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kLeft);
				*/
			}
			
		}
		/*蛇头向下移动*/
		public function tDown(e:TimerEvent):void
		{
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kUp);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kDown);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kRight);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kLeft);
			//trace("down"+pool.height+" "+pool.width);
			if(snake[0].y == 200-snake[0].height)
			{
				move();
				snake[0].y = 0;
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kRight);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kLeft);
				
				eat();
				die();
				return;
			}
			
			if(snake[0].y<200-snake[0].height && snake[0].y >=0)
			{
				move();
				snake[0].y += snake[0].height;
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kRight);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kLeft);
				
				eat();
				die();
				return;
			}
		}
		/*键盘向左*/
		public function kLeft(e:KeyboardEvent):void
		{
			if(e.keyCode == 0x25)
			{
				rightTimer.stop();
				upTimer.stop();
				downTimer.stop();
				leftTimer.start();
				
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kUp);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kDown);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kRight);
				
				/*
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kUp);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kRight);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kDown);
				*/
			}
			
		}
		/*蛇头向左移动*/
		public function tLeft(e:TimerEvent):void
		{
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kUp);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kDown);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kRight);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kLeft);
			//trace("left"+pool.height+" "+pool.width);
			if(snake[0].x == 0)
			{
				move();
				snake[0].x = 200 -head.width;
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kUp);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kDown);
				
				eat();
				die();
				return;
			}
			if(head.x<=200-snake[0].width && snake[0].x>0)
			{
				move();
				snake[0].x -= snake[0].width;
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kUp);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kDown);
				
				eat();
				die();
				return;
			}
		}
		/*键盘向右*/
		public function kRight(e:KeyboardEvent):void
		{
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kUp);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kDown);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kRight);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,kLeft);
			if(e.keyCode == 0x27)
			{
				upTimer.stop();
				downTimer.stop();
				leftTimer.stop();
				rightTimer.start();
				
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kUp);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kDown);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kLeft);
				/*
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kUp);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,kLeft);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kDown);
				*/
			}
		}
		/*蛇头向右移动*/
		public function tRight(e:TimerEvent):void
		{
			if(snake[0].x == 200-snake[0].width)
			{
				move();
				snake[0].x = 0;
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kUp);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kDown);
				
				eat();
				die();
				return;
			}
			if(snake[0].x<200-snake[0].width && snake[0].x>=0)
			{
				move();
				snake[0].x += snake[0].width;
				
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kUp);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,kDown);
				
				eat();
				die();
				return;
			}
		}					
	}
}