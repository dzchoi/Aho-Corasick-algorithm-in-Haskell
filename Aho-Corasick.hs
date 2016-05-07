--http://twanvl.nl/blog/haskell/Knuth-Morris-Pratt-in-Haskell
--Aho and Corasick generalized the KMP algorithm to recognize any of a set of keywords in a text
--string. In this case, the trie is a true tree, with branching from the root. There is one state
--for every prefix (not necessarily proper) of any keyword. The parent state of a state
--corresponding to string b[1]b[2]...b[k] is the state that corresponds to b[1]b[2]...b[k-1].
--A state is accepting (having True) if it corresponds to a complete keyword.

--This is actually generating a DFA from a regular expression like ".*(he|she|his|hers)".
--However, this is not minimal, yielding a 4-state DFA for "ba|aa", while the equivalent "(b|a)a"
--needs only 3-state DFA.



import Data.List (partition)

data State a = State { done :: Bool, next :: a -> State a }
-- State a is a state in a trie and is ready to process the next input by applying next to it.
-- "next" gives a transition function that will lead to next state on the next(not current) input.



buildTrie' :: Eq a => [[a]] -> (a -> State a) -> State a
buildTrie' [] failure =
    State True failure
	-- reuse failure for further looking for multiple matches

buildTrie' xss failure | any null xss =
-- for any []'s in xss, make State True ... and drop them; we have successfully matched one of
-- keywords.
    State True $ next $ buildTrie' (filter (not . null) xss) failure
	-- does not make a new state but only use its next function

buildTrie' ((x:xs) : xss) failure =
-- if (a:_)'s and (b:_)'s in xss, make
-- State False (\x -> if x == a then ... else if x == b then ... else ...)
    State False test where
	(xss', yss) = partition ((== x) . head) xss
	test c = if c == x then success
		 else next (buildTrie' yss failure) c
		    -- we cannot use here just (buildTrie' yss failure) as else because we have
		    -- already read x and have to process it anyway at this turn.
	success = buildTrie' (xs : map tail xss') (next $ failure x)

buildTrie :: Eq a => [[a]] -> State a
buildTrie xss = trie where
    -- trie(:: State a) is a sequence(or path) of functions that will finally yield "done" if
    -- applied to correct "keys" in order, thus serving as a transition diagram.
    trie = buildTrie' xss (const trie)
	-- (const trie) for failure function means to discard the input and to start over from s0.



isInfixOf :: Eq a => [[a]] -> [a] -> Bool
--isInfixOf as bs = any done $ scanl next (makeTrie as) bs
isInfixOf xss = any done . scanl next (buildTrie xss)
