{-# LANGUAGE OverloadedStrings #-}

import Network.Mail.SMTP

from       = Address Nothing "x20058@edu.ipc.hiroshima-cu.ac.jp"
to         = [Address Nothing "masakazu.minamiyama@gmail.com"]
cc         = []
bcc        = []
subject    = "email subject"
body       = plainTextPart "email body"
html       = htmlPart "<h1>HTML</h1>"

mail = simpleMail from to cc bcc subject [body, html]

main = sendMail "127.0.0.1" mail
