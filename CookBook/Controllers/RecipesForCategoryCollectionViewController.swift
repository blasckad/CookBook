//
//  RecipesForCategoryCollectionViewController.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 05.06.2023.
//

import UIKit

public class RecipesForCategoryCollectionViewController: UICollectionViewController {
    
    public typealias DataSourceType = UICollectionViewDiffableDataSource<SectionViewModel, ItemViewModel>
    
    private var categoryName: String
    
    private var models: [SectionViewModel] = []
    
    private var dataSource: DataSourceType!
    
    init(categoryName: String) {
        self.categoryName = categoryName
        super.init(collectionViewLayout: Self.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        
        navigationItem.title = "\(categoryName) Recipes"
        navigationItem.largeTitleDisplayMode = .never
        
        collectionView.register(ShortRecipeInfoCell.self, forCellWithReuseIdentifier: ShortRecipeInfoCell.reuseIdentifier)
        
        dataSource = createDataSource()
        
        update()
    }
    
    private func update() {
        models.removeAll()
        
        let recipesSection = SectionViewModel(uniqueSectionName: "RecipesSection")
        models.append(recipesSection)
        
        RecipesByCategoryRequest(category: categoryName).send { result in
            switch result {
            case .success(let recipesByCategoryResponse):
                guard let recipes = recipesByCategoryResponse.recipeInfos else { break }
                recipesSection.items.removeAll()
                
                for recipe in recipes {
                    recipesSection.items.append(ShortRecipeInfoItemViewModel(recipeInfo: recipe))
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
        navigationController?.pushViewController(recipeInfoViewController, animated: true)
    }
}
