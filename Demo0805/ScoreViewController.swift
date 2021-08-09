//
//  ScoreViewController.swift
//  Demo0805
//
//  Created by 林思甯 on 2021/8/8.
//

import UIKit

class ScoreViewController: UIViewController {
    
    var finalScore: passScore!
    var finalTimer: passTimer!

    
    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var finalTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreText.text = String(finalScore.score)
        finalTime.text = finalTimer.timer
        
    }
    
    @IBAction func playAgain(_ sender: Any) {
        
        self.performSegue(withIdentifier: "again", sender: self)
    }
    
}
