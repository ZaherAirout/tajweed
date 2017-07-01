(import sample.Helper)
(deftemplate aya
    (slot id)
    (slot content(type STRING))
    )
(deftemplate category
    (slot name)
    (multislot prefix(type STRING))
    (multislot postfix(type STRING))
    (slot direction)
    )
(deftemplate secondType
    (slot category-id)
    (slot name)
    (multislot prefix(type STRING))
    (multislot postfix(type STRING))
    (multislot infix(type STRING))
    )
(deftemplate TR
    (slot type)
    (slot name)
    (slot aya-id)
    (slot occurrence)
    (slot position(type integer))
    )

(defglobal ?*alphabet* ="ا أ ب ت ث ج ح خ د ذ ر ز س ش ص ض ط ظ ع غ ف ق ك ل م ن ه و ي ة")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;																;
;						Tajweed Rules							;
;																;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts Tajweed-Rules

    ;قلقلة
    (category (name "قلقة")(prefix ق ط ب ج د)(direction ternary))
    (secondType (category-id  "قلقة")(name "كبرى")(postfix  "ّ ") )
    (secondType (category-id  "قلقة")(name "وسطى")(postfix  "َ " "ً " "ُ " "ٌ " "ِ " "ٍ " "ْ ") )
    (secondType (category-id  "قلقة")(name "صغرى")(infix ْ)(postfix  (call Helper getLetters "" ?*alphabet*)) )

    ;    noon rules
    (category (name "أحكام النون")(prefix ن نْ ً ٍ ٌ))
    ; ادغام بغنّة
    (secondType (category-id "أحكام النون") (name "إدغام بغنة")(postfix ي ن م و))
    ; ادغام بلا بغنّة
    (secondType (category-id "أحكام النون") (name "إدغام بلا غنة")(postfix ل ر))
    ; اظهار
    (secondType (category-id "أحكام النون") (name "إظهار")(postfix ا إ أ ه ع ح غ خ))
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


    ; أحكام لام لفظ الجلالة
    (category (name "لام لفظ الجلالة")(postfix  اللَّه الله)(direction back))
    (secondType (category-id "لام لفظ الجلالة") (name "تفخيم ")(prefix َ ُ  ""))
    (secondType (category-id "لام لفظ الجلالة") (name "ترقيق ")(prefix ِ ))

    ; أحكام الراء
    (category (name "احكام الراء")(prefix ر)(postfix  رْ )(direction back))
    (secondType (category-id "احكام الراء") (name "تفخيم ") (postfix َ ُ َّ ُّ )(prefix َ ُ ))
    (secondType (category-id "احكام الراء") (name "ترقيق ")(postfix ِ ِّ )(prefix ِ ))

    ; أحكام النون والميم المشددة
    (category (name "أحكام النون والميم المشددة")(postfix  ّ)(direction back))
    (secondType (category-id "أحكام النون والميم المشددة") (name "الميم ")(prefix م))
    (secondType (category-id "أحكام النون والميم المشددة") (name "النون")(prefix ن))

    ; المدود
    (category (name "المدود")(prefix  َا ُو  ِي )(postfix  َا ُو  ِي )(direction ternary))
    (secondType (category-id "المدود")(name "طبيعي")(postfix (call Helper getLetters "ءأ" ?*alphabet*)) )
    (secondType (category-id "المدود")(name "بدل")(prefix أ ؤ ء ئ )(infix ""))
    (secondType (category-id "المدود")(name "منفصل/متصل")(postfix ئ ؤ ء أ))
    (secondType (category-id "المدود")(name "لازم كلمي مثقّل")(postfix ّ) (infix (call Helper getLetters "" ?*alphabet*)))
    (secondType (category-id "المدود")(name "لازم ")(postfix ْ) (infix (call Helper getLetters "" ?*alphabet*)))
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;																;
;				  Tajweed Matching Rules						;
;																;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 		One word Rule
(defrule one-word
    (declare (salience 0))
    (or (and
            (category
                (name ?id)
                (prefix $? ?pre $?))

            (secondType
                (category-id ?id)
                (name ?name&:(<> ?name "إدغام بغنة" ))
                (postfix $? ?post $?))
            )

        (and
            (category
                (name ?id)
                (direction back)
                (postfix $? ?post $?))
            (secondType
                (category-id ?id)
                (name ?name)
                (prefix $? ?pre $?))
            ))
    ?r<-(aya(content ?str))
    (test (str-index (str-cat ?pre ?post) ?str))

    =>
    (bind ?z (str-index (str-cat ?pre ?post) ?str))
    ;  (printout t "in one word :"crlf ?name " at char " ?post  " at index " ?z crlf)
    ; (printout t "in words : "(call Helper getWord ?str ?z) crlf )
    (assert (TR (type ?id)(name ?name)(aya-id ?r.id)(occurrence one-word)(position ?z)))

    (bind ?str (call Helper insertAt ?str (+ ?z (-  (str-length ?post) 1))))
    (modify ?r (content ?str))
    )
(defrule two-words
    (declare (salience 0))
    (or
        (and
            (category
                (name ?id)
                (prefix $? ?pre $?))

            (secondType
                (category-id ?id)
                (name ?name)
                (postfix $? ?post $?))
            )

        (and
            (category
                (name ?id)
                (direction back)
                (postfix $? ?post $?))
            (secondType
                (category-id ?id)
                (name ?name)
                (prefix $? ?pre $?))
            ))
    ?r<-(aya(content ?str))
    (test (str-index (str-cat ?pre " " ?post) ?str))

    =>
    (bind ?z (str-index (str-cat ?pre " " ?post) ?str))
    ;(printout t "in two words "  ?name " at char " ?post  " at index " ?z crlf)
    ;(printout t "in words : "(call Helper getWords ?str ?z) crlf )
    (assert (TR (type ?id)(name ?name)(aya-id ?r.id)(occurrence two-word)(position ?z)))
    (bind ?str (call Helper insertAt ?str (+ ?z (- (str-length ?post) 1))))
    (modify ?r (content ?str))
    )
(defrule ternary_one_word

    ?r<-(aya(content ?str))
    (or
        (and
            (category
                (name ?id)
                (direction ternary)
                (prefix $? ?pre $?))
            (secondType
                (category-id ?id)
                (name ?name)
                (postfix $? ?post $?)
                (infix $? ?in $?))
            (test (str-index (str-cat ?pre ?in ?post) ?str))
            )
        (and
            (category
                (name ?id)
                (direction ternary)
                (postfix $? ?post $?))
            (secondType
                (category-id ?id)
                (name ?name)
                (prefix $? ?pre $?)
                (infix $? ?in $?))
            (test (str-index (str-cat ?pre ?in ?post) ?str))

            )
        )

    =>
    (bind ?z (str-index (str-cat ?pre ?in ?post) ?str))
    ;(printout t "in two words "  ?name " at char " ?post  " at index " ?z crlf)
    ;(printout t "in words : "(call Helper getWords ?str ?z) crlf )
    (assert (TR (type ?id)(name ?name)(aya-id ?r.id)(occurrence two-word)(position ?z)))
    (bind ?str (call Helper insertAt ?str (+ ?z (- (str-length ?post) 1))))
    (modify ?r (content ?str))
    )

(defrule ternary_two_words

    ?r<-(aya(content ?str))

    (category
        (name ?id)
        (direction ternary)
        (prefix $? ?pre $?))
    (secondType
        (category-id ?id)
        (name ?name)
        (postfix $? ?post $?)
        (infix $? ?in $?))

    (test (str-index (str-cat ?pre " " ?in ?post) ?str))
    =>
    (bind ?z (str-index (str-cat ?pre " " ?in ?post) ?str))
    ;(printout t "in two words "  ?name " at char " ?post  " at index " ?z crlf)
    ;(printout t "in words : "(call Helper getWords ?str ?z) crlf )
    (assert (TR (type ?id)(name ?name)(aya-id ?r.id)(occurrence two-word)(position ?z)))
    (bind ?str (call Helper insertAt ?str (+ ?z (- (str-length ?post) 1))))
    (modify ?r (content ?str))
    )

(defrule two_words_splitter

    ?r<-(TR (type ?id)
        (name "منفصل/متصل")
        (aya-id ?aya-id)
        (occurrence two-word)
        (position ?z))
    =>
    (assert (TR (type ?id)(name "منفصل")(aya-id ?aya-id)(occurrence two-word)(position ?z)))
    (retract ?r)
    )

(defrule one_word_splitter

    ?r<-(TR (type ?id)
        (name "منفصل/متصل")
        (aya-id ?aya-id)
        (occurrence one-word)
        (position ?z))
    =>
    (assert (TR (type ?id)(name "متصل")(aya-id ?aya-id)(occurrence one-word)(position ?z)))
    (retract ?r)
    )
(reset)
;(run)
;(facts)
