// using Godot;
// using System;

// public partial class ResourceManager : Panel
// {
// 	Button ImportPackButton;
// 	Button RemoveAllButton;
// 	Button SelectAllButton;
// 	LineEdit Filter;
// 	VBoxContainer ItemSlots;
// 	FileDialog FileDialog;


// 	public override void _Ready()
// 	{
// 		ImportPackButton = GetNode<Button>("Options/ImportPackButton");
// 		RemoveAllButton = GetNode<Button>("VBoxContainer/Tools/RemoveAllButton");
// 		SelectAllButton = GetNode<Button>("VBoxContainer/Tools/SelectAllButton");
// 		Filter = GetNode<LineEdit>("VBoxContainer/Tools/Filter");
// 		ItemSlots = GetNode<VBoxContainer>("VBoxContainer/ItemSlots");
// 		FileDialog = GetNode<FileDialog>("FileDialog");

// 		ImportPackButton.Pressed += OnImportPackButtonPressed;
// 		RemoveAllButton.Pressed += OnRemoveAllButtonPressed;
// 		SelectAllButton.Pressed += OnSelectAllButtonPressed;
// 		Filter.TextSubmitted += OnFilterTextSubmitted;
// 		FileDialog.DirSelected += OnFileDialogDirSelected;
// 		GetTree().Root.FilesDropped += OnWindowFilesDropped;
// 	}

// 	public void OnImportPackButtonPressed()
// 	{
// 		FileDialog.Show();
// 	}
// 	public void OnRemoveAllButtonPressed()
// 	{
// 		GD.Print("y");
// 	}
// 	public void OnSelectAllButtonPressed()
// 	{
// 		GD.Print("y");
// 	}
// 	public void OnFilterTextSubmitted(string new_text)
// 	{
// 		GD.Print(new_text);
// 	}
// 	public void OnFileDialogDirSelected(string path)
// 	{
// 		Array files;
// 		files.Add(path);
// 		ItemsGenerator(files);
// 	}
// 	public void OnWindowFilesDropped(string[] files)
// 	{
// 		ItemsGenerator(files);
// 	}

// 	public void ItemsGenerator(string[] v)
// 	{
// 		var global = GetTree().Root.GetNode("Global");
// 		global.Call("parse_pack", v);
// 	}
// }
