//
//  SavedRecipesCollectionViewController.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 02.06.2023.
//

import UIKit

public class SavedRecipesCollectionViewController: UICollectionViewController {
    
    private var models: [SectionViewModel] = []
    
    public init() {
        super.init(collectionViewLayout: Self.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .systemBackground
        
        navigationItem.title = NSLocalizedString("Saved", comment: "")
        
        collectionView.register(ShortRecipeInfoCell.self, forCellWithReuseIdentifier: ShortRecipeInfoCell.reuseIdentifier)
        
        update()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    private func update() {
        
        var oldModels: [ShortRecipeInfoItemViewModel] = []
        
        if !models.isEmpty,
           let oldRecipesSection = models.first,
           let oldRecipeItems = oldRecipesSection.items as? [ShortRecipeInfoItemViewModel] {
            oldModels = oldRecipeItems
        }
        
        models.removeAll()
        
        let recipesSection = SectionViewModel(uniqueSectionName: "RecipesSection")
        models.append(recipesSection)
        
        for recipe in UserSettings.shared.savedRecipes {
            if let index = oldModels.firstIndex(where: { $0.recipeInfo.recipeID == recipe.recipeID }) {
                recipesSection.items.append(oldModels[index])
            } else {
                recipesSection.items.append(ShortRecipeInfoItemViewModel(recipeInfo: ShortRecipeInfo(recipeID: recipe.recipeID, recipeName: recipe.recipeName, imageURL: recipe.imageURL)))
            }
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
        let recipeInfoViewController = RecipeInfoViewController(recipeInfo: UserSettings.shared.savedRecipes[indexPath.item])
        navigationController?.pushViewController(recipeInfoViewController, animated: true)
    }
    
}
