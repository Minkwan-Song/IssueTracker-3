//
//  IssueListViewController.swift
//  IssueTracker
//
//  Created by 송민관 on 2020/11/02.
//

import UIKit

// TODO: Activity Indicators

class IssueListViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet private weak var issueListCollectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, IssueListViewModel>!
    private var issueListModelController: IssueListModelController!
    
    private lazy var issueList: [IssueListViewModel] = {
        return generateIssues()
    }()
    
    // MARK: Enums
    
    enum Section: CaseIterable {
        case main
    }
    
    // MARK: View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItems()
        issueListModelController = IssueListModelController()
        configureDataSource()
        performQuery(with: nil)
    }
    
    // MARK: Configure
    
    private func configureNavigationItems() {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        issueListCollectionView.allowsMultipleSelection = editing
        issueListCollectionView.indexPathsForVisibleItems.forEach { indexPath in
            guard let cell = issueListCollectionView.cellForItem(at: indexPath)
                    as? IssueListCollectionViewCell
            else {
                return
            }
            cell.isInEditingMode = editing
        }
    }
    
    // MARK: Action Functions
    
    @IBAction func editButtonTouched(_ sender: UIBarButtonItem) {
        if #available(iOS 14.0, *) {
            issueListCollectionView.allowsMultipleSelectionDuringEditing = true
        } else {
            // Fallback on earlier versions
        }
        setEditing(true, animated: true)
        print("bbb")
    }
}

// MARK: CollectionView DataSource

extension IssueListViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, IssueListViewModel>(
            collectionView: issueListCollectionView,
            cellProvider: {(
                collectionView, indexPath, item
            ) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueListCell", for: indexPath)
                        as? IssueListCollectionViewCell else { return UICollectionViewCell() }
                cell.configureIssueListCell(of: item)
                return cell
            })
    }
}

// MARK: UICollectionViewDelegate

extension IssueListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let storyboard = UIStoryboard(name: "IssueList", bundle: nil)
                .instantiateViewController(identifier: "IssueDetailViewController")
                as? IssueDetailViewController else { return }
        
        navigationController?.pushViewController(storyboard, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        // Replace the Select button with Done, and put the
        // collection view into editing mode.
    }
    
}

// MARK: UISearchBarDelegate

extension IssueListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performQuery(with: searchText)
    }
    
    func performQuery(with filter: String?) {
        let issueListItems = issueListModelController.filtered(with: filter ?? "",
                                                               model: issueList).sorted { $0.title < $1.title }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, IssueListViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(issueListItems)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: Dummy Issue Data

extension IssueListViewController {
    private func generateIssues() -> [IssueListViewModel] {
        var issues = [IssueListViewModel]()
        issues.append(IssueListViewModel(title: "test1",
                                         description: "설명",
                                         milestone: "프로젝트1",
                                         labels: ["label1, label2"]))
        issues.append(IssueListViewModel(title: "test2",
                                         description: "설명",
                                         milestone: "프로젝트2",
                                         labels: ["label1, label2"]))
        issues.append(IssueListViewModel(title: "test3",
                                         description: "설명",
                                         milestone: "프로젝트3",
                                         labels: ["label1, label2"]))
        issues.append(IssueListViewModel(title: "ha",
                                         description: "설명",
                                         milestone: "프로젝트4",
                                         labels: ["label1, label2"]))
        issues.append(IssueListViewModel(title: "haha",
                                         description: "설명",
                                         milestone: "프로젝트5",
                                         labels: ["label1, label2"]))
        return issues
    }
}
