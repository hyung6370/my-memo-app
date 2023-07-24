//
//  HeartToDoCell.swift
//  MyToDoApp
//
//  Created by KIM Hyung Jun on 2023/07/24.
//

import UIKit

class HeartToDoCell: UITableViewCell {
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var toDoTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    
    // ToDoData를 전달받을 변수 (전달 받으면 ==> 표시하는 메서드 실행) ⭐️
    var toDoData: ToDoData? {
        didSet {
            configureUIwithData()
        }
    }
    
    // 스토리보드의 생성자
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    // 기본 UI
    func configureUI() {
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 8

    }
    
    // 데이터를 가지고 적절한 UI 표시하기
    func configureUIwithData() {
        toDoTextLabel.text = toDoData?.memoText
        dateTextLabel.text = toDoData?.dateString
        guard let colorNum = toDoData?.color else { return }
        let color = MyColor(rawValue: colorNum) ?? .red
        backView.backgroundColor = color.backgoundColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private var isHeartButtonTapped = false
    
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        if isHeartButtonTapped {
            heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            heartButton.tintColor = .gray
            print("하트가 풀렸다")
        }
        else {
            heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            heartButton.tintColor = .red
            print("하트가 눌렸다")
        }
        
        // Toggle the state
        isHeartButtonTapped.toggle()
    }
    
}
