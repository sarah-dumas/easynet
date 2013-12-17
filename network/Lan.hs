{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE NoMonomorphismRestriction #-}
{-# OPTIONS_GHC -fno-warn-type-defaults #-}

module Lan (main) where

import Shelly
import qualified Data.Text as T
import Sudo
default (T.Text)


main = shelly $ verbosely $ do
	hosts <- readfile "hosts.config"
        echo "Writing out hostfile."
	writefile "/etc/hosts" hosts
        echo "Moving hostfile to appropriate position."
	run_ "/etc/init.d/networking" ["restart", "-y", "-q"]
        echo "Restarting networking."
