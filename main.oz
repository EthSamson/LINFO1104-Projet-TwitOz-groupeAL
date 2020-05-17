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

%%%LECTURE%%%
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

%%%PARSING%%%
    % Fonction qui renvoie une liste ou chaque element sont
    % des listes de mots formant les tweets
    % @pre L : une liste de Strings (les tweets)
    % @return : [tweet1 = [mot11 | mot12 | mot13 |...| nil]
    %            tweet2 = [mot21 | mot22 | mot23 |...| nil]
    %            ...                                       ]
    fun {Parsing Li}
       case Li
       of H |T then {String.tokens {ParsStr H} & }|{Parsing T}
       [] nil then nil end
    end

    % Fonction qui modifie les caractères inutiles d'un tweets
    fun {ParsStr Tw}
       case Tw
       of H|T then
	  % Remplacer par des espaces
	  if H==35 then 32|{ParsStr T} %#
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

	  elseif H==59 then 32|{ParsStr T} %;
          elseif H==58 then 32|{ParsStr T} %:
          elseif H==44 then 32|{ParsStr T} %,
          elseif H==39 then 32|{ParsStr T} %'

          elseif H==63 then 32|{ParsStr T} %?
          elseif H==33 then 32|{ParsStr T} %!
          elseif H==46 then 32|{ParsStr T} %.

	  % Tout mettre en minuscules
	  %elseif {Char.isUpper H} then {Char.toLower H}|{ParsStr T}
	     
	  % Ne pas changer les lettres
          else H|{ParsStr T} end
       [] nil then nil end
    end

%%%SAUVEGARDE%%%
   %Regarde la liste de tweet par tweet
    proc {SaveInDic1 D Lt}
       case Lt
       of H|T then
 	  {SaveInDic2 D H}
	  {SaveInDic1 D T}
       [] nil then skip end
    end

   %Regarde le tweet mot par mot et ajouter dans le dictionnaire
    proc {SaveInDic2 D Lm}
       case Lm
       of H|T then
	  if T\=nil then
	     {AddInDic D {String.toAtom H} {String.toAtom T.1}}
	     {SaveInDic2 D T}
	  else
	     {AddInDic D {String.toAtom H} {String.toAtom "."}} %Si en bout de ligne assimile a un point
	  end
       [] nil then skip end
    end

   %Ajoute proprement dans le dictionnaire en evitant les cas ou Key et Val sont nil
    proc {AddInDic D Key Val}
       if Val=={String.toAtom nil} then skip
       elseif Key=={String.toAtom nil} then skip
       elseif {Dictionary.member D Key} then
	  {Dictionary.put D Key {ChangeTupleInDic {Dictionary.get D Key} Val}}
       else
	  {Dictionary.put D Key Val(1)|nil}
       end
    end

    %Renvoie une nouvelle liste avec le tuple Val change
    fun {ChangeTupleInDic Lt Val}
       case Lt
       of H|T then
 	 if Val=={Label H} then 
 	    {Tuple.append add(1) H}|T
 	 else H|{ChangeTupleInDic T Val} end
       [] nil then Val(1)|nil end
    end

%%%PREDICTION ECRITURE%%%
    %Renvoie le label du plus grand tuple sous forme de String
    %@pre : W et L sont des accumulateurs initialise a 0 et nil
    %       Lm est la valeur du dictionnaire a la key voulue
    fun {Pred Lm W L}
       case Lm
       of H|T then
	  if W=<{Width H} then {Pred T {Width H} {Label H}}
	  else {Pred T W L} end
       [] nil then {Atom.toString L} end
    end
 
%%% Main
    Dic = {NewDictionary}
    for N in 1..12 do F1 F2 Li1 Li2 Lp1 Lp2 L1 L2 P1 P2 S1 in
       F1 = "tweets_dummies/part_"#(N)#".txt"
       F2 = "tweets_dummies/part_"#(N+12)#".txt"
       thread Li1 = {Lecture F1} L1=1 end
       thread Li2 = {Lecture F2} L2=1 end

       thread {Wait L1} Lp1 = {Parsing Li1} P1=1 end
       thread {Wait L2} Lp2 = {Parsing Li2} P2=1 end

       thread {Wait P1} {SaveInDic1 Dic Lp1} S1=1
	      {Wait P2} {Wait S1} {SaveInDic1 Dic Lp2} end
    end

    %Test pour visualiser lecture et parsing
    %Dic={NewDictionary} L P L1 P1 S1
    %thread L = {Lecture "tweets/aTest_1.txt"} L1=1 end
    %thread {Wait L1} P = {Parsing L} P1=1 end
    %{Browse P}
    %thread {Wait P1} {SaveInDic1 Dic P} {Browse {Dictionary.entries Dic}} S1=1 end
    %{Wait S1}
    %{Browse {Pred {Dictionary.get Dic {String.toAtom "Je"}} 0 nil}}
    %ATTENTION Dic pas accessible en dehors du thread
	  
%%% GUI
    % Make the window description, all the parameters are explained here:
    % http://mozart2.org/mozart-v1/doc-1.4.0/mozart-stdlib/wp/qtk/html/node7.html)
    Text1 Text2 Description=td(
        title: "Frequency count"
        lr(
            text(handle:Text1 width:35 height:10 background:white foreground:black wrap:word)
	    button(text:"Prédiction   " action:Press)
        )
        text(handle:Text2 width:35 height:10 background:black foreground:white glue:w wrap:word)
        action:proc{$}{Application.exit 0} end % quit app gracefully on window closing
    )
    proc {Press} Inserted S E A in
        S = {String.tokens {Text1 getText(p(1 0) 'end' $)} & }
        E = {List.last S}
        %{Browse E}
        A = {String.tokens E &\n}
        %{Browse A.1}
        Inserted = {Pred {Dictionary.get Dic {String.toAtom A.1}} 0 nil}% example using coordinates to get text      
        {Text2 set(Inserted)} % you can get/set text this way too
    end
    % Build the layout from the description
    W={QTk.build Description}
    {W show}

    {Text1 bind(event:"<Control-s>" action:Press)} % You can also bind events

    {Show 'You can print in the terminal...'}
    {Browse '...or you can use the Browser'}
end
