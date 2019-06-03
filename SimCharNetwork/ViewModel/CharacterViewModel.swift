//
//  CharacterViewModel.swift
//  SimpsonsCharacterViewer
//
//  Created by Dean Wagstaff on 5/17/19.
//  Copyright © 2019 Dean Wagstaff. All rights reserved.
//

import UIKit

public class CharacterViewModel: NSObject {
    public var names           = [[String: Any]]()
    public var descriptions    = [String]()
    
    var characterImageView: UIImageView!

    // Define property to hold data from web feed
    var characters: [NSDictionary]?
    
    var character:Character? = Character()
    
    public func getCharactersData(from url: String, completion: @escaping () -> Void) {
        character?.fetchData(with: url, completion: { (charactersFromDictionaries) in
            // assign to main queue so as not to clock the UI
            DispatchQueue.main.async {
                // assign to local array of characters
                self.characters = charactersFromDictionaries
                
                // call completion to reload tableview data
                completion()
            }
        })
    }
    
    // MARK: - Tableview display methods
    public func numberOfItemsToDisplay(in section: Int) -> Int {
        return characters?.count ?? 0
    }
    
    public func characterIdIndexPath(for name: String) -> IndexPath {
        var indexPath = IndexPath(item: 0, section: 0)
        
        if let allCharacters = characters {
            for (index,aChar) in allCharacters.enumerated() {
                var charName:String? {
                    // adding space before - char accounts for a hyphen between word with not space
                    let i = (aChar.value(forKey: "Text") as! String).range(of: " -")
                    let low = i?.lowerBound
                    
                    if low == nil {
                        return String((aChar.value(forKey: "Text") as! String)[...])
                    }
                    
                    return String((aChar.value(forKey: "Text") as! String)[..<low!])
                }

                if let cName = charName {
                    if cName.contains(name) {
                        indexPath = IndexPath(item: index, section: 0)
                        break
                    }
                }
            }
        }
        
        return indexPath
    }
    
    public func characterNameToDisplay(for indexPath: IndexPath) -> String {
        var name:String! {
            // adding space before - char accounts for a hyphen between word with not space
            let i = (characters?[indexPath.row].value(forKey: "Text") as! String).range(of: " -")
            let low = i?.lowerBound
            
            if low == nil {
                return String((characters?[indexPath.row].value(forKey: "Text") as! String)[...])
            }
            
            return String((characters?[indexPath.row].value(forKey: "Text") as! String)[..<low!])
        }
        
        names.append(["text":name])

        return name
    }
    
    public func characterDescriptionToDisplay(for indexPath: IndexPath) -> String {
        var description:String! {
            let idx = (characters?[indexPath.row].value(forKey: "Text") as! String).range(of: " - ")
            let up = idx?.upperBound
            
            if up == nil {
                return String((characters?[indexPath.row].value(forKey: "Text") as! String)[...])
            }
            
            return String((characters?[indexPath.row].value(forKey: "Text") as! String)[up!..<(characters?[indexPath.row].value(forKey: "Text") as! String).endIndex])
        }
        
        descriptions.append(description)
        
        return description
    }
    
    public func getCharacterImage(for indexPath: IndexPath, completion: @escaping (_ successful: Bool) -> Void) {
        let url:String = (characters?[indexPath.row].value(forKey: "Icon") as! NSDictionary).value(forKey: "URL") as! String
        
        character?.fetchImage(from: url, completion: { (characterImageView) in
            DispatchQueue.main.async {
                self.characterImageView = characterImageView
                
                completion(true)
            }
        })        
    }
    
    public func characterImageToDisplay() -> UIImageView {
        return self.characterImageView
    }
}
