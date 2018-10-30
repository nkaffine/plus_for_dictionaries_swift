# plus_for_dictionaries_swift

Creates an extension for Dictionaries in swift that implements the infix + function.
The plus function returns a new Dictionary with the key value pairs of both dictionaries if 
there are no duplicate keys. If there are duplicate keys, the function throws an error that
is defined in the extension as an enum. The associated value of the enum is the key
and a tuple containing the conflicting values of the keys.
