(in-package :cl-user)
(defpackage cl-annot-prove.struct
  (:use :cl
        :annot.doc)
  (:import-from :ppcre
                :regex-replace
                :regex-replace-all)
  (:export :*symbol-tests-list*
           :symbol-tests
           :symbol-tests-symbol
           :symbol-tests-tests
           :symbol-tests-before
           :symbol-tests-after
           :symbol-tests-around
           :symbol-tests-before-each
           :symbol-tests-after-each
           :symbol-tests-around-each
           :symbol-tests-load-pathname
           :make-symbol-tests
           :add-symbol-tests
           :test-document
           :test-document-got
           :test-document-expected
           :make-test-document))
(in-package :cl-annot-prove.struct)

(syntax:use-syntax :annot)

@doc
"List of #S(SYMBOL-TESTS ...)s."
(defvar *symbol-tests-list* nil)

@doc
"Structure of tests for symbol."
(defstruct (symbol-tests (:constructor make-symbol-tests
                             (symbol &key tests before after around
                                       before-each after-each around-each
                                       (load-pathname (or *compile-file-pathname* *load-pathname*)))))
  (symbol nil :type symbol)
  (tests nil :type list)
  (before)
  (after)
  (around)
  (before-each)
  (after-each)
  (around-each)
  (load-pathname nil :type (or null pathname)))

(defun add-symbol-tests (symbol-tests)
  (setq *symbol-tests-list*
        (append (remove symbol-tests *symbol-tests-list*
                      :test #'(lambda (obj1 obj2)
                                (eql (symbol-tests-symbol obj1)
                                     (symbol-tests-symbol obj2))))
                (list symbol-tests))))

(defstruct test-document
  (got)
  (expected))

(defun format-expected (expected)
  (regex-replace-all "\\n"
                     (regex-replace "^" expected ";; => ")
                     (format nil "~%;;    ")))

(defmethod print-object ((object test-document) stream)
  (with-slots (got expected) object
    (format stream "~s~%~a" got (format-expected expected))))
