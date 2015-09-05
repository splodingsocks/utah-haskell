{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module LibScotty
( scottyMain
)
where

import           Control.Monad.IO.Class  (liftIO)
import           Data.Aeson              (FromJSON, ToJSON)
import           Data.Monoid             (mconcat)
import           Data.Text.Lazy          (unpack)
import           Data.Text.Lazy.Encoding (decodeUtf8)
import           GHC.Generics
import           LibInteract             as LI
import           Reactive.Threepenny     (Handler (..))
import           Web.Scotty

data User = User { userId :: Int, userName :: String } deriving (Eq, Generic, Show)
bob       = User 1 "bob"
jenny     = User 2 "jenny"
allUsers  = [bob, jenny]

instance ToJSON   User
instance FromJSON User

-- scottyMain :: Handler String -> IO ()
scottyMain gu pu handler = scotty 3000 $ do
    post "/" $ do
        b <- body
        let d = decodeUtf8 b
        let msg = unpack d
        liftIO (handler msg)
        r <- liftIO (LI.inputS gu pu d)
        json r
