(deftemplate aya
    (slot id)
    (slot content(type STRING))
    )
(deftemplate category
    (slot name)
    (multislot prefix(type STRING))
    )
(deftemplate secondType
    (slot category-id)
    (slot name)
    (multislot postfix(type STRING))
    )
(deftemplate TR
    (slot type)
    (slot name)
    (slot aya-id)
    (slot occurrence)
    (slot position(type integer))
    )

(deffacts test-facts
    ;    noon rules
    (category (name "√Õﬂ«„ «·‰Ê‰")(prefix ‰ ‰˙  Ú Ò))
    ; «œ€«„ »€‰¯…
    (secondType (category-id "√Õﬂ«„ «·‰Ê‰") (name "≈œ€«„ »€‰…")(postfix Ì ‰ „ Ê))
    ; «œ€«„ »·« »€‰¯…
    (secondType (category-id "√Õﬂ«„ «·‰Ê‰") (name "≈œ€«„ »·« €‰…")(postfix · —))
    ; «ŸÂ«—
    (secondType (category-id "√Õﬂ«„ «·‰Ê‰") (name "≈ŸÂ«—")(postfix « ≈ √ Â ⁄ Õ € Œ))
    ; «ﬁ·«»
    (secondType (category-id "√Õﬂ«„ «·‰Ê‰") (name "≈ﬁ·«»")(postfix »))
    ; «Œ›«¡
    (secondType (category-id "√Õﬂ«„ «·‰Ê‰") (name "≈Œ›«¡")(postfix ’ – À Ã ‘ ﬁ ” ﬂ ÷ Ÿ “   œ ÿ ›))
    
    ;    meem rules
    (category (name "√Õﬂ«„ «·„Ì„")(prefix „ „˙))
    
    ; «Œ›«¡ ‘›ÊÌ
    (secondType (category-id "√Õﬂ«„ «·„Ì„") (name "≈Œ›«¡ ‘›ÊÌ")(postfix »))
    ; «œ€«„ ‘›ÊÌ
    (secondType (category-id "√Õﬂ«„ «·„Ì„") (name "≈œ€«„ ‘›ÊÌ")(postfix „))
    ; «ŸÂ«— ‘›ÊÌ
    (secondType (category-id "√Õﬂ«„ «·„Ì„") (name "≈ŸÂ«— ‘›ÊÌ")(postfix «   À Ã Õ Œ œ – — “ ” ‘ ’ ÷ ÿ Ÿ ⁄ € › ﬁ ﬂ · ‰ Â Ê Ì))
    
    
    ;; NOTE::  TBC for all rules
    

    )
(import sample.Helper)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;																;
;						Tjweed Rules							;
;																;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 		One word Rule
(defrule one-word
    (category
        (name ?id)
        (prefix $? ?pre $?))
    
    (secondType
        (category-id ?id)
        (name ?name)
        (postfix $? ?post $?))
    
    ?r<-(aya(content ?str))
    (test (str-index (str-cat ?pre ?post) ?str))
    
    =>
    (bind ?z (str-index (str-cat ?pre ?post) ?str))
  ;  (printout t "in one word :"crlf ?name " at char " ?post  " at index " ?z crlf)
   ; (printout t "in words : "(call Helper getWord ?str ?z) crlf )
    (assert (TR (type ?id)(name ?name)(aya-id ?r.id)(occurrence one-word)(position ?z)))

    (bind ?str (call Helper insertAt ?str ?z))
    (modify ?r (content ?str))
    )
(defrule two-words
    (category
        (name ?id)
        (prefix $? ?pre $?))
    
    (secondType
        (category-id ?id)
        (name ?name)
        (postfix $? ?post $?))
    
    ?r<-(aya(content ?str))
    (test (str-index (str-cat ?pre " " ?post) ?str))
    
    =>
    
    (bind ?z (str-index (str-cat ?pre " " ?post) ?str))
    ;(printout t "in two words "  ?name " at char " ?post  " at index " ?z crlf)
    ;(printout t "in words : "(call Helper getWords ?str ?z) crlf )
    (assert (TR (type ?id)(name ?name)(aya-id ?r.id)(occurrence two-word)(position ?z)))
    (bind ?str (call Helper insertAt ?str ?z))
    (modify ?r (content ?str))
    )
(reset)
