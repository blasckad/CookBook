//
//  HomeCollectionViewController.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 02.06.2023.
//

import UIKit

public class HomeCollectionViewController: UICollectionViewController {
    
    public typealias DataSourceType = UICollectionViewDiffableDataSource<SectionViewModel, ItemViewModel>
    
    private var models: [SectionViewModel] = []
    
    private var dataSource: DataSourceType!
    
    public init() {
        super.init(collectionViewLayout: Self.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = NSLocalizedString("Home", comment: "")
        
        collectionView.register(NamedSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NamedSectionHeader.reuseIdentifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.register(NewRecipesCell.self, forCellWithReuseIdentifier: NewRecipesCell.reuseIdentifier)
        
        
        dataSource = createDataSource()
        
        collectionView.isPrefetchingEnabled = false
        
        update()
        
    }
    
    private func update() {
        models.removeAll()
        
        let newRecipesSection = SectionViewModel(uniqueSectionName: "NewRecipesSection")
        models.append(newRecipesSection)
        
        newRecipesSection.headerItem = NamedSectionItemViewModel(sectionName: NSLocalizedString("New for you", comment: ""))
        newRecipesSection.items.append(NewRecipeItemViewModel(fullRecipeInfo: FullRecipeInfo.empty))
        
        newRecipesSection.items.removeAll()
            for _ in 1...5 {
                RandomRecipeRequest().send { result in
                    switch result {
                    case .success(let response):
                        newRecipesSection.items.append(NewRecipeItemViewModel(fullRecipeInfo: response.recipeInfo))
                        DispatchQueue.main.async {
                            self.updateCollectionView()
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                    
                }
            }
        
        
        let recipesByCategorySection = SectionViewModel(uniqueSectionName: "RecipesByCategorySection")
        models.append(recipesByCategorySection)
        recipesByCategorySection.headerItem = NamedSectionItemViewModel(sectionName: NSLocalizedString("Recipes by Category", comment: ""))
        for _ in 0 ..< 3 {
            recipesByCategorySection.items.append(CategoryItemViewModel(categoryInfo: CategoryInfo.empty))
        }

        CategoryListRequest().send { result in
            switch result {
            case .success(let categoryListResponse):
                recipesByCategorySection.items.removeAll()
                var categories = categoryListResponse.categoryInfos.sorted { $0.categoryName < $1.categoryName }
                if let miscIndex = categories.firstIndex(where: { $0.categoryName == "Miscellaneous" }) {
                    let misc = categories.remove(at: miscIndex)
                    categories.append(misc)
                }
                for category in categories {
                    recipesByCategorySection.items.append(CategoryItemViewModel(categoryInfo: category))
                }
                DispatchQueue.main.async {
                    self.updateCollectionView()
                }
            case .failure(let error):
                print(error)
            }
        }
        updateCollectionView()
        
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
        return .init { sectionIndex, environment in
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(360), heightDimension: .absolute(340))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 10, bottom: 16, trailing: 16)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                section.interGroupSpacing = 16
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            case 1:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                group.interItemSpacing = .fixed(16)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 8, trailing: 16)
                section.interGroupSpacing = 16
//                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            default:
                return nil
            }
        }
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
        switch indexPath.section {
        case 0:
            guard let newRecipesViewModel = models[indexPath.section].items[indexPath.item] as? NewRecipeItemViewModel else { return }
            let recipeInfoViewController = RecipeInfoViewController(recipeInfo: newRecipesViewModel.fullRecipeInfo)
            navigationController?.pushViewController(recipeInfoViewController, animated: true)
        case 1:
            guard let categoryViewModel = models[indexPath.section].items[indexPath.item] as? CategoryItemViewModel else { return }
            let recipesForCategoryViewController = RecipesForCategoryCollectionViewController(categoryName: categoryViewModel.categoryInfo.categoryName)
            navigationController?.pushViewController(recipesForCategoryViewController, animated: true)
        default:
            break
        }
    }
}

