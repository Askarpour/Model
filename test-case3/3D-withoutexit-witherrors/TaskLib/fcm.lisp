(defvar delta 3)

;list of inserted actions
; (defconstant Insp
; (ALwF
;    (<-> (-P- inspection)
;      (&&
;        (|| ([=](-V- Body_Part_pos head) L_1_2) ([=](-V- Body_Part_pos head) L_1_3))
;        (|| (&&([=](-V- LINK2_Position) (-V- Body_Part_pos head)))  (&&([=](-V- End_Eff_B_Position) (-V- Body_Part_pos head)))   )
; ;       (-P- Link2_Moving)
;  )))
; )

(defun Seq-errors (index Tname Terror)
 (eval (list `alw (append `(&&)
  (loop for i in index collect
  `(&&
    (limiting_erroneous_actions action_indexes ,(read-from-string (format nil "~A" Tname)))
    (!!(-P- ,(read-from-string (format nil "early_start_~A_~A" 1 Tname))) )
    ; Insp
    ;error
    (<->(-P- ,(read-from-string (format nil "Action_Err_State_~A_~A" i Tname)))(-P- ,(read-from-string (format nil "err_A_~A_~A" i Tname))))
    
    ;Err_A
    (<->(-P- ,(read-from-string (format nil "err_A_~A_~A" i Tname)))(|| (-P- ,(read-from-string (format nil "repetition_~A_~A" i Tname))) (-P- ,(read-from-string (format nil "omission_~A_~A" i Tname))) (-P- ,(read-from-string (format nil "late_~A_~A" i Tname))) (-P- ,(read-from-string (format nil "early_start_~A_~A" i Tname))) (-P- ,(read-from-string (format nil "early_end_~A_~A" i Tname))) (-P- ,(read-from-string (format nil "intrusion_~A_~A" i Tname)))))
  
    ;;repetition
    (<->(-P- ,(read-from-string (format nil "repetition_~A_~A" i Tname)))
      (&&
	(-P- ,(read-from-string (format nil "Action_Doer_op_~A_~A" i Tname)))
	(||
      	;;redo
      	(&& (SomP (-P- ,(read-from-string (format nil "Action_State_dn_~A_~A" i Tname)))) (-P- ,(read-from-string (format nil "Op_starts_~A_~A" i Tname))))
      	;;not stopping
      	; (&& (Yesterday (|| (-P- ,(read-from-string (format nil "Action_State_exe_~A_~A" i Tname)))(-P- ,(read-from-string (format nil "Action_State_exrm_~A_~A" i Tname))))) (-P- ,(read-from-string (format nil "Action_Post_~A_~A" i Tname))) (Yesterday (!! (-P- ,(read-from-string (format nil "Action_Post_L_~A_~A" i Tname)))))  )
        (&& (Yesterday (|| (-P- ,(read-from-string (format nil "Action_State_exe_~A_~A" i Tname)))(-P- ,(read-from-string (format nil "Action_State_exrm_~A_~A" i Tname))))) (-P- ,(read-from-string (format nil "Action_Post_~A_~A" i Tname))) (!! (-P- ,(read-from-string (format nil "Op_stops_~A_~A" i Tname))))(Yesterday (!! (-P- ,(read-from-string (format nil "Op_stops_~A_~A" i Tname)))))  )
	))) 

    ;;omission
    (<->
      (-P- ,(read-from-string (format nil "omission_~A_~A" i Tname)))
      (&&
	(AlwP (!!(-P- ,(read-from-string (format nil "Op_starts_~A_~A" i Tname)))))
        (AlwF (!!(-P- ,(read-from-string (format nil "Op_starts_~A_~A" i Tname)))))
        (|| 
        	(&& (-P- ,(read-from-string (format nil "Action_Doer_op_~A_~A" i Tname)))(SomP (Lasted (-P- ,(read-from-string (format nil "Action_State_wt_~A_~A" i Tname))) delta)))
        	(&& (-P- ,(read-from-string (format nil "Action_Doer_ro_~A_~A" i Tname))) (AlwF (-P- ,(read-from-string (format nil "Action_State_ns_~A_~A" i Tname)))) (SomP (-P- ,(read-from-string (format nil "Action_Pre_L_~A_~A" i Tname)))))
    	  )))
    
     (-> (-P- ,(read-from-string (format nil "omission_~A_~A" i Tname))) (AlwF (-P- ,(read-from-string (format nil "omission_~A_~A" i Tname)))))

    ;;late
    (<->
      (-P- ,(read-from-string (format nil "late_~A_~A" i Tname)))
      (&&
        (-P- ,(read-from-string (format nil "Action_Doer_op_~A_~A" i Tname)))
        (SomP (Lasted (&& (-P- ,(read-from-string (format nil "Action_State_wt_~A_~A" i Tname))) (!! (-P- ,(read-from-string (format nil "Op_starts_~A_~A" i Tname))))) delta))
        (-P- ,(read-from-string (format nil "Op_starts_~A_~A" i Tname)))
      )
    )

    ;;early_start
    (AlwF(<->
          (-P- ,(read-from-string (format nil "early_start_~A_~A" i Tname))) 
            (&&(|| (-P- ,(read-from-string (format nil "Action_State_ns_~A_~A" i Tname))) 
                (-P- ,(read-from-string (format nil "Action_State_wt_~A_~A" i Tname))))
                (-> 
                  (-P- ,(read-from-string (format nil "Action_Doer_ro_~A_~A" i Tname)))
                  (!! (-P- Base_1_Moving))
                )
                (-P- ,(read-from-string (format nil "Action_Pre_L_~A_~A" i Tname)))
                (-P- ,(read-from-string (format nil "Op_starts_~A_~A" i Tname))) 
                (!!(-P- ,(read-from-string (format nil "Action_Pre_~A_~A" i Tname))))
            )
      ))

    ;;early_end
    (<->
      (-P- ,(read-from-string (format nil "early_end_~A_~A" i Tname)))
      (&& 
        (-P- ,(read-from-string (format nil "Action_Post_~A_~A" i Tname)))
        (||(-P- ,(read-from-string (format nil "Action_State_exe_~A_~A" i Tname)))(-P- ,(read-from-string (format nil "Action_State_exrm_~A_~A" i Tname))))
        (-P- ,(read-from-string (format nil "Op_stops_~A_~A" i Tname)))
        ; (-P- ,(read-from-string (format nil "Action_State_dn_~A_~A" i Tname))) 
        ; (Yesterday(||(-P- ,(read-from-string (format nil "Action_State_exe_~A_~A" i Tname)))(-P- ,(read-from-string (format nil "Action_State_exrm_~A_~A" i Tname)))))
        ; (!!(-P- ,(read-from-string (format nil "Action_Post_L_~A_~A" i Tname)))) (-P- ,(read-from-string (format nil "Action_Post_~A_~A" i Tname)))
        ))

    (AlwF (!! (-P- ,(read-from-string (format nil "intrusion_~A_~A" i Tname)))))
;    ;;intrusion
 ;   (<->
     ; (!! (-P- ,(read-from-string (format nil "intrusion_~A_~A" i Tname))))
   ;   (&& (!!(|| (-P- ,(read-from-string (format nil "Action_State_ns_~A_~A" i Tname))) (-P- ,(read-from-string (format nil "Action_State_dn_~A_~A" i Tname))))) (-P- inspection))
  ;	)
    ;;err_F
    ; (->
    ;   (-P- ,(read-from-string (format nil "err_F_~A_~A" i Tname)))
    ;   (&& (-P- ,(read-from-string (format nil "Action_Doer_op_~A_~A" i Tname))) (|| (-P- ,(read-from-string (format nil "Action_State_exe_~A_~A" i Tname))) (-P- ,(read-from-string (format nil "Action_State_exrm_~A_~A" i Tname))) ))
    ; )

    ;;err_L
    ; (->
    ;   (-P- ,(read-from-string (format nil "err_L_~A_~A" i Tname)))
    ;   (&&
    ;     ; (-P- ,(read-from-string (format nil "Action_Doer_op_~A_~A" i Tname)))
    ;     (!!(-P- ,(read-from-string (format nil "Action_Safe_L_~A_~A" i Tname))))
    ;     (|| (-P- ,(read-from-string (format nil "Action_State_exe_~A_~A" i Tname)))  (-P- ,(read-from-string (format nil "Action_State_exrm_~A_~A" i Tname))))
    ;     ; (&& ([=] (-V- actions i 1 Tname) hold) (Yesterday (&& ([=](-V- OpStops i Tname) 0) (!!([=] (-V- actions i 1 Tname) hold)))))))
    ; ))

))))))

(defun limiting_erroneous_actions (index Tname)
  (eval (list `alwf (append `(&&)
    (first(loop for x in index
      collect (loop for y in index
        when (/= x y) 
        collect 
        `(->
          (-P- ,(read-from-string (format nil "Action_Err_State_~A_~A" x Tname)))
          (!! (-P- ,(read-from-string (format nil "Action_Err_State_~A_~A" y Tname))))
        ))))))))