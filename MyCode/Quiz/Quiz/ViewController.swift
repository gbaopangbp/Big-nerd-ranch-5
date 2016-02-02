//
//  ViewController.swift
//  Quiz
//
//  Created by cm on 16/2/2.
//  Copyright © 2016年 cm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    var currentIndext:Int = 0
    let questions = ["Who are you?","1+1=?","How old are you?"]
    let answers = ["Lilei","2","60"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        questionLabel.text = questions[currentIndext];
        answerLabel.text = "???"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showNextQuestion(sender: UIButton) {
        currentIndext++
        if currentIndext == questions.count {
            currentIndext = 0
        }
        questionLabel.text = questions[currentIndext];
        answerLabel.text = "???"
    }

    @IBAction func showAnswer(sender: AnyObject) {
        answerLabel.text = answers[currentIndext]
    }
}

