{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

module Lan (main) where

import Shelly
import qualified Data.Text as T
import Sudo
default (T.Text)


main = shelly $ verbosely $ do
	hosts <- readfile "hosts.config"
	writefile "/etc/tmp.hosts" hosts
        sudo_ "mv" ["/etc/tmp.hosts", "/etc/hosts"]
	run_ "/etc/init.d/networking" ["restart"]
