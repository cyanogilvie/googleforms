Google Forms
============

This package allows Tcl script to programmatically construct a Google Form, by
generating a Javascript script that executes in Google App Scripts to construct
the form.

Method names follow the form class methods (hence the camelCase).  Values
interpolated into the Javascript are safely quoted.

Not all available methods are implemented yet, raise an issue if there is one
you need that is lacking.

Requirements
------------

Tcl >= 8.6, rl_json, parse_args

Example
-------

~~~tcl
package require googleforms

googleform create form -name "My Test Form"

# Add a simple text input
form addTextItem -title "First Name"

# Add a paragraph text input
form addParagraphTextItem -title "Address"

# New section
form addPageBreakItem -title "Preferences"

# Add a group of checkboxes
form addCheckboxItem -title "Pets" -choices {
	Cats
	Dogs
	Rhinos
}

# Add a multiple choice question (radiobutton group)
form addMultipleChoiceItem -title "In case of emergency, administer" -choices {
	Tea
	Coffee
	"More Coffee"
}

# A text header
form addSectionHeaderItem -title "Example of a GridItem"

# Add an array of multiple choice items, with the same choices for each
form addGridItem -title "Rate your agreement with the following statements" -rows {
	"Tcl > JS"
	"Metaprogramming: fun and safe"
	"Coffee is the most important meal of the day"
} -columns {
	"Strongly disagree"
	Disagree
	Neutral
	Agree
	"Strongly Agree"
}

# Generate the Javascript to generate the form
puts [form script]

# Paste the resulting output into a new project on scripts.google.com, run it,
# accept the permission prompt.  The new form will be on your docs.google.com
~~~
