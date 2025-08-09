;; Art Education Program Contract
;; Coordinates art classes and workshops in community centers

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u500))
(define-constant ERR-ALREADY-EXISTS (err u501))
(define-constant ERR-NOT-FOUND (err u502))
(define-constant ERR-EXPIRED (err u503))
(define-constant ERR-INVALID-INPUT (err u504))
(define-constant ERR-CLASS-FULL (err u505))

;; Data Variables
(define-data-var program-counter uint u0)
(define-data-var instructor-fee uint u300000) ;; 0.3 STX registration

;; Data Maps
(define-map qualified-instructors
  { instructor-id: uint }
  {
    instructor: principal,
    name: (string-ascii 100),
    specializations: (list 5 (string-ascii 50)),
    experience-years: uint,
    certification-date: uint,
    status: (string-ascii 20),
    classes-taught: uint,
    student-rating: uint
  }
)

(define-map art-programs
  { program-id: uint }
  {
    instructor-id: uint,
    program-name: (string-ascii 100),
    description: (string-ascii 500),
    skill-level: (string-ascii 20),
    max-students: uint,
    duration-weeks: uint,
    schedule: (string-ascii 100),
    materials-included: bool,
    cost-per-student: uint,
    status: (string-ascii 20)
  }
)

(define-map student-enrollments
  { enrollment-id: uint }
  {
    program-id: uint,
    student: principal,
    student-name: (string-ascii 100),
    enrollment-date: uint,
    completion-date: (optional uint),
    attendance-rate: uint,
    final-grade: (optional uint),
    status: (string-ascii 20)
  }
)

(define-map program-sessions
  { session-id: uint }
  {
    program-id: uint,
    session-number: uint,
    session-date: uint,
    topic: (string-ascii 100),
    materials-used: (list 10 (string-ascii 50)),
    students-present: uint,
    session-notes: (string-ascii 500)
  }
)

;; Private Functions
(define-private (is-instructor-qualified (instructor-id uint))
  (match (map-get? qualified-instructors { instructor-id: instructor-id })
    instructor-data (is-eq (get status instructor-data) "active")
    false
  )
)

;; Public Functions

;; Register as qualified instructor
(define-public (register-instructor (name (string-ascii 100)) (specializations (list 5 (string-ascii 50))) (experience-years uint))
  (let (
    (instructor-id (+ (var-get program-counter) u1))
  )
    (asserts! (> (len name) u0) ERR-INVALID-INPUT)
    (asserts! (> experience-years u0) ERR-INVALID-INPUT)

    ;; Transfer registration fee
    (try! (stx-transfer? (var-get instructor-fee) tx-sender CONTRACT-OWNER))

    ;; Create instructor profile
    (map-set qualified-instructors
      { instructor-id: instructor-id }
      {
        instructor: tx-sender,
        name: name,
        specializations: specializations,
        experience-years: experience-years,
        certification-date: block-height,
        status: "active",
        classes-taught: u0,
        student-rating: u5
      }
    )

    ;; Update counter
    (var-set program-counter instructor-id)

    (ok instructor-id)
  )
)

;; Create art program
(define-public (create-program (instructor-id uint) (program-name (string-ascii 100)) (description (string-ascii 500)) (skill-level (string-ascii 20)) (max-students uint) (duration-weeks uint) (schedule (string-ascii 100)) (materials-included bool) (cost-per-student uint))
  (let (
    (program-id (+ (var-get program-counter) u1000))
    (instructor-data (unwrap! (map-get? qualified-instructors { instructor-id: instructor-id }) ERR-NOT-FOUND))
  )
    (asserts! (is-eq (get instructor instructor-data) tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (is-instructor-qualified instructor-id) ERR-INVALID-INPUT)
    (asserts! (> (len program-name) u0) ERR-INVALID-INPUT)
    (asserts! (> max-students u0) ERR-INVALID-INPUT)
    (asserts! (> duration-weeks u0) ERR-INVALID-INPUT)

    ;; Create program
    (map-set art-programs
      { program-id: program-id }
      {
        instructor-id: instructor-id,
        program-name: program-name,
        description: description,
        skill-level: skill-level,
        max-students: max-students,
        duration-weeks: duration-weeks,
        schedule: schedule,
        materials-included: materials-included,
        cost-per-student: cost-per-student,
        status: "open"
      }
    )

    (ok program-id)
  )
)

;; Enroll student in program
(define-public (enroll-student (program-id uint) (student-name (string-ascii 100)))
  (let (
    (enrollment-id (+ (var-get program-counter) u2000))
    (program-data (unwrap! (map-get? art-programs { program-id: program-id }) ERR-NOT-FOUND))
  )
    (asserts! (is-eq (get status program-data) "open") ERR-INVALID-INPUT)
    (asserts! (> (len student-name) u0) ERR-INVALID-INPUT)

    ;; Transfer program fee
    (try! (stx-transfer? (get cost-per-student program-data) tx-sender (get instructor (unwrap! (map-get? qualified-instructors { instructor-id: (get instructor-id program-data) }) ERR-NOT-FOUND))))

    ;; Create enrollment
    (map-set student-enrollments
      { enrollment-id: enrollment-id }
      {
        program-id: program-id,
        student: tx-sender,
        student-name: student-name,
        enrollment-date: block-height,
        completion-date: none,
        attendance-rate: u0,
        final-grade: none,
        status: "enrolled"
      }
    )

    (ok enrollment-id)
  )
)

;; Record program session
(define-public (record-session (program-id uint) (session-number uint) (topic (string-ascii 100)) (materials-used (list 10 (string-ascii 50))) (students-present uint))
  (let (
    (session-id (+ (var-get program-counter) u3000))
    (program-data (unwrap! (map-get? art-programs { program-id: program-id }) ERR-NOT-FOUND))
    (instructor-data (unwrap! (map-get? qualified-instructors { instructor-id: (get instructor-id program-data) }) ERR-NOT-FOUND))
  )
    (asserts! (is-eq (get instructor instructor-data) tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (> (len topic) u0) ERR-INVALID-INPUT)

    ;; Create session record
    (map-set program-sessions
      { session-id: session-id }
      {
        program-id: program-id,
        session-number: session-number,
        session-date: block-height,
        topic: topic,
        materials-used: materials-used,
        students-present: students-present,
        session-notes: ""
      }
    )

    (ok session-id)
  )
)

;; Complete student enrollment
(define-public (complete-enrollment (enrollment-id uint) (final-grade uint) (attendance-rate uint))
  (let (
    (enrollment-data (unwrap! (map-get? student-enrollments { enrollment-id: enrollment-id }) ERR-NOT-FOUND))
    (program-data (unwrap! (map-get? art-programs { program-id: (get program-id enrollment-data) }) ERR-NOT-FOUND))
    (instructor-data (unwrap! (map-get? qualified-instructors { instructor-id: (get instructor-id program-data) }) ERR-NOT-FOUND))
  )
    (asserts! (is-eq (get instructor instructor-data) tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (< final-grade u6) ERR-INVALID-INPUT)
    (asserts! (< attendance-rate u101) ERR-INVALID-INPUT)

    ;; Update enrollment
    (map-set student-enrollments
      { enrollment-id: enrollment-id }
      (merge enrollment-data {
        completion-date: (some block-height),
        attendance-rate: attendance-rate,
        final-grade: (some final-grade),
        status: "completed"
      })
    )

    ;; Update instructor class count
    (map-set qualified-instructors
      { instructor-id: (get instructor-id program-data) }
      (merge instructor-data {
        classes-taught: (+ (get classes-taught instructor-data) u1)
      })
    )

    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-instructor (instructor-id uint))
  (map-get? qualified-instructors { instructor-id: instructor-id })
)

(define-read-only (get-program (program-id uint))
  (map-get? art-programs { program-id: program-id })
)

(define-read-only (get-enrollment (enrollment-id uint))
  (map-get? student-enrollments { enrollment-id: enrollment-id })
)

(define-read-only (get-session (session-id uint))
  (map-get? program-sessions { session-id: session-id })
)

(define-read-only (is-instructor-active (instructor-id uint))
  (is-instructor-qualified instructor-id)
)
