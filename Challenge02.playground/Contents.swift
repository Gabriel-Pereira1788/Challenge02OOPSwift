import UIKit

struct Book {
   var title:String
   var numberPages:Int
   var price:Double
}

struct CartItem{
    var book:Book
    var amount:Int
    var total: Double {
        book.price * Double(amount)
    }
}

enum BookStoreErrorsHandlers:Error {
    
    case insufficientFunds
}

class BookStore {
    var bookShelf:[String:[Book]] = [
        "Action":[
            Book(title: "Aventura", numberPages: 100, price: 50.0),
            Book(title: "O Pacto", numberPages: 90, price: 60.5),
            Book(title: "Trem-bala", numberPages: 123, price: 100.5)
        ],
        
        "Drama":[
            Book(title: "Hamlet", numberPages: 100, price: 80.0),
            Book(title: "O Hobbit", numberPages: 50, price: 90.0),
            Book(title: "O ultimo trem para londres", numberPages: 100, price: 41.63)
        ],
        
        "Romance":[
            Book(title: "Ugly Love", numberPages: 125, price: 34.32),
            Book(title:"O Alquimista",numberPages: 80,price: 45.16),
            Book(title: "A hipotese do amor", numberPages: 100, price: 32.99)
        ]
    ]
    
    private var cartStore:[CartItem] = []
    
    func getCurrentCartStore() -> [CartItem]{
        return cartStore
    }
    
    func selectBooksByCategory(category:String) -> [Book]?{
        var bookList = bookShelf[category]
        if(bookList != nil){
            return bookList
        }else {
            print("Sinto muito categoria inexistente.")
            return nil
        }
    }
    
    func addToCart(item toAdd:CartItem){
        if var findedItemIndex = self.checkHaveInCart(bookTitle: toAdd.book.title) {
            cartStore[findedItemIndex].amount += 1
        } else {
            cartStore.append(toAdd)
        }
    }
    
    private func checkHaveInCart(bookTitle:String) -> Int? {
        return cartStore.firstIndex{item in item.book.title == bookTitle}
    }
    
    func finishSale(valueToBuy:Double) throws {
        let totalSale = calculateTotal()
        
        if(valueToBuy < totalSale){
            throw BookStoreErrorsHandlers.insufficientFunds
        } else {
            print("Compra efetuada com sucesso")
        }
    }
    
    private func calculateTotal() -> Double {
        var total = 0.0
        for item in cartStore{
            total += item.total
        }
        
        return total
    }
}


struct Person {
    var name:String
    var age:Int
    var amountFinance:Double
    var job:Job
}

class Job {
    var salary:Double
    var title:String
    
    init(salary:Double,title:String){
        self.salary = salary
        self.title = title
    }
}

func onStart(){
    let bookStore = BookStore()
    let gabriel = Person(name: "Gabriel", age: 21,amountFinance: 500, job:Job(salary: 2500, title: "Software developer"))
    let booksSelected = bookStore.selectBooksByCategory(category: "Action")
    
    if var book = booksSelected?[0] {
        bookStore.addToCart(item: CartItem(book: book, amount:3))
        print(bookStore.getCurrentCartStore())
    }
 
    do{
        try bookStore.finishSale(valueToBuy: 200)
    } catch {
        print(error)
    }
}


onStart()
