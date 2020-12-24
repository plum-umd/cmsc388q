#lang scribble/manual
@(require scribble/core
          "utils.rkt"
          "defns.rkt")

@provide[exam-table]

@title[#:style 'unnumbered]{Syllabus}

@elem[#:style circle-image-style]{@image{img/shipGreen_manned.png}}

@local-table-of-contents[]

@section{Prerequisites and Description}

@bold{Prerequisite:} none.

@bold{Credits:} 1.

@courseno is an introduction to functional programming in Racket.  Its
major goal is to explore programming within the Racket
ecosystem. Throughout the course, students will collaborative design
and build a single peice of software using Racket.

It is helpful, but not required, to have some familiarity with a
functional programming such as OCaml from CMSC 330.

@section{Course Workflow}

The course will be a combination of synchronous video meetings, live
Q+A sessions, online course notes, and a discussion forum in the form
of a Discord server.  Students are expected to keep up with the
Discord discussion and either attend the video meeting or view a
recording in a timely manner.

@section{Office Hours}

Office hours will consist of the professor's daily availability on
Discord or by email.  If you'd like to schedule a video meeting, just
ask.

The discord server is there for you to organize as a class, ask questions of
each other, and to get help from staff. 

There is a channel `#course-discussion' that is meant for
discussion/questions/help regarding the material of the course, make sure that
you keep that channel free from noise so that other students and course staff
can easily see what issues are being brought up.

@section{Topics}

This course will be intentionally open-ended; we will collectively
decide what to explore, but some potential topics include:

@itemlist[
  @item{Basics of Racket}
  @item{Modules}
  @item{Macros}
  @item{Contracts}  
  @item{Testing}
  @item{Classes}
  @item{Types}
  @item{DSLs}  
  @item{Reactive programming}  
  @item{GUI programming}
  @item{Systems programming}
  @item{Distributed programming}]

@section{Grading}

Grades will be maintained on @link[elms-url]{ELMS}.

You are responsible for all material discussed in lecture and posted
on the class web page, including announcements, deadlines, policies,
etc.

Your final course grade will be determined according to the following
percentages:

@(define (make-grade-component-table . entries)
  @tabular[#:style 'boxed
	   #:sep @hspace[1] 
           (list* (list @bold{Component} @bold{Percentage}) entries)])


@make-grade-component-table[
  (list "Participation" "30%")
  (list @elem{Quizzes & surveys}    "20%")
  (list "Final project" "50%")]



@section[#:tag "participation"]{Participation}

Participation is a crucial element of this course and there are
several ways to participate. You can:
@itemlist[
@item{participate in video meetings}
@item{participate in discussions on Discord}
@item{submit pull requests on Github}
@item{create issues on Github}
@item{write code reviews on Github}
]

@section[#:tag "syllabus-quiz"]{Quizzes & surveys}

There will be some quizzes and surveys.  Completed surveys receive
full credit.

@section[#:tag "syllabus-project"]{Project}

A major component of the course will be a course @secref{Project} that
will be assessed during the ``final exam'' period for the course.

@itemlist[
  @item{Final Project Assessment: @bold{@final-date}}
]

@section{Computing Resources}

It's highly recommended you use your own computing system for
development.  Racket runs on all major platforms, so there should be
no problem running programs on your own machines.

If you don't have access to your own computing systems, you may using
the University's @link["http://www.grace.umd.edu/"]{GRACE} cluster.

We will use Github and its continuous integration services to build
and test software.

@section{Outside-of-class communication with course staff}

Course staff will interact with students outside of class
electronically via e-mail. 

Important announcements will be made in class, on the class web
page, or via Discord.

@section{Excused Absences}

You are not required to attend the video meetings, so there is no need
to seek excused absences.  Just make sure you participate in other
ways.


Missing the @bold{final project deadline} for reasons such as illness,
religious observance, participation in required university activities,
or family or personal emergency (such as a serious automobile accident
or close relative's funeral) will be excused so long as the absence is
requested in writing at least @bold{2 days} in advance and the student
includes documentation that shows the absence qualifies as excused;
@bold{a self-signed note} is not sufficient as exams are Major
Scheduled Grading Events. For this class, the final
project assessment is on the only Major Scheduled Grading Event and it
will take place:

@(define grades:f  (list @elem{Final Exam, @final-date} "20%"))

@(define exam-table
  @make-grade-component-table[
    @grades:f])

@itemlist[
  @item{Final Project Assessment: @bold{@final-date}}]

The final time is scheduled according to the University Registrar.
You do not need to be present for the assesment; you just need to
submit your work prior to the assessment time.

It is the University's policy to provide accommodations for students
with religious observances conflicting with major scheduled grading
events, but it is the your responsibility to inform the instructor in
advance of intended religious observances. If you have a conflict with
one of the planned events, you @bold{must} inform the instructor prior
to the end of the first two weeks of the class.

Besides the policies in this syllabus, the University's policies apply
during the semester. Various policies that may be relevant appear in
the @link["http://www.umd.edu/catalog"]{Undergraduate Catalog}.

If you experience difficulty during the semester keeping up with the
academic demands of your courses, you may consider contacting the
Learning Assistance Service in 2201 Shoemaker Building at (301)
314-7693. Their educational counselors can help with time management
issues, reading, note-taking, and exam preparation skills.

@section{Students with Disabilities}

Students with disabilities who have been certified by Disability
Support Services as needing any type of special accommodations should
see the instructor as soon as possible during the schedule adjustment
period (the first two weeks of class). Please provide DSS's letter of
accommodation to the instructor at that time.

All arrangements for major grading event accommodations as a result of
disability @bold{must} be made and arranged with the instructor
@bold{at least} three business days prior to the event date; later
requests (including retroactive ones) will be refused.

@section{University of Maryland Policies for Undergraduate Students}

Please read the university's guide on
@link["https://www.ugst.umd.edu/courserelatedpolicies.html"]{Course
Related Policies}, which provides you with resources and information
relevant to your participation in a UMD course.


@section{Academic Integrity}

The Campus Senate has adopted a policy asking students to include the
following statement on each examination or assignment in every course:
"I pledge on my honor that I have not given or received any
unauthorized assistance on this examination (or assignment)."
Consequently, you will be requested to include this pledge on each
exam and assignment. Please also carefully read the Office of Information
Technology's @link["http://www.nethics.umd.edu/aup/"]{policy}
regarding acceptable use of computer accounts.

Assignments and projects are to be completed @bold{individually},
therefore cooperation with others or use of unauthorized materials on
assignment or projects is a violation of the University's Code of
Academic Integrity. Both the person receiving assistance @bold{and the
person providing assistance} are in violation of the honor
code. @bold{Any evidence} of this, or of unacceptable use of computer
accounts, use of unauthorized materials or cooperation on exams or
quizzes, or other possible violations of the Honor Code, @bold{will be
submitted} to the Student Honor Council, which could result in an XF
for the course, suspension, or expulsion.

@itemlist[

@item{For learning the course concepts, students are welcome to study
together or to receive help from anyone else. You may discuss with
others the assignment or project requirements, the features of the
programming languages used, what was discussed in class and in the
class web forum, and general syntax errors. Examples of questions that
would be allowed are "Does a cond expression always end with an
else-clause?"  or "What does a 'mismatched parenthesis' error
indicate?", because they convey no information about the contents of an
assignment.}

@item{When it comes to actually writing an assignment, other than help
from the instructional staff, assignments must solely and entirely be
your own work.  Working with another student or individual, or using
anyone else's work @bold{in any way} except as noted in this
paragraph, is a violation of the code of academic integrity and
@bold{will be reported} to the Honor Council. You may not discuss
design of any part of an assignment with anyone except the instructor
and teaching assistants. Examples of questions you may @bold{not} ask
others might be "How did you implement this part of the assignment?"
or "Please look at my code and help me find my stupid syntax
error!". You may not use any disallowed source of information in
creating either the design or code. When writing assignment you are
free to use ideas or @bold{short fragments} of code from
@bold{published} textbooks or @bold{publicly available} information,
but the specific source must be cited in a comment in the relevant
section of the program. }

]

@bold{Violations of the Code of Academic Integrity may include, but
are not limited to:}

@itemlist[

@item{Failing to do all or any of the work on a project by yourself,
    other than assistance from the instructional staff.}

@item{Using any ideas or any part of another person's project, or copying any other individual's work in any way.}

@item{Giving any parts or ideas from your project, including test
data, to another student.}

@item{Allowing any other students access to your program on any
computer system.}

@item{Posting solutions to your projects to publicly-accessible sites,
e.g., on github.}

@item{Transferring any part of an assignment or project to or from another
student or individual by any means, electronic or otherwise.}]

If you have any question about a particular situation or source then
consult with the instructors in advance. Should you have difficulty
with a programming assignment you should @bold{see the instructional
staff in office hours}, and not solicit help from anyone else in
violation of these rules.

@bold{It is the responsibility, under the honor policy, of anyone who
suspects an incident of academic dishonesty has occurred to report it
to their instructor, or directly to the Honor Council.}

Every semester the department has discovered a number of students
attempting to cheat on assignments, in violation of academic integrity
requirements. Students' academic careers have been significantly
affected by a decision to cheat. Think about whether you want to join
them before contemplating cheating, or before helping a friend to
cheat.

You may not share, discuss, or compare assignment solutions even after
they have been graded since later assignments may build upon earlier
solutions.

@;{
You are welcome and encouraged to study and compare or discuss their
implementations of the assignment with any others after they are
graded, @bold{provided that} all of the students in question have
received nonzero scores for that assignment, and if that assignment
will not be extended upon in a later assignment.
}


@section{Course Evaluations}

If you have a suggestion for improving this class, don't hesitate to
tell the staff during the semester. At the end of the semester, please
don't forget to provide your feedback using the campus-wide
@link["https://www.courseevalum.umd.edu/"]{CourseEvalUM} system. Your
comments will help make this class better.

@section{Right to Change Information}

Although every effort has been made to be complete and accurate,
unforeseen circumstances arising during the semester could require the
adjustment of any material given here. Consequently, given due notice
to students, the instructors reserve the right to change any
information on this syllabus or in other course materials.  Such
changes will be announced and prominently displayed at the top of the
syllabus.

