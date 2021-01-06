//
//  DatabaseHelper.swift
//  Jeopardy
//
//  Created by Christian Shirichena on 1/4/21.
//

import Foundation
import CoreData

// NSManagedObject CoreData class declaration
class CDclue: NSManagedObject {
    
    class func createOrUpdate(question: String, content: String) -> Clue {
        print("createOrUpdate note")
        
        let request: NSFetchRequest<Clue> = Clue.fetchRequest()
        request.predicate = NSPredicate(format: "question == %@", question)
        
        do {
            let clues = try AppDelegate.viewContext.fetch(request)
            if clues.count > 0 {
                assert(clues.count == 1, "Ooops, more than one clues that has the same question")
                clues[0].answer = content
                
                return clues[0]
            }
        } catch {
            print("Error getting clues")
        }
        let clue = Clue(context: AppDelegate.viewContext)
        clue.question = question
        clue.answer = content
     
        
        DispatchQueue.main.async {
            try? AppDelegate.viewContext.save()
        }
        
        return clue
    }
}
