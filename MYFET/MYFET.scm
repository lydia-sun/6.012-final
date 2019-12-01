
;; Defined Parameters:

;; Contact Sets:
(sdegeo:define-contact-set "Gate_contact" 4 (color:rgb 1 0 0 )"##" )
(sdegeo:define-contact-set "Drain_contact" 4 (color:rgb 1 1 1 )"##" )
(sdegeo:define-contact-set "Source_contact" 4 (color:rgb 1 0 1 )"##" )
(sdegeo:define-contact-set "Body_contact" 4 (color:rgb 1 1 0 )"##" )

;; Work Planes:
(sde:workplanes-init-scm-binding)

;; Defined ACIS Refinements:
(sde:refinement-init-scm-binding)

;; Reference/Evaluation Windows:
(sdedr:define-refeval-window "RefWin_1" "Rectangle" (position -0.035 0 0) (position 0.0525 -0.05 0))
(sdedr:define-refeval-window "RefWin_2" "Rectangle" (position -3.5e-05 0 0) (position 5.25e-05 0.0006 0))

;; Restore GUI session parameters:
(sde:set-window-position 55 14)
(sde:set-window-size 927 1028)
(sde:set-window-style "Windows")
(sde:set-background-color 0 127 178 204 204 204)
(sde:scmwin-set-prefs "Helvetica" "Normal" 8 100 )
