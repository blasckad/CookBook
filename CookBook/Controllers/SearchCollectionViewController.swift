//
//  SearchCollectionViewController.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 02.06.2023.
//

import UIKit

public class SearchCollectionViewController: UICollectionViewController {
    
    private var models: [SectionViewModel] = []
    
    public init() {
        super.init(collectionViewLayout: Self.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(NamedSubsectionHeader.self, forSupplementaryViewOfKind: NamedSubsectionHeader.elementKind, withReuseIdentifier: NamedSubsectionHeader.reuseIdentifier)
        collectionView.register(ShortRecipeInfoCell.self, forCellWithReuseIdentifier: ShortRecipeInfoCell.reuseIdentifier)
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = NSLocalizedString("Search", comment: "")
        
        let resultController = ResultCollectionViewController(searchViewController: self)
        let searchController = UISearchController(searchResultsController: resultController)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = NSLocalizedString("search", comment: "")
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        update()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        update()
    }
    
    private func update() {
        models.removeAll()
        
        guard UserSettings.shared.lastSearchedRecipes.count != 0 else { return }
        
        let recentSection = SectionViewModel(uniqueSectionName: "Recent")
        models.append(recentSection)
        recentSection.headerItem = NamedSubsectionItemViewModel(sectionName: NSLocalizedString("Recent", comment: ""))
        
        let recents = UserSettings.shared.lastSearchedRecipes
        
        for recent in recents {
            recentSection.items.append(ShortRecipeInfoItemViewModel(recipeInfo: recent))
        }
        
        collectionView.reloadData()
    }
    
    private static func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 16
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        section.boundarySupplementaryItems = [header]
        
        return .init(section: section)
    }

    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        models.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models[section].items.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.section].items[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.reuseIdentifier, for: indexPath)
        model.setup(cell, in: collectionView, at: indexPath)
        
        return cell
    }
    
    public override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let model = models[indexPath.section].model(forElementOfKind: kind) else { return UICollectionReusableView() }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: model.reuseIdentifier, for: indexPath)
        model.setup(view, in: collectionView, at: indexPath)
        
        return view
    }
    
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recipeViewModel = models[indexPath.section].items[indexPath.item] as? ShortRecipeInfoItemViewModel else { return }
        let recipeInfoViewController = RecipeInfoViewController(recipeID: recipeViewModel.recipeInfo.recipeID)
        navigationController?.pushViewController(recipeInfoViewController, animated: true)
        
        UserSettings.shared.addLastSearchedRecipes(recipeViewModel.recipeInfo)
    }
}


extension SearchCollectionViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text?.trimmingCharacters(in: whitespaceCharacterSet)
        
        if let resultController = searchController.searchResultsController as? ResultCollectionViewController {
            resultController.requestResults(matchingName: strippedString)
        }
    }
}
