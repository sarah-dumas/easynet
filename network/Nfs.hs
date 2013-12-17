{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

module Nfs (main) where

import Shelly
import Sudo
import qualified Data.Text as T
default (T.Text)


--update the system and install nfs and autofs
main = shelly $ verbosely $ do
       --sudo_ "apt-get" ["update"]
       --sudo_ "apt-get" ["install", "nfs-common", "-y", "-q"]
       --sudo_ "apt-get" ["install", "nfs-kernel-server", "-y", "-q"]
         directoryMove
         makeDir
         passwdOverwrite
         appender
         exporter

--move directories from home to home.computername

directoryMove = do computername <- readfile "computername.config"
                   let stripped = T.strip computername
                   sudo_ "mv" ["/home", "/home." `T.append` stripped]
                   echo "Moving home directories to home.itvm26-5."

--create a directory to use as a mount point named /home

makeDir = do sudo_ "mkdir" ["/home"]
             echo "Making new mount point."


--append /etc/passwd to change sysadmin account's home to home.computername

passwdOverwrite = do overwrite <- readfile "passwd.config"  --leave this a lazy overwrite for now. Later on we will change it so it pattern-matches.
                     writefile "/etc/tmp.passwd" overwrite
                     sudo_ "mv" ["/etc/tmp.passwd", "/etc/passwd"]
                     echo "Changing passwd file to respecify sysadmin's home."
                     echo "!!!WARNING!!! This may break some installs!"

--append /etc/exports to tell it where and how to export our homes

exporter = do exports <- readfile "exports.config"
              appendfile "/etc/exports" exports
              echo "Appending export rules to exports file."            
              
--edit /etc/auto.master to tell it that the homes are located in auto.home

appender = do appendfile "/etc/auto.master" "/home /etc/auto.home"
              echo "Appending auto.master with information for auto.home."

--restart the virtual machine

--Note: figure out how to implement this, for now, assume manual restart.

        
