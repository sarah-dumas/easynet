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
         makeHome
         restartNIS
         
--add the lines 'NIS' to the specified four lines in nsswitch.conf

addNIS = do contents <- readfile "nsswitch.conf.config"
            writefile "/etc/temp.nsswitch.conf" contents
            sudo_ "mv" ["/etc/temp.nsswitch.conf", "/etc/nsswitch.conf"]


--modify /etc/yp.conf to identify the gateway server

ypGateway = do gateway <- readfile "gateway.config"
               appendfile "/etc/yp.conf" $ "ypserver " `T.append` gateway




makeHome = do run_ "mkdir" ["/home/sdumas/"] --for each instance of mkhome, run mkdir to create a home directory for that user
              run_ "chown" ["sdumas", "/home/sdumas/"] --change owner of directory to user
              run_ "chgrp" ["sdumas", "/home/sdumas"] --change group of directory to user

--restart NIS

restartNIS = do sudo_ "service" ["ypbind", "restart"]
                sudo_ "sysv-rc-conf" ["ypbind", "on"]










 
