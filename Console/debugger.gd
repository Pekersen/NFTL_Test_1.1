extends Control

@onready var consoleHistory = $VBoxContainer/ConsoleHistory
@onready var consoleInput = $VBoxContainer/ConsoleInput

var command_list = {
	"help" : 0
	}

func _on_console_input_text_changed():
	if consoleInput.get_line_count() > 1:
		# put command in history
		var inputedString : String = consoleInput.text
		consoleHistory.text += inputedString
		consoleInput.clear()
		# see what command user inputed
		if inputedString[0] == "/":
			var commandAndParams = inputedString.split(" ")
			for command in command_list:
				if commandAndParams[0].substr(1, command.length()) == command:
					command_list[command]
		



func get_command_list():
	print("HERE")
	print(command_list)
