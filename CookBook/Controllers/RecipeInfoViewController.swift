//
//  RecipeInfoViewController.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 05.06.2023.
//

import UIKit

public class RecipeInfoViewController: UICollectionViewController {
    
    private var recipeID: String
    
    private var recipeInfo: FullRecipeInfo!
    
    private var models: [SectionViewModel] = []
    
    lazy var previewItem = NSURL()
    
    public init(recipeID: String) {
        self.recipeID = recipeID
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    public init(recipeInfo: FullRecipeInfo) {
        self.recipeID = recipeInfo.recipeID
        self.recipeInfo = recipeInfo
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        
        title = NSLocalizedString("Recipe", comment: "")
        
        collectionView.register(RecipeInfoSummaryInfoCell.self, forCellWithReuseIdentifier: RecipeInfoSummaryInfoCell.reuseIdentifier)
        collectionView.register(IngredientAmountCell.self, forCellWithReuseIdentifier: IngredientAmountCell.reuseIdentifier)
        collectionView.register(CookingInstructionsCell.self, forCellWithReuseIdentifier: CookingInstructionsCell.reuseIdentifier)
        collectionView.register(NamedSectionHeader.self, forSupplementaryViewOfKind: NamedSectionHeader.elementKind, withReuseIdentifier: NamedSectionHeader.reuseIdentifier)
        
        if recipeInfo != nil {
            update()
        } else {
            RecipeByIDRequest(recipeID: recipeID).send { result in
                switch result {
                case .success(let recipeByIDResponse):
                    self.recipeInfo = recipeByIDResponse.recipeInfo
                case .failure(let error):
                    print(error)
                }
                
                DispatchQueue.main.async {
                    if self.recipeInfo == nil {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.update()
                    }
                }
            }
        }
        collectionView.isPrefetchingEnabled = false
        
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
    }
    
    private func update() {
        models.removeAll()
        
        let recipeInfoSummarySection = SectionViewModel(uniqueSectionName: "QuickInfoSection")
        models.append(recipeInfoSummarySection)
        let recipeInfoSummaryItem = recipeInfoSummaryItemViewModel(recipeInfo: recipeInfo)
        recipeInfoSummarySection.items.append(recipeInfoSummaryItem)
        
        recipeInfoSummaryItem.setToggleSavedAction { [weak self] recipeInfo in
            guard let self = self else { return }
            self.toggleSaved(recipe: recipeInfo)
        }
                
        let ingredientsSection = SectionViewModel(uniqueSectionName: "IngredientsSection")
        models.append(ingredientsSection)
        ingredientsSection.headerItem = NamedSectionItemViewModel(sectionName: NSLocalizedString("Ingredients", comment: ""))
        for ingredient in recipeInfo.ingredients {
            let ingredientModel = IngredientAmountItemViewModel(ingredientAmount: ingredient)
            ingredientsSection.items.append(ingredientModel)
            
        }
        
        
        let cookingInstructionsSection = SectionViewModel(uniqueSectionName: "CookingInstructionsSection")
        models.append(cookingInstructionsSection)
        cookingInstructionsSection.headerItem = NamedSectionItemViewModel(sectionName: NSLocalizedString("Method", comment: ""))
        let cookingInstructionsItem = CookingInstructionsItemViewModel(recipeInfo: recipeInfo)
        cookingInstructionsSection.items.append(cookingInstructionsItem)
        
        
        collectionView.reloadData()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return .init { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(400))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                return section
            case 1:
                let itemsSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemsSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(360), heightDimension: .absolute(30))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                section.interGroupSpacing = 16
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(60))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            case 2:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                var sectionHeight: CGFloat = 0
                
                sectionHeight += UILabel.labelHeight(for: .preferredFont(forTextStyle: .body), withText: self.recipeInfo.cookingInstructions, width: self.collectionView.bounds.width - 16 * 2)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(sectionHeight))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
                
                section.boundarySupplementaryItems = [header]
                
                return section
            default:
                return nil
            }
        }
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
    
    
    
    private func toggleSaved(recipe: FullRecipeInfo) {
        UserSettings.shared.toggleSaved(for: recipe)
    }
}
