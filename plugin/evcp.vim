" *** Embedded Vim Preprocessor Version 1.0 ***
"
" First Of All: Let me tell you that it is a very basic Preprocessor, i was
" 	trying to find some of these programs like orb, ppwizard, etc.
" 	Vim is really a world, so I tought: Why vim doesn't have something
" 	similar? then I have tried to work on it and... here it is the first
" 	try.
" 
" Author: Roberto Morales
"
" Install Deatils: Only Source this file.
"
" Description: use ':%PPEV' at the current file, this program will
"   ask you the name of the file you want to receive the processed output file.
"
" Show Me Step By Step How To Use It:
"
"	1.- Once you have sourced this file you can use this PPEV command
"	2.- For example:
"		Create a new file with the following lines
"
"		----------------File: test.txt ----------------
"		<html>
"			<head>
"				<title>Testing what Robert said</title>
"			</head>
"			<body>
"				<!-- Creating ten buttons in a form -->
"				<form name=\"test\">
"					<?vim>let i=0|while i<11</?vim>
"
"					<input type=\"button\" name=\"btn_<?vim=i>\" value=\"MyButton_<?vim=i.".">\">
"					<?vim>
"
"						let i=i+1  " don't forget
"					
"						endw
"
"					</?vim>
"				</form>
"
"
"			</body>
"		</html>
"		----------------End Of File: test.txt ----------------
"
"	3.- Write the file
"	4.- type <ESC> :%PPEV
"	5.- type the new name of the file like test.html (if it doesn't
"	    exists)
"	5.- Save the changes (wall)
"	6.- open test.html in your browser and see the results
"
" ---------------------------END OF EXAMPLE-----------------------------
" 
"
" Known Bugs: I have tested it with HTML files when you use one of this
"   characters: ",'  they aren't parsed correctly, in order to use them
"   you will need to type them as: \", \' you may consider this bug as a part
"   of the first version of EVP.
"
"  
"	
" Features: 
" 	Actually you can use two kinds of tags like:
" 	   <?vim> 		<---openning vim statements
" 	   </?vim> 		<---closing vim statements
" 	   <?vim> </?vim>	<---this is basically the same
" 	   <?vim={Expression}>	<---where Expression is a variable name string
" 	   			or something else
"
" How Does It Work: 
"
" 	(This is the algorithm)
" 	
" 	1.-It creates a new buffer
" 	2.-It parses line by line and create append statements in that new
" 	buffer, when a vim code statement arrives it just moves it to that 
" 	new buffer
" 	3.-It save that new file
" 	4.-It sources that statements in the new buffer
" 	5.-finally it deletes all the new Vim generated code
"
" Future Versions: 
"   *Include statement	(at this time you can use filters like !!)
"   *define statement	(at this time you can use simple vim variables)
"   *ifdef statement	
"   *ifndef statement
"   *A real good parser
" 
" Consider:
" 	Consider helping a Vim beginner(me) to create a better Preprocessor
" 	for our favorite text editor (Vim).
"
"
" NOTE:
"   	I have included the testing example testing.txt and the testing.html generated
"   	by this script.
"
"


function! Ev2PP(from,to)

	let actual=bufnr("%")

	let fn=input("Please write the new file name: ") 
	:exec "new ".fn
	call setline(".","\"---Generated Intermediate Embedded Vim File---")
	let nuevo=bufnr("%")
	:exec "".bufwinnr(actual)." winc w"
	
	let index=a:from
	let code=0

	while(index<=a:to)
		let ln=getline(index)
		if match(ln,"<?vim>")>-1 
			let code=1
		elseif match(ln,"</?vim>")>-1 
			let code=0
		else 

		endif
			:exec "".bufwinnr(nuevo)." winc w"
		if match(ln,"</?vim>")>-1 && match(ln,"<?vim>")>-1
			let ln2=substitute(ln,"<\?vim>","","g")
			let ln2=substitute(ln2,"</?vim>","","g")
			call append("$",ln2)
			let code=0
		elseif code==1 && match(ln,"<?vim>")==-1 && match(ln,"</?vim>")==-1
			call append("$",ln)
		elseif code==0 && match(ln,"</?vim>")==-1
			let ln2=substitute(ln,"<?vim=\\(.\\{-\\}\\)>","\"\\.\\1\\.\"","g")
			call append("$","call append(\"$\",\"".ln2."\")")


		endif
			:exec "".bufwinnr(actual)." winc w"

		let index=index+1
	
	endw
			:exec "".bufwinnr(nuevo)." winc w"
			:write
			let lastln=line("$")
			:so%
			execute "1,".lastln." delete"
	
	

endf


command! -range PPEV call Ev2PP(<line1>,<line2>)
