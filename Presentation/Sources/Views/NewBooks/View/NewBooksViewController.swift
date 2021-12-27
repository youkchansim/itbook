//
//  SearchBooksViewController.swift
//  
//
//  Created by 육찬심 on 2021/12/26.
//

import UIKit
import Image
import Combine
import Storyboards

public protocol SearchDelegate: AnyObject {
    
    func search(query: String?)
}

public final class NewBooksViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    
    public var viewModel: NewBooksViewModelType!
    public var resultViewController: (UIViewController & SearchDelegate)?
    
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: resultViewController)
        searchController.searchBar.placeholder = "Search books"
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
        viewModel.action.loadNewBooks()
    }
}

private extension NewBooksViewController {
    
    func setupViews() {
        setupSearchController()
        setupTableVew()
    }
    
    func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.title = "Books"
    }
    
    func setupTableVew() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func bind() {
        viewModel.state.newBooks
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [weak self] _ in self?.tableView.reloadData() })
            .store(in: &cancellables)
    }
}

extension NewBooksViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        resultViewController?.search(query: searchController.searchBar.text)
    }
}

extension NewBooksViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension NewBooksViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.newBooks.value.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "New books"
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBookCell", for: indexPath) as? SearchBookCell else {
            return UITableViewCell()
        }
        
        let newBook = viewModel.state.newBooks.value[indexPath.row]
        
        cell.titleLabel.text = newBook.title
        cell.subtitleLabel.text = newBook.subtitle
        cell.isbn13Label.text = newBook.isbn13
        cell.urlLabel.text = newBook.url
        cell.priceLabel.text = newBook.price
        cell.bookImageView.cs.setImage(newBook.imageURL, placeHolderImage: UIImage(systemName: "book"), animated: true)
        
        return cell
    }
}

extension NewBooksViewController: StoryboardInstantiable {
    
    public static var storyboardName: String { "NewBooks" }
}
