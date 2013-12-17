{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

module Nis (main) where

import Shelly
import Sudo
import qualified Data.Text as T
default (T.Text)


main = shelly $ verbosely $ do
         --sudo_ "apt-get" ["update"]
         --sudo_ "apt-get" ["install", "nis", "-y", "-q"]
         --sudo_ "apt-get" ["install", "sysv-rc-conf", "-y", "-q"]
         addNIS
         ypGateway
         defaultCheck
         makeHome

--add the lines 'NIS' to the specified four lines in nsswitch.conf

addNIS = do contents <- readfile "nsswitch.conf.config"
            writefile "/etc/temp.nsswitch.conf" contents
            echo "writing nsswitch.conf out."
            sudo_ "mv" ["/etc/temp.nsswitch.conf", "/etc/nsswitch.conf"]
            echo "Moving nsswitch.conf to appropriate location."

--modify /etc/yp.conf to identify the gateway server

ypGateway = do gateway <- readfile "gateway.config"
               appendfile "/etc/yp.conf" $ "ypserver " `T.append` gateway
               echo "Appending gateway to yp.conf"

defaultCheck = do defaultdomain <- readfile "/etc/defaultdomain"
                  echo $ "Default domain is" `T.append` defaultdomain

makeHome = do run_ "mkdir" ["/home/sdumas/"] --for each instance of mkhome, run mkdir to create a home directory for that user
              echo "Making home directory for user sdumas."
              sudo_ "service" ["ypbind", "restart"]
              sudo_ "sysv-rc-conf" ["ypbind", "on"]
              echo "restarting NIS."
              run_ "chown" ["sdumas", "/home/sdumas/"] --change owner of directory to user
              echo "Changing ownership and group rights for home directory of user sdumas."
              run_ "chgrp" ["sdumas", "/home/sdumas"] --change group of directory to user









 
