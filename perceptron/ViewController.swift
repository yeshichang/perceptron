//
//  ViewController.swift
//  perceptron
//
//  Created by 叶世昌 on 2018/10/16.
//  Copyright © 2018 Luomi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 误差
    var losses: [Float] = []
    // 学习率
    let rate: Float = 0.0
    // 训练次数
    let n = 50
    // 训练集
    let trainData: [[Float]] = [[0.0, 0.0], [0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]
    var tempData: [[Float]] = []
    // 真值
    var trainLabel: [Float] = []
    var tempLabel: [Float] = []
    // 参数
    var W: [Float] = [0.0, 0.0, 0.0]

    @IBOutlet weak var field_x1: UITextField!
    @IBOutlet weak var field_x2: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var resLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // 取0-1间随机数
    func getRandomNumber() -> Float {
        return Float(arc4random()) / Float(RAND_MAX)
    }

    // 激活函数
    func activation(x: Float) -> Float {
        return x > 0.0 ? 1.0 : 0.0
    }
    
    // 随机获取样本
    func randomSample() -> ([Float], Float) {
        if tempLabel.count == 0 {
            tempData += trainData
            tempLabel += trainLabel
        }
        let loc = Int(arc4random()) % tempData.count
        let data = tempData[loc]
        let label = tempLabel[loc]
        tempData.remove(at: loc)
        tempLabel.remove(at: loc)
        return(data, label)
    }
    
    // 训练
    func train(label: [Float]) {
        // 先给trainLabel赋值
        trainLabel = label
        // 再次初始化参数
        for i in 0..<3 {
            let w = getRandomNumber()
            W[i] = w
        }
        // 迭代训练
        losses.removeAll()
        for i in 0..<n {
            let sample = randomSample()
            let result = W[1] * sample.0[0] + W[2] * sample.0[1] + W[0] * 1
            let loss = activation(x: result) - sample.1
            print("训练第\(i + 1)次，loss为\(String.init(format: "%.2f", loss))")
            losses.append(loss)
            // 更新参数
            for (index, _) in W.enumerated() {
                if index == 0 {
                    W[index] -= rate * loss * 1
                } else {
                    W[index] -= rate * loss * sample.0[index - 1]
                }
            }
        }
    }

    @IBAction func trainBtnAct(_ sender: UIButton) {
        // 判断是什么操作
        switch segmentControl.selectedSegmentIndex {
        case 0:
            train(label: [0.0, 0.0, 0.0, 1.0])
        case 1:
            train(label: [0.0, 1.0, 1.0, 1.0])
        default:
            return
        }
    }
    @IBAction func testBtnAct(_ sender: UIButton) {
        if field_x1.text == "" || field_x2.text == "" {
            print("请输入待测试的X1和X2")
            return
        }
        let result = W[0]*1 + W[1] * Float(field_x1.text!)! + W[2]*Float(field_x2.text!)!
        resLabel.text = "\(activation(x: result))"
    }
}

