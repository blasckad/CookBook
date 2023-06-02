//
//  UserSettings.swift
//  CookBook
//
//  Created by Матвей Кузнецов on 03.06.2023.
//

import Foundation

public class UserSettings {
    
    public static let shared = UserSettings()
    
    private init() {}
    
    //MARK: - UserDefaults managment
    
    private let defaults = UserDefaults.standard
    
    private enum userSettings {
        public static let savedRecipe = "savedRecipe"
        public static let lastSearchedRecipesKey = "lastSearchedRecipes"
    }
    
    //MARK: - Utility functions
    
    private func makeJSON<T: Encodable>(key: String, value: T) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        let jsonString = String(data: data, encoding: .utf8)
        defaults.set(jsonString, forKey: key)
    }
    
    private func getJSON<T: Decodable>(key: String) -> T? {
        guard let string = defaults.string(forKey: key), let data = string.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    //MARK: - Properties
    
    public private(set) var savedRecipes: [FullRecipeInfo] {
        get {
            getJSON(key: userSettings.savedRecipe) ?? []
        }
        set {
            makeJSON(key: userSettings.savedRecipe, value: newValue)
        }
    }
    
    public private(set) var lastSearchedRecipes: [ShortRecipeInfo] {
        get {
            getJSON(key: userSettings.lastSearchedRecipesKey) ?? []
        }
        set {
            makeJSON(key: userSettings.lastSearchedRecipesKey, value: newValue)
        }
    }
    
    //MARK: - Functions for data work
    
    func toggleSaved(for recipe: FullRecipeInfo) {
        var saved = savedRecipes
        
        if saved.contains(recipe) {
            saved = saved.filter { $0 != recipe }
        } else {
            saved.insert(recipe, at: 0)
        }
        
        savedRecipes = saved

    }
    
    func addLastSearchedRecipes(_ recipe: ShortRecipeInfo) {
        var searched = lastSearchedRecipes

        searched = searched.filter { $0 != recipe }

        searched.insert(recipe, at: 0)
        
        if searched.count > 10 {
            searched.removeLast()
        }
        
        lastSearchedRecipes = searched
    }
    
}
