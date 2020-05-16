functor
import
    QTk at 'x-oz://system/wp/QTk.ozf'
    System
    Application
    OS
    Browser

    Reader
define
%%% Easier macros for imported functions
    Browse = Browser.browse
    Show = System.show

%%% Read File
    fun {GetFirstLine IN_NAME}
        {Reader.scan {New Reader.textfile init(name:IN_NAME)} 1}
    end

%%% Lecture - Producer 1
    % Cree une liste ou chaque element est un tweet du fichier FileName
    fun {Lecture FileName}
       fun {LectureAux N} L in
	  L = {Reader.scan {New Reader.textfile init(name:FileName)} N}
	  if L\=none then L|{LectureAux N+1}
	  else nil end
       end
    in
       {LectureAux 1}
    end

%%% Parsing - Consumer 1/Producer 2
    % Renvoie une liste ou chaque element sont modifié
    % @pre L : une liste de Strings (les tweets)
    fun {Parsing L}
       case L
       of H|T then {ParsStr H}|{Parsing T}
       [] nil then nil end
    end
    
%%% Fonction qui modifie les caractères
    fun {ParsStr Tw}
       case Tw
       of H|T then
	  if H==35 then 32|{ParsStr T} %#
	 % Remplacer par des espaces
	  elseif H==64 then 32|{ParsStr T} %@
          elseif H==36 then 32|{ParsStr T} %$
          elseif H==37 then 32|{ParsStr T} %%
          elseif H==95 then 32|{ParsStr T} %_
          elseif H==91 then 32|{ParsStr T} %[
          elseif H==93 then 32|{ParsStr T} %]
          elseif H==123 then 32|{ParsStr T} %{
          elseif H==125 then 32|{ParsStr T} %}
          elseif H==38 then 32|{ParsStr T} %&
          elseif H==42 then 32|{ParsStr T} %*
          elseif H==47 then 32|{ParsStr T} %/

	 % Remplace par un vides
	  elseif H==59 then {ParsStr T} %;
          elseif H==58 then {ParsStr T} %:
          elseif H==44 then {ParsStr T} %,
          elseif H==39 then {ParsStr T} %'

	 % Remplacer par des points
          elseif H==63 then 46|{ParsStr T} %?
          elseif H==33 then 46|{ParsStr T} %!

	 % Ne pas changer les lettres
          else H|{ParsStr T} end
       [] nil then nil end
    end


	  
%%% Main
%    for N in 1..1 do F L in
%       F1 = "tweets/aTest_"#(N)#".txt"
%       F2 = "tweets/_"#(N+104)#".txt"
%       thread Li1 = {Lecture F1} end
%       thread Li2 = {Lecture F2} end

%       thread Lp1 = {Parsing Li1} end
%       thread Lp2 = {Parsing Li2} end
%
%       thread {Sauvegarde Li2} end

    %Test pour visualiser lecture et parsing
    local L M in
       thread L = {Lecture "tweets/aTest_1.txt"} end
       {Browse L}
       thread M = {Parsing L} end
       {Browse M}
    end
	  
%%% GUI
    % Make the window description, all the parameters are explained here:
    % http://mozart2.org/mozart-v1/doc-1.4.0/mozart-stdlib/wp/qtk/html/node7.html)
    Text1 Text2 Description=td(
        title: "Frequency count"
        lr(
            text(handle:Text1 width:35 height:10 background:white foreground:black wrap:word)
            button(text:"A changer!!" action:Press)
        )
        text(handle:Text2 width:35 height:10 background:black foreground:white glue:w wrap:word)
        action:proc{$}{Application.exit 0} end % quit app gracefully on window closing
    )
    proc {Press} Inserted in
        Inserted = {Text1 getText(p(1 0) 'end' $)} % example using coordinates to get text
        {Text2 set(1:Inserted)} % you can get/set text this way too
    end
    % Build the layout from the description
    W={QTk.build Description}
    {W show}

    {Text1 tk(insert 'end' {GetFirstLine "tweets/part_1.txt"})}
    {Text1 bind(event:"<Control-s>" action:Press)} % You can also bind events

    {Show 'You can print in the terminal...'}
    {Browse '...or you can use the Browser'}
end
