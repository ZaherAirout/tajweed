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
    (category (name "أحكام النون")(prefix ن نْ ً ٍ ٌ))
    ; ادغام بغنّة
    (secondType (category-id "أحكام النون") (name "إدغام بغنة")(postfix ي ن م و))
    ; ادغام بلا بغنّة
    (secondType (category-id "أحكام النون") (name "إدغام بلا غنة")(postfix ل ر))
    ; اظهار
    (secondType (category-id "أحكام النون") (name "إظهار")(postfix أ ه ع ح غ خ))
    ; اقلاب
    (secondType (category-id "أحكام النون") (name "إقلاب")(postfix ب))
    ; اخفاء
    (secondType (category-id "أحكام النون") (name "إخفاء")(postfix ص ذ ث ج ش ق س ك ض ظ ز ت د ط ف))
    
    ;    meem rules
    (category (name "أحكام الميم")(prefix م مْ))
    
    ; اخفاء شفوي
    (secondType (category-id "أحكام الميم") (name "إخفاء شفوي")(postfix ب))
    ; ادغام شفوي
    (secondType (category-id "أحكام الميم") (name "إدغام شفوي")(postfix م))
    ; اظهار شفوي
    (secondType (category-id "أحكام الميم") (name "إظهار شفوي")(postfix ا ت ث ج ح خ د ذ ر ز س ش ص ض ط ظ ع غ ف ق ك ل ن ه و ي))
    
    
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
