{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

module Dns (main) where

import Shelly
import qualified Data.Text as T
import Sudo
default (T.Text)


main = shelly $ verbosely $ do
	dns <- readfile "dns.config"
	writefile "/etc/tmp.nsswitch.config" dns
        sudo_ "mv" ["/etc/tmp.nsswitch.config", "/etc/nsswitch.config"]
        echo "setup complete."
