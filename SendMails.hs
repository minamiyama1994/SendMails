{-# LANGUAGE OverloadedStrings #-}

import Data.Text
import Text.Regex
import Network.Mail.SMTP

data SchoolClass = Inte | Info | Art

from = Address Nothing "x20058@edu.ipc.hiroshima-cu.ac.jp"
cc = [ ]
bcc = [ ]
subject = "プログラミング愛好会創設に関して"
text to = plainTextPart $ pack $ getBody to
html to = htmlPart $ pack $ getBody to

mail to = simpleMail from [ Address Nothing ( pack to ) ] cc bcc subject [ text to , html to ]

getSchoolClass to = case to =~ "^.(.)" of
    ( _ , [ '1' ] , _ ) -> Inte
    ( _ , [ '2' ] , _ ) -> Info
    ( _ , [ '3' ] , _ ) -> Art

getBody to = "情報科学部2年の北原です。\r\n現在「プログラミング愛好会」を設立しようと考えています。\r\n" ++ t ++ "\r\n興味を持ってくださった方や質問のある方などはこのメールに返信して下さい。よろしくお願いします。" where
    t = case getSchoolClass to of
        Inte -> "ITの技術は全世界を繋ぐ技術です、プログラムも国際対応を考えて作らなければならない時代になっています、僕はあなたの力を必要としています。"
        Info -> "プログラミングは情報技術の中心に常に位置しています、プログラミングを学ぶことはあなたにとってとても重要です。"
        Art -> "プログラムの使いやすさ、見た目、全ては芸術に依存しています、僕はあなたの力を必要としています。"

main = do
    ( filePath : _ ) <- getArgs
    emailsString <- readFile filePath
    emails <- return $ filter ( /= [ ] ) $ lines emailsString
    mapM_ ( sendMail "127.0.0.1" . mail ) emails
