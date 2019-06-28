module Filter.Qualitative (makeQualitativeProblems) where

import Carnap.GHCJS.SharedFunctions (simpleHash)
import Text.Pandoc
import Filter.Util (splitIt, intoChunks,formatChunk, unlines')
import Data.Map (fromList, toList, unions)
import Data.Hashable
import Prelude

makeQualitativeProblems :: Block -> Block
makeQualitativeProblems cb@(CodeBlock (_,classes,extra) contents)
    | "QualitativeProblem" `elem` classes = Div ("problem",[],[]) $ map (activate classes extra) $ intoChunks contents
    | otherwise = cb
makeQualitativeProblems x = x

activate cls extra chunk
    | "MultipleChoice" `elem` cls = RawBlock "html" $ mctemplate (opts [("qualitativetype","multiplechoice")])
    | "ShortAnswer" `elem` cls = RawBlock "html" $ template (opts [("qualitativetype","shortanswer")])
    | otherwise = RawBlock "html" "<div>No Matching Qualitative Problem Type</div>"
    where numof x = takeWhile (/= ' ') x
          contentOf x = dropWhile (== ' ') . dropWhile (/= ' ') $  x
          (h:t) = formatChunk chunk
          opts adhoc = unions [fromList extra, fromList fixed, fromList adhoc]
          fixed = [ ("type","qualitative")
                  , ("goal", contentOf h) 
                  , ("submission", "saveAs:" ++ numof h)
                  ]
          mctemplate opts = "<div class=\"exercise\">"
                            ++ "<span> exercise " ++ numof h ++ "</span><div"
                            ++ concatMap (\(x,y) -> " data-carnap-" ++ x ++ "=\"" ++ y ++ "\"") (toList opts)
                            ++ ">" 
                            ++ unlines' (map (show . withHash) t)
                            ++ "</div></div>" 
          template opts = "<div class=\"exercise\">"
                          ++ "<span> exercise " ++ numof h ++ "</span><div"
                          ++ concatMap (\(x,y) -> " data-carnap-" ++ x ++ "=\"" ++ y ++ "\"") (toList opts)
                          ++ ">" 
                          ++ unlines' t
                          ++ "</div></div>" 
          withHash s | length s' > 0 = if head s' == '*' then (simpleHash s', tail s') else (simpleHash s',s')
                     | otherwise = (simpleHash s', s')
            where s' = (dropWhile (== ' ') s)