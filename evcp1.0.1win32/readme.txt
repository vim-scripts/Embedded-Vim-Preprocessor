This time i have included a more complex example using <?vim:include=""> statement.

Processing structure:

+----generated.html (it is the output file)
       |
       +-page_source.html (it is the file to be processed)
         |
         +---1layer_source.html
               |
               +---header_source.html
               |
               +---footer_source.html


I mean, generated file is generated as a result of processing page_source.html file, the other nested files are basic structures that will be processed by EVCP too by applying %PPEV on page_source.html
