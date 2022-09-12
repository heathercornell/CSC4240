;;==========================================================================
;;
;; STARTER FILE FOR CSC 4240/5240 PROGRAM #1: Eliza
;;==========================================================================

;;----------------------------------------------------------------------------
;; eliza: top-level function which, when given a sentence (no
;; punctuation, please!), comes back with a response like you would.

( defun eliza ( sentence )
  ( respond ( change-pros sentence ) database ) )

;;----------------------------------------------------------------------------
;; change-pros: changes the pronouns of the sentence so that Eliza can
;; come back with the appropriately switched first and second person
;; references.

( defun change-pros ( sentence )
  ( cond 
    ( ( null sentence ) nil )
    ( ( equal ( car sentence ) 'you )
      ( cons 'I ( change-pros ( cdr sentence ) ) ) )
    ( ( equal ( car sentence ) 'I )
      ( cons 'you ( change-pros ( cdr sentence ) ) ) )
    ( ( equal ( car sentence ) 'My )
      ( cons 'your ( change-pros ( cdr sentence ) ) ) )
    ( ( equal ( car sentence ) 'I )
      (cons 'my ( change-pros ( cdr sentence ) ) ) )
    ( ( equal (car sentence ) 'am )
      ( cons 'are (change-pros ( cdr sentence ) ) ) )
    ( ( equal ( car sentence ) 'Im )
      (cons 'youre (change-pros (cdr sentence ) ) ) )


    ;; CHANGE THIS: add more cases here of pronouns or other words
    ;; that should flip in order for this to work well

    ( t ( cons ( car sentence ) ( change-pros ( cdr sentence ) ) ) ) ) )

;;----------------------------------------------------------------------------
;; respond: given a sentence, looks through the database in search of
;; a matching pattern and the response; given the database response,
;; uses 'instantiate' to fill in the blanks, and returns the completed
;; response

( defun respond ( sentence db )
  ( cond
    ;; end of DB, return nil - should never really happen
    ( ( null db ) (randList myList) )

    ;; if the result of matching the sentence against the current
    ;; pattern is a success, produce this response
    ( ( success ( setq result ( match sentence ( first ( car db ) ) ) ) )
      ( instantiate result ( second ( car db ) ) ) )

    ;; otherwise, keep looking through the DB
    ( t ( respond sentence ( cdr db ) ) ) ) )

;;----------------------------------------------------------------------------
;; match: if there is not a match between this pattern and this data,
;; returns 'fail;' otherwise, returns the sentence in partitioned
;; format

( defun match ( data pattern )
  ( cond
    ;; end of both data and pattern; a match
    ( ( and ( null data ) ( null pattern ) ) nil )

    ;; end of pattern, but not end of data; no match
    ( ( null pattern ) fail )

    ;; end of data, but not end of pattern; if the pattern starts with
    ;; a variable, eat it and try and match the rest of the pattern to
    ;; the null sentence (will only work if all variables); otherwise,
    ;; fail
    ( ( null data ) 
      ( cond
	( ( variablep ( car pattern ) )
	  ( if ( success ( setq result ( match data ( cdr pattern ) ) ) )
	      result
	    fail ) )
	( t fail ) ) )


    ;; first item of data and pattern are identical; if the rest of it
    ;; matched, return the first item cons'ed with the rest of the
    ;; partitioned sentence; otherwise, fail
    ( ( equal ( car data ) ( car pattern ) )
      ( if ( success ( setq result ( match ( cdr data ) ( cdr pattern ) ) ) )
	  ( cons ( list ( car data ) ) result )
	fail ) )

    ;; first item of pattern is a variable; if the rest of the data
    ;; (minus the first word, matched to the variable) is a match with
    ;; all of the pattern, return the appropriate stuff; if all of the
    ;; data (variable eats nothing) matches the rest of the pattern,
    ;; return appropriate stuff; else, fail.
    ( ( variablep ( car pattern ) ) 
      ( cond
	;; variable eats nothing;  () is put in partitioned sentence
	( ( success ( setq result ( match data ( cdr pattern ) ) ) )
	  ( cons () result ) )
	;; variable eats one word; word is cons'ed into the first
	;; element of the partitioned sentence, assuming that the step
	;; before an actual match word would be a ()
	( ( success ( setq result ( match ( cdr data ) pattern ) ) )
	  ( cons ( cons ( car data ) ( car result ) ) ( cdr result ) ) )
	;; otherwise, fail
	( t fail ) ) )

    ( t fail ) ) )

;;----------------------------------------------------------------------------
;; instantiate: takes a partitioned sentence and the response it has
;; been matched to and generates the appropriated completed response

( defun instantiate ( partitioned response )
  ( cond
    ( ( null response ) nil )
    ;; numbers indicate what part of the partitioned sentence to
    ;; insert into the response
    ( ( numberp ( car response ) )
      ( setq index ( - ( car response ) 1 ) )
      ( append ( nth index partitioned )
	     ( instantiate partitioned ( cdr response ) ) ) )
    ( t ( cons ( car response )
	     ( instantiate partitioned ( cdr response ) ) ) ) ) )

;;---------------------------------------------------------------------------
;;
;;  			     helping functions
;;
;;---------------------------------------------------------------------------

( setq fail '-1 )

( defun success ( result )
  ( not ( equal result fail ) ) )

( defun variablep ( word )
  ( equal word '0 ) )

(setf myList '
  ( (Could you expand on that?)(Ask me how I am!)(Sorry - I did not understand that.)(Ask me something else.)))

(defun randList ( myList)
  (nth (random ( length myList ) ) myList))

;;---------------------------------------------------------------------------
;;
;;  			         database
;;
;;---------------------------------------------------------------------------

;; CHANGE THIS: add more to this database so that the interaction is
;; more interesting and communicative and so that Eliza sounds like you 
;; would sound in the same conversation!
;;---------------------------------------------------------------------------

( setq database
       '(
	 ;; example greetings/farewells -- change them to sound like you
	 ( (Hello 0)
	   (Hello - have a seat and chat! ) )
	 ( (0 you came here because 0)
	   (A lot of people come here for that reason so you are not alone.) )
	 ( (0 Goodbye 0)
	   (Goodbye - I hope you have a good rest of your day.) )
	 ( (Whats good 0)
	   (Not much - what is good with you?) )
	 ( (Howdy )
	   (Howdy - How are you today? ) )

	 ;;statements/questions
         ( (Is there anything I feel strongly about? 0 ) 
           (Yes I believe that aliens are real.))
	 
	 ;;default responses
	 ( (Why 0? )
	   (Why do you think 2 ) )
	 ( (Because 0 )
	   (I guess 2) )
	 ( (No )
	   (Thats negative - do you have any other reason ) )
	 ( (youre not sure 0)
	   (What can help you to make a decision on 4) )
	 ( (What do I want to eat) 
	   (I like all kinds of food. What is your favorite food ) )
	 ( (your favorite 0 is 0)
	   (I also love 5 - they are one of the best 3) )
	 ( (Do robots need to eat )
	   (No but we still like to try foods) )

	 ;; feelings
	 ( (0 you think 0) 
	   (And just why do you think 4 ) )
	 ( (Do I think 0 )
	   (No I do not think 4 - but some others do. ) )
         ( (0 you feel 0 )  
           (What makes you feel 4 ) )
         ( (your 0 )
           (Why does your 2 ) ) 
	 ( (you was 0 ) 
	   (Why were you 3 ) )
	 ( (Why would I think 0 ) 
	   (What else does a robot have to do aside from 4 ) )
	 ( (youre doing 0 ) 
	   (Glad to hear you are doing 3 ) )	
	 ( (How are I 0 ) 
	   (A lil hungry but I am okay ) )
	 ( (0 is 0 )
	   (Why is 1 3 ) )	 
	 ( (Its 0 )
	   (I agree - it is 2 ) )
	 ( (Are I 0 )
	   (I may be  - but it depends who you ask) ) ) )
