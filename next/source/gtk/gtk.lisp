;;;; gtk.lisp --- gtk interface
(in-package :interface)

(defparameter *next-interface* nil)

(defclass next-interface ()
  ((window :accessor window :initarg :window)
   (minibuffer-view :accessor minibuffer-view :initarg :minibuffer-view)))

(defclass minibuffer-view ()
  ((container-view :accessor container-view :initarg :container-view)
   (input-entry :accessor input-entry :initarg :input-entry)
   (completion-model :accessor completion-model :initarg :completion-model)
   (completion-view :accessor completion-view :initarg :completion-view)))

(defun initialize ())

(defun start ()
  (gtk:within-main-loop
   (let* ((window
           (make-instance 'gtk:gtk-window
                          :type :toplevel
                          :title "nEXT"
                          :default-width 250
                          :border-width 0))
          (button
           (make-instance 'gtk:gtk-button
                          :label "Browser View Placeholder"))
          (entry
           (make-instance 'gtk:gtk-entry
                          :text "Minibuffer Input"))
          (root-box
           (make-instance 'gtk:gtk-box
                          :orientation :vertical
                          :spacing 0))
          (minibuffer-box
           (make-instance 'gtk:gtk-box
                          :orientation :vertical
                          :spacing 0))
          (model
           (make-instance 'gtk:gtk-list-store
                          :column-types '("gchararray")))
          (list-view
           (make-instance 'gtk:gtk-tree-view
                          :model model))
          (renderer (gtk:gtk-cell-renderer-text-new))
          (column (gtk:gtk-tree-view-column-new-with-attributes
                   "Name" renderer "text" 0)))
     (gtk:gtk-tree-view-append-column list-view column)
     (gtk:gtk-list-store-set model (gtk:gtk-list-store-append model) "Element 1")
     (gobject:g-signal-connect window "destroy"
                               (lambda (widget)
                                 (declare (ignore widget))
                                 (gtk:leave-gtk-main)))
     (gtk:gtk-box-pack-start root-box button)
     (gtk:gtk-box-pack-start root-box minibuffer-box :expand nil)
     (gtk:gtk-box-pack-start minibuffer-box entry :expand nil)
     (gtk:gtk-box-pack-start minibuffer-box list-view :expand nil)
     (gtk:gtk-container-add window root-box)
     (setf *next-interface* (make-instance
                             'next-interface
                             :window window
                             :minibuffer-view (make-instance
                                               'minibuffer-view
                                               :container-view minibuffer-box
                                               :input-entry entry
                                               :completion-model model
                                               :completion-view list-view)))
     (gobject:g-signal-connect
      window "key_press_event"
      (lambda (window event)
        (declare (ignore window))
        (process-event event)))
     (gtk:gtk-widget-show-all window))))

(defun kill ()
  (quit))

(defun copy ())
(defun paste ())
(defun cut ())

(defun process-event (event)
  (let ((modifier-state (gdk:gdk-event-key-state event))
        (character (gdk:gdk-keyval-to-unicode
                    (gdk:gdk-event-key-keyval event))))
    (unless (equalp character #\Null)
      (next:push-key-chord
       (member :control-mask modifier-state :test #'equalp)
       (member :mod1-mask modifier-state :test #'equalp)
       (member :super-mask modifier-state :test #'equalp)
       (string character)))))

(defun set-visible-view (view)
  (declare (ignore view)))
(defun delete-view (view)
  (declare (ignore view)))
(defun make-web-view ())
(defun web-view-set-url (view url)
  (declare (ignore view url)))
(defun web-view-set-url-loaded-callback (view function)
  (declare (ignore view function)))
(defun web-view-get-url (view)
  (declare (ignore view)))
(defun web-view-execute (view script)
  (declare (ignore view script)))
(defun make-minibuffer ())

(defun minibuffer-show ()
  (gtk:gtk-widget-show (container-view (minibuffer-view *next-interface*)))
  (gtk:gtk-widget-grab-focus (input-entry (minibuffer-view *next-interface*))))

(defun minibuffer-hide ()
  (gtk:gtk-widget-hide (container-view (minibuffer-view *next-interface*))))

(defun minibuffer-set-input (input)
  (declare (ignore input)))
(defun minibuffer-get-input ())
(defun minibuffer-get-input-complete ())
(defun minibuffer-select-next ())
(defun minibuffer-select-previous ())
(defun minibuffer-set-completion-function (function)
  (declare (ignore function)))
