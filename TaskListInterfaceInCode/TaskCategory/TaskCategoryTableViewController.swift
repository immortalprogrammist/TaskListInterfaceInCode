//
//  TaskCategoryTableViewController.swift
//  TaskListInterfaceInCode
//
//  Created by Nikita on 23.10.21.
//

import UIKit

class TaskCategoryTableViewController: UITableViewController {
    
    private let cellID = "categoryCell"
    
    private var viewModel: TaskCategoryViewModelProtocol! {
        didSet {
            viewModel.fetchTaskCategories {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TaskCategoryViewModel()
        
        tableView.register(TaskCategoryCellTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        
        setupNavigation()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TaskCategoryCellTableViewCell
        cell.viewModel = viewModel.getCellViewModel(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let viewModel = viewModel else { return }
        
        viewModel.selectRow(atIndexPath: indexPath)
        
        let taskListVC = TaskListViewController()
        let navigationController = UINavigationController(rootViewController: taskListVC)
        navigationController.modalPresentationStyle = .automatic
        taskListVC.viewModel = viewModel.viewModelForSelectedRow()
        present(navigationController, animated: true)
    }
    
    private func setupNavigation() {
        title = "Category"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearence = UINavigationBarAppearance()
        
        navBarAppearence.configureWithOpaqueBackground()
        navBarAppearence.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearence.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppearence.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearence
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearence
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewCategory)
        )
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewCategory() {
        let name = "Test"
        DataManager.shared.save(name) { taskCategory in
            viewModel.taskCategories.append(taskCategory)
        }
        tableView.reloadData()
    }
}