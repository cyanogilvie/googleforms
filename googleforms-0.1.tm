oo::class create googleform {
	variable {*}{
		formname
		script
	}

	constructor args { #<<<
		if {[self next] ne ""} next
		package require tdom
		package require rl_json
		package require parse_args

		if {"::rl_json" ni [namespace path]}    {namespace path [list {*}[namespace path] ::rl_json]}
		if {"::parse_args" ni [namespace path]} {namespace path [list {*}[namespace path] ::parse_args]}

		parse_args $args {
			-name		{-required -name formname}
		}
	}

	#>>>
	method script {} { #<<<
		return "function myFunction() {\n\tvar form = FormApp.create([json new string $formname]), item;\n\n$script\n\tLogger.log('Published URL: ' + form.getPublishedUrl());\n\tLogger.log('Editor URL: ' + form.getEditUrl());\n}"
	}

	#>>>
	method addPageBreakItem args { #<<<
		parse_args $args {
			-title		{-required}
		}

		append script "\n\t//----------------------------------------------------------------------------\n"
		append script "\tform.addPageBreakItem().setTitle([json new string $title]);\n"
	}

	#>>>
	method addCheckboxItem args { #<<<
		parse_args $args {
			-title		{-default {}}
			-choices	{-default {}}
		}

		append script "\titem = form.addCheckboxItem();\n"
		if {$title ne ""} {
			append script "\titem.setTitle([json new string $title]);\n"
		}
		append script "\titem.setChoices(\[\n"
		set sep	""
		foreach choice $choices {
			append script $sep
			set sep	",\n"
			append script "\t\titem.createChoice([json new string $choice])"
		}
		append script "\n\t\]);\n"
	}

	#>>>
	method addTextItem args { #<<<
		parse_args $args {
			-title		{-required}
		}

		append script "\tform.addTextItem().setTitle([json new string $title]);\n"
	}

	#>>>
	method addParagraphTextItem args { #<<<
		parse_args $args {
			-title		{-required}
		}

		append script "\tform.addParagraphTextItem().setTitle([json new string $title]);\n"
	}

	#>>>
	method addMultipleChoiceItem args { #<<<
		parse_args $args {
			-title		{-default {}}
			-choices	{-required}
		}

		append script "\tform.addMultipleChoiceItem()\n"
		if {$title ne ""} {
			append script "\t\t.setTitle([json new string $title])\n"
		}
		append script "\t\t.setChoiceValues([my _list2array $choices]);\n"
	}

	#>>>
	method addSectionHeaderItem args { #<<<
		parse_args $args {
			-title		{-required}
		}

		append script "\tform.addSectionHeaderItem().setTitle([json new string $title]);\n"
	}

	#>>>
	method addGridItem args { #<<<
		parse_args $args {
			-title		{-default {}}
			-rows		{-required}
			-columns	{-required}
		}

		append script "\tform.addGridItem()\n"
		if {$title ne ""} {
			append script "\t\t.setTitle([json new string $title])\n"
		}
		append script "\t\t.setRows([string map [list \n \n\t\t] [json pretty [my _list2array $rows]]])\n"
		append script "\t\t.setColumns([my _list2array $columns])\n"
	}

	#>>>
	method _list2array list { #<<<
		set arr	{[]}
		foreach e $list {
			json set arr end+1 [json new string $e]
		}
		set arr
	}

	#>>>
}

# vim: ft=tcl foldmethod=marker foldmarker=<<<,>>> ts=4 shiftwidth=4
