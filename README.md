# Aho-Corasick-algorithm-in-Haskell
Implementation of Aho-Corasick algorithm in Haskell

Aho and Corasick generalized the KMP algorithm to recognize any of a set of keywords in a text string. In this case, the trie is a true tree, with branching from the root. There is one state for every prefix (not necessarily proper) of any keyword. The parent state of a state corresponding to string b[1]b[2]...b[k] is the state that corresponds to b[1]b[2]...b[k-1].
A state is accepting (having True) if it corresponds to a complete keyword.

This is actually generating a DFA from a regular expression like ".*(he|she|his|hers)". However, this is not minimal, yielding a 4-state DFA for "ba|aa", while the equivalent "(b|a)a" needs only 3-state DFA.

- refencing [the great article] (http://twanvl.nl/blog/haskell/Knuth-Morris-Pratt-in-Haskell)
 
- for example,  
`isInfixOf ["he", "she", "his", "hers"] "the"` gives `True`  
`isInfixOf ["he", "she", "his", "hers"] "him"` gives `False`  
