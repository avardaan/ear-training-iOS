//
//  ViewController.swift
//  Ear Training
//
//  Created by Vardaan Aashish on 11/28/16.
//  Copyright © 2016 Booz Productions. All rights reserved.
//

import UIKit
import AVFoundation


// social network

// rapid fire
// survival (successively longer rounds)
// practice

// warm up option?
// piano option?

// gameplay mode that user has chosen
var mode = "survival"

// correct note for the round
var correctNoteTag = -1

// round number
var round = 0



class TrainingVC: UIViewController
{
    

    // score label
    @IBOutlet weak var scoreLabel: UILabel!
    
    // round label
    @IBOutlet weak var roundLabel: UILabel!
    
    // tells user if note correct or not
    @IBOutlet weak var resultLabel: UILabel!
    
    // array of piano sounds
    let pianoSounds = ["C2", "C#2", "D2", "D#2", "E2", "F2", "F#2", "G2", "G#2", "A2", "A#2", "B2"]
    
    // initialize empty audio array to store all sounds
    var soundsArray = [AVAudioPlayer]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // sounds load up. for every note in pianoSounds, load into app.
        for note in pianoSounds
        {
            do
            {
                // create url for the sound using it's name from the array
                let url = URL(fileURLWithPath: Bundle.main.path(forResource: note, ofType: "m4a")!)
                // assign that sound to audioPlayer
                let pianoNote = try AVAudioPlayer(contentsOf: url)
                // add this audioPlayer to the array of ACTUAL SOUNDS in order because LOOP
                soundsArray.append(pianoNote)
                // prepare buffer, minimize delay
                pianoNote.prepareToPlay()
            }
            
            // catch errors
            catch
            { // insert empty audio to avoid misplacement
                soundsArray.append(AVAudioPlayer())
            }
        }
        
    }
    
    // use this audio variable so that only one sound can be played at once
    var practiceNote = AVAudioPlayer()
    
    // number of times to play each round
    var survivalCount = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
    
    // list will contain correct tags in sequence
    var survivalCorrect : [Int] = []
    
    // survival sequence chosen by user
    var survivalChosen : [Int] = []



    @IBAction func buttonPress(_ sender: UIButton)
    {
        // assign practice note appropriate sound
        practiceNote = soundsArray[sender.tag]
        
        // if practiceNote AVAudioPlayer is already being used ->
        if (practiceNote.isPlaying)
        {
            // stop practiceNote audio
            practiceNote.stop()
            practiceNote.currentTime = 0.0
        }
        
        // round is over
        if (mode == "practice") && (correctNoteTag == -1)
        {
            // use tag to identify which note, then play it
            practiceNote.play()
        }
        
        // user pressed PLAY
        else if (mode == "practice")
        {
            
            // use tag to identify which note, then play it
            practiceNote.play()
            
            // check if correct note played, if so then increase scoer
            if (sender.tag == correctNoteTag)
            {
                // increment score
                scoreLabel.text = String(Int(scoreLabel.text!)! + 1)
                // update result label
                resultLabel.text = "Correct! " +  (pianoSounds[correctNoteTag])
            }
            else // if user chose wrong note
            {
                // update result label
                resultLabel.text = "Wrong! " + (pianoSounds[correctNoteTag])
            }
            
            // regardless, after the user presses a button, reset correct note so the user can't keep pressing the same button and increase score
            correctNoteTag = -1
            
            
            // calls function playRandom with 1 second delay
            /*
             Timer.scheduledTimer(timeInterval: TimeInterval(1.0), target: self, selector: #selector(ViewController.playRandom), userInfo: nil, repeats: false)
             */
        }
        
        else if (mode == "survival") && (correctNoteTag != -1)
        {
            // use tag to identify which note, then play it
            practiceNote.play()
            // append chosen note to survivalChosen
            survivalChosen.append(sender.tag)
            
            // ROUND HAS ENDED AND USER HAS WON
            if (survivalChosen == survivalCorrect) // counts are also equal
            {
                // increment score
                scoreLabel.text = String(Int(scoreLabel.text!)! + 1)
                // update result label
                resultLabel.text = "Correct! " + "\(survivalCorrect)"
                
                // reset survivalCorrect and survivalChosen for next round
                survivalCorrect = []
                survivalChosen = []
                // don't let em play notes without pressing play
                correctNoteTag = -1
            }
            
            // ROUND IS STILL GOING ON
            else if (survivalChosen.count < survivalCorrect.count)
            {
                /*
                create a new array that is printed at the top as the user chooses more buttons, the array is printed in sequence and tells the user what notes theyve chosen and also stops them if the sequence is wrong.............
                */
            
                // number of notes chosen by user
                let chosenLen = survivalChosen.count
                // survivalCorrect until the length user has chosen
                let check = Array(survivalCorrect[0...(chosenLen-1)])
                
                // check if correct. if user hit wrong note, let them know and restart!
                if (survivalChosen != check)
                {
                    // tell user they're wrong
                    resultLabel.text = "Wrong! " + "\(check)"
                    // reset survivalCorrect and survivalChosen for next round
                    survivalCorrect = []
                    survivalChosen = []
                    // don't let em play notes without pressing play
                    correctNoteTag = -1
                    
                }
                
                // if user hits right note, let them know and keep going
                else
                {
                    // tell user they're wrong
                    resultLabel.text = "Correct! " + "\(check)"
                }
            
            }
                
            // ROUND HAS ENDED AND USER HAS LOST
            else if (survivalChosen.count == survivalCorrect.count) // but elements are not equal
            {
                // update result label
                resultLabel.text = "Wrong! " + "\(survivalCorrect)"
                // reset survivalCorrect and survivalChosen for next round
                survivalCorrect = []
                survivalChosen = []
                // don't let em play notes without pressing play
                correctNoteTag = -1
            }

        }
        
    }
    
    
    // when play button is pressed
    @IBAction func playPress(_ sender: UIButton)
    {
        if (mode == "practice")
        {   // play random note
            playRandom()
            // update round
            updateRound()
        }
        
        else if (mode == "survival")
        {
            // play bunch of random notes
            playRandoms(num: survivalCount[0])
            // move to next level of survival
            survivalCount.remove(at: 0)
            // update round
            updateRound()
            
        }
        
        
        
    }
    
    // let user repeat note that was randomly played
    @IBAction func repeatPress(_ sender: UIButton)
    {
        if (mode == "practice" && correctNoteTag != (-1))
        {
            // if practiceNote is already being used ->
            if (practiceNote.isPlaying)
            {
                // stop practiceNote audio
                practiceNote.stop()
                practiceNote.currentTime = 0.0
            }
            // play note that was chosen at random by playRandom() function and
            practiceNote.play()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    // CUSTOM FUNCTIONS by Vardaan
    
    // function that plays a random note and stores the correct note's tag in a global variable for reference
    func playRandom()
    {
        // get random index within limits
        let randomIndex = Int(arc4random_uniform(UInt32(pianoSounds.count)))
        // create note from random index
        practiceNote = soundsArray[randomIndex]
        // play random note x seconds after button press
        practiceNote.play(atTime: practiceNote.deviceCurrentTime + 0.1)
        
        // store correct note tag for the round in global string
        correctNoteTag = randomIndex
    }
    
    // plays num random notes and stores them in survivalCorrect IN ORDER
    func playRandoms(num : Int)
    {
        // creates countable closed range to iterate over
        let range : CountableClosedRange = 0...(num-1)
        
        for i in range
        {
            // get random index within limits
            let randomIndex = Int(arc4random_uniform(UInt32(pianoSounds.count)))
            // create note from random index
            practiceNote = soundsArray[randomIndex]
            
            // if practiceNote is already being used ->
            if (practiceNote.isPlaying)
            {
                // stop practiceNote audio
                practiceNote.stop()
                practiceNote.currentTime = 0.0
            }
            
            // play random note x seconds after button press
            practiceNote.play(atTime: practiceNote.deviceCurrentTime + (0.8*Double(i)))
            
            // store correct note tag for the round in global string
            correctNoteTag = randomIndex
            
            // append correct note tag to survivalCorrect
            survivalCorrect.append(correctNoteTag)
        }
        // testing
        print(survivalCorrect)
    }
    
    // increments round label by 1
    func updateRound()
    { roundLabel.text = String(Int(roundLabel.text!)! + 1) }
    
    
    /* LAST BUG FOR SURVIVAL MODE
     // number of notes user has chosen till now
     let chosenLen = survivalChosen.count
     // if user has chosen less notes than they're supposed and they've been correct until now but they still skip to the next round by pressing play
     if (chosenLen == 0)
     {
     // tell user they're wrong
     resultLabel.text = "Wrong! " + "\(survivalCorrect)"
     // reset survivalCorrect and survivalChosen for next round
     survivalCorrect = []
     survivalChosen = []
     // don't let em play notes without pressing play
     correctNoteTag = -1
     }
     else if (chosenLen < survivalCorrect.count && survivalChosen == Array(survivalCorrect[0...chosenLen-1]))
     {
     // tell user they're wrong
     resultLabel.text = "Wrong! " + "\(survivalCorrect)"
     // reset survivalCorrect and survivalChosen for next round
     survivalCorrect = []
     survivalChosen = []
     // don't let em play notes without pressing play
     correctNoteTag = -1
     }
 
 
    */
    
    
    
    

}

