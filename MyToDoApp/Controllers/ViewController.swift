//
//  ViewController.swift
//  MyToDoApp
//
//  Created by KIM Hyung Jun on 2023/07/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
//    var heartedCells: [ToDoCell] = []
    
    // 모델 (저장 데이터를 관리하는 코어데이터)
    let toDoManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setupTableView()
        
    }
    
    // 화면에 다시 진입할때마다 테이블뷰 리로드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func setupNaviBar() {
        self.title = "Home"
        
        // 네비게이션바 우측에 Plus 버튼 만들기
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .black
        navigationItem.rightBarButtonItem = plusButton
    }

    func setupTableView() {
        tableView.dataSource = self
        // 테이블뷰의 선 없애기
        tableView.separatorStyle = .none
    }

    @objc func plusButtonTapped() {
        performSegue(withIdentifier: "ToDoCell", sender: nil)
    }
    
    // 삭제 확인(alert) 창을 보여주는 함수
    func makeRemoveCheckAlert(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "메모 삭제", message: "정말 메모를 지우시겠습니까?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (_) in
            completion(true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in
            completion(false)
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 버튼 눌림에 따라 삭제 확인(alert) 창 표시
    func showDeleteConfirmation(indexPath: IndexPath) {
        makeRemoveCheckAlert { [weak self] confirmed in
            if confirmed {
                // 확인 버튼이 눌리면 삭제 동작 수행
                self?.deleteToDoItemAt(indexPath: indexPath)
            }
        }
    }
    
    // 특정 IndexPath에 해당하는 ToDo 항목 삭제
    func deleteToDoItemAt(indexPath: IndexPath) {
        guard indexPath.row < toDoManager.getToDoListFromCoreData().count else {
            return
        }

        let toDoData = toDoManager.getToDoListFromCoreData()[indexPath.row]
        toDoManager.deleteToDo(data: toDoData) {
            self.tableView.reloadData()
        }
    }
    
    // HeartedCellDelegate 메서드 구현
//    func heartButtonTapped(cell: ToDoCell) {
//        if !heartedCells.contains(cell) {
//            heartedCells.append(cell)
//        }
//    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoManager.getToDoListFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        // 셀에 모델(ToDoData) 전달
        let toDoData = toDoManager.getToDoListFromCoreData()
        cell.toDoData = toDoData[indexPath.row]
        
        // 셀위에 있는 버튼이 눌렸을때 (뷰컨트롤러에서) 어떤 행동을 하기 위해서 클로저 전달
        cell.updateButtonPressed = { [weak self] (senderCell) in
            // 뷰컨트롤러에 있는 세그웨이의 실행
            self?.performSegue(withIdentifier: "ToDoCell", sender: indexPath)
        }
        
        cell.deleteButtonPressed = { [weak self] (senderCell: ToDoCell) in
            guard let indexPath = tableView.indexPath(for: senderCell) else { return }
            self?.showDeleteConfirmation(indexPath: indexPath)
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToDoCell", sender: indexPath)
    }
    
    // (세그웨이를 실행할때) 실제 데이터 전달 (ToDoData전달)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToDoCell" {
            let detailVC = segue.destination as! DetailViewController

            guard let indexPath = sender as? IndexPath else { return }
            detailVC.toDoData = toDoManager.getToDoListFromCoreData()[indexPath.row]
        }

    }
    
    // 테이블뷰의 높이를 자동적으로 추청하도록 하는 메서드
    // (ToDo에서 메세지가 길때는 셀의 높이를 더 높게 ==> 셀의 오토레이아웃 설정도 필요)
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
