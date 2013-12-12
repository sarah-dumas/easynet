module Main where

import qualified Lan
import qualified Nis
import qualified Nfs
import qualified Dns

main = do Lan.main
          Nis.main
          Nfs.main
          Dns.main

