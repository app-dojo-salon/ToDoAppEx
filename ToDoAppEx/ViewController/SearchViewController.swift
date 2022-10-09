//
//  SearchViewController.swift
//  ToDoAppEx
//
//  Created by izumiyoshiki on 2021/03/07.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var beginDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!

    private var todoList: Results<TodoItem>!
    private var token: NotificationToken?
    // 表示される内容となるリスト
    private var displayList: [TodoItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var categoryList: [String] = []
    private var selectedCategory: String = ""
    private var isStartDateType: Bool = true {
        didSet {
            print("isStartDateTypeが変更")
            filterDate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.tintColor = UIColor.clear

        searchBar.delegate = self

        dateTypeSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)

        beginDatePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)

        endDatePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)

        // 現在登録されているタスクの一覧を取得
        setTodoListConfig()

        // カテゴリーリストの一覧を取得
        setCategoryList()

        // TableViewの設定メソッド
        setTableViewConfig()
    }

    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            isStartDateType = true
        } else {
            isStartDateType = false
        }
    }

    @objc func datePickerChanged(_ sender: UIDatePicker) {
        filterDate()
    }

    deinit {
        if let token = self.token {
            token.invalidate()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SearchViewController {
    private func setTodoListConfig() {
        todoList = RealmManager.shared.getItemInRealm(type: TodoItem.self)
        reload()
        token = todoList.observe { [weak self] _ in
            self?.tableView.reloadData()
        }
    }

    private func setCategoryList() {
        // categoryPickerViewを設定
        let categoryPickerView = UIPickerView()
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self

        categoryTextField.inputView = categoryPickerView

        var _categoryList: [String] = []
        for item in todoList {
            // カテゴリーリストの中身
            _categoryList.append(item.category)
        }
        // 重複のないリストとして格納
        categoryList = _categoryList.reduce([], { $0.contains($1) ? $0 : $0 + [$1] })
    }

    private func filterDate() {
        var filterDateList: [TodoItem] = []
        for item in todoList {
            if isStartDateType {
                let startDate = item.startdate.dateFromString(format: "yyyy/MM/dd HH:mm:ss")
                if startDate.compare(beginDatePicker.date) == .orderedDescending, startDate.compare(endDatePicker.date) == .orderedAscending {
                    filterDateList.append(item)
                }
            } else {
                let endDate = item.enddate.dateFromString(format: "yyyy/MM/dd HH:mm:ss")
                if endDate.compare(beginDatePicker.date) == .orderedDescending, endDate.compare(endDatePicker.date) == .orderedAscending  {
                    filterDateList.append(item)
                }
            }
        }
        displayList = filterDateList
    }

    private func setTableViewConfig() {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "ImageCell")

        // セルの高さを固定
        tableView.estimatedRowHeight = 100
        // 区切り線を左端まで伸ばす
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.reloadData()
    }

    private func reload() {
        displayList = []
        for item in todoList {
            displayList.append(item)
        }
        tableView.reloadData()
    }

    private func changeStatusToDoItem(index: Int) {
        RealmManager.shared.changeStatusToDoItem(type: TodoItem.self, uuid: displayList[index].itemid)
        reload()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var filterdArr: [TodoItem] = []
        if let text = searchBar.text {
            if text == "" {
                // 検索窓に入力がない場合にはreloadしてタスクを全て表示する
                reload()
            } else {
                for item in todoList {
                    if item.title.contains(text) {
                        filterdArr.append(item)
                    }
                }
                displayList = filterdArr
            }
        }
    }
}

// MARK: - TableView

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
        // カスタムセルにRealmの情報を反映
        cell.configure(image: displayList[indexPath.row].image,
                       title: displayList[indexPath.row].title,
                       category: displayList[indexPath.row].category,
                       startDate: displayList[indexPath.row].startdate,
                       endDate: displayList[indexPath.row].enddate,
                       status: displayList[indexPath.row].status)
        return cell
    }

    // ToDoのステータス状態を変更するメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeStatusToDoItem(index: indexPath.row)
    }
}

// MARK: - PickerView

extension SearchViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }

    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return categoryList[row]
    }

    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        // 処理
        selectedCategory = categoryList[row]
        var filterdArr: [TodoItem] = []
        for item in todoList {
            if item.category == selectedCategory {
                filterdArr.append(item)
            }
        }
        displayList = filterdArr
    }
}
