import Data.Function
import Data.List
import Data.Maybe

data Diagram = Diagram (Int, Int) [[Bool]] deriving (Show)

(!!!) :: Diagram -> (Int, Int) -> Bool
(!!!) (Diagram (w, h) diagram) (x, y)
  | y < 0 || y >= h = False
  | x < 0 || x >= w = False
  | otherwise = diagram !! y !! x

parseDiagramLine :: String -> [Bool]
parseDiagramLine = map (== '@')

parseDiagram :: String -> Diagram
parseDiagram x = Diagram (width, length body) body
  where
    body = map parseDiagramLine $ lines x
    width = fromMaybe (length x) $ elemIndex '\n' x

allIndices :: Diagram -> [(Int, Int)]
allIndices (Diagram (w, h) _) = [(x, y) | x <- [0 .. w - 1], y <- [0 .. h - 1]]

neighborCount :: (Int, Int) -> Diagram -> Int
neighborCount (x, y) diagram =
  sum $
    map
      (fromEnum . (diagram !!!))
      [ (x - 1, y - 1),
        (x - 1, y),
        (x - 1, y + 1),
        (x, y - 1),
        (x, y + 1),
        (x + 1, y - 1),
        (x + 1, y),
        (x + 1, y + 1)
      ]

-- TODO: use STArray
removePapers :: [(Int, Int)] -> Diagram -> Diagram
removePapers [] diagram = diagram
removePapers ((rx, ry) : rest) (Diagram (w, h) diagram) = removePapers rest (Diagram (w, h) newDiagram)
  where
    newDiagram =
      [ [if x == rx && y == ry then False else p | (x, p) <- zip [0 ..] row]
        | (y, row) <- zip [0 ..] diagram
      ]

removePapersRecursive :: Int -> Diagram -> Int
removePapersRecursive maxPapers diagram =
  if null pointsToRemove
    then 0
    else
      length pointsToRemove + removePapersRecursive maxPapers newDiagram
  where
    newDiagram = removePapers pointsToRemove diagram
    pointsToRemove =
      allIndices diagram
        & filter (diagram !!!)
        & filter ((< maxPapers) . (`neighborCount` diagram))

solvePart1 :: Int -> Diagram -> Int
solvePart1 maxPapers diagram =
  allIndices diagram
    & filter (diagram !!!)
    & map (`neighborCount` diagram)
    & filter (< maxPapers)
    & length

solvePart2 :: Int -> Diagram -> Int
solvePart2 = removePapersRecursive

main :: IO ()
main = do
  input <- getContents

  print $ solvePart1 4 $ parseDiagram input
  print $ solvePart2 4 $ parseDiagram input
