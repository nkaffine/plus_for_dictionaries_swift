//
//  DictionaryExtension.swift
//  
//
//  Created by Nicholas Kaffine on 10/30/18.
//

import Foundation

extension Dictionary
{
    //Enum for custom dictionary errors
    enum DictionaryError: Error
    {
        case duplicateKey(key: Key, values: (Value, Value))
    }

    //Helper method for +
    //Takes in a dictionary and uses reduce to add all the values from
    //the given dictionary to self, throwing a duplicateKey exception if
    //there are any duplicate keys
    func combine(with dictionary: [Key: Value]) throws -> [Key: Value]
    {
        do
        {
            return try dictionary.reduce(self)
            { (partialResults, keyValuePair) in
                let key = keyValuePair.key
                if let value1 = self[key]
                {
                    throw DictionaryError.duplicateKey(key: key, values: (value1, keyValuePair.value))
                }
                //Already checked that there are no duplicates so the uniquingKeysWith closure will never be called
                let temp = [keyValuePair.key: keyValuePair.value]
                return partialResults.merging(temp, uniquingKeysWith: { first,_ in return first})
            }
        }
        catch DictionaryError.duplicateKey(let key, let values)
        {
            throw DictionaryError.duplicateKey(key: key, values: values)
        }
    }

    //+ function
    //Takes in two dictionaries with the same Key Value types
    //Returns a new dictionary with key value pairs of both dictionaries
    //Throws duplicateKey exception if there is a duplicate key
    static func + (lhs: [Key: Value], rhs: [Key: Value]) throws -> [Key: Value]
    {
        //Always appending the smaller dictionary to the larger dictionary
        //only increases speed by a constant factor.
        if lhs.count > rhs.count
        {
            do
            {
                return try lhs.combine(with: rhs)
            }
            catch DictionaryError.duplicateKey(let key, let values)
            {
                throw DictionaryError.duplicateKey(key: key, values: values)
            }
        }
        else
        {
            do
            {
                return try rhs.combine(with: lhs)
            }
            catch DictionaryError.duplicateKey(let key, let values)
            {
                throw DictionaryError.duplicateKey(key: key, values: values)
            }
        }
    }
}
