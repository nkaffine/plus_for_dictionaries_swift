//
//  DictionaryExtension.swift
//  
//
//  Created by Nicholas Kaffine on 10/30/18.
//

import Foundation

extension Dictionary
{
    enum DictionaryError: Error
    {
        case duplicateKey(key: Key, values: (Value, Value))
    }

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

    static func + (lhs: [Key: Value], rhs: [Key: Value]) throws -> [Key: Value]
    {
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
