" *** Embedded Vim Preprocessor Version 1.0.1 ***
"
" New Features:
"   <?vim:include="file.xxx"> statement
" 
" Author: Roberto Morales
"
" Install Deatils: Only Source this file.
"
" Description: use ':%PPEV' at the current file, this program will
"   ask you the name of the file you want to receive the processed output file.
"   Not necesary to specify a range it will process the whole file at this
"   moment.
"
" Show Me Step By Step How To Use It:
"
"  
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
"				<form name="test">
"					<?vim>let i=0|while i<11</?vim>
"
"					<input type="button" name="btn_<?vim=i>" value="MyButton_<?vim=i.'.'>">
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
" Known Bugs: Use <?vim='...'.var.'...'> instead of <?vim="...".var."...">, well
" i expect to correct that soon
"
"  
"	
" Features: 
" 	Actually you can use three tags styles:
" 	   <?vim> 			<---openning vim statements
"
" 	   </?vim> 	      		<---closing vim statements
"
" 	   <?vim> </?vim>     	  	<---this is basically the same
" 	   
" 	   <?vim={Expression}>		<---where Expression is a variable name
" 	   				, string or something else.
" 	   				For strings use ' instead of "
"
" 	   <?vim:include="{filename}"> 	<-where filename is a file you want to
" 	   				insert.
" 	   				Note: it will be processed too,
" 	   				be careful with nested files not to
" 	   				call a file itself, in order to have
" 	   				control use <?vim>if {expr}</?vim>
" 	   				statements
"
" How Does It Work: This algoritm is a little diferent to the previous version
"
" 	
" 	1.-Saves the current buffer as CurrentFileName.evcp(intermediate file)
" 	2.-Reopen it and process each include statement
" 	3.-Writes the changes
" 	4.-Creates the new file
" 	5.-Navigates line by line and creates append statements in that new
" 	buffer, when a vim code statement arrives it just moves it to that 
" 	new buffer
" 	6.-Saves that new file
" 	7.-Sources itself
" 	8.-finally it deletes all the new Vim generated code
"
" Pending Features: 
"   *define statement	(at this time you can use vim variables)
"   *ifdef statement	
"   *ifndef statement
"   *A real good parser
"   *A syntax file
" 
" Consider:
" 	Consider helping a Vim beginner(me) to create a better Preprocessor
" 	for our favorite text editor (Vim).
"
"
" NOTE:
"   	I have included the testing example testing.txt and the 
"   	testing.html generated by this script.
"
"   	I have tested it, and developed it on Windows XP.
"
" BEST PRACTICES:
" 	Name your source files like header_source.html, footer_source.html, it
" 	will let you to identify that it is an unprocessed file ("source")
" 	wich will be written as an html file
"

function! Ev2PP(from,to)
	"procesing included files
	:silent exec "write! ".expand("%").".evcp"
	:silent exec "split ".expand("%").".evcp"
	let result=search("<?vim:include=\\\"\\(.\\{-\\}\\)\\\">", "w") 
	while result>0
		silent exec "normal ".result."G"
		:s/<?vim:include=\"\(.\{-\}\)\">/.!type \1/g
		silent exec getline(".")
		let result=search("<?vim:include=\"\\(.\\{-\\}\\)\">", "w") 
	endwhile
	update	
	"end of procesing included files
	
	"get current buffer
	let actual=bufnr("%")
		"get the new buffer file
	let fn=input("Please type the new file name: ") 
	:exec "new ".fn
	:% delete
	call setline(".","\"---Generated Intermediate Embedded Vim Code v1.0.1---")
	let nuevo=bufnr("%")
		"switch again to the current buffer
	:exec "".bufwinnr(actual)." winc w"
		"start processing loop
	normal "%G"
	let index=1
	let endc=line(".")
	let code=0
	while(index<=endc)
		let ln=getline(index)

		"looking for identifiers
		if match(ln,"<?vim>")>-1 
			let code=1
		elseif match(ln,"</?vim>")>-1 
			let code=0

		else 

		endif
			:exec "".bufwinnr(nuevo)." winc w"
		"Processing identifiers
		if match(ln,"</?vim>")>-1 && match(ln,"<?vim>")>-1
			let ln2=substitute(ln,"<\?vim>","","g")
			let ln2=substitute(ln2,"</?vim>","","g")
			call append("$",ln2)
			let code=0
		elseif code==1 && match(ln,"<?vim>")==-1 && match(ln,"</?vim>")==-1 && match(ln,"^$")!=0
			call append("$",ln)
		elseif code==0 && match(ln,"</?vim>")==-1 
			let ln2=escape(ln, '\"')
			let ln2=substitute(ln2,"<?vim=\\(.\\{-\\}\\)>","\"\\.\\1\\.\"","g")

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
			:exec "".bufwinnr(actual)." winc w"
			:q!
endf


command! -range PPEV call Ev2PP(<line1>,<line2>)


