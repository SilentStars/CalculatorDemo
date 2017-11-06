//
//  ViewController.swift
//  CaculatorDemo
//
//  Created by 侯钦瀚 on 2017/10/29.
//  Copyright © 2017年 HouQinhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var calLabel = UILabel()
    var firstNumber: Double?
    var secondNumber: Double?
    var currentNumber = ""
    var operatingNumber: Double?
    var firstInput: [String] = []
    var secondInput: [String] = []
    var calSymbol = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let SCREEN_WIDTH = self.view.frame.width
        let SCREEN_HEIGHT = self.view.frame.height
        let buttonWidth = Int(SCREEN_WIDTH/4)
        let buttonHeight = Int(SCREEN_HEIGHT*2/15)
        let buttonLocation_Y = Int(SCREEN_HEIGHT/15)
        let buttonLocation_X = Int(SCREEN_WIDTH/4)
        
        //把所有 button 放在一个数组里面
        let buttonList: [NumberButton] = [
            NumberButton(x: 0, y: buttonLocation_Y*7, title: "1", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X, y: buttonLocation_Y*7, title: "2", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X*2, y: buttonLocation_Y*7, title: "3", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: 0, y: buttonLocation_Y*9, title: "4", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X, y: buttonLocation_Y*9, title: "5", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X*2, y: buttonLocation_Y*9, title: "6", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: 0, y: buttonLocation_Y*11, title: "7", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X, y: buttonLocation_Y*11, title: "8", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X*2, y: buttonLocation_Y*11, title: "9", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: 0, y: buttonLocation_Y*13, title: "0", width: Int(buttonWidth*2), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X*2, y: buttonLocation_Y*13, title: ".", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: 0, y: buttonLocation_Y*5, title: "AC", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X, y: buttonLocation_Y*5, title: "+/-", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X*2, y: buttonLocation_Y*5, title: "%", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X*3, y: buttonLocation_Y*5, title: "/", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X*3, y: buttonLocation_Y*7, title: "*", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X*3, y: buttonLocation_Y*9, title: "-", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X*3, y: buttonLocation_Y*11, title: "+", width: Int(buttonWidth), height: Int(buttonHeight)),
            NumberButton(x: buttonLocation_X*3, y: buttonLocation_Y*13, title: "=", width: Int(buttonWidth), height: Int(buttonHeight))
        ]
        
        for i in 14..<buttonList.count {
            buttonList[i].numberButton.backgroundColor = .orange
        }
        
        //添加视图
        for i in 0..<buttonList.count {
            self.view.addSubview(buttonList[i].numberButton)
        }
        
        //计算背景框
        let caculatorView = UIView(frame: CGRect(x: 0, y: buttonLocation_Y*2, width: Int(SCREEN_WIDTH), height: buttonHeight*3/2))
        caculatorView.backgroundColor = .black
        self.view.addSubview(caculatorView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Int(SCREEN_WIDTH), height: buttonHeight))
        titleLabel.text = "My Calculator"
        titleLabel.font = UIFont.systemFont(ofSize: 28)
        titleLabel.backgroundColor = .brown
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        //显示输入数字
        calLabel = UILabel(frame: CGRect(x: 0, y: buttonLocation_Y*2, width: Int(SCREEN_WIDTH), height: buttonHeight*3/2))
        calLabel.text = "0"
        calLabel.textAlignment = .right
        calLabel.textColor = .white
        calLabel.font = UIFont.systemFont(ofSize: 52)
        self.view.addSubview(calLabel)
        
        for i in 0..<11 {
            buttonList[i].numberButton.addTarget(self, action: #selector(tapNumber), for: .touchUpInside)
        }
        buttonList[11].numberButton.addTarget(self, action: #selector(allClear), for: .touchUpInside)
        buttonList[12].numberButton.addTarget(self, action: #selector(changePN), for: .touchUpInside)
        buttonList[13].numberButton.addTarget(self, action: #selector(percentage), for: .touchUpInside)
        for i in 14..<18 {
            buttonList[i].numberButton.addTarget(self, action: #selector(tapOperator), for: .touchUpInside)
        }
        buttonList[18].numberButton.addTarget(self, action: #selector(returnResult), for: .touchUpInside)
        
    }
    
    //转换正负动作
    func changePN(sender: UIButton?) {
        if calSymbol == "" {
            firstNumber = -firstNumber!
            calLabel.text = "\(firstNumber!)"
        }
        else {
            secondNumber = -secondNumber!
            calLabel.text! = "\(secondNumber!)"
        }
    }
    
    //百分数动作
    func percentage(sender: UIButton?) {
        if calSymbol == "" {
            firstNumber = firstNumber! / 100
            calLabel.text = "\(firstNumber!)"
        }
        else {
            secondNumber = secondNumber! / 100
            calLabel.text = "\(secondNumber!)"
        }
    }
    
    //全部清空
    func allClear(sender: UIButton?) {
        firstNumber = nil
        secondNumber = nil
        currentNumber = ""
        firstInput.removeAll()
        secondInput.removeAll()
        calSymbol = ""
        calLabel.text = "0"
    }
    
    //按下数字键
    func tapNumber(sender: UIButton?) {
        if calSymbol == "" {
            firstInput.append(sender!.title(for: .normal)!)
            currentNumber = ""
            for item in firstInput {
                currentNumber += item
            }
            calLabel.text = currentNumber
            firstNumber = analysStringToInt(for: firstInput)
            operatingNumber = firstNumber
        }
        else {
            secondInput.append(sender!.title(for: .normal)!)
            currentNumber = ""
            for item in secondInput {
                currentNumber += item
            }
            calLabel.text = currentNumber
            secondNumber = analysStringToInt(for: secondInput)
            operatingNumber = firstNumber
        }
    }
    
    //按下运算符
    func tapOperator(sender: UIButton?) {
        if calSymbol == "" {
            calSymbol = sender!.title(for: .normal)!
        }
    }
    
    private func analysStringToInt(for inputString: [String]?) -> Double? {
        var result: Double = 0
        var dotLocation: Int?
        if inputString == nil {
            return nil
        } else {
            for i in 0..<inputString!.count {
                if(inputString?[i] == ".") {
                    dotLocation = i
                }
            }
            if(dotLocation != nil) {
                for i in 0..<dotLocation! {
                    let temp = dotLocation! - i - 1
                    let powNum:Double = pow(10, Double(temp))
                    result += Double((inputString?[i])!)! * powNum
                }
                for i in dotLocation!+1..<inputString!.count {
                    let temp = -(i - dotLocation!)
                    let powNum:Double = pow(10, Double(temp))
                    result += Double((inputString?[i])!)! * powNum
                }
            }
            else {
                for i in 0..<inputString!.count {
                    let temp = inputString!.count - i - 1
                    let powNum:Double = pow(10, Double(temp))
                    result += Double((inputString?[i])!)! * powNum
                }
            }
            return result
        }
    }
    
    //按下等号，得出结果
    func returnResult(sender: UIButton?) {
        if(firstInput != []) {
            if(calSymbol == "" || secondInput == []) {
                calLabel.text = String(describing: firstNumber!)
            }
            else {
                switch calSymbol {
                case "+":
                    calLabel.text = String(describing: firstNumber! + secondNumber!)
                case "-":
                    calLabel.text = String(describing: firstNumber! - secondNumber!)
                case "*":
                    calLabel.text = String(describing: firstNumber! * secondNumber!)
                case "/":
                    calLabel.text = String(describing: firstNumber! / secondNumber!)
                default:
                    break
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class NumberButton: UIView {
    var numberButton = UIButton()
    var buttonWidth: Int
    var buttonHeight: Int
    init(x: Int, y: Int, title: String, width: Int, height: Int) {
        numberButton = UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
        buttonWidth = width
        buttonHeight = height
        numberButton.setTitle(title, for: .normal)
        numberButton.setTitleColor(.black, for: .normal)
        numberButton.backgroundColor = .lightGray
        super.init(frame: CGRect(x: x, y: y, width: width, height: height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
