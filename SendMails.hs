import System.Environment
import qualified Data.Text as T ( pack )
import qualified Data.Text.Lazy as TL ( pack )
import Text.Regex
import Text.Regex.Posix
import Network.Mail.SMTP

data SchoolClass = Inte | Info | Art

from = Address Nothing $ T.pack "x20058@edu.ipc.hiroshima-cu.ac.jp"
cc = [ ]
bcc = [ ]
subject = T.pack "プログラミング愛好会創設に関して"
plain to = plainTextPart $ TL.pack $ getBody to "\r\n"
html to = htmlPart $ TL.pack $ getBody to "<br />"
mail to = simpleMail from [ Address Nothing ( T.pack to ) ] cc bcc subject [ plain to , html to ]

getSchoolClass to = case to =~ "^.[123]" of
    ( _ : "1" ) -> Inte
    ( _ : "2" ) -> Info
    ( _ : "3" ) -> Art

getBody to crlf = "情報科学部2年の北原です。" ++ crlf ++ "現在「プログラミング愛好会」を設立しようと考えています。" ++ crlf ++ t ++ crlf ++ "興味を持ってくださった方や質問のある方などはこのメールに返信して下さい。よろしくお願いします。" where
    t = case getSchoolClass to of
        Inte -> "ITの技術は全世界を繋ぐ技術です、プログラムも国際対応を考えて作らなければならない時代になっています、僕はあなたの力を必要としています。"
        Info -> "プログラミングは情報技術の中心に常に位置しています、プログラミングを学ぶことはあなたにとってとても重要です。一緒に大学の講義では学べないプログラミングを学びませんか？"
        Art -> "プログラムの使いやすさ、見た目、全ては芸術に依存しています、僕はあなたの力を必要としています。"

main = do
    ( filePath : _ ) <- getArgs
    emailsString <- readFile filePath
    emails <- return $ filter ( /= [ ] ) $ lines emailsString
    mapM_ ( sendMail "127.0.0.1" . mail ) emails
