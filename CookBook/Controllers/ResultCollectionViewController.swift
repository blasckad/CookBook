//
//  ResultCollectionViewController.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 08.06.2023.
//

import UIKit

public class ResultCollectionViewController: UICollectionViewController {
    
    public typealias DataSourceType = UICollectionViewDiffableDataSource<SectionViewModel, ItemViewModel>
    
    private var models: [SectionViewModel] = []

    private var dataSource: DataSourceType!
    
    private var searchViewController: SearchCollectionViewController
    
    public init(searchViewController: SearchCollectionViewController) {
        self.searchViewController = searchViewController
        super.init(collectionViewLayout: Self.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        
        navigationItem.largeTitleDisplayMode = .never
        
        collectionView.register(ShortRecipeInfoCell.self, forCellWithReuseIdentifier: ShortRecipeInfoCell.reuseIdentifier)
        
        dataSource = createDataSource()
    }
    
    public func requestResults(matchingName name: String?) {
        Self.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(fetchRecipes(withName:)), with: name, afterDelay: 0.5)
    }
    
    @objc private func fetchRecipes(withName name: String?) {
        let recipeName = name ?? ""
        
        models.removeAll()
        
        let recipesSection = SectionViewModel(uniqueSectionName: "RecipesSection")
        models.append(recipesSection)
        
        guard !recipeName.isEmpty else {
            updateCollectionView()
            return
        }
        
        RecipesByNameRequest(recipeName: recipeName).send { result in
            switch result {
            case .success(let RecipesByNameResponse):
                recipesSection.items.removeAll()
                
                guard let recipes = RecipesByNameResponse.recipeInfos else {
                    DispatchQueue.main.async {
                        self.updateCollectionView()
                    }
                    break
                }
                
                for recipe in recipes {
                    recipesSection.items.append(ShortRecipeInfoItemViewModel(recipeInfo: ShortRecipeInfo(recipeID: recipe.recipeID, recipeName: recipe.recipeName, imageURL: recipe.imageURL)))
                }
                
                DispatchQueue.main.async {
                    self.updateCollectionView()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionViewModel, ItemViewModel>()
        
        for model in models {
            snapshot.appendSections([model])
            snapshot.appendItems(model.items, toSection: model)
            snapshot.reloadItems(model.items)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
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
        
        return .init(section: section)
    }
    
    
    private func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { collectionView, indexPath, model in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.reuseIdentifier, for: indexPath)
            
            model.setup(cell, in: collectionView, at: indexPath)
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            
            guard let model = self.models[indexPath.section].model(forElementOfKind: kind) else { return nil }
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: model.reuseIdentifier, for: indexPath)
            model.setup(view, in: collectionView, at: indexPath)
            
            return view
        }
        
        return dataSource
    }
    
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recipeItemViewModel = models[indexPath.section].items[indexPath.item] as? ShortRecipeInfoItemViewModel else { return }
        let recipeInfoViewController = RecipeInfoViewController(recipeID: recipeItemViewModel.recipeInfo.recipeID)
        UserSettings.shared.addLastSearchedRecipes(recipeItemViewModel.recipeInfo)
        searchViewController.navigationController?.pushViewController(recipeInfoViewController, animated: true)
    }
}

