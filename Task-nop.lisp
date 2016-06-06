
;;	screw driving Parameters
	(defvar parts 1)
	(defvar parts_indexes (loop for i from 1 to parts collect i))
	(defvar jigs 1)
	(defvar jigs_indexes (loop for i from 0 to (- jigs 1) collect i))
	; (defvar iteration_index 0)
		

;; Task Parameters
	; actions(i 0) -->priority
	; actions(i 1) -->status
	; actions(i 2) -->exeTime
	; actions(i 3) -->subject

	(define-tvar actions *int* *int* *int*)
	(define-tvar Action_Pre *int* *int*)
	(define-tvar Action_Post *int* *int*)
	(define-tvar Action_SafetyPro *int* *int*)
	(defvar actions-indexes (loop for i from 1 to (+ 8 (* 6 jigs)) collect i))
	; (defvar similar-sf-indexes (loop for i from 5 to 9 collect i))

	;;Statuses
		(defvar notstarted 0)
		(defvar waiting 1)
		(defvar executing 2)
		; (defvar parallel-executing 3)
		(defvar pause 3)
		(defvar done 4)

	; ;;priorities
	; 	(defvar superhigh-p 4)
	; 	(defvar high-p 3)
	; 	(defvar medium-p 2)
	; 	(defvar low-p 1)
	
	;subject identifier
		
		(defconstant operator 1)
		(defconstant robot 2)

(defconstant *ActionInit*

 (alwf 

 	(&&
 		 ; Initialization of priority
 			 (-A- i actions-indexes
 			 	(&& 
 			 		 ; ([=] (-V- actions i 0) (- (+ 7 (* 7 jigs)) i))

	    
 		;;;;; 	 	 ([=] (-V- actions 14 0) 1) ;;;;;;;
	 	 	 	
	 	    
	 	  

	 	 ; Initialization of exe-time
	 	    
	 	    
		 	 	 ([=] (-V- actions i 2) 3)
	 	 	 )
		 	)


 	 	 ; Initialization of subject
 	 	 		 ([=] (-V- actions 1 3) operator)
		 	 	 ([=] (-V- actions 2 3) operator)
		 	 	 ([=] (-V- actions 3 3) operator)
		 	 	 ([=] (-V- actions 4 3) operator)
		 	 	 ([=] (-V- actions 5 3) operator)
		 	 	 ([=] (-V- actions 6 3) robot)
		 	 	
		 	 	 (-A- k jigs_indexes

			 	 (&&
			 	 	 ([=] (-V- actions (+  (* k 6) 7) 3) operator)
			 	     ([=] (-V- actions (+  (* k 6) 8) 3) robot)
		    	     ([=] (-V- actions (+  (* k 6) 9) 3) robot)
			 	 	 ([=] (-V- actions (+  (* k 6) 10) 3) robot)
			 	 	 ([=] (-V- actions (+  (* k 6) 11) 3) robot)
			 	 	 ([=] (-V- actions (+  (* k 6) 12) 3) robot)
		 	 	 )

		 	 	 )
		 	 	 ([=] (-V- actions (+  (* (- jigs 1) 6) 13) 3) operator)
		 	 	 ([=] (-V- actions (+  (* (- jigs 1) 6) 14) 3) robot)
		 	 	 
	 	 		
	 	 	 )
		)	 	 
	)

(defconstant *SeqAction* 
 	  (alwf 
	      (-A- i actions-indexes
	       (&& 
	       ;status among 1 to 5
		       (&& ([>=] (-V- actions i 1) 0) ([<=] (-V- actions i 1) 4))
		       ;;

		       ;if now notStarted, it was not done and executed before

		       (->
			       	([=] (-V- actions i 1) notstarted)
			       	(&&
			       	(!! (somp ([=] (-V- actions i 1) executing)))
			       	; (!! (somp ([=] (-V- actions i 1) parallel-executing)))
			       	(!! (somp ([=] (-V- actions i 1) done)))
			       	)
		       	)

		       ;if now waiting somp it was notstarted
		        (->
			       	([=] (-V- actions i 1) waiting)
			       	(&&
	       			(somp ([=] (-V- actions i 1) notstarted))
			       	(!! (somp ([=] (-V- actions i 1) executing)))
			       	; (!! (somp ([=] (-V- actions i 1) parallel-executing)))
			       	(!! (somp ([=] (-V- actions i 1) done)))
			       	)
			       
		       	)
		      		
	      		(-> ;if it is executing then it has started in the past, not done in the past and not starting in the future
	            		; (|| 
	            		([=] (-V- actions i 1) executing)
	            		 ; ([=] (-V- actions i 1) parallel-executing))
	            		(&&
	                              (somp ([=] (-V- actions i 1) notstarted))
	                              (somp ([=] (-V- actions i 1) waiting))
	                              (!! (somp ([=] (-V- actions i 1) done)))
	                              (!! (somf ([=] (-V- actions i 1) notstarted)))
	                              (!! (somf ([=] (-V- actions i 1) waiting)))
	                              (somf ([=] (-V- actions i 1) done))
	                     )
	      		)

	      		(->
	      			([=] (-V- actions i 1) pause) 
					(&&
                      ; (||
                      	(somp 
                      ([=] (-V- actions i 1) executing)
                      )
                       ; (somp ([=] (-V- actions i 1) parallel-executing)))
                      ; (||
                      (somf ([=] (-V- actions i 1) executing)) 
                      ; (somf ([=] (-V- actions i 1) parallel-executing)))
                      (!! (somf ([=] (-V- actions i 1) notstarted)))
			       	  (!! (somf ([=] (-V- actions i 1) waiting)))
			       	  ; (yesterday
			       	  ; 	; (|| 
			       	  ; 	([=] (-V- actions i 1) executing) 
			       	  ; 	; ([=] (-V- actions i 1) parallel-executing) ([=] (-V- actions i 1) pause)
			       	  ; 	; )
			       	  ; )
                 

                    )
	      		)

	      		;when it is executing then there were no notstarted from last waiting to the start of the execution
	      		(->
	      			; (||
						([=] (-V- actions i 1) executing)
						; ([=] (-V- actions i 1) parallel-executing)
					; )

					(somp 
						(&& 
							([=] (-V- actions i 1) waiting) 
							; (alwf (!! ([=] (-V- actions i 1) notStarted)))
							(Until_ie (!! ([=] (-V- actions i 1) notStarted)) ([=] (-V- actions i 1) executing))
						)
					)

      			)



	    ;   		(->  ;definition of parallel executing
	    ;   			(-E- j actions-indexes
					; 	(&&
					; 		([=] (-V- actions i 1) executing)
					; 		([!=] j i)
					; 		(||
					; 			([=] (-V- actions j 1) executing)
					; 			([=] (-V- actions j 1) parallel-executing)
					; 		)
					; 	)
					; 	)
					
					; 		([=] (-V- actions i 1) parallel-executing)

	      				
					; )
      			

	      		;
	      		;;Robot in home before Action6
	      		(->
	      			(!!([=] (-V- actions 4 1) done))
	      			(-P- Robot_Homing)
	      		)
	      		 
	      		(-> ; waiting robot action must be executed right away
	      			(&& 
	      				([=] (-V- actions i 1) waiting)
	      				([=] (-V- actions i 3) robot)
	      			)
	      			
	      			; (||
		      			(next ([=] (-V- actions i 1) executing))
		      			; (next ([=] (-V- actions i 1) parallel-executing))
	      			; )
	      		)

	      		(-> ; waiting robot action eventually should be executed
	      			(&& 
	      				([=] (-V- actions i 1) waiting)
	      				([=] (-V- actions i 3) operator)
	      			)
	      			
	      			(||
		      			(withinf_ie ([=] (-V- actions i 1) executing) 5)
		      			; (withinf_ie ([=] (-V- actions i 1) parallel-executing) 5)
		      			(withinf_ie ([=] (-V- actions i 1) notstarted) 5)
	      			)
	      		)


	      		
      			; (-E- i, j actions-indexes
      			
      			(-A-  j actions-indexes
      				(-A-  i actions-indexes 
      					(->
		      				(&&
		      					([=] (-V- actions i 3) operator)
		      					([=] (-V- actions j 3) operator)
		      					([=] (-V- actions i 1) executing)
		      					([=] (-V- actions j 1) executing)
		      					(!! ([=] i j))

	      					)
      				
		  					(!! 
		  						(-E- k actions-indexes
		  							(&&
			      						([=] (-V- actions k 3) operator)
				      					([=] (-V- actions k 1) executing)
				      					(!! ([=] i k))
				      					(!! ([=] k j))
			      					)
		      					)
							) 
  						)
  					)
  				)
      				


	      		; (->
	      		; 	([=] (-V- actions i 1) parallel-executing)
	      		; 	(-E- j actions-indexes
	      		; 		(&&
		      	; 			([=] (-V- actions j 1) parallel-executing)
		      	; 			([!=] j i)
	      		; 		)

	      		; 	)
      			; )


	      		(-> ;definition of done
	            		([=] (-V- actions i 1) done)

	            		(&&
	            			;when a Action is done it remains done until loop for jigs 
	            			(alwf ([=] (-V- actions i 1) done))
	            			; (until_ie ([=] (-V- actions i 1) done) (-P- JigLoop))

	            			


	            			;if its done then it was executing in the past
	            			(somp 
	            			; 	(||
		            				([=] (-V- actions i 1) executing)
		            			; 	([=] (-V- actions i 1) parallel-executing)
	            				; )
	            			)
	            			;no pause within "exe_time" time units 
	            			(!! (withinp_ie ([=] (-V- actions i 1) pause) 6))

	            			;NOTE::::////exetime must be instead of 3
	            		)
            		)


	      		; pre/post/safety conditions
				; (->
				; 	(&& (yesterday (|| ([=] (-V- actions i 1) executing) ([=] (-V- actions i 1) parallel-executing))) ([=] (-V- Action_SafetyPro i) 0))
				; 	(until_ie ([=] (-V- actions i 1) pause) ([=] (-V- Action_SafetyPro i) 1))

				; )
				
				; (->
				; 	(&& (yesterday ([=] (-V- actions i 1) pause)) ([=] (-V- Action_SafetyPro i) 1))
				; 	(|| ([=] (-V- actions i 1) executing) ([=] (-V- actions i 1) parallel-executing))
				; )

				;
				(->
					(&& ([=] (-V- actions i 1) waiting) (yesterday([=] (-V- actions i 1) notstarted)))
					(yesterday ([=] (-V- Action_Pre i) 1))
				)


				(->
					(&& 
						; (|| 
						([=] (-V- actions i 1) executing)
						 ; ([=] (-V- actions i 1) parallel-executing))
						  (yesterday([=] (-V- actions i 1) waiting)))
					([=] (-V- Action_SafetyPro i) 1)
				)



				(->
					(&& 
						(yesterday 
						; (|| 
						([=] (-V- actions i 1) executing) 
						; ([=] (-V- actions i 1) parallel-executing))
						) 
						([=] (-V- actions i 1) pause))
				(until_ie ([=] (-V- actions i 1) pause) ([=] (-V- Action_SafetyPro i) 1))
					
				)

				; ; (->
				; ; 	(&& (|| ([=] (-V- actions i 1) executing) ([=] (-V- actions i 1) parallel-executing)) (yesterday([=] (-V- actions i 1) pause)))
				; ; 	(yesterday ([=] (-V- Action_SafetyPro i) 1))
				; ; )



				(->
					; (|| 
						([=] (-V- actions i 1) executing)
					; 	([=] (-V- actions i 1) parallel-executing)
					; )

					([=] (-V- Action_SafetyPro i) 1)
				)
				
			 	
				(->
					(&& ([=] (-V- actions i 1) done) 
						(yesterday 
							; (|| 
							([=] (-V- actions i 1) executing) 
							; ([=] (-V- actions i 1) parallel-executing))
							))
					([=] (-V- Action_Post i) 1)
			 	)



				)
			)
		)
)

;;1. the operator moves to the bin
(defconstant *Action1* 

	 (&&

	 	(<->
	 		([=] (-V- Action_Pre 1) 1) 
	 		(&& 
	 			(-P- Robot_Homing)
	 			; (!! (-P- End_Eff_facing_Operator))
 			)

 		)

 		(<->
 			([=] (-V- Action_Post 1) 1)
 			(&&
 				; (!! (-P- End_Eff_facing_Operator))
 				(|| ([=](-V- Body_Part_pos hand) L_5_a) ([=](-V- Body_Part_pos hand) L_5_b))
 				(-P- Robot_Homing)
 			)
		)

		(<->	
			([=] (-V- Action_SafetyPro 1) 1)
			(&& 
				(-P- Robot_Homing)
	 			; (!! (-P- End_Eff_facing_Operator))
 			)
		)
	 )
)

;;2. he grasps a part
(defconstant *Action2* 
	(&&

		(<->
	 		([=] (-V- Action_Pre 2) 1)
	 		(&& 
	 			([=] (-V- actions 1 1) done)
	 			(|| ([=](-V- Body_Part_pos hand) L_5_a) ([=](-V- Body_Part_pos hand) L_5_b))
	 			(-P- Robot_Homing)
	 			; (!! (-P- End_Eff_facing_Operator))
 			)

 		)

 		(<->
 			([=] (-V- Action_Post 2) 1)
 			(&& 
				(-P- partTaken)
				(-P- Robot_Homing)
				; (!! (-P- End_Eff_facing_Operator))

		 	)
		)
		;part is taken until partfixed
		; (->	
		; 	(-P- partTaken)
		; 	(until_ie (-P- partTaken) (-P- partFixed))
		; )

		

	 	
 	)
)

;;3. he takes the part to the tombstone
(defconstant *Action3* 

	(&&

		(<->
	 		([=] (-V- Action_Pre 3) 1)
			(&& 
				([=] (-V- actions 2 1) done)
				(-P- partTaken)
				(-P- Robot_Homing)
				; (!! (-P- End_Eff_facing_Operator))

		 	)	 		

 		)

 		(<->
 			([=] (-V- Action_Post 3) 1)
 			(&& 
				(|| ([=](-V- Body_Part_pos hand) L_7) ([=](-V- Body_Part_pos hand) L_1))	
				(-P- partTaken)
				(-P- Robot_Homing)
				; (!! (-P- End_Eff_facing_Operator))
	 		)
 			
		)

		(<->
			([=] (-V- Action_SafetyPro 3) 1)
			(&&

				(-P- partTaken)
				(-P- Robot_Homing)
				; (!! (-P- End_Eff_facing_Operator))
			)

		)
	)
)

;;4. he puts the part on the stone
(defconstant *Action4* 
	(&&
		(<->
	 		([=] (-V- Action_Pre 4) 1)
	 		(&& 
	 			([=] (-V- actions 3 1) done)
				([=](-V- Body_Part_pos hand) L_1)	
				(-P- partTaken)
				(-P- Robot_Homing)
				; (!! (-P- End_Eff_facing_Operator))
	 		)

 		)

 		(<->
 			([=] (-V- Action_Post 4) 1)
 			(&& 
				([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
				(-P- partTaken)
				(-P- Robot_Homing)
				; (!! (-P- End_Eff_facing_Operator))
	 		)
		)
		
		; (<->	
		; 	([=] (-V- actions 4 1) done)
		; 	(-P- partFixed)
		; )


		(<->
			([=] (-V- Action_SafetyPro 4) 1)
			(&&

	 			(-P- Robot_Homing)
	 			; (!! (-P- End_Eff_facing_Operator))

			)

		)

		
	 )
 )

;;5. Operator holding the part
(defconstant *Action5*

	(&&

	 	(<->
	 		([=] (-V- Action_Pre 5) 1)
	 		(&&
	 			([=] (-V- actions 4 1) done)
	 			(-P- partTaken)
	 			([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
	 			([=](-V- End_Eff_B_Position) L_1)
	 			; (!! (-P- End_Eff_facing_Operator))
	 			; (!!(-P- partHold))
 			)
	 		
 		)

 	; 	(<->
 	; 		([=] (-V- Action_Post 5) 1)
 	; 		(!!(-P- partFixed))

		; )

		(<->
			([=] (-V- Action_SafetyPro 5) 1)
			; (&&
	 			([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
	 			; ([=](-V- End_Eff_B) L_1)
 			; )
		)

		; (->
		; 	(&& 
		; 		([=] (-V- actions 5 1) pause)
		; 		(yesterday (|| ([=] (-V- actions 5 1) parallel-executing) ([=] (-V- actions 5 1) parallel-executing)))
		; 	)
			
			
		; 	(-E- j actions-indexes
		; 		(&&
		; 			(->
		; 				(&&
		; 					(yesterday (|| ([=] (-V- actions j 1) parallel-executing) ([=] (-V- actions j 1) parallel-executing)))
		; 					(!! ([=] j 5))
		; 				)
		; 				(until_ie  ([=] (-V- actions j 1) pause) (!! ([=] (-V- actions 5 1) pause)))
		; 			)

		; 			(->
		; 				(&&
		; 					(yesterday ([=] (-V- actions j 1) waiting))
		; 					(!! ([=] j 5))
		; 				)
		; 				(until_ie ([=] (-V- actions j 1) waiting) (!! ([=] (-V- actions 5 1) pause)))
		; 			)
		; 		)
		; 	)
 	; 	)


	)
)

;;6. robot moves from home to stone/ operator holds the part
(defconstant *Action6* 
	(&&


		(<->
	 		([=] (-V- Action_Pre 6) 1)
			(&& 
				; (|| 
				([=] (-V- actions 5 1) executing)
				 ; ([=] (-V- actions 5 1) parallel-executing))

				([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
	 		)
	

 		)

 		(<->
 			([=] (-V- Action_Post 6) 1)
 			(&& 
				; ([=](-V- Body_Part_pos hand) L_6)
				; (|| 
				([=] (-V- actions 5 1) executing) 
				; ([=] (-V- actions 5 1) parallel-executing))

				; (-P- partFixed)
				(!! (-P- LINK1_Moving))
				(!! (-P- LINK2_Moving))
	 			([=](-V- End_Eff_B_Position) L_1)


	 		)	
		)

		(<->
			([=] (-V- Action_SafetyPro 6) 1)
			(&&
				([=](-V- Body_Part_pos hand) L_1)

				; (|| 
				([=] (-V- actions 5 1) executing) 
				; ([=] (-V- actions 5 1) parallel-executing))
				; (-P- partFixed)

				(-A- i body_indexes 
					(->  ; no part allowed on pallet except hand
						([!=] i hand)
						([!=](-V- Body_Part_pos i) L_1)
					)
				)
			)
		)

		
	 )
 )

; ;;7.operator prepares a jig
(defun Action7(i)
 	(&&
	   

		(<->
	 		; (-P- Action7_Pre) 
	 		([=] (-V- Action_Pre i) 1)
	 		; (||
	 			(&& 
	 				
	 				([=] (-V- actions 6 1) done)
	 				([=] (-V- actions (- i 1) 1) done)
	 				; (|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
	 				([=] (-V- actions 5 1) executing)
					([=](-V- Body_Part_pos hand) L_1)	
					; (-P- partFixed)
					(!! (-P- LINK1_Moving))
					(!! (-P- LINK2_Moving))
		 			([=](-V- End_Eff_B_Position) L_1)
		 		)
		 		
 		)	

 		(<->
 			; (-P- Action7_Post)
 			([=] (-V- Action_Post i) 1)
 			(&& 
				([=](-V- Body_Part_pos hand) L_1)	
				; (|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
				([=] (-V- actions 5 1) executing)
				; (-P- partFixed)
				(!! (-P- LINK1_Moving))
					(!! (-P- LINK2_Moving))
	 			([=](-V- End_Eff_B_Position) L_1)
	 			(-P- preparedJig)
	 			; (!! (-P- NewIteration))


	 		)	
		)

		(<->
			([=] (-V- Action_SafetyPro i) 1)
			; (-P- Action7_SafetyPro)
			(&&
				([=](-V- Body_Part_pos hand) L_1)	
				; (|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
				([=] (-V- actions 5 1) executing)
				; (-P- partFixed)
				(!! (-P- LINK1_Moving))
				(!! (-P- LINK2_Moving))
	 			([=](-V- End_Eff_B_Position) L_1)
	 			; (!! ([=] (-V- actions (+ i 1) 1) executing))
	 			(-A- j body_indexes 
					(->  ; no part allowed on pallet except hand
						([!=] j hand)
						([!=](-V- Body_Part_pos j) L_1)
					)
				)
			)
		)


		
		
	 )
	)

; ;; 8. robot moves toward stone/ operator holds the part
(defun Action8(i)
 ;   (->
	; (&& ([=] ([%] i 6 ) 2) (!!([=] i (+ (* (- jigs 1) 6) 14))) ([>] i 6))

	(&&
		
		(<->
	 		([=] (-V- Action_Pre i) 1)
	 		(&& 
	 			
	 			([=] (-V- actions (- i 1) 1) done)
	 			([=] (-V- actions 5 1) executing)
	 			; (|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
		 		([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
	 			([=](-V- End_Eff_B_Position) L_1)
	 			(-P- preparedjig)
 			)
 		)

 		(<->
 			([=] (-V- Action_Post i) 1)
 			(&&
 				([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
	 			([=](-V- End_Eff_B_Position) L_1)
	 			([=] (-V- actions 5 1) executing)
	 			;(|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
	 			; (!! ([=] (-V- actions (+ i 1) executing))
	 			(-A- j body_indexes 
					(->  ; no part allowed on pallet except hand
						([!=] j hand)
						([!=](-V- Body_Part_pos j) L_1)
					)
				)
				; (-P- ScrewDriveReady)
				(-P- preparedjig)
			)
		)
 			
		(<->
			([=] (-V- Action_SafetyPro i) 1)
			(&&
				([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
	 			([=](-V- End_Eff_B_Position) L_1)
	 			; (-P- preparedjig)
	 			([=] (-V- actions 5 1) executing)
	 			;(|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
	 			(-A- j body_indexes 
					(->  ; no part allowed on pallet except hand
						([!=] j hand)
						([!=](-V- Body_Part_pos j) L_1)
					)
				)
			)

		)

		

	 )
   )

; ;;9. robot screws the prepared jig of a part/ operator holds the part
(defun Action9(i) 
 ; (->
	; (&& ([=] ([%] i 6 ) 3) ([>] i 6))
	(&&
		(<->
	 		([=] (-V- Action_Pre i) 1)
	 		(&& 
	 			(-P- preparedjig)
	 			([=] (-V- actions (- i 1) 1) done)
	 			
	 			([=] (-V- actions 5 1) executing)
	 			;(|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
	 			([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
	 			([=](-V- End_Eff_B_Position) L_1)
	 		
	 			(-A- j body_indexes 
					(->  ; no part allowed on pallet except hand
						([!=] j hand)
						([!=](-V- Body_Part_pos j) L_1)
					)
				)
	 			; (-P- ScrewDriveReady)
 			)

 		)


 		; (<->
 		; 	(-P- ScrewDriveReady)
 		; 	(&& ([=] (-V- actions (- i 1) 1) done) (!!([=] (-V- actions i 1) done)))
 		; 	)

 		

 		(<->
 			([=] (-V- Action_Post i) 1)
 			(&&
				([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
	 			([=](-V- End_Eff_B_Position) L_1)
	 			([=] (-V- actions 5 1) executing)
	 			;(|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
	 		
	 			(-A- j body_indexes 
					(->  ; no part allowed on pallet except hand
						([!=] j hand)
						([!=](-V- Body_Part_pos j) L_1)
					)
				)
				
			)
 			
		)

		(<->
			([=] (-V- Action_SafetyPro i) 1)
			
			(&&
				([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
	 			([=](-V- End_Eff_B_Position) L_1)
	 			([=] (-V- actions 5 1) executing)
	 			;(|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
	 			(-A- j body_indexes 
					(->  ; no part allowed on pallet except hand
						([!=] j hand)
						([!=](-V- Body_Part_pos j) L_1)
					)
				)
			)
		)

		
	 )
 )

;;10. robot moves backward from the stone/ operator holds the part
(defun Action10(i) 
 ; (->
	; (&& ([=] ([%] i 6 ) 4) ([>] i 6))
	(&&
		  
		
		(<->
	 		([=] (-V- Action_Pre i) 1)
	 		(&&
	 			([=] (-V- actions (- i 1) 1) done)
	 			([=] (-V- actions 5 1) executing)
	 			;(|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
				([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
	 			([=](-V- End_Eff_B_Position) L_1)
	 		
	 			(-A- j body_indexes 
					(->  ; no part allowed on pallet except hand
						([!=] j hand)
						([!=](-V- Body_Part_pos j) L_1)
					)
				)
			)

 		)

 		(<->
 			([=] (-V- Action_Post i) 1)
 			(&&
				([=](-V- Body_Part_pos hand) L_1)	
				([=] (-V- actions 5 1) executing)
				;(|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
				; (-P- partFixed)
	 			([=](-V- End_Eff_B_Position) L_1)
	 		
	 			(-A- j body_indexes 
					(->  ; no part allowed on pallet except hand
						([!=] j hand)
						([!=](-V- Body_Part_pos j) L_1)
					)
				)
			)
 			
		)

		(<->
			([=] (-V- Action_SafetyPro i) 1)
			(&&
				([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
	 			([=](-V- End_Eff_B_Position) L_1)
	 			([=] (-V- actions 5 1) executing)
	 			;(|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
	 			(-A- j body_indexes 
					(->  ; no part allowed on pallet except hand
						([!=] j hand)
						([!=](-V- Body_Part_pos j) L_1)
					)
				)
			)

		)

		
	)
 )

;;11. robot checks the number of jigs/ operator holds the part
(defun Action11(i) 
 ; (->
	; (&& ([=] ([%] i 6 ) 5) ([>] i 6))
	(&&
		(<->
	 		([=] (-V- Action_Pre i) 1)
	 		(&&

	 			([=] (-V- actions (- i 1) 1) done)
	 			([=] (-V- actions 5 1) executing)
	 			;(|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
				([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
	 			([=](-V- End_Eff_B_Position) L_1)
	 		
	 			(-A- j body_indexes 
					(->  ; no part allowed on pallet except hand
						([!=] j hand)
						([!=](-V- Body_Part_pos j) L_1)
					)
				)
			)

 		)

 		(<->
 			([=] (-V- Action_Post i) 1)
 			(&&
				([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
				; ([=] (-V- actions 5 1) executing)
	 			([=](-V- End_Eff_B_Position) L_1)
	 		
	 			(-A- j body_indexes 
					(->  ; no part allowed on pallet except hand
						([!=] j hand)
						([!=](-V- Body_Part_pos j) L_1)
					)
				)
			)
		)

		(<->
			([=] (-V- Action_SafetyPro i) 1)
			(&&
				([=](-V- Body_Part_pos hand) L_1)	
				; (-P- partFixed)
	 			([=](-V- End_Eff_B_Position) L_1)
	 			([=] (-V- actions 5 1) executing)
	 			;(|| ([=] (-V- actions 5 1) executing) ([=] (-V- actions 5 1) parallel-executing))
	 		
	 			(-A- j body_indexes 
					(->  ; no part allowed on pallet except hand
						([!=] j hand)
						([!=](-V- Body_Part_pos j) L_1)
					)
				)
			)		

		)

		
	 )
)

;12. go back to action7
(defun Action12(i)
 ; (->
	; (&& ([=] ([%] i 6 ) 0) ([>] i 6))

	(&&

		(<->

	 		([=] (-V- Action_Pre i) 1)
	 		; (&&
	 			; ([>=] i 0)
	 			([=] (-V- actions (- i 1) 1) done)
			; 	([=](-V- Body_Part_pos hand) L_6)	
			; 	([=] (-V- actions 5 1) executing)
			; 	(-P- partFixed)
	 	; 		([=](-V- End_Eff_B) L_6)
	 	; 		([=](-V- LINK1_Position) (yesterday(-V- LINK1_Position)))
	 	; 		([=](-V- LINK2_Position) (yesterday(-V- LINK2_Position)))
	 		
	 	; 		(-A- j body_indexes 
			; 		(->  ; no part allowed on pallet except hand
			; 			([!=] j hand)
			; 			([!=](-V- Body_Part_pos j) L_6)
			; 		)
			; 	)
			; )

 		)



	)
)

; ;;13. else operator releases the part and moves back
(defun ActionBeforeLast(i)
	 (&&

		
		(<->

		 		([=] (-V- Action_Pre i) 1)
		 		([=] (-V- actions (- i 1) 1) done)

	 		)

 		(<->

 			([=] (-V- Action_Post i) 1)
 			(&& 
				
				(!! (-P- partTaken))
				(!! (-P- partHold))
				(-A- i body_indexes 
					  ; no part on pallet
						([!=](-V- Body_Part_pos i) L_1)
					
				)

				
			)	
		)
			

		(<->
			([=] (-V- Action_SafetyPro i) 1)
			(&&
				([=](-V- LINK1_Position) (yesterday(-V- LINK1_Position)))
	 			([=](-V- LINK2_Position) (yesterday(-V- LINK2_Position)))
	 			([=](-V- End_Eff_B_Position) (yesterday(-V- End_Eff_B_Position)))
 			)

		)

 	)
)

; ;;14. robot moves from stone to the home
 (defun ActionLast (i)
	(&&


		(<->
	 		([=] (-V- Action_Pre i) 1)
	 		
	 			([=] (-V- actions (- i 1) 1) done)
		 

 		)


 		(<->
 			([=] (-V- Action_Post i) 1)
				(&& 
					; ([=](-V- LINK1_Position) L_1)
 				; 	([=](-V- LINK2) L_2)
 					(!!([=](-V- End_Eff_B_Position) L_1))
				)
			
		)

		; (<->
		; 	([=] (-V- Action_SafetyPro i) 1)
		; 	([=] (-V- Action_Post 13) 1)

		; )

		




		; (<->
		; 	([=] (-V- Action_SafetyPro i) 1)
		; 	(&&
		; 		([=](-V- LINK1_Position) (yesterday(-V- LINK1_Position)))
	 ; 			([=](-V- LINK2_Position) (yesterday(-V- LINK2_Position)))
	 ; 			([=](-V- End_Eff_B) (yesterday(-V- End_Eff_B)))
 	; 		)

		; )

	
		
 	)
)

