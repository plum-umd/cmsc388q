#lang racket

(displayln "   ____                  __  _                      ____")
(displayln "  / __ \\__  _____  _____/ /_(_)___  ____     ____  / __/")
(displayln " / / / / / / / _ \\/ ___/ __/ / __ \\/ __ \\   / __ \\/ /_  ")
(displayln "/ /_/ / /_/ /  __(__  ) /_/ / /_/ / / / /  / /_/ / __/  ")
(displayln "\\___\\_\\__,_/\\___/____/\\__/_/\\____/_/ /_/   \\____/_/     ")
(sleep 1)
(displayln "   __  __            ____                 __")
(displayln "  / /_/ /_  ___     / __ \\____ ___  __   / /")
(displayln " / __/ __ \\/ _ \\   / / / / __ `/ / / /  / / ")
(displayln "/ /_/ / / /  __/  / /_/ / /_/ / /_/ /  /_/  ")
(displayln "\\__/_/ /_/\\___/  /_____/\\__,_/\\__, /  (_)   ")
(displayln "                             /____/         \n\n")

(sleep 2)

(displayln "A random multiple choice question will be selected from a list and you are to answer it.")
(sleep 1)
(displayln "You have only one chance to answer correctly and hone your skills daily.\n")
(sleep 2)
(displayln "     Are you ready? (Y/N)")

(define worthless_input (read))
(cond
  [(equal? 'Y worthless_input) (displayln "Great! Here's the question...\n")]
  [(equal? 'y worthless_input) (displayln "Great! Here's the question...\n")]
  [(equal? 'Yes worthless_input) (displayln "Great! Here's the question...\n")]
  [(equal? 'yes worthless_input) (displayln "Great! Here's the question...\n")]
  [(equal? 'N worthless_input) (displayln "Well that's too bad!\n")]
  [(equal? 'n worthless_input) (displayln "Well that's too bad!\n")]
  [(equal? 'No worthless_input) (displayln "Well that's too bad!\n")]
  [(equal? 'no worthless_input) (displayln "Well that's too bad!\n")]
  [else (displayln "I'll assume that means yes so here's the question...\n")])
(sleep 2)

(define question1 (vector "Where is Covid generally known to have originated from? \nA. China \nB. USA \nC. Italy\n" 'A 'a "The correct answer was China! \nTry again tomorrow!"))
(define question2 (vector "Do armadillos have bulletproof shells? \nA. Completely true for most ammunition. \nB. Absolutely false for any ammo \nC. Bullet resistant to some ammo\n" 'C 'c "The correct answer was C since they're hard but not that hard. \nCome back later!"))
(define question3 (vector "What is the smallest country/territory in the world? \nA. Bermuda \nB. Vatican City \nC. British Virgin Islands\n" 'B 'b "The correct answer is Vatican City which is less than 0.2 square miles. \nTry again tomorrow!"))
(define question4 (vector "How many different blood types are there? \nA. Three \nB. Four \nC. Eight\n" 'C 'c "It's technically eight for A, B, AB, and O which can all be positive or negative. \nYou still learned something new today!"))
(define question5 (vector "What do M&M's stand for? \nA. Miller and Moordale \nB. Mars and Murrie \nC. Mouthwatering Mickey's\n" 'B 'b "It was Mars and Murrie since those were the last names of the people who made the candy possible. \nCome back next time!"))
(define questions (vector-append question1 question2 question3 question4 question5))

(define rand_q (* (random 0 5) 4))
(display (vector-ref questions rand_q))

(define ans (read))
(cond
  [(equal? (vector-ref questions (+ rand_q 1)) ans)
(displayln " ██████  ██████  ███    ██  ██████  ██████   █████  ████████ ███████ ")
(displayln "██      ██    ██ ████   ██ ██       ██   ██ ██   ██    ██       ███  ")
(displayln "██      ██    ██ ██ ██  ██ ██   ███ ██████  ███████    ██      ███   ")
(displayln "██      ██    ██ ██  ██ ██ ██    ██ ██   ██ ██   ██    ██     ███    ")
(displayln " ██████  ██████  ██   ████  ██████  ██   ██ ██   ██    ██    ███████ ")
(displayln "\nYou've won! Come back next time for another question!")]
  [(equal? (vector-ref questions (+ rand_q 2)) ans)
(displayln " ██████  ██████  ███    ██  ██████  ██████   █████  ████████ ███████ ")
(displayln "██      ██    ██ ████   ██ ██       ██   ██ ██   ██    ██       ███  ")
(displayln "██      ██    ██ ██ ██  ██ ██   ███ ██████  ███████    ██      ███   ")
(displayln "██      ██    ██ ██  ██ ██ ██    ██ ██   ██ ██   ██    ██     ███    ")
(displayln " ██████  ██████  ██   ████  ██████  ██   ██ ██   ██    ██    ███████ ")
(displayln "\nYou've won! Come back next time for another question!")]
  [else (displayln (vector-ref questions (+ rand_q 3)))])