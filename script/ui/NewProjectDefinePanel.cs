//using Godot;
//using Godot.Collections;
//using System;
//using System.Collections.Generic;
//
//public partial class NewProjectDefinePanel : Panel
//{
	//Button CancelButton;
	//Button SpawnButton;
	//VBoxContainer Slots;
//
	//public override void _Ready()
	//{
		//CancelButton = GetNode<Button>("Slots/Ation/Cancel");
		//SpawnButton = GetNode<Button>("Slots/Ation/Spawn");
		//Slots = GetNode<VBoxContainer>("Slots");
		//CancelButton.Connect(Button.SignalName.Pressed, Callable.From(CancelButtonPressed));
		//SpawnButton.Connect(Button.SignalName.Pressed, Callable.From(SpawnButtonPressed));
	//}
//
//
	//public void CancelButtonPressed()
	//{
		//QueueFree();
	//}
	//public void SpawnButtonPressed()
	//{
		//List<Dictionary> Datas = new List<Dictionary>();
		//foreach (EditSlot Node in Slots.GetChildren())
		//{
			//if (Node is EditSlot)
			//{
				//Datas.Add(Node.GetValue());   
			//}
		//}
//
		//Global.ProjectGenerator(Datas);
	//}
//}
