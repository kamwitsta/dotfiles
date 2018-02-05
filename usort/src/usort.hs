{-# OPTIONS_GHC -Wno-tabs #-}

import Data.List (nub,sortBy)
import Data.Text (pack,replace,Text(),unpack)		-- text 1.2.2.2-1+b1
import Data.Text.ICU (collate,NormalizationMode(NFC,NFKD),normalize,uca)	-- text-icu 0.7.0.1-6+b2


subs :: [(String,String)]
subs = [
	("ʒ","dz")
	]

collateFst :: (Text,Text) -> (Text,Text) -> Ordering
collateFst (s,_) (t,_)	= collate uca s t

doSubs :: [(Text,Text)] -> Text -> Text
doSubs [] str		= str
doSubs (s:ss) str	= doSubs ss $ replace (fst s) (snd s) str

pack2 :: (String,String) -> (Text,Text)
pack2 (s1,s2)	= (pack s1, pack s2)


main = do
	-- read the data from stdin
	datums <- getContents
	let
		-- split the data into lines, remove duplicates, and pack them into Text
		datPckd = map pack (nub $ lines datums)
		-- pack the substitutions into Text
		subPckd = map pack2 subs
		-- make a copy of the data for sorting and normalize it
		tmpNrmd = map (normalize NFKD) datPckd
		-- apply the substitutions to the copy
		tmpSubd = map (doSubs subPckd) tmpNrmd
		-- zip the modified and the originals, and sort by the former
		tmpSrtd = sortBy collateFst $ zip tmpSubd datPckd
		-- return the now-sorted originals and compose them for good measure
		res = map (unpack . normalize NFC . snd) tmpSrtd
	-- and print the result
	mapM putStrLn res
