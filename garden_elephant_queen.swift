import UIKit

// MARK: - Enums

enum Colour: String {
    case black
    case white
    case red
    case green
    case blue
    case orange
    case yellow
    case pink
    case purple
    case brown
    case grey
}

enum Size: String {
    case extraSmall
    case small
    case medium
    case large
    case extraLarge
}

enum ItemCondition: String {
    case new
    case used
    case vintage
}

enum Currency: String {
    case usd
    case aud
    case gbp
    case cad
    case eur
}

// MARK: - Structs

struct Item {
    let title: String
    let description: String
    let size: Size?
    let colour: Colour?
    let condition: ItemCondition
    let price: Double
    let currency: Currency
}

struct Listing {
    let item: Item
    let imageURL: String?
    let sellerUsername: String
    let sellerLocation: String?
    let sellerRating: Double?
}

struct Store {
    let name: String
    let description: String
    let listings: [Listing]
    let websiteURL: String?
}

// MARK: - Classes

class Sale {
    let item: Item
    let buyerUsername: String
    let sellerUsername: String
    let salePrice: Double
    let date: Date
    
    init(item: Item, buyerUsername: String, sellerUsername: String, salePrice: Double, date: Date) {
        self.item = item
        self.buyerUsername = buyerUsername
        self.sellerUsername = sellerUsername
        self.salePrice = salePrice
        self.date = date
    }
}

class User {
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    var sales: [Sale]
    
    init(username: String, email: String, firstName: String, lastName: String, sales: [Sale] = []) {
        self.username = username
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.sales = sales
    }
    
    func addSale(_ sale: Sale) {
        sales.append(sale)
    }
}

class Review {
    let buyerUsername: String
    let sellerUsername: String
    let rating: Double
    let comment: String
    let createdAt: Date
    
    init(buyerUsername: String, sellerUsername: String, rating: Double, comment: String, createdAt: Date) {
        self.buyerUsername = buyerUsername
        self.sellerUsername = sellerUsername
        self.rating = rating
        self.comment = comment
        self.createdAt = createdAt
    }
}

class UpcycleNation {
    static let sharedInstance = UpcycleNation()
    private init(){}
    let store = Store(name: "Upcycle Nation",
                      description: "Reduce, Reuse, Recycle with Upcycle Nation!",
                      listings: [],
                      websiteURL: "upcyclenation.com")
    var users: [User] = []
    
    func registerUser(username: String, email: String, firstName: String, lastName: String) -> User {
        let user = User(username: username,
                        email: email,
                        firstName: firstName,
                        lastName: lastName)
        users.append(user)
        return user
    }
    
    func createListing(item: Item, imageURL: String?, sellerUsername: String, sellerLocation: String?, sellerRating: Double?) -> Listing {
        let listing = Listing(item: item,
                              imageURL: imageURL,
                              sellerUsername: sellerUsername,
                              sellerLocation: sellerLocation,
                              sellerRating: sellerRating)
        store.listings.append(listing)
        return listing
    }
    
    func addSale(item: Item, buyerUsername: String, sellerUsername: String, salePrice: Double, date: Date) -> Sale {
        // Find buyer
        guard let buyer = users.first(where: { $0.username == buyerUsername }) else { return Sale(item: item, buyerUsername: buyerUsername, sellerUsername: sellerUsername, salePrice: salePrice, date: date) }
        
        // Find seller
        let seller = users.first(where: { $0.username == sellerUsername })
        
        // Create sale
        let sale = Sale(item: item, buyerUsername: buyerUsername, sellerUsername: sellerUsername, salePrice: salePrice, date: date)
        
        // Add to buyer's list of sales
        buyer.addSale(sale)
        
        // Add to seller's list of sales if exists
        if let seller = seller {
            seller.addSale(sale)
        }
        
        return sale
    }
    
    func addReview(buyerUsername: String, sellerUsername: String, rating: Double, comment: String, createdAt: Date) -> Review {
        let review = Review(buyerUsername: buyerUsername, sellerUsername: sellerUsername, rating: rating, comment: comment, createdAt: createdAt)
        return review
    }
    
    func getStoreListings(for size: Size? = nil, condition: ItemCondition? = nil, colour: Colour? = nil) -> [Listing] {
        let filteredListings = store.listings.filter({ listing -> Bool in
            if let size = size {
                if listing.item.size != size {
                    return false
                }
            }
            if let colour = colour {
                if listing.item.colour != colour {
                    return false
                }
            }
            if let condition = condition {
                if listing.item.condition != condition {
                    return false
                }
            }
            return true
        })
        return filteredListings
    }
    
    func getSellerListings(sellerUsername: String) -> [Listing] {
        let listings = store.listings.filter { listing -> Bool in
            return listing.sellerUsername == sellerUsername
        }
        return listings
    }
    
    func getBuyerSales(buyerUsername: String) -> [Sale] {
        let sales = users.reduce([Sale]()) { result, user -> [Sale] in
            if user.username == buyerUsername {
                return result + user.sales
            } else {
                return result
            }
        }
        return sales
    }
    
    func getSellerSales(sellerUsername: String) -> [Sale] {
        let sales = users.reduce([Sale]()) { result, user -> [Sale] in
            if user.username == sellerUsername {
                return result + user.sales
            } else {
                return result
            }
        }
        return sales
    }
    
    func getStoreRevenue() -> Double {
        let storeRevenue = store.listings.reduce(0.0) { result, listing -> Double in
            return result + listing.item.price
        }
        return storeRevenue
    }
    
    func getSellerRevenue(sellerUsername: String) -> Double {
        let listings = getSellerListings(sellerUsername: sellerUsername)
        let sellerRevenue = listings.reduce(0.0) { result, listing -> Double in
            return result + listing.item.price
        }
        return sellerRevenue
    }
    
    func getBuyerExpenditure(buyerUsername: String) -> Double {
        let sales = getBuyerSales(buyerUsername: buyerUsername)
        let buyerExpenditure = sales.reduce(0.0) { result, sale -> Double in
            return result + sale.salePrice
        }
        return buyerExpenditure
    }
    
    func convert(amount: Double, fromCurrency: Currency, toCurrency: Currency) -> Double {
        // Call API endpoint to get conversion rate
        let conversionRate = 1.0 // API call result
        return amount * conversionRate
    }
}