
import Foundation

class IngredientsServiceManager{
    
    
    func loadIngredients() -> [Ingredients]? {
        if let url = Bundle.main.url(forResource: "IngredientsData", withExtension: "json"),
            let data = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            do {
                let ingredients = try decoder.decode([Ingredients].self, from: data)
                return ingredients
            } catch {
                print("Error decoding JSON: \(error)")
                return nil
            }
        }
        return nil
    }
    
}
