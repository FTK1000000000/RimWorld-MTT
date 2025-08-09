// using Godot;
// using Godot.Collections;
// using System;

// public partial class StartPanel : Panel
// {
// 	PackedScene NewProjectDefinePanel = ResourceLoader.Load<PackedScene>("res://ui/new_project_define_panel.tscn");
// 	Button DefineProjectButton;
// 	Button ImportPackButton;

// 	public override void _Ready()
// 	{
// 		DefineProjectButton = GetNode<Button>("MainPanel/Options/DefineProjectButton");
// 		DefineProjectButton.Pressed += OnDefineProjectButtonPressed;
// 		ImportPackButton = GetNode<Button>("MainPanel/Options/ImportPackButton");
// 		ImportPackButton.Pressed += OnImportPackButtonPressed;
// 	}


// 	public void OnDefineProjectButtonPressed()
// 	{
// 		// DefineProjectButton.Disabled = true;
// 		AddChild(NewProjectDefinePanel.Instantiate());
// 	}
// 	public void OnImportPackButtonPressed()
// 	{
// 		var Global = GetTree().Root.GetNode("Global");
// 		Global.Call();
// 	}
// }
