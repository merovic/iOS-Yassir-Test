//
//  CharacterListViewController.swift
//  take-home-test-ios
//
//  Created by Amir Morsy on 02/01/2025.
//

import UIKit
import Combine
import SwiftUI

class CharacterListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let viewModel = CharacterListViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Characters"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupNavigationBar()
        setupMainView()
        setupTableView()
        bindViews()
        
        viewModel.fetchCharacters()
    }
    
    private func bindViews() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                let indicator = LoadingIndicatorView.sharedInstance(in: self.view ?? UIView())
                if isLoading {
                    indicator.startAnimating()
                } else {
                    indicator.stopAnimating()
                }
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.onUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    private func setupMainView() {
        let headerView = ViewFragmentation.embedSwiftUIView(view: FilterScrollView(viewModel: self.viewModel), parent: self)
        
        let stackView = UIStackView(arrangedSubviews: [headerView, tableView])
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterCell")
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
    }
    
    private func setupHeaderView() -> UIView {
        let hostingController = UIHostingController(rootView: FilterScrollView(viewModel: viewModel))
        addChild(hostingController)
        
        let headerView = hostingController.view!
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        hostingController.didMove(toParent: self)
        return headerView
    }
}

extension CharacterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCharacters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterTableViewCell
        let character = viewModel.filteredCharacters[indexPath.row]
        cell.configure(with: character)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.filteredCharacters.count - 2 {
            if viewModel.hasNext {
                viewModel.fetchCharacters()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.filteredCharacters[indexPath.row]
        let detailsViewModel = CharacterDetailsViewModel(character: character)
        let detailsView = CharacterDetailsViewController(viewModel: detailsViewModel)
        detailsView.modalPresentationStyle = .fullScreen
        navigationController?.present(detailsView, animated: true)
    }
}
