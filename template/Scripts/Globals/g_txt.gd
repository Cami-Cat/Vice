@warning_ignore("integer_division")
extends Node

@onready var regex = RegEx.new()

## Uses regex to remove bb tags
func remove_bb_tags(input:String) -> String:
	regex.compile("\\[.*?\\]")
	input = regex.sub(input,"",true)
	return input

## Uses regex to remove resources ending in png[br]
## res://something.png would be removed from the string, used when remove inline images for indentation
func remove_png_resource_paths(input:String) -> String:
	regex.compile("res.*?png")
	input = regex.sub(input,"",true)
	return input

## Colors the input string and returns string [color = inputcolor] input [/color]
func color_text(input:String,color:Color) -> String:
	input = "[color=" + str(color.to_html(false))+"] " + input +  " [/color]"
	return input

## Colors all instances of word within given string and returns string
func color_word(input:String,word:String,color:Color) -> String:
	if word in input:
		var replacement = color_text(word,color)
		input = input.replace(word,replacement)
	else:
		push_error(str(self),"word to color not found in string")
	return input

## Colors all instances of words with given colors and returns string using a dict[br]
## Usage:
## [codeblock]
## func do_something():
##     var input:String = "The quick brown fox jumps over the lazy dog"
##     var dict = {"brown":Color.Brown,"lazy":Color.Blue}
##     var colored_string = color_words(input,dict)
func color_words(input:String,word_color_dict:Dictionary = {"null":Color.RED}) -> String:
	if word_color_dict[0] == "null":
		push_error(str(self),"word : color dict not set")
		return input
	for word in word_color_dict:
		input = color_word(input,word,word_color_dict[word])
	return input

## Hyperlinks input inserting the hyperlink callback string for use in the meta signal event in richtext lables
func hyperlink_text(input:String, hyperlink_callback_string:String) -> String:
	input = "[url=" + hyperlink_callback_string+"] " + input +  " [/url]"
	return input

## Hyperlinks all instances of word within given string and returns string
func hyperlink_word(input:String,word:String, hyperlink_callback_string:String) -> String:
	if word in input:
		var replacement = hyperlink_text(word,hyperlink_callback_string)
		input = input.replace(word,replacement)
	else:
		push_error(str(self),"word to hyperlink not found in string")
	return input

## Hyperlinks all instances of words with given hyperlink callback strings and returns string using a dict[br]
## Usage:
## [codeblock]
## func do_something():
##     var input:String = "The quick brown fox jumps over the lazy dog"
##     var dict = {"brown":"brown_callback","lazy":"lazy_callback"}
##     var hyperlinked_string = hyperlink_words(input,dict)
func hyperlink_words(input:String,word_linkcallback_dict:Dictionary = {"null":"null"}) -> String:
	if word_linkcallback_dict[0] == "null":
		push_error(str(self),"word : linkcallback dict not set")
		return input
	for word in word_linkcallback_dict:
		input = hyperlink_word(input,word,word_linkcallback_dict[word])
	return input

## Inserts image into rich text at given location using Texture2D defaults to front
func insert_image(input:String,image:Texture2D,location:int = 0) ->String:
	var insert = "[img=valign]"+image.resource_path+"[/img]"+input
	input = input.insert(location,insert)
	return input

## Inserts image into rich text at given location using ResourcePath defaults to front
func insert_image_resource_path(input:String,resource_path:String,location:int = 0) ->String:
	var insert = "[img=valign]"+resource_path+"[/img]"+input
	input = input.insert(location,insert)
	return input

## Linebreaks the input string at the given "linebreak_every"
## Automatically removes bb tags and png resource paths for correct linebreaks
## Usefull for runtime UI consistency
func linebreak_text(input:String, linebreak_every:int) -> String:
	var input_without_bb = remove_bb_tags(input)
	var input_without_res = remove_png_resource_paths(input_without_bb)
	var count = input_without_res.length()
	if linebreak_every < count:
		@warning_ignore("integer_division")
		var linebreaks_required:int = GFnc.iround_down_to(count,linebreak_every) / linebreak_every
		for n in linebreaks_required:
			var pos = input.find(" ", ((n+1)*linebreak_every))
			if pos > 0:
				input = input.insert(pos+1,"\n")
				input = input.erase(pos,1)
	return input

## Centers_text with center tag
func center_text(input:String) -> String:
	var length = input.length()
	input = input.insert(length,"[/center]")
	input = input.insert(0,"[center]")
	return input

## Converts float values to a percentage 
func float_to_percent_0_to_1(input:float) ->String:
	input = input*100.0
	return str(input) + "%"
