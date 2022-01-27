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
    var questionCount = 1
    var score = 0
    var checkAnswerNumber = 0
    let stopWatch = ShowTime()
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var numberOfQuestionLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var choiceBtnOutlet: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuestions()
        
        for i in 0...3 {
            choiceBtnOutlet[i].layer.cornerRadius = 10
            choiceBtnOutlet[i].addTarget(self, action: #selector(selectAnswerAction), for: .touchUpInside)
        }
       
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
                            for j in 0...2{
                                incorrectAnswerArray.append(questionArray.results[i].incorrect_answers[j])
                            }
                        }
                        DispatchQueue.main.async {
                            self.firstQuestionAnswer(nil)
                            Timer.scheduledTimer(timeInterval: 0.1,
                                                 target: self,
                                                 selector: #selector(QuestionsViewController.updateElapsedTimeLabel(_:)),
                                                 userInfo: nil,
                                                 repeats: true)
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
    
    func firstQuestionAnswer(_ sender: UIButton?) {
        var answerArray:[String] = []
        answerArray.append(correctAnswerArray[0])
        answerArray.append(incorrectAnswerArray[0])
        answerArray.append(incorrectAnswerArray[1])
        answerArray.append(incorrectAnswerArray[2])
        answerArray.shuffle()
        questionLabel.text = questionsArray[0]
        
        for i in 0...3 {
            choiceBtnOutlet[i].setTitle(answerArray[i], for: .normal)
            
        }
        
    }
    
    @objc func selectAnswerAction(_ sender: UIButton){
        print(correctAnswerArray[questionCount-1])
        print((sender.titleLabel?.text)!)
        
        if sender.titleLabel?.text == correctAnswerArray[questionCount-1]{
            sender.backgroundColor = .green
            
            if checkAnswerNumber >= 3 {
                score += 30
            } else {
                score += 10
            }
            checkAnswerNumber += 1
            scoreLabel.text = String(score)
        } else {
            sender.backgroundColor = .red
            //要把正確答案找出來，並亮綠色
            for choicebtn in 0..<choiceBtnOutlet.count {
                if choiceBtnOutlet[choicebtn].titleLabel?.text == correctAnswerArray[questionCount-1] {
                    choiceBtnOutlet[choicebtn].backgroundColor = .green
                    break
                }
            }
            
            if checkAnswerNumber >= 3 {
                score -= 10
            }
            checkAnswerNumber = 0
            scoreLabel.text = String(score)
        }
        
        //選完答案之後
        DispatchQueue.main.asyncAfter( deadline: DispatchTime.now() + 1 ) {
            if self.questionCount >= 10 {
                self.stopWatch.stop()
                self.performSegue(withIdentifier: "score", sender: nil)
            } else {
                var answerArray: [String] = []
                answerArray.append(self.correctAnswerArray[0+self.questionCount])
                answerArray.append(self.incorrectAnswerArray[0+3*self.questionCount])
                answerArray.append(self.incorrectAnswerArray[1+3*self.questionCount])
                answerArray.append(self.incorrectAnswerArray[2+3*self.questionCount])
                answerArray.shuffle()
                self.questionLabel.text = self.questionsArray[0+self.questionCount]
                for i in 0...3 {
                    self.choiceBtnOutlet[i].setTitle(answerArray[i], for: .normal)
                    self.choiceBtnOutlet[i].backgroundColor =  UIColor(red: 225, green: 214, blue: 179, alpha: 1)

                }
                self.questionCount += 1
                self.numberOfQuestionLabel.text = String(self.questionCount)
            }
        }
    }
    
    
    
    @IBSegueAction func passFinalScore(_ coder: NSCoder) -> ScoreViewController? {
        
        let controller = ScoreViewController(coder: coder)
        controller?.finalScore = passScore(score: score)
        controller?.finalTimer = passTimer(timer: String(elapsedTimeLabel.text!))
       
        return controller
    }
    
    
}
