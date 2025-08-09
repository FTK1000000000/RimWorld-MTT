using Godot;
using Godot.Collections;
using System;
using System.Collections.Generic;

[GlobalClass]
public partial class EditSlot : HBoxContainer
{
	[Export]
	string key;
	[Export]
	string item;
	[Export]
	string demo;
	[Export]
	string defa;

	Label Option;
	LineEdit Value;
	public override void _Ready()
	{
		Option = GetNode<Label>("Option");
		Value = GetNode<LineEdit>("Value");

		Option.Text = item;
		Value.PlaceholderText = demo;
	}


	public Dictionary GetValue()
	{
		Dictionary ReturnValue;
		if (Value.Text.Contains(","))
		{
			String[] array = Value.Text.Split(",");
			ReturnValue = new Dictionary()
			{
				{ $"{key}", array}
			};
		}
		else
		{
			ReturnValue = new Dictionary()
			{
				{ $"{key}", Value.Text == "" ? $"{defa}" : $"{Value.Text}"}
			};
		}
		return ReturnValue;
	}
}
