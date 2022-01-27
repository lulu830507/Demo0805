//
//  QuestionsViewController.swift
//  Demo0805
//
//  Created by 林思甯 on 2021/8/6.
//

import UIKit

class QuestionsViewController: UIViewController {
    
    var category: passCategory!
    var difficulty: passDifficulty!
    var playerName: passPlayerName!
    var questionsArray :[String] = []
    var correctAnswerArray :[String] = []
    var incorrectAnswerArray :[String] = []
    var q = 1
    var score = 0
    var checkAnswerNumber = 0
    let stopWatch = ShowTime()
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var numberOfQuestionLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getQuestions()
        
        nextButton.layer.cornerRadius = 10
        buttonA.layer.cornerRadius = 10
        buttonB.layer.cornerRadius = 10
        buttonC.layer.cornerRadius = 10
        buttonD.layer.cornerRadius = 10
       
    }
    
    @objc func updateElapsedTimeLabel(_ timer: Timer) {
        
        if stopWatch.isRunning {
            elapsedTimeLabel.text = stopWatch.elapsedTimeAsString
        } else {
            timer.invalidate()
        }
    }
    
    func getQuestions() {
        
        var categoryURL: String!
        var difficultyURL: String!
        
        switch category.passCategory {
        case "Any Category":
            categoryURL = ""
        case "General Knowledge":
            categoryURL = "&category=9"
        case "Entertainment: Books":
            categoryURL = "&category=10"
        case "Entertainment: Films":
            categoryURL = "&category=11"
        case "Entertainment: Music":
            categoryURL = "&category=12"
        case "Entertainment: Musicals & Theatres":
            categoryURL = "&category=13"
        case "Entertainment: Television":
            categoryURL = "&category=14"
        case "Entertainment: Video Games":
            categoryURL = "&category=15"
        case "Entertainment: Board Games":
            categoryURL = "&category=16"
        case "Science & Nature":
            categoryURL = "&category=17"
        case "Science : Computers":
            categoryURL = "&category=18"
        case "Science: Mathematics":
            categoryURL = "&category=19"
        case "Mythology":
            categoryURL = "&category=20"
        case "Sports":
            categoryURL = "&category=21"
        case "Geography":
            categoryURL = "&category=22"
        case "History":
            categoryURL = "&category=23"
        case "Politics":
            categoryURL = "&category=24"
        case "Art":
            categoryURL = "&category=25"
        case "Celebrities":
            categoryURL = "&category=26"
        case "Animals":
            categoryURL = "&category=27"
        case "Vehicles":
            categoryURL = "&category=28"
        case "Entertainment: Comics":
            categoryURL = "&category=29"
        case "Science: Gadgets":
            categoryURL = "&category=30"
        case "Entertainment: Japanese Anime & Manga":
            categoryURL = "&category=31"
        case "Entertainment: Cartoon & Animations":
            categoryURL = "&category=32"
        default:
            break
        }
        
        switch difficulty.passDifficulty {
        case "Any Difficulty":
            difficultyURL = ""
        case "Easy":
            difficultyURL = "&difficulty=easy"
        case "Medium":
            difficultyURL = "&difficulty=medium"
        case "Hard":
            difficultyURL = "&difficulty=hard"
        default:
            break
        }
        
        let urlStr = "https://opentdb.com/api.php?amount=10"+categoryURL+difficultyURL+"&type=multiple"
        
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { [self] (data, response , error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                if let data = data {
                    do {
                        let questionArray = try decoder.decode(QuestionArray.self, from: data)
                        
                        for i in 0...9 {
                            questionsArray.append(questionArray.results[i].question)
                            correctAnswerArray.append(questionArray.results[i].correct_answer)
                            incorrectAnswerArray.append(questionArray.results[i].incorrect_answers[0])
                            incorrectAnswerArray.append(questionArray.results[i].incorrect_answers[1])
                            incorrectAnswerArray.append(questionArray.results[i].incorrect_answers[2])
                        }
                        DispatchQueue.main.async {
                            self.firstQuestionAnswer(nil)
                            Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                selector: #selector(QuestionsViewController.updateElapsedTimeLabel(_:)), userInfo: nil, repeats: true)
                            stopWatch.start()
                        }
                    }
                    catch{
                        print("error")
                    }
                } else {
                    print("error")
                    
                }
            }.resume()
        }
        
    }
    
    @IBAction func firstQuestionAnswer(_ sender: UIButton?) {
        var answerArray:[String] = []
        answerArray.append(correctAnswerArray[0])
        answerArray.append(incorrectAnswerArray[0])
        answerArray.append(incorrectAnswerArray[1])
        answerArray.append(incorrectAnswerArray[2])
        answerArray.shuffle()
        questionLabel.text = questionsArray[0]
        buttonA.setTitle(answerArray[0], for: .normal)
        buttonB.setTitle(answerArray[1], for: .normal)
        buttonC.setTitle(answerArray[2], for: .normal)
        buttonD.setTitle(answerArray[3], for: .normal)

        nextButton.isUserInteractionEnabled = false
        
    }
    
    @IBAction func nextQuestion(_ sender: Any) {
        
        if q >= 10 {
            stopWatch.stop()
            performSegue(withIdentifier: "score", sender: nil)
        } else {
            var answerArray: [String] = []
            answerArray.append(correctAnswerArray[0+q])
            answerArray.append(incorrectAnswerArray[0+3*q])
            answerArray.append(incorrectAnswerArray[0+1*q])
            answerArray.append(incorrectAnswerArray[2+3*q])
            answerArray.shuffle()
            questionLabel.text = questionsArray[0+q]
            buttonA.setTitle(answerArray[0], for: .normal)
            buttonA.backgroundColor = UIColor(red: 225, green: 214, blue: 179, alpha: 1)
            buttonB.setTitle(answerArray[1], for: .normal)
            buttonB.backgroundColor = UIColor(red: 225, green: 214, blue: 179, alpha: 1)
            buttonC.setTitle(answerArray[2], for: .normal)
            buttonC.backgroundColor = UIColor(red: 225, green: 214, blue: 179, alpha: 1)
            buttonD.setTitle(answerArray[3], for: .normal)
            buttonD.backgroundColor = UIColor(red: 225, green: 214, blue: 179, alpha: 1)
            q += 1
            numberOfQuestionLabel.text = String(q)
            nextButton.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func selectA(_ sender: UIButton) {
       
        if buttonA.titleLabel?.text == correctAnswerArray[q-1] {
            buttonA.backgroundColor = .green
            
            if checkAnswerNumber >= 3 {
                score += 30
            } else {
                score += 10
            }
            checkAnswerNumber += 1
            scoreLabel.text = String(score)
        } else {
            switch correctAnswerArray[q-1] {
            case buttonB.titleLabel?.text:
                buttonB.backgroundColor = .green
            case buttonC.titleLabel?.text:
                buttonC.backgroundColor = .green
            case buttonD.titleLabel?.text:
                buttonD.backgroundColor = .green
            default:
                break
            }
            buttonA.backgroundColor = .red
            if checkAnswerNumber >= 3 {
                score -= 10
            }
            checkAnswerNumber = 0
            scoreLabel.text = String(score)
        }
        nextButton.isUserInteractionEnabled = true
    }
    
    @IBAction func selectB(_ sender: UIButton) {
       
        if buttonB.titleLabel?.text == correctAnswerArray[q-1] {
            buttonB.backgroundColor = .green
            
            if checkAnswerNumber >= 3 {
                score += 30
            } else {
                score += 10
            }
            checkAnswerNumber += 1
            scoreLabel.text = String(score)
        } else {
            switch correctAnswerArray[q-1] {
            case buttonA.titleLabel?.text:
                buttonA.backgroundColor = .green
            case buttonC.titleLabel?.text:
                buttonC.backgroundColor = .green
            case buttonD.titleLabel?.text:
                buttonD.backgroundColor = .green
            default:
                break
            }
            buttonB.backgroundColor = .red
            if checkAnswerNumber >= 3 {
                score -= 10
            }
            checkAnswerNumber = 0
            scoreLabel.text = String(score)
        }
        nextButton.isUserInteractionEnabled = true
    }
    
    @IBAction func selectC(_ sender: UIButton) {
       
        if buttonC.titleLabel?.text == correctAnswerArray[q-1] {
            buttonC.backgroundColor = .green
            
            if checkAnswerNumber >= 3 {
                score += 30
            } else {
                score += 10
            }
            checkAnswerNumber += 1
            scoreLabel.text = String(score)
        } else {
            switch correctAnswerArray[q-1] {
            case buttonB.titleLabel?.text:
                buttonB.backgroundColor = .green
            case buttonA.titleLabel?.text:
                buttonA.backgroundColor = .green
            case buttonD.titleLabel?.text:
                buttonD.backgroundColor = .green
            default:
                break
            }
            buttonC.backgroundColor = .red
            if checkAnswerNumber >= 3 {
                score -= 10
            }
            checkAnswerNumber = 0
            scoreLabel.text = String(score)
        }
        nextButton.isUserInteractionEnabled = true
    }
    
    @IBAction func selectD(_ sender: UIButton) {
       
        if buttonD.titleLabel?.text == correctAnswerArray[q-1] {
            buttonD.backgroundColor = .green
            
            if checkAnswerNumber >= 3 {
                score += 30
            } else {
                score += 10
            }
            checkAnswerNumber += 1
            scoreLabel.text = String(score)
        } else {
            switch correctAnswerArray[q-1] {
            case buttonB.titleLabel?.text:
                buttonB.backgroundColor = .green
            case buttonC.titleLabel?.text:
                buttonC.backgroundColor = .green
            case buttonA.titleLabel?.text:
                buttonA.backgroundColor = .green
            default:
                break
            }
            buttonD.backgroundColor = .red
            if checkAnswerNumber >= 3 {
                score -= 10
            }
            checkAnswerNumber = 0
            scoreLabel.text = String(score)
        }
        nextButton.isUserInteractionEnabled = true
    }
    
    
    
    @IBSegueAction func passFinalScore(_ coder: NSCoder) -> ScoreViewController? {
        
        let controller = ScoreViewController(coder: coder)
        controller?.finalScore = passScore(score: score)
        controller?.finalTimer = passTimer(timer: String(elapsedTimeLabel.text!))
       
        return controller
    }
    
    
}
